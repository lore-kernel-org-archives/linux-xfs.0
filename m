Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 22 Sep 2008 03:53:53 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8MArktR014519
	for <xfs@oss.sgi.com>; Mon, 22 Sep 2008 03:53:46 -0700
Received: from tyo201.gate.nec.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1A0C746AE37
	for <xfs@oss.sgi.com>; Mon, 22 Sep 2008 03:55:19 -0700 (PDT)
Received: from tyo201.gate.nec.co.jp (TYO201.gate.nec.co.jp [202.32.8.193]) by cuda.sgi.com with ESMTP id 60fAQGKqYlsg1jKf for <xfs@oss.sgi.com>; Mon, 22 Sep 2008 03:55:19 -0700 (PDT)
Subject: [PATCH 0/10] freeze feature ver 1.12
Message-Id: <20080922195505t-sato@mail.jp.nec.com>
Mime-Version: 1.0
From: Takashi Sato <t-sato@yk.jp.nec.com>
Date: Mon, 22 Sep 2008 19:55:05 +0900
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>"xfs@oss.sgi.com" <xfs@oss.sgi.com>, "mtk.manpages@googlemail.com" <mtk.manpages@googlemail.com>, Eric Sandeen <sandeen@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

Hi,

Eric Sandeen wrote:
> Not a problem with your patch exactly, but I was just wondering; you
> check here whether the sb returned from freeze_bdev is an ERR_PTR (as
> does lock_fs()) - but, freeze_bdev never returns an error, does it?
> ->write_super_lockfs is a void...
> 
> It really seems that at least we should be able to handle IO errors on
> the freeze request, and tell the user "No, your filesystem was not
> frozen..."?

I've changed the type of write_super_lockfs and unlockfs from "void" to
"int" so that they can return an error.  In addition, I've changed ext3/4's
write_super_lockfs and unlockfs so that they return an error in case of
an I/O failure.  (Current journal_flush() called by
ext3_write_super_lockfs() doesn't handle an I/O error sufficiently,
but Kawai-san's patch (jbd-fix-error-handling-for-checkpoint-io.patch)
in mm-tree will solve it soon.)

On the other filesystems (xfs, jfs, reiserfs, gfs2) which implement
write_super_lockfs and unlockfs, they always return 0 (success)
to keep the current behavior.

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

[PATCH 1/10] Fix error handling of write_super_lockfs/unlockfs (VFS)
  Changed the type of write_super_lockfs and unlockfs from "void"
  to "int" so that they can return an error. 

[PATCH 2/10] Fix error handling in write_super_lockfs/unlockfs (ext3)
  Changed write_super_lockfs/unlockfs so that they return
  an error in case of an I/O failure.

[PATCH 3/10] Fix error handling in write_super_lockfs/unlockfs (ext4)
  Changed write_super_lockfs/unlockfs so that they return
  an error in case of an I/O failure.

[PATCH 4/10]-[PATCH 7/10] Fix error handling in write_super_lockfs/unlockfs
                          (xfs, reiserfs, gfs2, jfs)
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
