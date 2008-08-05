Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 05 Aug 2008 05:02:59 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m75C2qm3001147
	for <xfs@oss.sgi.com>; Tue, 5 Aug 2008 05:02:53 -0700
Received: from tyo201.gate.nec.co.jp (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3806835DC29
	for <xfs@oss.sgi.com>; Tue,  5 Aug 2008 05:04:06 -0700 (PDT)
Received: from tyo201.gate.nec.co.jp (TYO201.gate.nec.co.jp [202.32.8.193]) by cuda.sgi.com with ESMTP id 2RLgjAjj2GSebsZ5 for <xfs@oss.sgi.com>; Tue, 05 Aug 2008 05:04:06 -0700 (PDT)
Subject: Re: [PATCH 0/3] freeze feature ver 1.9
In-reply-to: <20080805113411t-sato@mail.jp.nec.com>
References: <20080805113411t-sato@mail.jp.nec.com>
Message-Id: <20080805210321t-sato@mail.jp.nec.com>
Mime-Version: 1.0
From: Takashi Sato <t-sato@yk.jp.nec.com>
Date: Tue, 5 Aug 2008 21:03:21 +0900
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Takashi Sato <t-sato@yk.jp.nec.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "dm-devel@redhat.com" <dm-devel@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>, "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, Christoph Hellwig <hch@infradead.org>, "axboe@kernel.dk" <axboe@kernel.dk>, "mtk.manpages@googlemail.com" <mtk.manpages@googlemail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

Hi,

I sent the latest patch-set of the freeze feature (ver 1.9)
as the following mail.
The points are:
- When multiple freeze requests arrive simultaneously, only the last
  unfreeze process should unfreeze the frozen filesystem actually.
  So I added the reference counter to the freeze feature.
- I left the timeout feature in my patch-set because we need it for
  the case someone dirties so much data that the freeze process is
  swapped out.

Any comments?

>When multiple freeze requests arrive simultaneously, only the last
>unfreeze process should unfreeze the frozen filesystem actually
>(as Dave Chinner, Eric Sandeen and Alasdair G Kergon commented).
>So I've added the reference counter to the freeze feature.
>It counts up in freeze_bdev() and counts down in thaw_bdev().
>When it becomes "0", thaw_bdev() will unfreeze actually.
>
>The following regular cases have worked correctly.
>
>A)
>1. dmsetup suspend
>2. FIFREEZE
>3. FITHAW
>4. dmsetup resume
>B)
>1. FIFREEZE
>2. dmsetup suspend
>3. dmsetup resume
>4. FITHAW
>
>But in the following case, the last FITHAW has been frozen
>for writing the super block because device-mapper layer is still frozen.
>It's a irregular case (app's bug) and the next "dmsetup resume"
>can solve it.  So I don't think it is a problem.
>C)
>1. dmsetup suspend
>2. FIFREEZE
>3. FITHAW
>4. FITHAW<- The thaw process was frozen.
>
>In my previous mail, I have mentioned considering removing the timeout
>feature.  But I leave it in my patch-set because we need it for the case
>someone dirties so much data that the freeze process is swapped out
>(as some people said).
>
>Currently, ext3 in mainline Linux doesn't have the freeze feature which
>suspends write requests.  So, we cannot take a backup which keeps
>the filesystem's consistency with the storage device's features
>(snapshot and replication) while it is mounted.
>In many case, a commercial filesystem (e.g. VxFS) has
>the freeze feature and it would be used to get the consistent backup.
>If Linux's standard filesytem ext3 has the freeze feature, we can do it
>without a commercial filesystem.
>
>So I have implemented the ioctls of the freeze feature.
>I think we can take the consistent backup with the following steps.
>1. Freeze the filesystem with the freeze ioctl.
>2. Separate the replication volume or create the snapshot
>   with the storage device's feature.
>3. Unfreeze the filesystem with the unfreeze ioctl.
>4. Take the backup from the separated replication volume
>   or the snapshot.
>
>[PATCH 1/3] Implement generic freeze feature
>  I have modified to set the suitable error number (EOPNOTSUPP)
>  in case the filesystem doesn't support the freeze feature.
>
>  The ioctls for the generic freeze feature are below.
>  o Freeze the filesystem
>    int ioctl(int fd, int FIFREEZE, arg)
>      fd: The file descriptor of the mountpoint
>      FIFREEZE: request code for the freeze
>      arg: Ignored
>      Return value: 0 if the operation succeeds. Otherwise, -1
>
>  o Unfreeze the filesystem
>    int ioctl(int fd, int FITHAW, arg)
>      fd: The file descriptor of the mountpoint
>      FITHAW: request code for unfreeze
>      arg: Ignored
>      Return value: 0 if the operation succeeds. Otherwise, -1
>
>[PATCH 2/3] Remove XFS specific ioctl interfaces for freeze feature
>  It removes XFS specific ioctl interfaces and request codes
>  for freeze feature.
>  This patch has been supplied by David Chinner.
>
>[PATCH 3/3] Add timeout feature
>  The timeout feature is added to freeze ioctl.  And new ioctl
>  to reset the timeout period is added.
>  o Freeze the filesystem
>    int ioctl(int fd, int FIFREEZE, long *timeout_sec)
>      fd: The file descriptor of the mountpoint
>      FIFREEZE: request code for the freeze
>      timeout_sec: the timeout period in seconds
>               If it's 0 or 1, the timeout isn't set.
>               This special case of "1" is implemented to keep
>               the compatibility with XFS applications.
>      Return value: 0 if the operation succeeds. Otherwise, -1
>
>  o Reset the timeout period
>    This is useful for the application to set the timeout_sec more accurately.
>    For example, the freezer resets the timeout_sec to 10 seconds every 5
>    seconds.  In this approach, even if the freezer causes a deadlock
>    by accessing the frozen filesystem, it will be solved by the timeout
>    in 10 seconds and the freezer can recognize that at the next reset
>    of timeout_sec.
>    int ioctl(int fd, int FIFREEZE_RESET_TIMEOUT, long *timeout_sec)
>      fd:file descriptor of mountpoint
>      FIFREEZE_RESET_TIMEOUT: request code for reset of timeout period
>      timeout_sec: new timeout period in seconds
>      Return value: 0 if the operation succeeds. Otherwise, -1
>      Error number: If the filesystem has already been unfrozen,
>                    errno is set to EINVAL.
>
>Any comments are very welcome.
>
>Cheers, Takashi
