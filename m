Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:45602 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752444AbeB0K5Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 27 Feb 2018 05:57:25 -0500
Received: by mail-wr0-f194.google.com with SMTP id p104so24337407wrc.12
        for <linux-xfs@vger.kernel.org>; Tue, 27 Feb 2018 02:57:24 -0800 (PST)
Date: Tue, 27 Feb 2018 11:57:21 +0100
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: xfs_repair: add '-F' option to ignore writable mount checking
Message-ID: <20180227105721.iebac6qlny2r445d@odin.usersys.redhat.com>
References: <5A914B45.8080200@xtaotech.com>
 <5c0df437-0f09-129c-945f-0f917bfdaa7e@sandeen.net>
 <20180224220428.GB30854@dastard>
 <5A953693.8080101@xtaotech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5A953693.8080101@xtaotech.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Yang Joseph <joseph.yang@xtaotech.com>
Cc: Dave Chinner <david@fromorbit.com>, Eric Sandeen <sandeen@sandeen.net>, sandeen@redhat.com, nathans@debian.org, linux-xfs@vger.kernel.org

On Tue, Feb 27, 2018 at 06:44:35PM +0800, Yang Joseph wrote:
> xfs_repair should not touch non-xfs mountpoints in platform_check_mount().
> If non-xfs mountpoints can be filtered out, the dead fuse mountpoint can
> never block our xfs_repair. The following patch can fix my problem and not
> add dangerous option to xfs_repair.
> 
> thx,
> 
> Yang Honggang
> 

Should be properly indented, but it looks fair to me. There is no reason
xfsprogs should act upon non-xfs mount points afaik.

> -------------------------new patch----------------------
> diff --git a/libxfs/linux.c b/libxfs/linux.c
> index 0bace3e..6ad24ce 100644
> --- a/libxfs/linux.c
> +++ b/libxfs/linux.c
> @@ -44,6 +44,7 @@ static int max_block_alignment;
>  #endif
> 
>  #define PROC_MOUNTED   "/proc/mounts"
> +#define MNTTYPE_XFS        "xfs"
> 
>  /*
>   * Check if the filesystem is mounted.  Be verbose if asked, and
> @@ -78,6 +79,9 @@ platform_check_mount(char *name, char *block, struct stat
> *s, int flags)
>                 return 1;
>         }
>         while ((mnt = getmntent(f)) != NULL) {
> +               /* filter out non xfs mountpoint */
> +               if (strncmp(mnt->mnt_type, MNTTYPE_XFS,
> strlen(mnt->mnt_type)))
> +                       continue;
>                 if (stat(mnt->mnt_dir, &mst) < 0)
>                         continue;
>                 if (mst.st_dev != s->st_rdev)
> -------------------------new patch end-----------------
> 
> On 02/25/2018 06:04 AM, Dave Chinner wrote:
> > On Sat, Feb 24, 2018 at 11:56:44AM -0600, Eric Sandeen wrote:
> > > On 2/24/18 5:23 AM, Yang Joseph wrote:
> > > > hello,
> > > > 
> > > > Before the repair process, xfs_repair will check if user specified device already
> > > > has a writable mountpoint. And it will stat all the mountpoints of the system. If there
> > > > is a dead mountpoint, this checking will be blocked and xfs_repair will enter 'D' state.
> > So why is the mount point dead?
> > 
> > That kinda means that the filesystem is still mounted, but something
> > has hung somewhere and the filesystem may still have active
> > references to the underlying device and be doing stuff that is
> > modifying the filesystem....
> > 
> > And if the device is still busy, then you aren't going to be able to
> > mount the repaired device, anyway, because the block device is still
> > busy...
> > 
> > > That sounds like a bug worth fixing, but I am much
> > > less excited about adding options which could do serious damage
> > > to a filesystem.
> > TO me it sounds like something that should be fixed by a reboot, not
> > by adding dangerous options to xfs_repair...
> > 
> > Cheers,
> > 
> > Dave.
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-xfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Carlos
