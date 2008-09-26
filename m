Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 26 Sep 2008 01:55:43 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8Q8tftI030943
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 01:55:41 -0700
Received: from tyo201.gate.nec.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 7EE33486CAB
	for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 01:57:14 -0700 (PDT)
Received: from tyo201.gate.nec.co.jp (TYO201.gate.nec.co.jp [202.32.8.193]) by cuda.sgi.com with ESMTP id etFOmWbayQWcfy0G for <xfs@oss.sgi.com>; Fri, 26 Sep 2008 01:57:14 -0700 (PDT)
Subject: [PATCH 0/10] freeze feature ver 1.13
Message-Id: <20080926175652t-sato@mail.jp.nec.com>
Mime-Version: 1.0
From: Takashi Sato <t-sato@yk.jp.nec.com>
Date: Fri, 26 Sep 2008 17:56:52 +0900
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "mtk.manpages@googlemail.com" <mtk.manpages@googlemail.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

Hi, 

I've addressed the comments from Christoph, Steve, Dave, Shaggy and Eric.
The points are followings.

- Fixed unlockfs method in ext3/4, xfs, gfs2, jfs and reiserfs
  so that they always return 0 (success).
  Because the caller (thaw_bdev()) should unfreeze a filesystem
  successfully even in case of unlockfs's failure.

- Fixed xfs's write_super_lockfs so that it returns an error
  of xfs_trans_reserve() and xfs_trans_commit().

- Fixed gfs2's write_super_lockfs so that it returns -EINVAL
  in the following case.
>      if (test_bit(SDF_SHUTDOWN, &sdp->sd_flags))
> -        return;
> +        return -EINVAL;

- Rename write_super_lockfs/unlockfs of the super block operation
  freeze_fs/unfreeze_fs to avoid a confusion.

Currently, ext3 in mainline Linux doesn't have the freeze feature which
suspends write requests.  So, we cannot take a backup which keeps
the filesystem's consistency with the storage device's features
(snapshot and replication) while it is mounted.
In many case, a commercial filesystem (e.g. VxFS) has
the freeze feature and it would be used to get the consistent backup.
If Linux's standard filesystem ext3 has the freeze feature, we can do it
without a commercial filesystem.

So I have implemented the ioctls of the freeze feature.
I think we can take the consistent backup with the following steps.
1. Freeze the filesystem with the freeze ioctl.
2. Separate the replication volume or create the snapshot
   with the storage device's feature.
3. Unfreeze the filesystem with the unfreeze ioctl.
4. Take the backup from the separated replication volume
   or the snapshot.

[PATCH 1/10] VFS: Fix error handling of write_super_lockfs/unlockfs
  Changed the type of write_super_lockfs and unlockfs from "void"
  to "int" so that they can return an error. 
  Rename write_super_lockfs/unlockfs of the super block operation
  freeze_fs/unfreeze_fs to avoid a confusion.

[PATCH 2/10]-[PATCH 6/10] Fix error handling in write_super_lockfs/unlockfs
                          (ext3, ext4, xfs, gfs2, jfs)
  Changed write_super_lockfs so that it returns an error if needed.
  unlockfs always returns 0.

[PATCH 7/10] reiserfs: Fix error handling in write_super_lockfs/unlockfs
  Changed write_super_lockfs/unlockfs so that they always return
  0 (success) to keep a current behavior.

[PATCH 8/10] Implement generic freeze feature
  The ioctls for the generic freeze feature are below.
  o Freeze the filesystem
    int ioctl(int fd, int FIFREEZE, arg)
      fd: The file descriptor of the mountpoint
      FIFREEZE: request code for the freeze
      arg: Ignored
      Return value: 0 if the operation succeeds. Otherwise, -1

  o Unfreeze the filesystem
    int ioctl(int fd, int FITHAW, arg)
      fd: The file descriptor of the mountpoint
      FITHAW: request code for unfreeze
      arg: Ignored
      Return value: 0 if the operation succeeds. Otherwise, -1

[PATCH 9/10] Remove XFS specific ioctl interfaces for freeze feature
  It removes XFS specific ioctl interfaces and request codes
  for freeze feature.
  This patch has been supplied by David Chinner.

[PATCH 10/10] Add timeout feature
  The timeout feature is added to "freeze ioctl" to solve a deadlock
  when the freezer accesses a frozen filesystem. And new ioctl
  to reset the timeout period is added to extend the timeout period.
  For example, the freezer resets the timeout period to 10 seconds every 5
  seconds.  In this approach, even if the freezer causes a deadlock by
  accessing the frozen filesystem, it will be solved by the timeout
  in 10 seconds and the freezer will be able to recognize that
  at the next reset of timeout period.
  o Freeze the filesystem
    int ioctl(int fd, int FIFREEZE, long *timeout_sec)
      fd: The file descriptor of the mountpoint
      FIFREEZE: request code for the freeze
      timeout_sec: the timeout period in seconds
               If it's 0 or 1, the timeout isn't set.
               This special case of "1" is implemented to keep
               the compatibility with XFS applications.
      Return value: 0 if the operation succeeds. Otherwise, -1

  o Reset the timeout period
    This is useful for the application to set the timeout_sec more accurately.
    For example, the freezer resets the timeout_sec to 10 seconds every 5
    seconds.  In this approach, even if the freezer causes a deadlock
    by accessing the frozen filesystem, it will be solved by the timeout
    in 10 seconds and the freezer can recognize that at the next reset
    of timeout_sec.
    int ioctl(int fd, int FIFREEZE_RESET_TIMEOUT, long *timeout_sec)
      fd:file descriptor of mountpoint
      FIFREEZE_RESET_TIMEOUT: request code for reset of timeout period
      timeout_sec: new timeout period in seconds
      Return value: 0 if the operation succeeds. Otherwise, -1
      Error number: If the filesystem has already been unfrozen,
                    errno is set to EINVAL.

Any comments are very welcome.

Cheers, Takashi
