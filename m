Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 24 Jun 2008 14:37:53 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m5OLbmQ6002223
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2008 14:37:48 -0700
Received: from smtp1.linux-foundation.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2B1B6274EC2
	for <xfs@oss.sgi.com>; Tue, 24 Jun 2008 14:38:48 -0700 (PDT)
Received: from smtp1.linux-foundation.org (smtp1.linux-foundation.org [140.211.169.13]) by cuda.sgi.com with ESMTP id cy7lGWKweovJ27eY for <xfs@oss.sgi.com>; Tue, 24 Jun 2008 14:38:48 -0700 (PDT)
Date: Tue, 24 Jun 2008 14:38:40 -0700
From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 0/3] freeze feature ver 1.6
Message-Id: <20080624143840.c183d0d9.akpm@linux-foundation.org>
In-Reply-To: <20080624155919t-sato@mail.jp.nec.com>
References: <20080624155919t-sato@mail.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Takashi Sato <t-sato@yk.jp.nec.com>
Cc: viro@ZenIV.linux.org.uk, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, axboe@kernel.dk, mtk.manpages@googlemail.com

On Tue, 24 Jun 2008 15:59:19 +0900
Takashi Sato <t-sato@yk.jp.nec.com> wrote:

> Hi Andrew and Alexander,
> 
> I have implemented the ioctls for the filesystem freeze feature
> and discussed its implementation on the ML (linux-ext4, xfs,
> linux-fsdevel, linux-kernel) for five months.  All of the comments are
> addressed in my patch-set.
> Could you consider merging it into Linux?
> 
> The filesystem freeze feature can suspend accesses to the filesystem
> keeping the filesystem's consistency.  We can take the consistent backup
> with it cooperating with the backup software.
> 
> The patches are re-based from linux-2.6.26-rc3 to linux-2.6.26-rc7
> There is no functional change from the previous version.
> The patch-set consists of the following three patches.
> 
> [PATCH 1/3] Implement generic freeze feature
>   I have modified to set the suitable error number (EOPNOTSUPP)
>   in case the filesystem doesn't support the freeze feature.
> 
>   The ioctls for the generic freeze feature are below.
>   o Freeze the filesystem
>     int ioctl(int fd, int FIFREEZE, arg)
>       fd: The file descriptor of the mountpoint
>       FIFREEZE: request code for the freeze
>       arg: Ignored
>       Return value: 0 if the operation succeeds. Otherwise, -1
> 
>   o Unfreeze the filesystem
>     int ioctl(int fd, int FITHAW, arg)
>       fd: The file descriptor of the mountpoint
>       FITHAW: request code for unfreeze
>       arg: Ignored
>       Return value: 0 if the operation succeeds. Otherwise, -1
> 
> [PATCH 2/3] Remove XFS specific ioctl interfaces for freeze feature
>   It removes XFS specific ioctl interfaces and request codes
>   for freeze feature.
>   This patch has been supplied by David Chinner.
> 
> [PATCH 3/3] Add timeout feature
>   The timeout feature is added to freeze ioctl.  And new ioctl
>   to reset the timeout period is added.
>   o Freeze the filesystem
>     int ioctl(int fd, int FIFREEZE, long *timeval)
>       fd: The file descriptor of the mountpoint
>       FIFREEZE: request code for the freeze
>       timeval: the timeout period in seconds
>                If it's 0 or 1, the timeout isn't set.
>                This special case of "1" is implemented to keep
>                the compatibility with XFS applications.
>       Return value: 0 if the operation succeeds. Otherwise, -1
> 
>   o Reset the timeout period
>     This is useful for the application to set the timeval more accurately.
>     For example, the freezer resets the timeval to 10 seconds every 5
>     seconds.  In this approach, even if the freezer causes a deadlock
>     by accessing the frozen filesystem, it will be solved by the timeout
>     in 10 seconds and the freezer can recognize that at the next reset
>     of timeval.
>     int ioctl(int fd, int FIFREEZE_RESET_TIMEOUT, long *timeval)
>       fd:file descriptor of mountpoint
>       FIFREEZE_RESET_TIMEOUT: request code for reset of timeout period
>       timeval: new timeout period in seconds
>       Return value: 0 if the operation succeeds. Otherwise, -1
>       Error number: If the filesystem has already been unfrozen,
>                     errno is set to EINVAL.
> 
> Any comments are very welcome.

umm, OK, but nowhere in this patch series can I find a justification or
reason for making these changes to Linux.  Why do we want to do this? 
What is the benefit?  What is the motivation.  What are the use-cases,
etc?

Thanks.
