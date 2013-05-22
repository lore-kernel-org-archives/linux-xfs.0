Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EAC0B29E03
	for <xfs@oss.sgi.com>; Tue, 21 May 2013 23:15:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D9036304043
	for <xfs@oss.sgi.com>; Tue, 21 May 2013 21:15:28 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id VZqU612TAbEWdCqT for
	<xfs@oss.sgi.com>; Tue, 21 May 2013 21:15:28 -0700 (PDT)
Date: Wed, 22 May 2013 00:15:21 -0400
From: Dave Jones <davej@redhat.com>
Subject: Re: XFS assertion from truncate. (3.10-rc2)
Message-ID: <20130522041521.GA1837@redhat.com>
References: <20130521225257.GA12713@redhat.com>
	<20130521233429.GW29466@dastard>
	<20130521234016.GB14347@redhat.com>
	<20130521235410.GY29466@dastard>
	<20130522000803.GA19891@redhat.com>
	<20130522001603.GZ29466@dastard>
	<20130522025605.GA29767@redhat.com>
	<20130522040318.GG29466@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130522040318.GG29466@dastard>
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
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Wed, May 22, 2013 at 02:03:18PM +1000, Dave Chinner wrote:

 > That doesn't make a whole lot of sense to me. What am I missing?
 > Are you seeing this fire at all from notify_change()?
 > 
 > 	WARN_ON_ONCE(!mutex_is_locked(&inode->i_mutex));

No.
 
 > <Light Bulb>
 > 
 > What's wrong with this code in do_truncate()?
 > 
 >         /* Remove suid/sgid on truncate too */
 >         ret = should_remove_suid(dentry);
 >         if (ret)
 >                 newattrs.ia_valid |= ret | ATTR_FORCE;
 > 
 >         mutex_lock(&dentry->d_inode->i_mutex);
 >         ret = notify_change(dentry, &newattrs);
 >         mutex_unlock(&dentry->d_inode->i_mutex);
 > 
 > Patch below to fix this.
 > 
 > However, it probably doesn't fix the fact that truncate can change
 > the size and kill suid/sgid bits at the same time and XFS doesn't
 > appear to handle that sanely right now. Can you run the patch below
 > just so when it fails we can see that the mask is actually sane?

[   36.339105] XFS (sda2): xfs_setattr_size: mask 0xa068 mismatch on file 0\xffffffb8\xffffffd3-\xffffff88\xffffffff\xffffffff

[   36.350823] XFS: Assertion failed: 0, file: fs/xfs/xfs_iops.c, line: 730
[   36.359459] ------------[ cut here ]------------
[   36.365247] kernel BUG at fs/xfs/xfs_message.c:108!
[   36.371360] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[   36.379091] Modules linked in: xfs libcrc32c snd_hda_codec_realtek snd_hda_codec_hdmi microcode(+) pcspkr snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm e1000e snd_page_alloc snd_timer ptp snd soundcore pps_core
[   36.405431] CPU: 1 PID: 2887 Comm: cc1 Not tainted 3.10.0-rc2+ #4
[   36.432814] task: ffff880233e24980 ti: ffff88022dd3a000 task.ti: ffff88022dd3a000
[   36.442191] RIP: 0010:[<ffffffffa01be182>]  [<ffffffffa01be182>] assfail+0x22/0x30 [xfs]
[   36.452369] RSP: 0018:ffff88022dd3b7d8  EFLAGS: 00010292
[   36.459027] RAX: 000000000000003c RBX: ffff88022d8198c0 RCX: 0000000000000006
[   36.467968] RDX: 0000000000004040 RSI: ffff880233e250d8 RDI: ffff880233e24980
[   36.476909] RBP: ffff88022dd3b7d8 R08: 0000000000000000 R09: 0000000000000000
[   36.485851] R10: 0000000000000001 R11: 0000000000000001 R12: ffff88022dd3bca8
[   36.494793] R13: ffff880241158948 R14: 0000000000000000 R15: 0000000000000000
[   36.503729] FS:  00007f1f4f9c3800(0000) GS:ffff880244a00000(0000) knlGS:0000000000000000
[   36.513858] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   36.521053] CR2: 00000000007c0360 CR3: 000000022dfb2000 CR4: 00000000001407e0
[   36.529986] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   36.538918] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   36.547851] Stack:
[   36.550373]  ffff88022dd3bc48 ffffffffa01bc3ef 0000000000000046 0000a06881c94d18
[   36.559738]  ffff88022d819b80 ffff88022dadf2e0 00007fff0000a068 0000000000000000
[   36.569091]  ffff88022dd3b830 ffffffff824fc100 00007fff2cd12300 ffff88022dd3b848
[   36.578436] Call Trace:
[   36.581514]  [<ffffffffa01bc3ef>] xfs_setattr_size+0x48f/0x630 [xfs]
[   36.589475]  [<ffffffff810c86ef>] ? is_module_text_address+0x2f/0x60
[   36.597433]  [<ffffffff810774a8>] ? __kernel_text_address+0x58/0x80
[   36.605279]  [<ffffffff8100a394>] ? native_sched_clock+0x24/0x80
[   36.612801]  [<ffffffff810916a5>] ? sched_clock_cpu+0xb5/0x100
[   36.620103]  [<ffffffff810b69c5>] ? __lock_acquire+0x2e5/0x1af0
[   36.627548]  [<ffffffff8100a394>] ? native_sched_clock+0x24/0x80
[   36.635069]  [<ffffffff8100a394>] ? native_sched_clock+0x24/0x80
[   36.642591]  [<ffffffff810916a5>] ? sched_clock_cpu+0xb5/0x100
[   36.649895]  [<ffffffff8100a394>] ? native_sched_clock+0x24/0x80
[   36.657417]  [<ffffffff8100a394>] ? native_sched_clock+0x24/0x80
[   36.664947]  [<ffffffff8100a394>] ? native_sched_clock+0x24/0x80
[   36.672468]  [<ffffffff810916a5>] ? sched_clock_cpu+0xb5/0x100
[   36.679765]  [<ffffffff810916a5>] ? sched_clock_cpu+0xb5/0x100
[   36.687068]  [<ffffffff8100a394>] ? native_sched_clock+0x24/0x80
[   36.694590]  [<ffffffff810916a5>] ? sched_clock_cpu+0xb5/0x100
[   36.701894]  [<ffffffff8100a394>] ? native_sched_clock+0x24/0x80
[   36.709417]  [<ffffffff810916a5>] ? sched_clock_cpu+0xb5/0x100
[   36.716722]  [<ffffffff810b61ab>] ? mark_held_locks+0xbb/0x140
[   36.724027]  [<ffffffff816e634a>] ? mutex_lock_nested+0x32a/0x430
[   36.731659]  [<ffffffff8108c05d>] ? get_parent_ip+0xd/0x50
[   36.738533]  [<ffffffffa01bc5c6>] xfs_vn_setattr+0x36/0x40 [xfs]
[   36.746047]  [<ffffffff811c8e2c>] notify_change+0x1dc/0x360
[   36.753024]  [<ffffffff811a9d9d>] do_truncate+0x6d/0xa0
[   36.759574]  [<ffffffffa01ae0a0>] ? xfs_extent_busy_ag_cmp+0x20/0x20 [xfs]
[   36.768182]  [<ffffffff811bb4af>] do_last+0x54f/0xe40
[   36.775319]  [<ffffffff811bbe53>] path_openat+0xb3/0x530
[   36.782780]  [<ffffffff810b3951>] ? lock_release_holdtime.part.30+0xa1/0x170
[   36.792408]  [<ffffffff811bc958>] do_filp_open+0x38/0x80
[   36.799870]  [<ffffffff816ea961>] ? _raw_spin_unlock+0x31/0x60
[   36.807981]  [<ffffffff811cb49f>] ? __alloc_fd+0xaf/0x200
[   36.815544]  [<ffffffff811aae19>] do_sys_open+0xe9/0x1c0
[   36.822989]  [<ffffffff811aaf0e>] SyS_open+0x1e/0x20


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
