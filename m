Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41446 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727204AbeJXUhV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 24 Oct 2018 16:37:21 -0400
Date: Wed, 24 Oct 2018 08:09:27 -0400
From: Brian Foster <bfoster@redhat.com>
Subject: Re: xfs_alloc_ag_vextent_near() takes about 30ms to complete
Message-ID: <20181024120926.GA46681@bfoster>
References: <CAGiyNfAUewzAjASPBccOk91PJ+nLS0nF4U3EvO4n59XsYu5P-w@mail.gmail.com>
 <20181023145339.GA7537@bfoster>
 <CAGiyNfAy+eTq+oba0Rb8Oe_kajFqD5a6rPnOkWPjC_E=foSqkg@mail.gmail.com>
 <20181024043416.GA19305@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20181024043416.GA19305@dastard>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: Mao Cheng <chengmao2010@gmail.com>, linux-xfs@vger.kernel.org

On Wed, Oct 24, 2018 at 03:34:16PM +1100, Dave Chinner wrote:
> On Wed, Oct 24, 2018 at 11:01:13AM +0800, Mao Cheng wrote:
> > Hi Brian,
> > Thanks for your response.
> > Brian Foster <bfoster@redhat.com> 于2018年10月23日周二 下午10:53写道：
> > >
> > > On Tue, Oct 23, 2018 at 03:56:51PM +0800, Mao Cheng wrote:
> > > > Sorry for trouble again. I just wrote wrong function name in previous
> > > > sending, so resend it.
> > > > If you have received previous email please ignore it, thanks
> > > >
> > > > we have a XFS mkfs with "-k" and mount with the default options(
> > > > rw,relatime,attr2,inode64,noquota), the size is about 2.2TB，and
> > > > exported via samba.
> > > >
> > > > [root@test1 home]# xfs_info /dev/sdk
> > > > meta-data=/dev/sdk               isize=512    agcount=4, agsize=131072000 blks
> > > >          =                       sectsz=4096  attr=2, projid32bit=1
> > > >          =                       crc=1        finobt=0 spinodes=0
> > > > data     =                       bsize=4096   blocks=524288000, imaxpct=5
> > > >          =                       sunit=0      swidth=0 blks
> > > > naming   =version 2              bsize=4096   ascii-ci=0 ftype=1
> > > > log      =internal               bsize=4096   blocks=256000, version=2
> > > >          =                       sectsz=4096  sunit=1 blks, lazy-count=1
> > > > realtime =none                   extsz=4096   blocks=0, rtextents=0
> > > >
> > > > free space about allocation groups:
> > > >    from      to extents  blocks    pct
> > > >       1       1       9       9   0.00
> > > >       2       3   14291   29124   0.19
> > > >       4       7    5689   22981   0.15
> > > >       8      15     119    1422   0.01
> > > >      16      31  754657 15093035  99.65
> 
> 750,000 fragmented free extents means something like 1600 btree
> leaf blocks to hold them all.....
> 
> > > xfs_alloc_ag_vextent_near() is one of the several block allocation
> > > algorithms in XFS. That function itself includes a couple different
> > > algorithms for the "near" allocation based on the state of the AG. One
> > > looks like an intra-block search of the by-size free space btree (if not
> > > many suitably sized extents are available) and the second looks like an
> > > outward sweep of the by-block free space btree to find a suitably sized
> > > extent.
> 
> Yup, just like the free inode allocation search, which is capped
> at about 10 btree blocks left and right to prevent searching the
> entire tree for the one free inode that remains in it.
> 
> The problem here is that the first algorithm fails immediately
> because there isn't a contiguous free space large enough for the
> allocation being requested, and so it finds the largest block whose
> /location/ is less than target block as the start point for the
> nearest largest freespace.
> 

Hmm, not sure I follow what you're saying here wrt to why we end up in
the second algorithm. I was thinking the most likely condition is that
there are actually plenty of suitably sized extents, but as shown by the
free space data, they're amidst a huge number of too small extents. The
first algorithm is only active if a lookup in the cntbt lands in the
last block (the far right leaf) of the btree, so unless I'm missing
something this would mean we'd skip right past it to the second
algorithm if the last N blocks (where N > 1) of the cnt_bt have large
enough extents.

IOW, the first algo seems like an optimization for when we know there
are only a small number of minimum sized extents available and the
second (location based) algorithm would mostly churn. Regardless, we end
up in the same place in the end...

> IOW, we do an expanding radius size search based on physical
> locality rather than finding a free space based on size. Once we
> find a good extent to either the left or right, we then stop that
> search and try to find a better extent to the other direction
> (xfs_alloc_find_best_extent()). That search is not bound, so can
> search the entire of the tree in that remaining directory without
> finding a better match.
> 
> We can't cut the initial left/right search shorter - we've got to
> find a large enough free extent to succeed, but we can chop
> xfs_alloc_find_best_extent() short, similar to searchdistance in
> xfs_dialloc_ag_inobt(). The patch below does that.
> 

This search looks like it goes as far in the opposite direction as the
current candidate extent. So I take it this could potentially go off the
rails if we find one suitable extent in one direction that is relatively
far off wrt to startblock, and then the opposite direction happens to be
populated with a ton of too small extents before we extend to the range
that breaks the search.

I'm curious whether this contributes to the reporter's problem at all,
but this sounds like a reasonable change to me either way.

> Really, though, I think what we need to a better size based search
> before falling back to a locality based search. This is more
> complex, so not a few minutes work and requires a lot more thought
> and testing.
> 

Indeed. As noted above, the current size based search strikes me as an
optimization that only executes under particular conditions.

Since the purpose of this function is locality allocation, I'm wondering
if we could implement a smarter location based search using information
available in the by-size tree. For example, suppose we could identify
the closest minimally sized extents to agbno in order to better seed the
left/right starting points of the location based search. This of course
would require careful heuristics/tradeoffs to make sure we don't just
replace a bnobt scan with a cntbt scan.

Or perhaps do something like locate the range of cntbt extents within
the min/max size, then make an intelligent decision over whether to scan
that set of cntbt records, perform a smarter bnobt scan or resort to the
current algorithm. Just thinking out loud...

Brian

> > We share an xfs filesystem to windows via SMB protocol.
> > There are about 5 windows copy small files to the samba share at the same time.
> > The main problem is the throughput degraded from 30MB/s to around
> > 10KB/s periodically and recovered about 5s later.
> > The kworker consumes 100% of one CPU when the throughput degraded and
> > kworker task is wrteback.
> > /proc/vmstat shows nr_dirty is very close to nr_dirty_threshold
> > and nr_writeback is too small(is that means there too many dirty pages
> > in page cache and can't be written out to disk?)
> 
> incoming writes are throttled at the rate writeback makes progress,
> hence the system will sit at the threshold. This is normal.
> Writeback is just slow because of the freespace fragmentation in the
> filesystem.
> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
> 
> xfs: cap search distance in xfs_alloc_ag_vextent_near()
> 
> From: Dave Chinner <dchinner@redhat.com>
> 
> Don't waste too much CPU time finding the perfect free extent when
> we don't have a large enough contiguous free space and there are
> many, many small free spaces that we'd do a linear search through.
> Modelled on searchdistance in xfs_dialloc_ag_inobt() which solved
> the same problem with the cost of finding the last free inodes in
> the inode allocation btree.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/libxfs/xfs_alloc.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
> index e1c0c0d2f1b0..c0c0a018e3bb 100644
> --- a/fs/xfs/libxfs/xfs_alloc.c
> +++ b/fs/xfs/libxfs/xfs_alloc.c
> @@ -886,8 +886,14 @@ xfs_alloc_ag_vextent_exact(
>  }
>  
>  /*
> - * Search the btree in a given direction via the search cursor and compare
> - * the records found against the good extent we've already found.
> + * Search the btree in a given direction via the search cursor and compare the
> + * records found against the good extent we've already found.
> + *
> + * We cap this search to a number of records to prevent searching hundreds of
> + * thousands of records in a potentially futile search for a larger freespace
> + * when free space is really badly fragmented. Spending more CPU time than the
> + * IO cost of a sub-optimal allocation is a bad tradeoff - cap it at searching
> + * a full btree block (~500 records on a 4k block size fs).
>   */
>  STATIC int
>  xfs_alloc_find_best_extent(
> @@ -906,6 +912,7 @@ xfs_alloc_find_best_extent(
>  	int			error;
>  	int			i;
>  	unsigned		busy_gen;
> +	int			searchdistance = args->mp->m_alloc_mxr[0];
>  
>  	/* The good extent is perfect, no need to  search. */
>  	if (!gdiff)
> @@ -963,7 +970,7 @@ xfs_alloc_find_best_extent(
>  			error = xfs_btree_decrement(*scur, 0, &i);
>  		if (error)
>  			goto error0;
> -	} while (i);
> +	} while (i && searchdistance-- > 0);
>  
>  out_use_good:
>  	xfs_btree_del_cursor(*scur, XFS_BTREE_NOERROR);
