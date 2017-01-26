Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39942 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752055AbdAZSxL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 26 Jan 2017 13:53:11 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5262B80469
        for <linux-xfs@vger.kernel.org>; Thu, 26 Jan 2017 18:44:30 +0000 (UTC)
Date: Thu, 26 Jan 2017 13:44:28 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: Re: [BUG] xfs/305 hangs 4.10-rc4 kernel
Message-ID: <20170126184427.GA39683@bfoster.bfoster>
References: <20170125063943.GF1859@eguan.usersys.redhat.com>
 <20170125145215.GC28388@bfoster.bfoster>
 <20170126032950.GM1859@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170126032950.GM1859@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Jan 26, 2017 at 11:29:50AM +0800, Eryu Guan wrote:
> On Wed, Jan 25, 2017 at 09:52:16AM -0500, Brian Foster wrote:
> > On Wed, Jan 25, 2017 at 02:39:43PM +0800, Eryu Guan wrote:
> > > Hi all,
> > > 
> > > I hit another test hang triggered by running xfs/305 in a loop, it
> > > usually reproduces within 50 iterations. It also involves disabling
> > > quota, which looks similar to the generic/232 hang[1]. Perhaps they
> > > share the same root cause?
> > > 
> > > [333853.198159] xfs_quota       D    0 13880  13441 0x00000080
> > > [333853.227479] Call Trace:
> > > [333853.239429]  __schedule+0x21c/0x6b0
> > > [333853.255410]  schedule+0x36/0x80
> > > [333853.269932]  schedule_timeout+0x1d1/0x3a0
> > > [333853.288354]  ? lock_timer_base+0xa0/0xa0
> > > [333853.306296]  ? xfs_qm_need_dqattach+0x80/0x80 [xfs]
> > > [333853.329015]  schedule_timeout_uninterruptible+0x1f/0x30
> > > [333853.353344]  xfs_qm_dquot_walk.isra.10+0x172/0x190 [xfs]
> > > [333853.377747]  xfs_qm_dqpurge_all+0x5c/0x80 [xfs]
> > > [333853.398433]  xfs_qm_scall_quotaoff+0x127/0x380 [xfs]
> > > [333853.421062]  xfs_quota_disable+0x3d/0x50 [xfs]
> > > [333853.441319]  SyS_quotactl+0x391/0x850
> > > [333853.458143]  ? __audit_syscall_entry+0xaf/0x100
> > > [333853.478903]  ? syscall_trace_enter+0x1d0/0x2b0
> > > [333853.499262]  ? __audit_syscall_exit+0x209/0x290
> > > [333853.519938]  do_syscall_64+0x67/0x180
> > > [333853.536771]  entry_SYSCALL64_slow_path+0x25/0x25
> > > [333853.558105] RIP: 0033:0x7f95be064fea
> > > [333853.574521] RSP: 002b:00007ffc988b6348 EFLAGS: 00000206 ORIG_RAX: 00000000000000b3
> > > [333853.608922] RAX: ffffffffffffffda RBX: 0000000000000004 RCX: 00007f95be064fea
> > > [333853.641478] RDX: 0000000000000000 RSI: 00000000027bb2f0 RDI: 0000000000580201
> > > [333853.674091] RBP: 00000000027bb320 R08: 00007ffc988b635c R09: 0000000000000001
> > > [333853.706913] R10: 00007ffc988b635c R11: 0000000000000206 R12: 00000000027bb2d0
> > > [333853.744953] R13: 00000000027ba0a0 R14: 0000000000000000 R15: 00000000027ba080
> > > 
> > > I've seen this hang on multiple test hosts with different test configs,
> > > e.g. xfs_2k_crc xfs_4k_reflink. I also tried with 4.9 kernel, but I kept
> > > hitting the BUG_ON that this kernel commit[2] fixed in 4.10-rc kernel.
> > > 
> > 
> > Interesting... I'm not sure this is necessarily locked up given the call
> > to schedule_timeout(). That suggests we could be in the
> > xfs_qm_dquot_walk()->delay() call and possibly spinning on skipped
> > entries. It looks like the only way we skip an entry is if it is already
> > being freed or has a reference count. The only other dquot free path
> > looks like the shrinker, but that doesn't appear in the blocked task
> > list at all. We do have a dqread call, but that path hasn't even added
> > the dquot to the radix tree yet.
> > 
> > > I attached full sysrq-w output. If you need more info please let me
> > > know.
> > >
> > 
> > It looks like pretty much everything is hung up on log reservation,
> > including writeback, which is more indicative of a potential log
> > reservation problem. xfsaild appears to be alive, however (a
> > schedule_timeout() in that path suggests the thread is working to push
> > log items and free up log space), so maybe something else is going on.
> > It might be interesting to see if we can tell if we're spinning
> > somewhere by enabling tracepoints once in this state. Also, have you
> > checked for any unexpected syslog messages when this occurs?
> 
> There's nothing interesting in dmesg with stock 4.10-rc4 kernel, but if
> I test with Darrick's xfs-linux tree for-next branch (which has a few
> patches on top of 4.10-rc4), I can see this message:
> 
> XFS (dm-5): xlog_verify_grant_tail: space > BBTOB(tail_blocks)
> 
> But I can see this message in every xfs/305 iteration, and other tests
> too. I attached dmesg log prior to sysrq-w output, gathered from
> "for-next" kernel.
> 
> I also attached trace log while we're in this state (also from
> "for-next" kernel):
> 
> cd /mnt/ext4
> trace-cmd record -e xfs_*
> sleep 10
> trace-cmd report > log
> 

Thanks Eryu. The only thing in the AIL is the XFS_LI_QUOTAOFF log item.
This item is hardcoded to the locked state because it does not really
exist on disk (i.e., it cannot be pushed). Rather, it looks like it is
released upon commit of an accompanying quotaoff_end log item that is
committed after most of the quotaoff work is completed, including the
purge that you're actually stuck on. The purpose of this appears to be
to allow log recovery to deal with the possibility of dquots being
logged after the initial quotaoff transaction. This mechanism
effectively pins the tail of the log with the quotaoff start log item to
ensure log recovery sees it before any subsequent dquot modifications if
we happen to crash at some point in the middle of those operations.

What this means is that there is only a fixed amount of physical log
space between the time the quotaoff start is logged and until the
quotaoff completes. If we consume the log space before the quotaoff
completes, we basically deadlock the fs. Indeed, while I haven't been
able to reproduce via xfs/305 alone, I can manufacture this problem by
inserting a long enough sleep after the qutoaoff start item is logged.
The parallel fsstress' then chew up the log and the fs ends up stuck.

So I think this is the state you get into, but the root cause is still
not totally clear. It could just be the workload, but it seems a little
crazy to wrap the log before the purge completes since it doesn't log
anything itself. Then again, it looks like the xfs/305 workload can chew
up the log in 30-45s on my 10g scratch dev, so probably not out of the
realm of possibility.

I am wondering about the possibility of something else getting stuck
that stalls the dqpurge and then causes the fs-wide deadlock via domino
effect. Could you provide the xfs_info of your scratch device? Also, if
you could make a system available that is able to reproduce this
reliably enough, that might make it easier to analyze what's going on...

Brian

> Thanks,
> Eryu



