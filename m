Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 920E37CA0
	for <xfs@oss.sgi.com>; Sun, 10 Apr 2016 04:22:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 668C18F8037
	for <xfs@oss.sgi.com>; Sun, 10 Apr 2016 02:22:39 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id gOGqZvF0BkF4GCj1 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 10 Apr 2016 02:22:38 -0700 (PDT)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id A730A3CF
	for <xfs@oss.sgi.com>; Sun, 10 Apr 2016 09:22:37 +0000 (UTC)
Date: Sun, 10 Apr 2016 17:22:35 +0800
From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 0/6 v2] xfs: xfs_iflush_cluster vs xfs_reclaim_inode
Message-ID: <20160410092235.GZ10345@eguan.usersys.redhat.com>
References: <1460072271-23923-1-git-send-email-david@fromorbit.com>
	<20160408032841.GW10345@eguan.usersys.redhat.com>
	<20160408113709.GA30614@bfoster.bfoster>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160408113709.GA30614@bfoster.bfoster>
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

On Fri, Apr 08, 2016 at 07:37:09AM -0400, Brian Foster wrote:
> On Fri, Apr 08, 2016 at 11:28:41AM +0800, Eryu Guan wrote:
> > On Fri, Apr 08, 2016 at 09:37:45AM +1000, Dave Chinner wrote:
> > > Hi folks,
> > > 
> > > This is the second version of this patch set, first posted and
> > > described here:
> > > 
> > > http://oss.sgi.com/archives/xfs/2016-04/msg00069.html
> > 
> > Just a quick note here, I'm testing the v1 patchset right now, v4.6-rc2
> > kernel + v1 patch, config file is based on rhel7 debug kernel config.
> > 
> > The test is the same as the original reproducer (long term fsstress run
> > on XFS, exported from NFS). The test on x86_64 host has been running for
> > two days and everything looks fine. Test on ppc64 host has been running
> > for a few hours and I noticed a lock issue and a few warnings, not sure
> > if it's related to the patches or even to XFS yet(I need to run test on
> > stock -rc2 kernel to be sure), but just post the logs here for reference
> > 
> 
> Had the original problem ever been reproduced on an upstream kernel?

No, I've never seen the original problem in my upstream kernel testings.
Perhaps that's because I didn't run tests on debug kernels. But I didn't
see it in RHEL7 debug kernel testings either.

> 
> FWIW, my rhel kernel based test is still running well approaching ~48
> hours. I've seen some lockdep messages (bad unlock balance), but IIRC
> I've been seeing those from the start so I haven't been paying much
> attention to it while digging into the core problem.
> 
> > [ 1911.626286] ======================================================
> > [ 1911.626291] [ INFO: possible circular locking dependency detected ]
> > [ 1911.626297] 4.6.0-rc2.debug+ #1 Not tainted
> > [ 1911.626301] -------------------------------------------------------
> > [ 1911.626306] nfsd/7402 is trying to acquire lock:
> > [ 1911.626311]  (&s->s_sync_lock){+.+.+.}, at: [<c0000000003585f0>] .sync_inodes_sb+0xe0/0x230
> > [ 1911.626327]
> > [ 1911.626327] but task is already holding lock:
> > [ 1911.626333]  (sb_internal){.+.+.+}, at: [<c00000000031a780>] .__sb_start_write+0x90/0x130
> > [ 1911.626346]
> > [ 1911.626346] which lock already depends on the new lock.
> > [ 1911.626346]
> > [ 1911.626353]
> > [ 1911.626353] the existing dependency chain (in reverse order) is:
> > [ 1911.626358]
> ...
> > [ 1911.627134]  Possible unsafe locking scenario:
> > [ 1911.627134]
> > [ 1911.627139]        CPU0                    CPU1
> > [ 1911.627143]        ----                    ----
> > [ 1911.627147]   lock(sb_internal);
> > [ 1911.627153]                                lock(&s->s_sync_lock);
> > [ 1911.627160]                                lock(sb_internal);
> > [ 1911.627166]   lock(&s->s_sync_lock);
> > [ 1911.627172]
> > [ 1911.627172]  *** DEADLOCK ***
> > [ 1911.627172]
> ...
> 
> We actually have a report of this one on the list:
> 
> http://oss.sgi.com/archives/xfs/2016-04/msg00001.html
> 
> ... so I don't think it's related to this series. I believe I've seen
> this once or twice when testing something completely unrelated, as well.
> 
> > [ 2046.852739] kworker/dying (399) used greatest stack depth: 4352 bytes left
> > [ 2854.687381] XFS: Assertion failed: buffer_mapped(bh), file: fs/xfs/xfs_aops.c, line: 780
> > [ 2854.687434] ------------[ cut here ]------------
> > [ 2854.687488] WARNING: CPU: 5 PID: 28924 at fs/xfs/xfs_message.c:105 .asswarn+0x2c/0x40 [xfs]
> ...
> > [ 2854.687997] ---[ end trace 872ac2709186f780 ]---
> 
> These asserts look new to me, however. It would be interesting to see if
> these reproduce independently.

I've seen just the assert failures in the same fsstress testing on ppc64
host (no lock warnings in the beginning). Will see if it's still
reproducible on stock kernel.

Thanks,
Eryu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
