Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46240 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727504AbeJYVyR (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 25 Oct 2018 17:54:17 -0400
Date: Thu, 25 Oct 2018 09:21:30 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: xfs_alloc_ag_vextent_near() takes about 30ms to complete
Message-ID: <20181025132130.GA2819@bfoster>
References: <CAGiyNfAUewzAjASPBccOk91PJ+nLS0nF4U3EvO4n59XsYu5P-w@mail.gmail.com>
 <20181023145339.GA7537@bfoster>
 <CAGiyNfAy+eTq+oba0Rb8Oe_kajFqD5a6rPnOkWPjC_E=foSqkg@mail.gmail.com>
 <20181024043416.GA19305@dastard>
 <20181024120926.GA46681@bfoster>
 <20181024223523.GB19305@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181024223523.GB19305@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Mao Cheng <chengmao2010@gmail.com>, linux-xfs@vger.kernel.org

On Thu, Oct 25, 2018 at 09:35:23AM +1100, Dave Chinner wrote:
> On Wed, Oct 24, 2018 at 08:09:27AM -0400, Brian Foster wrote:
> > On Wed, Oct 24, 2018 at 03:34:16PM +1100, Dave Chinner wrote:
> > > On Wed, Oct 24, 2018 at 11:01:13AM +0800, Mao Cheng wrote:
> > > > Hi Brian,
> > > > Thanks for your response.
> > > > Brian Foster <bfoster@redhat.com> 于2018年10月23日周二 下午10:53写道：
> > > > >
> > > > > On Tue, Oct 23, 2018 at 03:56:51PM +0800, Mao Cheng wrote:
> > > > > > Sorry for trouble again. I just wrote wrong function name in previous
> > > > > > sending, so resend it.
> > > > > > If you have received previous email please ignore it, thanks
> > > > > >
> > > > > > we have a XFS mkfs with "-k" and mount with the default options(
> > > > > > rw,relatime,attr2,inode64,noquota), the size is about 2.2TB，and
> > > > > > exported via samba.
> > > > > >
> > > > > > [root@test1 home]# xfs_info /dev/sdk
> > > > > > meta-data=/dev/sdk               isize=512    agcount=4, agsize=131072000 blks
> > > > > >          =                       sectsz=4096  attr=2, projid32bit=1
> > > > > >          =                       crc=1        finobt=0 spinodes=0
> > > > > > data     =                       bsize=4096   blocks=524288000, imaxpct=5
> > > > > >          =                       sunit=0      swidth=0 blks
> > > > > > naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
> > > > > > log      =internal               bsize=4096   blocks=256000, version=2
> > > > > >          =                       sectsz=4096  sunit=1 blks, lazy-count=1
> > > > > > realtime =none                   extsz=4096   blocks=0, rtextents=0
> > > > > >
> > > > > > free space about allocation groups:
> > > > > >    from      to extents  blocks    pct
> > > > > >       1       1       9       9   0.00
> > > > > >       2       3   14291   29124   0.19
> > > > > >       4       7    5689   22981   0.15
> > > > > >       8      15     119    1422   0.01
> > > > > >      16      31  754657 15093035  99.65
> > > 
> > > 750,000 fragmented free extents means something like 1600 btree
> > > leaf blocks to hold them all.....
> > > 
> > > > > xfs_alloc_ag_vextent_near() is one of the several block allocation
> > > > > algorithms in XFS. That function itself includes a couple different
> > > > > algorithms for the "near" allocation based on the state of the AG. One
> > > > > looks like an intra-block search of the by-size free space btree (if not
> > > > > many suitably sized extents are available) and the second looks like an
> > > > > outward sweep of the by-block free space btree to find a suitably sized
> > > > > extent.
> > > 
> > > Yup, just like the free inode allocation search, which is capped
> > > at about 10 btree blocks left and right to prevent searching the
> > > entire tree for the one free inode that remains in it.
> > > 
> > > The problem here is that the first algorithm fails immediately
> > > because there isn't a contiguous free space large enough for the
> > > allocation being requested, and so it finds the largest block whose
> > > /location/ is less than target block as the start point for the
> > > nearest largest freespace.
> > > 
> > 
> > Hmm, not sure I follow what you're saying here wrt to why we end up in
> > the second algorithm.
> 
> I probably didn't explain it well. I wrote it quickly, didn't proof
> read. What I meant was "...because there isn't enough contiguous
> free space large for the allocation requested to land in the last
> btree block, and so...."
> 
> > I was thinking the most likely condition is that
> > there are actually plenty of suitably sized extents, but as shown by the
> > free space data, they're amidst a huge number of too small extents. The
> 
> Yup, if we do a by-size lookup for >= 22 blocks and there are a
> 1000 free 22 block extents, the lookup doesn't land in the last
> block. Straight to physical locality search.
> 
> > first algorithm is only active if a lookup in the cntbt lands in the
> > last block (the far right leaf) of the btree, so unless I'm missing
> > something this would mean we'd skip right past it to the second
> > algorithm if the last N blocks (where N > 1) of the cnt_bt have large
> > enough extents.
> 
> *nod*.
> 
> > IOW, the first algo seems like an optimization for when we know there
> > are only a small number of minimum sized extents available and the
> > second (location based) algorithm would mostly churn. Regardless, we end
> > up in the same place in the end...
> > 
> > > IOW, we do an expanding radius size search based on physical
> > > locality rather than finding a free space based on size. Once we
> > > find a good extent to either the left or right, we then stop that
> > > search and try to find a better extent to the other direction
> > > (xfs_alloc_find_best_extent()). That search is not bound, so can
> > > search the entire of the tree in that remaining directory without
> > > finding a better match.
> > > 
> > > We can't cut the initial left/right search shorter - we've got to
> > > find a large enough free extent to succeed, but we can chop
> > > xfs_alloc_find_best_extent() short, similar to searchdistance in
> > > xfs_dialloc_ag_inobt(). The patch below does that.
> > > 
> > 
> > This search looks like it goes as far in the opposite direction as the
> > current candidate extent.  So I take it this could potentially go off the
> > rails if we find one suitable extent in one direction that is relatively
> > far off wrt to startblock, and then the opposite direction happens to be
> > populated with a ton of too small extents before we extend to the range
> > that breaks the search.
> 
> Precisely.
> 
> > I'm curious whether this contributes to the reporter's problem at all,
> > but this sounds like a reasonable change to me either way.
> 
> So am I. It's the low hanging fruit - we have ot search until we
> find the first candidate block (no chioce in that) but we can chose
> to terminate the "is there a better choice" search.
> 
> > > Really, though, I think what we need to a better size based search
> > > before falling back to a locality based search. This is more
> > > complex, so not a few minutes work and requires a lot more thought
> > > and testing.
> > > 
> > 
> > Indeed. As noted above, the current size based search strikes me as an
> > optimization that only executes under particular conditions.
> 
> It's the common condition in a typical filesystem - if large,
> contiguous free spaces in the filesystem, then the lookup will
> almost always land in the last block of the btree.
> 

I guess that makes sense for a clean fs. I wonder how long that state
persists in practice as usage increases, however. The more smaller free
extents that are created, the more this algorithm decision varies to the
size (or maxlen at least) of the request.

> > Since the purpose of this function is locality allocation,
> 
> Well, locality is the /second/ consideration - the first algorithm
> prioritises maxlen for contiguous allocation, then selects the best
> candidate by locality. The second alogortihm prioiritises locality
> over allocation length.
> 

Ah yes, good point. I missed the maxlen/minlen dynamic on my first read
through. So if we have some small number of extents that satisfy maxlen
(as opposed to the [minlen, maxlen] range), we prioritize those extents
and apply locality to that subset. If we have none of such extents or
too many, we move on to the bno-based fan out search. There, we find the
closest extent that satisfies the [minlen, maxlen] request.

> > I'm wondering
> > if we could implement a smarter location based search using information
> > available in the by-size tree. For example, suppose we could identify
> > the closest minimally sized extents to agbno in order to better seed the
> > left/right starting points of the location based search. This of course
> > would require careful heuristics/tradeoffs to make sure we don't just
> > replace a bnobt scan with a cntbt scan.
> 
> I wouldn't bother. I'd just take the "last block" algorithm and make
> it search all the >= contiguous free space extents for best locality
> before dropping back to the minlen search.
> 

Ok, that makes sense. The caveat seems to be though that the "last
block" algorithm searches all of the applicable records to discover the
best locality. We could open up this search as such, but if free space
happens to be completely fragmented to >= requested extents, that could
mean every allocation falls into a full cntbt scan where a bnobt lookup
would result in a much faster allocation.

So ISTM that we still need some kind of intelligent heuristic to fall
back to the second algorithm to cover the "too many" case. What exactly
that is may take some more thought, experimentation and testing.

> Really, that's what the first algorithm should be. Looking at the
> last block and selecting the best free space by size and then
> locality is really just a degenerate case of the more general
> algorithm.
> 
> Back when this algorithm was designed, AGs could only be 4GB in
> size, so searching the oly the last block by size made sense - the
> total number of free space extents is fairly well bound by the
> AG size. That bound essentially went away with expanding AGs to 1TB,
> but the algorithm wasn't changed to reflect that even a small amount
> of free space fragmentation could result almost never hitting the
> last block of the btree....
> 

Ok, thanks for the historical context.

Brian

> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
