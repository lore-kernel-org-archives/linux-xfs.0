Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p27IBsSn172055 for <xfs@oss.sgi.com>; Mon, 7 Mar 2011 12:11:54 -0600
Subject: Re: [PATCH 0/3] xfsprogs: sync up with 2.6.38 kernel code V2
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110214063042.GL2559@dastard>
References: <1294649091-27174-1-git-send-email-david@fromorbit.com>
	<20110214063042.GL2559@dastard>
Date: Mon, 07 Mar 2011 12:14:44 -0600
Message-ID: <1299521684.2578.457.camel@doink>
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

It looks to me like you may not have done much with the third
patch since I first reviewed it.  I'm not going to spend
as much time on it this time around, but I will try to
condense my original response into a more useful form
than the first time.

Please consider my suggestions below.  But even if you
don't address everything I'm OK with it, provided we
ensure we do as much test coverage as possible.

Reviewed-by: Alex Elder <aelder@sgi.com>

1) Please verify that the updated user space files
   match an up-to-date version of the kernel headers.
2) Many of the files become identical to their kernel
   counterparts with this update.  Can you create a
   script that verifies that it's still the case?
   That will also serve the purpose of documenting
   which files are identical now.
3) Why are you dropping the use of the symbols
   XFS_DINODE_VERSION_1 and XFS_DINODE_VERSION_2 in
  favor of just using 1 and 2?  (I guess I'm OK with
  it, but wanted to call it out anyway.)

A few things on specific files follow.  I've dropped
a few of the things I commented on the first time around.

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

> diff --git a/include/xfs_inode.h b/include/xfs_inode.h
> index 7e6fc91..ca56544 100644
> --- a/include/xfs_inode.h
> +++ b/include/xfs_inode.h

Here is how this file differs from the kernel:
version.
- Missing "xfs: add lockdep annotations for the rt inodes"
- And there are a few lines where prototypes differ (struct
  versus typedef usage).

> diff --git a/include/xfs_mount.h b/include/xfs_mount.h
> index ff200d1..94a02e1 100644
> --- a/include/xfs_mount.h
> +++ b/include/xfs_mount.h

Here is how this file differs from the kernel:
- The perag_get/put function declarations sit in different
  parts of the file.

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

With the exception of this, this function is identical to the
kernel version.  I don't know why there's this difference.



_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
