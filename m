Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6152329E03
	for <xfs@oss.sgi.com>; Wed, 22 May 2013 00:29:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id CF2A7AC002
	for <xfs@oss.sgi.com>; Tue, 21 May 2013 22:29:47 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id wcrnzSKTSqMHCxoI for
	<xfs@oss.sgi.com>; Tue, 21 May 2013 22:29:43 -0700 (PDT)
Date: Wed, 22 May 2013 01:29:38 -0400
From: Dave Jones <davej@redhat.com>
Subject: Re: XFS assertion from truncate. (3.10-rc2)
Message-ID: <20130522052938.GA2573@redhat.com>
References: <20130521225257.GA12713@redhat.com>
	<20130521233429.GW29466@dastard>
	<20130521234016.GB14347@redhat.com>
	<20130521235410.GY29466@dastard>
	<20130522000803.GA19891@redhat.com>
	<20130522001603.GZ29466@dastard>
	<20130522025605.GA29767@redhat.com>
	<20130522040318.GG29466@dastard> <20130522041521.GA1837@redhat.com>
	<20130522051243.GH29466@dastard>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130522051243.GH29466@dastard>
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

On Wed, May 22, 2013 at 03:12:43PM +1000, Dave Chinner wrote:

 > > [   36.339105] XFS (sda2): xfs_setattr_size: mask 0xa068 mismatch on file 0\xffffffb8\xffffffd3-\xffffff88\xffffffff\xffffffff
 > 
 > So, still the same strange mask. That just doesn't seem right.

any idea what I screwed up in the filename printing part ?
 
 > > [   36.350823] XFS: Assertion failed: 0, file: fs/xfs/xfs_iops.c, line: 730
 > > [   36.359459] ------------[ cut here ]------------
 > > [   36.365247] kernel BUG at fs/xfs/xfs_message.c:108!
 > > [   36.371360] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
 > > [   36.379091] Modules linked in: xfs libcrc32c snd_hda_codec_realtek snd_hda_codec_hdmi microcode(+) pcspkr snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device snd_pcm e1000e snd_page_alloc snd_timer ptp snd soundcore pps_core
 > > [   36.405431] CPU: 1 PID: 2887 Comm: cc1 Not tainted 3.10.0-rc2+ #4
 > 
 > Your compiler is triggering this? That doesn't seem likely...

yeah, though it seems pretty much anything that writes to that partition will cause it.
Here's fsx, which died instantly...

[   34.938367] XFS (sda2): xfs_setattr_size: mask 0x2068 mismatch on file 

(Note, different mask this time)


[   34.948754] XFS: Assertion failed: 0, file: fs/xfs/xfs_iops.c, line: 730
[   34.957305] ------------[ cut here ]------------
[   34.963093] kernel BUG at fs/xfs/xfs_message.c:108!
[   34.969202] invalid opcode: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[   34.976916] Modules linked in: xfs libcrc32c snd_hda_codec_realtek snd_hda_codec_hdmi microcode(+) pcspkr snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device e1000e snd_pcm snd_page_alloc snd_timer ptp snd pps_core soundcore
[   35.003254] CPU: 2 PID: 603 Comm: fsx Not tainted 3.10.0-rc2+ #4
[   35.030365] task: ffff8802346824c0 ti: ffff880234318000 task.ti: ffff880234318000
[   35.039733] RIP: 0010:[<ffffffffa01db182>]  [<ffffffffa01db182>] assfail+0x22/0x30 [xfs]
[   35.049897] RSP: 0018:ffff8802343199f0  EFLAGS: 00010286
[   35.056547] RAX: 000000000000003c RBX: ffff8802348af380 RCX: 0000000000000006
[   35.065480] RDX: 00000000000040b0 RSI: ffff880234682c18 RDI: ffff8802346824c0
[   35.074411] RBP: ffff8802343199f0 R08: 0000000000000000 R09: 0000000000000000
[   35.083349] R10: 0000000000000001 R11: 0000000000000001 R12: ffff880234319ec0
[   35.092310] R13: ffff880241171bd8 R14: 0000000000000000 R15: 0000000000000000
[   35.101258] FS:  00007fea1197a740(0000) GS:ffff880244c00000(0000) knlGS:0000000000000000
[   35.111397] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   35.118603] CR2: 0000003159cee0b0 CR3: 00000002339bc000 CR4: 00000000001407e0
[   35.127536] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   35.136467] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   35.145399] Stack:
[   35.147919]  ffff880234319e60 ffffffffa01d93ef 00000000816eaa35 0000206800000063
[   35.157258]  ffff8802348af640 ffff88023483cb90 ffff880200002068 ffffffff8100a394
[   35.166630]  0000000000000002 ffff880234319a60 ffffffff810916a5 0000000000000002
[   35.176002] Call Trace:
[   35.179112]  [<ffffffffa01d93ef>] xfs_setattr_size+0x48f/0x630 [xfs]
[   35.187071]  [<ffffffff8100a394>] ? native_sched_clock+0x24/0x80
[   35.194595]  [<ffffffff810916a5>] ? sched_clock_cpu+0xb5/0x100
[   35.201900]  [<ffffffff8100a394>] ? native_sched_clock+0x24/0x80
[   35.209418]  [<ffffffff810916a5>] ? sched_clock_cpu+0xb5/0x100
[   35.216724]  [<ffffffff810b69c5>] ? __lock_acquire+0x2e5/0x1af0
[   35.224134]  [<ffffffff8100a394>] ? native_sched_clock+0x24/0x80
[   35.231656]  [<ffffffff810916a5>] ? sched_clock_cpu+0xb5/0x100
[   35.238961]  [<ffffffff8108c05d>] ? get_parent_ip+0xd/0x50
[   35.245832]  [<ffffffff816ef211>] ? sub_preempt_count+0x71/0x100
[   35.253353]  [<ffffffff813080f0>] ? delay_tsc+0x90/0xe0
[   35.259895]  [<ffffffff8100a394>] ? native_sched_clock+0x24/0x80
[   35.267414]  [<ffffffff810916a5>] ? sched_clock_cpu+0xb5/0x100
[   35.274718]  [<ffffffff810b33ce>] ? put_lock_stats.isra.29+0xe/0x40
[   35.282564]  [<ffffffff810b399e>] ? lock_release_holdtime.part.30+0xee/0x170
[   35.291387]  [<ffffffff8100a394>] ? native_sched_clock+0x24/0x80
[   35.298908]  [<ffffffff810916a5>] ? sched_clock_cpu+0xb5/0x100
[   35.306211]  [<ffffffff8100a394>] ? native_sched_clock+0x24/0x80
[   35.313731]  [<ffffffff810916a5>] ? sched_clock_cpu+0xb5/0x100
[   35.321045]  [<ffffffff8108c05d>] ? get_parent_ip+0xd/0x50
[   35.327913]  [<ffffffff810b61ab>] ? mark_held_locks+0xbb/0x140
[   35.335216]  [<ffffffff816e634a>] ? mutex_lock_nested+0x32a/0x430
[   35.342844]  [<ffffffff8108c05d>] ? get_parent_ip+0xd/0x50
[   35.349714]  [<ffffffff816ef211>] ? sub_preempt_count+0x71/0x100
[   35.357241]  [<ffffffffa01d95c6>] xfs_vn_setattr+0x36/0x40 [xfs]
[   35.364763]  [<ffffffff811c8e2c>] notify_change+0x1dc/0x360
[   35.371741]  [<ffffffff811a9d9d>] do_truncate+0x6d/0xa0
[   35.378284]  [<ffffffff811aa0ee>] do_sys_ftruncate.constprop.16+0x10e/0x160
[   35.387883]  [<ffffffff811aa17e>] SyS_ftruncate+0xe/0x10
[   35.395390]  [<ffffffff816f3714>] tracesys+0xdd/0xe2
[   35.402440] Code: 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 89 f1 41 89 d0 48 89 e5 48 89 fa 48 c7 c6 18 87 26 a0 31 ff 31 c0 e8 ce fb ff ff <0f> 0b 66 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 
[   35.429006] RIP  [<ffffffffa01db182>] assfail+0x22/0x30 [xfs]
[   35.437088]  RSP <ffff8802343199f0>

 > This has come through the open path via handle_truncate(), which
 > means that ATTR_MTIME|ATTR_CTIME|ATTR_OPEN|ATTR_FILE should also be
 > set in the mask. They aren't, and that says to me that something
 > else has been blottoed before XFS trips over this. Memory
 > corruption?
 >
 > Can you print out the entire struct iattr? perhaps even hexdump it?

About to turn in for the night. If there's a shiny diff in my inbox in the morning,
I'll try it.

Tomorrow I'll also try running some older kernels with the same options to see if it's
something new, or an older bug. This is a new machine, so it may be something
that's been around for a while, and for whatever reason, my other machines don't hit this.

	Dave

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
