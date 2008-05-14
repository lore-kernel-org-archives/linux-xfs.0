Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 14 May 2008 01:05:25 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4E84xu7031574
	for <xfs@oss.sgi.com>; Wed, 14 May 2008 01:05:04 -0700
Received: from tyo201.gate.nec.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F3FE8167493
	for <xfs@oss.sgi.com>; Wed, 14 May 2008 01:05:45 -0700 (PDT)
Received: from tyo201.gate.nec.co.jp (TYO201.gate.nec.co.jp [202.32.8.193]) by cuda.sgi.com with ESMTP id wu4xwR8XOILCKXR1 for <xfs@oss.sgi.com>; Wed, 14 May 2008 01:05:45 -0700 (PDT)
Subject: [RFC PATCH 0/3] freeze feature ver 1.3
Message-Id: <20080514170534t-sato@mail.jp.nec.com>
Mime-Version: 1.0
From: Takashi Sato <t-sato@yk.jp.nec.com>
Date: Wed, 14 May 2008 17:05:34 +0900
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

Hi,

Christoph Hellwig wrote:
>> + case FIFREEZE: {
> 
> This would be better to split intot a small helper ala ioctl_fibmap()
> 
>> + case FITHAW: {
> 
> Same here.

I have added two new helper functions (ioctl_freeze and ioctl_thaw)
in "[PATCH 1/3] Implement generic freeze feature".

>>> I think the protection against double freezes would be better done by
>>> using a trylock on bd_mount_sem.
>>
>> bd_mount_sem can protect against only freezes and cannot protect against
>> unfreezes.  If multiple unfreezes run in parallel,  the multiple up() for
>> bd_mount_sem might occur incorrectly.
> 
> Indeed.  The bit flag would fix that because unfreeze could then check
> for the bit beeing set first.  So that's probably the easiest way to go.

I have replaced the semaphore (bd_freeze_sem) with new bit flag
in "[PATCH 1/3] Implement generic freeze feature".
When a thread is in freeze operation, subsequent freeze operations
will fail immediately.
(They waited for the thread in the previous patches.)
I think this change of the behavior doesn't matter because
freezes and unfreezes don't run in parallel in usual situation.

In addition, the patches are re-based from linux-2.6.25 to
linux-2.6.26-rc2.
The patch-set consists of the following three patches.
Only [PATCH 1/3] is modified as above from the previous version.

[PATCH 1/3] Implement generic freeze feature
  I have modified the following two points from the previous version.
  These are suggested by Christoph Hellwig.
  o Two helper functions for ioctls (ioctl_freeze and ioctl_thaw) are
    added for the readability.
  o The semaphore for the freeze operation is replaced with new bit
    flag (bd_state) for the efficiency of the locking. 
    
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

[PATCH 2/3] Remove XFS specific ioctl interfaces for freeze feature
  It removes XFS specific ioctl interfaces and request codes
  for freeze feature.
  This patch has been supplied by David Chinner.

[PATCH 3/3] Add timeout feature
  The timeout feature is added to freeze ioctl.  And new ioctl
  to reset the timeout period is added.
  o Freeze the filesystem
    int ioctl(int fd, int FIFREEZE, long *timeval)
      fd: The file descriptor of the mountpoint
      FIFREEZE: request code for the freeze
      timeval: the timeout period in seconds
               If it's 0 or 1, the timeout isn't set.
               This special case of "1" is implemented to keep
               the compatibility with XFS applications.
      Return value: 0 if the operation succeeds. Otherwise, -1

  o Reset the timeout period
    This is useful for the application to set the timeval more accurately.
    For example, the freezer resets the timeval to 10 seconds every 5
    seconds.  In this approach, even if the freezer causes a deadlock
    by accessing the frozen filesystem, it will be solved by the timeout
    in 10 seconds and the freezer can recognize that at the next reset
    of timeval.
    int ioctl(int fd, int FIFREEZE_RESET_TIMEOUT, long *timeval)
      fd:file descriptor of mountpoint
      FIFREEZE_RESET_TIMEOUT: request code for reset of timeout period
      timeval: new timeout period in seconds
      Return value: 0 if the operation succeeds. Otherwise, -1
      Error number: If the filesystem has already been unfrozen,
                    errno is set to EINVAL.

Any comments are very welcome.

Cheers, Takashi
