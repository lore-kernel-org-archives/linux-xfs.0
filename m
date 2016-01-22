Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BC2327F37
	for <xfs@oss.sgi.com>; Fri, 22 Jan 2016 03:52:40 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AC02F8F8049
	for <xfs@oss.sgi.com>; Fri, 22 Jan 2016 01:52:37 -0800 (PST)
Received: from mx2.suse.de (mx2.suse.de [195.135.220.15]) by cuda.sgi.com with
	ESMTP id 6CF2hhwhkaGDrEQI (version=TLSv1
	cipher=ECDHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 22 Jan 2016 01:52:35 -0800 (PST)
Date: Fri, 22 Jan 2016 10:52:33 +0100
From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH] Revert "xfs: clear PF_NOFREEZE for xfsaild kthread"
Message-ID: <20160122095233.GA19465@dhcp22.suse.cz>
References: <1452661968-11482-1-git-send-email-david@fromorbit.com>
	<20160120084750.GA14187@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160120084750.GA14187@dhcp22.suse.cz>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: jkosina@suse.cz, Hendrik Woltersdorf <hendrikw@arcor.de>, xfs@oss.sgi.com

On Wed 20-01-16 09:47:50, Michal Hocko wrote:
> On Wed 13-01-16 16:12:48, Dave Chinner wrote:
> > This reverts commit 24ba16bb3d499c49974669cd8429c3e4138ab102 as it
> > prevents machines from suspending. This regression occurs when the
> > xfsaild is idle on entry to suspend, and so there s no activity to
> > wake it from it's idle sleep and hence see that it is supposed to
> > freeze. Hence the freezer times out waiting for it and suspend is
> > cancelled.
> > 
> > There is no obvious fix for this short of freezing the filesystem
> > properly, so revert this change for now.
> 
> We had a similar report opensuse bugzilla just recently. I believe the
> proper fix should be the following:
> ---
> From ae910a86ada86804c34cc8136afebc9fefa15813 Mon Sep 17 00:00:00 2001
> From: Michal Hocko <mhocko@suse.com>
> Date: Tue, 19 Jan 2016 20:28:49 +0100
> Subject: [PATCH] xfs, xfsaild: Do not block suspend
> 
> Hendik has reported suspend failures due to xfsaild blocking the freezer
> to settle down.
> Jan 17 19:59:56 linux-6380 kernel: PM: Syncing filesystems ... done.
> Jan 17 19:59:56 linux-6380 kernel: PM: Preparing system for sleep (mem)
> Jan 17 19:59:56 linux-6380 kernel: Freezing user space processes ... (elapsed 0.001 seconds) done.
> Jan 17 19:59:56 linux-6380 kernel: Freezing remaining freezable tasks ...
> Jan 17 19:59:56 linux-6380 kernel: Freezing of tasks failed after 20.002 seconds (1 tasks refusing to freeze, wq_busy=0):
> Jan 17 19:59:56 linux-6380 kernel: xfsaild/dm-5    S 00000000     0  1293      2 0x00000080
> Jan 17 19:59:56 linux-6380 kernel:  f0ef5f00 00000046 00000200 00000000 ffff9022 c02d3800 00000000 00000032
> Jan 17 19:59:56 linux-6380 kernel:  ee0b2400 00000032 f71e0d00 f36fabc0 f0ef2d00 f0ef6000 f0ef2d00 f12f90c0
> Jan 17 19:59:56 linux-6380 kernel:  f0ef5f0c c0844e44 00000000 f0ef5f6c f811e0be 00000000 00000000 f0ef2d00
> Jan 17 19:59:56 linux-6380 kernel: Call Trace:
> Jan 17 19:59:56 linux-6380 kernel:  [<c0844e44>] schedule+0x34/0x90
> Jan 17 19:59:56 linux-6380 kernel:  [<f811e0be>] xfsaild+0x5de/0x600 [xfs]
> Jan 17 19:59:56 linux-6380 kernel:  [<c0286cbb>] kthread+0x9b/0xb0
> Jan 17 19:59:56 linux-6380 kernel:  [<c0848a79>] ret_from_kernel_thread+0x21/0x38
> 
> The issue has been there for quite some time but it has been made
> visible by only by 24ba16bb3d49 ("xfs: clear PF_NOFREEZE for xfsaild
> kthread") because the suspend started seeing xfsaild.
> 
> The above commit has missed that the !xfs_ail_min branch might call
> schedule with TASK_INTERRUPTIBLE without calling try_to_freeze so the pm
> suspend would wake up the kernel thread over and over again without any
> progress. What we want here is to use freezable_schedule instead to hide
> the thread from the suspend.
> 
> While we are here also change schedule_timeout to freezable variant to
> prevent from spurious wakeups by suspend.
> 
> Reported-by: Hendrik Woltersdorf <hendrikw@arcor.de>
> Signed-off-by: Michal Hocko <mhocko@suse.com>

Hendrik was able to test the patch so feel free to add his Tested-by
-- 
Michal Hocko
SUSE Labs

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
