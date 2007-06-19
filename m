Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Jun 2007 07:34:43 -0700 (PDT)
Received: from mailout1.imos.net (mailout1.imos.net [212.87.132.33])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5JEYcdo001248
	for <xfs@oss.sgi.com>; Tue, 19 Jun 2007 07:34:39 -0700
Received: from homer.imos.net (homer.imos.net [212.87.132.35])
	by mailout1.imos.net (8.14.1/8.14.1) with ESMTP id l5JEYc6m019273
	for <xfs@oss.sgi.com>; Tue, 19 Jun 2007 16:34:38 +0200
Received: from lstyd.imos.net (lstyd.imos.net [212.87.130.122])
	by homer.imos.net (8.14.1/8.14.1) with ESMTP id l5JEYcdr006782
	for <xfs@oss.sgi.com>; Tue, 19 Jun 2007 16:34:38 +0200
Received: from [5.15.153.128] ([5.15.153.128])
	by lstyd.imos.net (8.14.0/8.13.7) with ESMTP id l5JEciET003851
	for <xfs@oss.sgi.com>; Tue, 19 Jun 2007 16:38:44 +0200
Message-ID: <4677E97E.5070802@theendofthetunnel.de>
Date: Tue, 19 Jun 2007 16:34:38 +0200
From: Hannes Dorbath <light@theendofthetunnel.de>
MIME-Version: 1.0
Subject: BUG: soft lockup detected on CPU#0!
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

I got this on a server box today. Kernel 2.6.21, x86_64, LVM2:

Jun 19 10:58:16 phoenix Ending XFS recovery on filesystem: dm-5 (logdev: 
internal)
Jun 19 10:58:16 phoenix BUG: soft lockup detected on CPU#0!
Jun 19 10:58:16 phoenix
Jun 19 10:58:16 phoenix Call Trace:
Jun 19 10:58:16 phoenix <IRQ>  [<ffffffff80277a60>] 
wake_up_process+0x10/0x20
Jun 19 10:58:16 phoenix [<ffffffff80297829>] softlockup_tick+0xe9/0x110
Jun 19 10:58:16 phoenix [<ffffffff8024dc93>] run_local_timers+0x13/0x20
Jun 19 10:58:16 phoenix [<ffffffff802815e7>] update_process_times+0x57/0x90
Jun 19 10:58:16 phoenix [<ffffffff8026eea4>] 
smp_local_timer_interrupt+0x34/0x60
Jun 19 10:58:16 phoenix [<ffffffff8026f49e>] 
smp_apic_timer_interrupt+0x4e/0x70
Jun 19 10:58:16 phoenix [<ffffffff8025ed56>] apic_timer_interrupt+0x66/0x70
Jun 19 10:58:16 phoenix <EOI>  [<ffffffff8026368c>] 
_spin_unlock_irqrestore+0xc/0x10
Jun 19 10:58:16 phoenix [<ffffffff80221acb>] __up_read+0x9b/0xb0
Jun 19 10:58:16 phoenix [<ffffffff8028d6e9>] up_read+0x9/0x10
Jun 19 10:58:16 phoenix [<ffffffff8034699d>] xfs_iunlock+0x3d/0xa0
Jun 19 10:58:16 phoenix [<ffffffff80362b1a>] xfs_rwunlock+0x3a/0x50
Jun 19 10:58:16 phoenix [<ffffffff80369c46>] xfs_vm_bmap+0x66/0x90
Jun 19 10:58:16 phoenix [<ffffffff8025cecc>] bmap+0x1c/0x20
Jun 19 10:58:16 phoenix [<ffffffff802a684e>] sys_swapon+0x6ae/0xae0
Jun 19 10:58:16 phoenix [<ffffffff8025e11e>] system_call+0x7e/0x83

What does it tell me?

-- 
Regards,
Hannes Dorbath
