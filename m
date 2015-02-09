Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 93FCC7FB2
	for <xfs@oss.sgi.com>; Mon,  9 Feb 2015 15:48:24 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 14CBFAC002
	for <xfs@oss.sgi.com>; Mon,  9 Feb 2015 13:48:20 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	cUUkEeWatRb4QVFG for <xfs@oss.sgi.com>;
	Mon, 09 Feb 2015 13:48:17 -0800 (PST)
Date: Tue, 10 Feb 2015 08:48:15 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v3 04/18] xfs: introduce inode record hole mask for
	sparse inode chunks
Message-ID: <20150209214815.GV12722@dastard>
References: <1423252385-3063-1-git-send-email-bfoster@redhat.com>
	<1423252385-3063-5-git-send-email-bfoster@redhat.com>
	<20150206231615.GQ12722@dastard>
	<20150208160600.GB2927@bfoster.bfoster>
	<20150208215710.GC4251@dastard>
	<20150209151502.GB18336@laptop.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150209151502.GB18336@laptop.bfoster>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Mon, Feb 09, 2015 at 10:15:02AM -0500, Brian Foster wrote:
> On Mon, Feb 09, 2015 at 08:57:10AM +1100, Dave Chinner wrote:
> > On Sun, Feb 08, 2015 at 11:06:01AM -0500, Brian Foster wrote:
> > > > > @@ -82,7 +84,9 @@ xfs_inobt_update(
> > > > >  	union xfs_btree_rec	rec;
> > > > >  
> > > > >  	rec.inobt.ir_startino = cpu_to_be32(irec->ir_startino);
> > > > > -	rec.inobt.ir_freecount = cpu_to_be32(irec->ir_freecount);
> > > > > +	rec.inobt.ir_holemask = cpu_to_be16(irec->ir_holemask);
> > > > > +	rec.inobt.ir_count = irec->ir_count;
> > > > > +	rec.inobt.ir_freecount = irec->ir_freecount;
> > > > >  	rec.inobt.ir_free = cpu_to_be64(irec->ir_free);
> > > > >  	return xfs_btree_update(cur, &rec);
> > > > >  }
> > > > 
> > > > Hmmm - perhaps a similar set of helpers for sparse inode enabled
> > > > filesystems
> > > > 
> > > 
> > > We could do that for the insert/update helpers, but note again the
> > > separate helpers would not split along the lines of sparse vs full
> > > chunks. Even if we were to change the design such that they do, that
> > > would have th effect of complicating some of the subsequent code. For
> > 
> > I suspect it might, but I really don't like the idea of writing
> > fields that don't actually exist (and hence are always zero) in
> > the on-disk format to disk. See, for example, the v5 superblock
> > field writes are conditional in xfs_sb_to_disk, the v3 inode field
> > writes are conditional in xfs_dinode_to_disk, etc.
> > 
> 
> Indeed. The point here is just that a v1/v2 differentiation might be
> more relevant than full vs. sparse. As it is, a sparse inode enabled fs
> uses all of the fields (e.g., ir_count == 64 on a full chunk). So this
> is more about providing clean backwards compatibility than deciding
> between two different "allocation types," so to speak.
> 
> Beyond that, I'm more just probing for a clean use of the new on-disk
> format distinction. The references above actually use the associated
> feature checks in a single helper as opposed to a separate one, and that
> seems a bit more clean an approach to me.

BUt that's because those object have enough information internally
to determine what the correct action to take is. An inobt record
doesn't have the internal information to say whay format it is
supposed to be in. Hence we need to enforce the use of the correct
marshalling logic in some way...

> > > example, the merge/update code currently has no reason to care about
> > > whether it has created a full chunk out of multiple sparse chunks. This
> > > would require more code to make that distinction simply to pick the
> > > correct api, for something that can easily be done with a simple generic
> > > helper. The same goes for things like the finobt, where now
> > > lookup/update/insert has to make distinctions depending on the type of
> > > inode record.
> > 
> > That was another thing that wasn't clear to me - does the finobt
> > record format change on disk? I don't think it does, as it only
> > holds a free count and a free inode bitmask, so it doesn't care
> > which bits of the chunk are allocated or not....
> > 
> 
> No, it shouldn't change the format. But if we have a separate set of
> inobt helpers, it has to use one or the other depending on the type of
> record holding the inode that is freed or allocated.

Ok, so we now have 3 instances of inode btrees that use the current
format, and one that uses the new sparse record format. (i.e.
existing inobt, existing finobt and sparse inode enable finobt vs
sparse inode inobt). That really, to me, says we need clear
demarcation....

> > > An alternate approach could be to stick with the generic helpers, but
> > > try and tweak them to use the appropriate on-disk format depending on
> > > the record. Then again, how can one really identify one from the other
> > > in the lookup or _get_rec() scenarios?
> > 
> > Solving these problem was exactly why I suggested different helpers
> > - the btree ops structure that is chosen for the cursor is in a
> > place where we know what format we are using, and that avoids
> > needing "if (xfs_sb_version...)" checks in the helpers to determine
> > what format we need to use.
> > 
> 
> Hmm, I'm not sure I follow the train of thought here. The examples above
> use exactly that kind of logic within the helper. Further, some of the

They use internal object state (i.e. inode version number,
superblock flag field in sb being translated) to make that decision.
the inobt changes use external structure state to do the
conversion...

> > > Before I go one way or another here with regard to the on-disk data
> > > structure, care to take a look at the subsequent patch(es) that use
> > > these helpers? Patch 10 in particular pretty much sums up how these
> > > helpers are used for sparse inode record management.
> > 
> > Yup, I'll get to it.
> > 
> 
> Thanks. I've made a quick pass and most of it makes sense save some of
> the helper business we're discussing here. I can start into some of the
> higher level refactoring, try to incorporate the on-disk record format
> union as clean as I can and we can move forward using the code of the
> next version, if that's easier. ;)

Yup, that's fine - refactoring the code might make a difference ;)

> > > FWIW, comments on the generic bitmap stuff is also appreciated as that's
> > > another area I'm not totally convinved is done right. :)
> > 
> > Why use the generic bitmap stuff rather than the existing XFS code?
> > If that's just an in-memory change to the free mask processing, then
> > it can be done separately to the sparse inode functionality, and
> > probably should be done first in the series....
> > 
> 
> http://oss.sgi.com/archives/xfs/2014-07/msg00380.html
> 
> Last comment in that mail. ;) To be honest, I liked the original code
> better because it didn't require the bitmap_to_u64() helper hack and

I didn't realise there were arch-specific warts in the generic
bitmap code.

> ports directly to userspace (so far I've managed to get away with
> dropping that stuff entirely in userspace). Alternatively, I've done
> significantly more testing with the latest code than the initial version
> so I'd rather not change it back unless a real need arises.

Well, either way I'd like to avoid nasty conversions if it can be
avoided. Perhaps look at the in-memory bitmaps being held in LE
format (i.e. __le64) and using the primitives in
include/asm-generic/bitops/le.h to manipulate them (i.e
find_next_zero_bit_le() and friends)? Maybe that would avoid all the
problems of architectural layout of the bitmap fields and hence make
conversion simple (i.e. just a le64_to_cpu() call?)

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
