Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from m213138.ym.163.com ([223.252.213.138]:22672 "EHLO
        m213138.ym.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935990AbeCBGXg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 2 Mar 2018 01:23:36 -0500
Subject: Re: xfs_repair: add '-F' option to ignore writable mount checking
References: <5A97638A.9050509@xtaotech.com> <5A9765FD.1090907@xtaotech.com>
From: Yang Joseph <joseph.yang@xtaotech.com>
Message-ID: <5A98EDCD.9060005@xtaotech.com>
Date: Fri, 2 Mar 2018 14:23:09 +0800
MIME-Version: 1.0
In-Reply-To: <5A9765FD.1090907@xtaotech.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: sandeen@sandeen.net, david@fromorbit.com, sandeen@redhat.com, nathans@debian.org, rtlinux@163.com


Hello Eric Sandeen and Dave Chinner,

Could you kindly help me to review this patch? This time, the xfs_repair 
block problem is fixed,
and xfs_repair/xfs_copy's behaviors are the same as before.

# mount | grep fuse
ceph-fuse on /mnt/registry type fuse.ceph-fuse 
(rw,nosuid,nodev,relatime,user_id=0,group_id=0,default_permissions,allow_other)

stat('ceph-fuse') will return error, and the mountpoint scanning loop 
will continue, other than blocked on stat("/mnt/registry").

thx,

Yang Honggang

On 03/01/2018 10:31 AM, Yang Joseph wrote:
>
> hello,
>
> My last reply is rejected, so I resend this email.
>
> A new suggestion:
>
> From: Yang Honggang <joseph.yang@xtaotech.com>
>
> stat(/path/to/device) instead of stat(mountpoint) to prevent
> platform_check_mount() from hanging on stat() systemcall
> when a dead fuse mountpoint is encountered. Because this
> kind of mountpoint has no local device, only 'ceph-fuse',
> stat('ceph-fuse') will return error, and the while loop will
> continue.
>
> Signed-off-by: Yang Honggang <joseph.yang@xtaotech.com>
> ---
>  libxfs/linux.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/libxfs/linux.c b/libxfs/linux.c
> index 0bace3e..d415c33 100644
> --- a/libxfs/linux.c
> +++ b/libxfs/linux.c
> @@ -78,9 +78,9 @@ platform_check_mount(char *name, char *block, struct 
> stat *s, int flags)
>          return 1;
>      }
>      while ((mnt = getmntent(f)) != NULL) {
> -        if (stat(mnt->mnt_dir, &mst) < 0)
> +        if (stat(mnt->mnt_fsname, &mst) < 0)
>              continue;
> -        if (mst.st_dev != s->st_rdev)
> +        if (mst.st_rdev != s->st_rdev)
>              continue;
>          /* Found our device, is RO OK? */
>          if ((flags & CHECK_MOUNT_WRITABLE) && hasmntopt(mnt, MNTOPT_RO))

