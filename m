Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p3DGVhVq205195 for <xfs@oss.sgi.com>; Wed, 13 Apr 2011 11:31:43 -0500
Subject: Re: [PATCH 0/3] xfsprogs: sync up with 2.6.38 kernel code V2
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110214063042.GL2559@dastard>
References: <1294649091-27174-1-git-send-email-david@fromorbit.com>
	<20110214063042.GL2559@dastard>
Date: Wed, 13 Apr 2011 11:34:36 -0500
Message-ID: <1302712476.2648.111.camel@doink>
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

On Mon, 2011-02-14 at 17:30 +1100, Dave Chinner wrote:
> I just updated these patches at:
> 
> git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev kernel-2.6.38-sync
> 
> With all the review comments addressed.
> 
> Cheers,
> 
> Dave.
> 

Below is an edited version of my review for the third patch in this
series from an earlier time you posted it for review.  I've compared
what's in the updated git branch with what I originally said, and
have ripped out a lot of stuff I wrote, leaving only the things that
I'd like you to consider updating before committing this to the
xfsprogs-dev tree.  

In general, I assume that your plan is to do an initial commit, then
update again later with something that will bring things more
closely in line with the kernel code (specifically, I think you
mentioned 2.6.38 or .39 on IRC).  The code has diverged a bit since
last time I looked this over, but I'm pretty sure it will sync up
fine later.

Thereafter it would be nice to update with each kernel release.  For
header files at least, it would be nice to transition our way so we
can just point to the kernel headers directory rather than including
copies of the header files here.

I'll leave it to your discretion to do what you think is best.
Whatever you do, you can consider it reviewed by me.

Reviewed-by: Alex Elder <aelder@sgi.com>


On Mon, 2011-01-10 at 19:44 +1100, Dave Chinner wrote:
> Bring the libxfs headers and code into sync with the 2.6.37 kernel
code.
> Update the rest of xfsprogs to work with the new code.
>
> Note: this does not convert xfsprogs to the kernel xfs_trans_ijoin
\ijoin_ref
> interface, it maintains the older ijoin/ihold interface because of the
> different way the inode reference counting works in libxfs. More work
will be
> needed to change it over to a manner compatible with the current
kernel API.
>

------------

> diff --git a/db/attrset.c b/db/attrset.c
> index 35fea11..cbecbe9 100644
> --- a/db/attrset.c
> +++ b/db/attrset.c
> @@ -158,7 +158,8 @@ attr_set_f(
>               goto out;
>       }
>
> -     if (libxfs_attr_set(ip, name, value, valuelen, flags)) {
> +     if (libxfs_attr_set(ip, (unsigned char *)name,
> +                             (unsigned char *)value, valuelen,
flags)) {

Maybe just change the types of "name" and "value", and cast them
when they are assigned.  (And drop the needless cast of the value
returned by memalign() when you do.)

And another aside in this function.  What the hell is this?
                memset(value, 0xfeedface, valuelen);

>               dbprintf(_("failed to set attr %s on inode %llu\n"),
>                       name, (unsigned long long)iocur_top->ino);
>               goto out;
> @@ -233,7 +234,7 @@ attr_remove_f(
>               goto out;
>       }
>
> -     if (libxfs_attr_remove(ip, name, flags)) {
> +     if (libxfs_attr_remove(ip, (unsigned char *)name, flags)) {

Again, I'd rather see the cast occur when "name" gets
assigned.

>               dbprintf(_("failed to remove attr %s from inode %llu
\n"),
>                       name, (unsigned long long)iocur_top->ino);
>               goto out;

------------

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

------------

> diff --git a/include/xfs_mount.h b/include/xfs_mount.h
> index ff200d1..94a02e1 100644
> --- a/include/xfs_mount.h
> +++ b/include/xfs_mount.h

Here is how this file differs from the kernel:
- The perag_get/put function declarations sit in different
  parts of the file.  (Easily reconciled.)


------------


> diff --git a/include/xfs_sb.h b/include/xfs_sb.h
> index f88dc32..5dcc2d7 100644
> --- a/include/xfs_sb.h
> +++ b/include/xfs_sb.h

Kernel is missing xfs_sb_version_addprojid32bit().
Otherwise identical.  I'm not sure whether this
would be used in the kernel, but maybe we should
make the two files identical.

------------

> diff --git a/libxfs/xfs_inode.c b/libxfs/xfs_inode.c
> index 1c9ea3b..e4474fd 100644
> --- a/libxfs/xfs_inode.c
> +++ b/libxfs/xfs_inode.c

. . .

> @@ -266,55 +277,65 @@ xfs_iformat(

. . .

> +     if (unlikely((ip->i_d.di_flags & XFS_DIFLAG_REALTIME) &&
> +                  !ip->i_mount->m_rtdev)) {

                       !ip->i_mount->m_rtdev_targp

With the exception of this, this function is nearly identical to the
kernel version.  I don't know why there's this difference.

> +             xfs_fs_repair_cmn_err(CE_WARN, ip->i_mount,
> +                     "corrupt dinode %Lu, has realtime flag set.",
> +                     ip->i_ino);
> +             XFS_CORRUPTION_ERROR("xfs_iformat(realtime)",
> +                                  XFS_ERRLEVEL_LOW, ip->i_mount,
dip);

------------

> diff --git a/repair/phase6.c b/repair/phase6.c
> index d056063..f7ae25e 100644
> --- a/repair/phase6.c
> +++ b/repair/phase6.c

. . .

> @@ -444,11 +444,11 @@ mk_rbmino(xfs_mount_t *mp)
>                       error);
>       }
>
> -     memset(&ip->i_d, 0, sizeof(xfs_dinode_core_t));
> +     memset(&ip->i_d, 0, sizeof(xfs_icdinode_t));

Was this just a bug that you're fixing now?  (Wrong
data type used in the size.)  Same thing in mk_rsumino()
and mk_root_dir().

. . .


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
