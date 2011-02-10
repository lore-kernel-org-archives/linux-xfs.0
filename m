Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p1AJ1iw3151177 for <xfs@oss.sgi.com>; Thu, 10 Feb 2011 13:01:44 -0600
Subject: Re: [PATCH 3/3] libxfs: sync files with 2.6.38 kernel code
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <1294649091-27174-4-git-send-email-david@fromorbit.com>
References: <1294649091-27174-1-git-send-email-david@fromorbit.com>
	<1294649091-27174-4-git-send-email-david@fromorbit.com>
Date: Thu, 10 Feb 2011 13:02:25 -0600
Message-ID: <1297364545.2529.167.camel@doink>
Mime-Version: 1.0
Reply-To: aelder@sgi.com
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, 2011-01-10 at 19:44 +1100, Dave Chinner wrote: 
> Bring the libxfs headers and code into sync with the 2.6.37 kernel code.
> Update the rest of xfsprogs to work with the new code.
> 
> Note: this does not convert xfsprogs to the kernel xfs_trans_ijoin\ijoin_ref
> interface, it maintains the older ijoin/ihold interface because of the
> different way the inode reference counting works in libxfs. More work will be
> needed to change it over to a manner compatible with the current kernel API.
> 
> Note: log sector size handling needs to be sorted out. Specifically,
> initialising l_sectbb_log/l_sectBBsize correctly and removing the hacks in
> xlog_bread and friends (libxlog/xfs_log_recover.c) to work around the fact they
> are not initialised correctly. (FWIW, I don't think xfsprogs handles large log
> sector size correctly as a result, and especially not if the log device sector
> size is different to the data device sector size).
> 
> Testing:
> 
> Currently passes xfstests on x86_64 w/ 4k block sizes and 512 byte block/2k
> directory block filesystems. No obvious regressions are occurring during
> xfstests runs.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>

OK, I spent a lot of time on this.  At first I thought the changes
were small enough that I was fairly confident they were OK.  But
after getting into it for a while I realized it was really too much
to review at once, so instead I worked on some more systematic
analysis based mostly on comparing what I could with corresponding
kernel code.  More on all this below.

As a bottom line summary though:
- Generally this looks fine.  The kernel code has been updated
  a bit since you submitted this patch, and it would be nice
  if you could update things to reflect that.  I don't expect
  you to track that moving target, but at least now that it's
  undergone an initial review, future reviews won't require
  much effort so you can get pretty close.
- We really need to subject this to as much testing as we
  can before committing to the change.  I don't know how
  much is reasonable, or if there is more we could add
  to xfstests to ensure we have good coverage.  On the
  other hand, I don't want to wait too long either (because
  of the constantly changing kernel code base).
- Now that we'll be fairly well sync'ed, what can we do
  to keep things in sync in the future?  It would be
  nice if at least pieces of that process could be
  automated so we can keep things current incrementally
  rather than doing a big update every so often.

That's probably enough discussion.  I guess you might
as well consider this reviewed by me; I'm not going to
review it as closely as this again.  I do think an
update would be warranted before committing though.

Without further ado...

Reviewed-by: Alex Elder <aelder@sgi.com>




Why are you dropping the use of the symbols XFS_DINODE_VERSION_1 and
XFS_DINODE_VERSION_2 in favor of just using 1 and 2?  I recognize
the symbolic names offer little value on their face but at least you
can search for them.  (I'll not comment on all the instances where
this occurs in your patch.) 

Here are some things that are included in these changes.
They're simple, but widespread.
- xfs_dinode_core is gone; xfs_dinode incorporates its
  fields directly rather than having them in a substructure.
  This accounts for the bulk of the changes.
- Put in xfs_perag_get() and xfs_perag_put() calls in places
  where the perag structure was just used naked before.
- Drop the "delta" argument from xfs_bmapi() and xfs_bunmapi().
- Drop the "bno" and "imap_flags" arguments from xfs_itobp().
- Change xfs_ichgtime() references to xfs_trans_ichgtime().
- Pointless macros like XFS_ATTR_LEAVE_NAME_LOCAL() have
  been eliminated.
- xfs_bmbt_rec_64_t is gone, replaced by xfs_bmbt_rec_t.
- Use of XFS_DFORK_DPTR() in some places rather than using
  the union fields.
- New log item descriptor memory zone/slab.
- Switch from the old (xfs_*_trace_*()) to the new
  (trace_xfs_*()) tracing interfaces.
- A few objects and interfaces have switched to use
  (unsigned char) rather than (char).
- Spelling errors in comments fixed.

I started out reviewing all of the changes, and came up with the
above list in the process.  Then I took a different approach and
tried to eliminate a bunch of the files by finding any that have
kernel counterparts and eliminating them if they were identical.
That is, if they match what's in the kernel I assume that's good
and correct (which is not a valid assumption, I realize).

These header files, found under xfsprogs/include, are now
(after applying this patch series) identical to their
counterparts found under fs/xfs in the kernel tree.  I have
therefore not really reviewed them:

    include/xfs_alloc_btree.h (not affected by this patch)
    include/xfs_arch.h
    include/xfs_attr_leaf.h
    include/xfs_attr_sf.h
    include/xfs_bit.h
    include/xfs_bmap_btree.h
    include/xfs_bmap.h
    include/xfs_btree.h
    include/xfs_btree_trace.h
    include/xfs_da_btree.h
    include/xfs_dfrag.h
    include/xfs_dinode.h
    include/xfs_dir2_block.h (not affected by this patch)
    include/xfs_dir2_data.h
    include/xfs_dir2.h
    include/xfs_dir2_leaf.h
    include/xfs_dir2_node.h
    include/xfs_dir2_sf.h
    include/xfs_extfree_item.h (not affected by this patch)
    include/xfs_ialloc_btree.h
    include/xfs_ialloc.h
    include/xfs_inode_item.h
    include/xfs_inum.h
    include/xfs_log_priv.h (not affected by this patch)
    include/xfs_log_recover.h (not affected by this patch)
    include/xfs_rtalloc.h
    include/xfs_trans.h
    include/xfs_trans_space.h
    include/xfs_types.h

For the rest of the files affected by this patch I have
reviewed each and have commented below.  If a file has
a kernel counterpart, I mainly just report what now
differs between the two; in such cases the review is
mostly superficial.

. . .

> diff --git a/db/attr.c b/db/attr.c

This file looks good.

> diff --git a/db/attrset.c b/db/attrset.c
> index 35fea11..cbecbe9 100644
> --- a/db/attrset.c
> +++ b/db/attrset.c
> @@ -158,7 +158,8 @@ attr_set_f(
>  		goto out;
>  	}
>  
> -	if (libxfs_attr_set(ip, name, value, valuelen, flags)) {
> +	if (libxfs_attr_set(ip, (unsigned char *)name,
> +				(unsigned char *)value, valuelen, flags)) {

Maybe just change the types of "name" and "value", and cast them
when they are assigned.  (And drop the needless cast of the value
returned by memalign() when you do.)

And another aside in this function.  What the hell is this?
                memset(value, 0xfeedface, valuelen);

> 		dbprintf(_("failed to set attr %s on inode %llu\n"),
>  			name, (unsigned long long)iocur_top->ino);
>  		goto out;
> @@ -233,7 +234,7 @@ attr_remove_f(
>  		goto out;
>  	}
>  
> -	if (libxfs_attr_remove(ip, name, flags)) {
> +	if (libxfs_attr_remove(ip, (unsigned char *)name, flags)) {

Again, I'd rather see the cast occur when "name" gets
assigned.

> 		dbprintf(_("failed to remove attr %s from inode %llu\n"),
>  			name, (unsigned long long)iocur_top->ino);
>  		goto out;
> diff --git a/db/bmap.c b/db/bmap.c

This file looks good.

> diff --git a/db/bmap.h b/db/bmap.h

This file looks good.

> diff --git a/db/check.c b/db/check.c

This file looks good.

> diff --git a/db/convert.c b/db/convert.c

This file looks good.

> diff --git a/db/dir2sf.c b/db/dir2sf.c

This file looks good.

> diff --git a/db/field.c b/db/field.c

This file looks good.

> diff --git a/db/frag.c b/db/frag.c

This file looks good.

> diff --git a/db/inode.c b/db/inode.c

This file looks good.

> diff --git a/db/metadump.c b/db/metadump.c

This file looks good.

> diff --git a/include/libxfs.h b/include/libxfs.h

This file looks good.  It collects some things from several
other files; I didn't verify everthing but it all seems
reasonable.

> diff --git a/include/xfs_ag.h b/include/xfs_ag.h
> index 729ee3e..5adce91 100644
> --- a/include/xfs_ag.h
> +++ b/include/xfs_ag.h

This file looks good.

> diff --git a/include/xfs_alloc.h b/include/xfs_alloc.h

Here is how this file differs from the kernel:
- Missing "xfs: limit extent length for allocation to AG size"
- Missing "xfs: add FITRIM support"
They'll be identical if you update I think.

> diff --git a/include/xfs_fs.h b/include/xfs_fs.h
> index 47c1e93..faac5af 100644
> --- a/include/xfs_fs.h
> +++ b/include/xfs_fs.h

This file looks good.  It is now nearly identical to the
kernel version, with these exceptions:
- This version includes the definition of bstat_get_projid().
  It's used once, but it should be deleted and the one use
  should be converted to use xfs_get_projid() if that can
  be arranged.
- XFS_IOC_FREEZE and XFS_IOC_THAW are still defined in
  this version.  The code that uses it here could possibly
  be converted to use the Linux generic FIFREEZE and FITHAW
  instead.

> diff --git a/include/xfs_imap.h b/include/xfs_imap.h
> deleted file mode 100644
> index f9ce628..0000000
> --- a/include/xfs_imap.h
> +++ /dev/null

This looks good (file now gone, both places).

> diff --git a/include/xfs_inode.h b/include/xfs_inode.h
> index 7e6fc91..ca56544 100644
> --- a/include/xfs_inode.h
> +++ b/include/xfs_inode.h

Here is how this file differs from the kernel:
- For some reason, xfs_get_projid() and xfs_set_projid() are
  defined twice in this version.
- Missing "xfs: add lockdep annotations for the rt inodes"
- And there are a few lines where prototypes differ (struct
  versus typedef usage).

> diff --git a/include/xfs_mount.h b/include/xfs_mount.h
> index ff200d1..94a02e1 100644
> --- a/include/xfs_mount.h
> +++ b/include/xfs_mount.h

Here is how this file differs from the kernel:
- The perag_get/put function declarations sit in different
  parts of the file.  (Easily reconciled.)

> diff --git a/include/xfs_quota.h b/include/xfs_quota.h
> index 12c4ec7..5d1f57d 100644
> --- a/include/xfs_quota.h
> +++ b/include/xfs_quota.h

Here is how this file differs from the kernel:
- A few prototypes are in different parts of the two files.
- I think all of the other differences are simply declarations
  of stub routines for the user space code.

> diff --git a/include/xfs_sb.h b/include/xfs_sb.h
> index f88dc32..5dcc2d7 100644
> --- a/include/xfs_sb.h
> +++ b/include/xfs_sb.h

Kernel is missing xfs_sb_version_addprojid32bit().
Otherwise identical.  I'm not sure whether this
would be used in the kernel, but maybe we should
make the two files identical.

> diff --git a/include/xfs_trace.h b/include/xfs_trace.h
> index fef82d0..bf82f6e 100644
> --- a/include/xfs_trace.h
> +++ b/include/xfs_trace.h

This file is the only one located under the linux-2.6
directory in the kernel tree.  Pretty much everything
here seems to be just setting up stub routines, which
I'm going to assume is fine (without any really deep
review).

> diff --git a/libxfs/init.c b/libxfs/init.c
> index 75d043e..d59308d 100644
> --- a/libxfs/init.c
> +++ b/libxfs/init.c

. . .

> +static int
> +libxfs_initialize_perag(
> +	xfs_mount_t	*mp,
> +	xfs_agnumber_t	agcount,
> +	xfs_agnumber_t	*maxagi)
> +{

This function is identical to what's in the kernel except
the pag_ici_root is not initialized.

> @@ -534,6 +640,7 @@ libxfs_mount(
>  	mp->m_logdev = logdev;
>  	mp->m_flags = (LIBXFS_MOUNT_32BITINODES|LIBXFS_MOUNT_32BITINOOPT);
>  	mp->m_sb = *sb;
> +	INIT_RADIX_TREE(&mp->m_perag_tree, GFP_KERNEL);

This looks like it's where the initialization moved to, but
the GFP is different (it's GFP_ATOMIC in the kernel).
 
> diff --git a/libxfs/logitem.c b/libxfs/logitem.c

This file looks good.

> diff --git a/libxfs/trans.c b/libxfs/trans.c

This file looks good.

> diff --git a/libxfs/util.c b/libxfs/util.c
> index 077d2a2..bffbac0 100644
> --- a/libxfs/util.c
> +++ b/libxfs/util.c

. . .

> @@ -74,22 +77,26 @@ libxfs_iread(
>  	ip->i_ino = ino;
>  	ip->i_mount = mp;

This function looks like it could possibly be updated
to be more closely matched to the kernel code.  The
changes otherwise look OK.

> diff --git a/libxfs/xfs.h b/libxfs/xfs.h
> index a9e2bf1..b3f8378 100644
> --- a/libxfs/xfs.h
> +++ b/libxfs/xfs.h

This file looks generally OK.  The changes look
fairly routine and most of them I remember the
corresponding change going into the kernel.

>  @@ -99,6 +95,8 @@ typedef __uint32_t		inst_t;		/* an instruction */
>  #define spin_unlock(a)		((void) 0)
>  #define likely(x)		(x)
>  #define unlikely(x)		(x)
> +#define rcu_read_lock()		((void) 0)
> +#define rcu_read_unlock()	((void) 0)

As Christoph pointed out elsewhere, we ought to do some
thinking about how to manage locking interfaces like this
to support actual locking when doing multithreaded work.
 
>  /*
>   * random32 is used for di_gen inode allocation, it must be zero for libxfs
> 
. . .

> diff --git a/libxfs/xfs_alloc.c b/libxfs/xfs_alloc.c

Here is how this file differs from the kernel:
- Different set of included header files.
- A few functions declared STATIC here but not in the kernel,
  and vice-versa.
- A pointless assignment to "rlen" remains here, but has been
  deleted from the kernel version.
- The busy list management functions are not present in the
  user space code.
- Maybe a comment different here and there.

> diff --git a/libxfs/xfs_alloc_btree.c b/libxfs/xfs_alloc_btree.c

This file looks good.  The only difference between it and
its kernel counterpart is the set of included header files.

> diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c

Here is how this file differs from the kernel:
- Different set of included header files.
- Seems to be missing "xfs: simplify inode to transaction joining"
- Definitions of a bunch of functions related to attribute
  lists are not present here (but are in the kernel).

> diff --git a/libxfs/xfs_attr_leaf.c b/libxfs/xfs_attr_leaf.c

Here is how this file differs from the kernel:
- Different set of included header files.
- Definitions of a bunch of functions related to attribute
  lists are not present here (but are in the kernel).
- Definitions of a bunch of functions related to attributes
  becoming inactive are not present here.


> diff --git a/libxfs/xfs_bmap.c b/libxfs/xfs_bmap.c

Here is how this file differs from the kernel:
- Different set of included header files.
- Missing "xfs: fix failed write truncation handling." and
  newer commits.
- Definitions of a bunch of functions are not present here
  (some of them are DEBUG-only).  Includes xfs_getbmap(),
  xfs_bmap_finish(), and several others.


> diff --git a/libxfs/xfs_bmap_btree.c b/libxfs/xfs_bmap_btree.c

This file looks good.

> diff --git a/libxfs/xfs_btree.c b/libxfs/xfs_btree.c

This file looks good.

> diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c

This file looks good.

> diff --git a/libxfs/xfs_dir2.c b/libxfs/xfs_dir2.c

This file looks good.

> diff --git a/libxfs/xfs_dir2_block.c b/libxfs/xfs_dir2_block.c

This file looks good.

> diff --git a/libxfs/xfs_dir2_leaf.c b/libxfs/xfs_dir2_leaf.c

This file looks good.

> diff --git a/libxfs/xfs_dir2_node.c b/libxfs/xfs_dir2_node.c

This file looks good.

> diff --git a/libxfs/xfs_dir2_sf.c b/libxfs/xfs_dir2_sf.c

This file looks good.

> diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
> index 32ae4b0..1fcafb6 100644
> --- a/libxfs/xfs_ialloc.c
> +++ b/libxfs/xfs_ialloc.c

. . .

> @@ -546,7 +504,7 @@ xfs_ialloc_ag_select(
>  					agbp = NULL;
>  					goto nextag;
>  				}
> -				up_read(&mp->m_peraglock);
> +				xfs_perag_put(pag);
>  				return agbp;
>  			}
>  		}
> 
> 

. . . (below is xfs_imap())

> -	int		i;	/* temp state */
>  	int		offset;	/* index of inode in its buffer */
> -	int		offset_agbno;	/* blks from chunk start to inode */
> +	xfs_agblock_t	offset_agbno;	/* blks from chunk start to inode */

This one is still an int in kernel code for some reason
 
> 	ASSERT(ino != NULLFSINO);
> +
>  	/*



> diff --git a/libxfs/xfs_ialloc_btree.c b/libxfs/xfs_ialloc_btree.c

This file looks good.

> diff --git a/libxfs/xfs_inode.c b/libxfs/xfs_inode.c
> index 1c9ea3b..e4474fd 100644
> --- a/libxfs/xfs_inode.c
> +++ b/libxfs/xfs_inode.c

. . .

> @@ -266,55 +277,65 @@ xfs_iformat(

. . . 

> +	if (unlikely((ip->i_d.di_flags & XFS_DIFLAG_REALTIME) &&
> +		     !ip->i_mount->m_rtdev)) {

		       !ip->i_mount->m_rtdev_targp

With the exception of this, this function is identical to the
kernel version.  I don't know why there's this difference.

> +		xfs_fs_repair_cmn_err(CE_WARN, ip->i_mount,
> +			"corrupt dinode %Lu, has realtime flag set.",
> +			ip->i_ino);
> +		XFS_CORRUPTION_ERROR("xfs_iformat(realtime)",
> +				     XFS_ERRLEVEL_LOW, ip->i_mount, dip);

. . .

> diff --git a/libxfs/xfs_mount.c b/libxfs/xfs_mount.c

This file looks good.

> diff --git a/logprint/log_misc.c b/logprint/log_misc.c

This file looks good.

> diff --git a/mkfs/proto.c b/mkfs/proto.c

This file looks good.

> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c

This file looks good.

> diff --git a/repair/attr_repair.c b/repair/attr_repair.c

This file looks good.

> diff --git a/repair/dino_chunks.c b/repair/dino_chunks.c

This file looks good.

> diff --git a/repair/dinode.c b/repair/dinode.c

This file looks good.

> diff --git a/repair/dir.c b/repair/dir.c

This file looks good.

> diff --git a/repair/dir2.c b/repair/dir2.c

This file looks good.

> diff --git a/repair/incore.h b/repair/incore.h

This file looks good.

> diff --git a/repair/phase6.c b/repair/phase6.c
> index d056063..f7ae25e 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c

. . .

> @@ -444,11 +444,11 @@ mk_rbmino(xfs_mount_t *mp)
>  			error);
>  	}
>  
> -	memset(&ip->i_d, 0, sizeof(xfs_dinode_core_t));
> +	memset(&ip->i_d, 0, sizeof(xfs_icdinode_t));

Was this just a bug that you're fixing now?  (Wrong
data type used in the size.)  Same thing in mk_rsumino()
and mk_root_dir(). 

. . .

> diff --git a/repair/prefetch.c b/repair/prefetch.c

This file looks good.

> diff --git a/repair/rt.c b/repair/rt.c

This file looks good.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
