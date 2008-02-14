Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 14 Feb 2008 00:47:42 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1E8lXZE018569
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2008 00:47:37 -0800
Received: from ug-out-1314.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F1284E1220C
	for <xfs@oss.sgi.com>; Thu, 14 Feb 2008 00:47:57 -0800 (PST)
Received: from ug-out-1314.google.com (ug-out-1314.google.com [66.249.92.173]) by cuda.sgi.com with ESMTP id LV3UvzLGn1HVeDg2 for <xfs@oss.sgi.com>; Thu, 14 Feb 2008 00:47:57 -0800 (PST)
Received: by ug-out-1314.google.com with SMTP id o29so1946148ugd.20
        for <xfs@oss.sgi.com>; Thu, 14 Feb 2008 00:47:55 -0800 (PST)
Message-ID: <1a4a774c0802140041h49a88b9l281f5ac3213381a2@mail.gmail.com>
Date: Thu, 14 Feb 2008 09:41:21 +0100
From: "=?ISO-8859-1?Q?Christian_R=F8snes?=" <christian.rosnes@gmail.com>
Subject: Re: XFS internal error xfs_trans_cancel at line 1150 of file fs/xfs/xfs_trans.c
In-Reply-To: <20080213214551.GR155407@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
References: <1a4a774c0802130251h657a52f7lb97942e7afdf6e3f@mail.gmail.com>
	 <20080213214551.GR155407@sgi.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs@oss.sgi.com

On Wed, Feb 13, 2008 at 10:45 PM, David Chinner <dgc@sgi.com> wrote:
> On Wed, Feb 13, 2008 at 11:51:51AM +0100, Christian Røsnes wrote:

>  > Kernel: 2.6.17.7 (custom compiled)
>  >
>  > Are there any known XFS problems with this kernel version and nearly
>  > full partitions ?
>
>  Yes. Deadlocks that weren't properly fixed until 2.6.18 (partially
>  fixed in 2.6.17) and an accounting problem in the transaction code
>  that leads to the shutdown you are seeing. The accounting problem is
>  fixed by this commit:
>
>  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=45c34141126a89da07197d5b89c04c6847f1171a
>
>  which I think went into 2.6.22.
>
>  Luckily, neither of these problems result in corruption.
>
>
>  > I'm thinking about upgrading the kernel to a newer version, to see if
>  > it fixes this problem.
>  > Are there any known XFS problems with version 2.6.24.2 ?
>
>  Yes - a problem with readdir. The fix is currently in the stable
>  queue (i.e for 2.6.24.3):
>
>  http://git.kernel.org/?p=linux/kernel/git/stable/stable-queue.git;a=commit;h=ee864b866419890b019352412c7bc9634d96f61b
>
>  So we are just waiting for Greg to release 2.6.24.3 now.
>

Thanks. I ran memtest overnight just to be sure and no errors were
found.  I'll wait for 2.6.24.3, and then upgrade the kernel.

Christian
