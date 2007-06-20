Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 19 Jun 2007 20:30:10 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5K3U4do024086
	for <xfs@oss.sgi.com>; Tue, 19 Jun 2007 20:30:05 -0700
Date: Wed, 20 Jun 2007 13:29:54 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: BUG: soft lockup detected on CPU#0!
Message-ID: <20070620032954.GW86004887@sgi.com>
References: <4677E97E.5070802@theendofthetunnel.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4677E97E.5070802@theendofthetunnel.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Hannes Dorbath <light@theendofthetunnel.de>
Cc: xfs@oss.sgi.com

On Tue, Jun 19, 2007 at 04:34:38PM +0200, Hannes Dorbath wrote:
> I got this on a server box today. Kernel 2.6.21, x86_64, LVM2:
> 
> Jun 19 10:58:16 phoenix Ending XFS recovery on filesystem: dm-5 (logdev: 
> internal)
> Jun 19 10:58:16 phoenix BUG: soft lockup detected on CPU#0!
> Jun 19 10:58:16 phoenix
> Jun 19 10:58:16 phoenix Call Trace:
> Jun 19 10:58:16 phoenix <IRQ>  [<ffffffff80277a60>] 
> wake_up_process+0x10/0x20
> Jun 19 10:58:16 phoenix [<ffffffff80297829>] softlockup_tick+0xe9/0x110
> Jun 19 10:58:16 phoenix [<ffffffff8024dc93>] run_local_timers+0x13/0x20
> Jun 19 10:58:16 phoenix [<ffffffff802815e7>] update_process_times+0x57/0x90
> Jun 19 10:58:16 phoenix [<ffffffff8026eea4>] 
> smp_local_timer_interrupt+0x34/0x60
> Jun 19 10:58:16 phoenix [<ffffffff8026f49e>] 
> smp_apic_timer_interrupt+0x4e/0x70
> Jun 19 10:58:16 phoenix [<ffffffff8025ed56>] apic_timer_interrupt+0x66/0x70
> Jun 19 10:58:16 phoenix <EOI>  [<ffffffff8026368c>] 
> _spin_unlock_irqrestore+0xc/0x10
> Jun 19 10:58:16 phoenix [<ffffffff80221acb>] __up_read+0x9b/0xb0
> Jun 19 10:58:16 phoenix [<ffffffff8028d6e9>] up_read+0x9/0x10
> Jun 19 10:58:16 phoenix [<ffffffff8034699d>] xfs_iunlock+0x3d/0xa0
> Jun 19 10:58:16 phoenix [<ffffffff80362b1a>] xfs_rwunlock+0x3a/0x50
> Jun 19 10:58:16 phoenix [<ffffffff80369c46>] xfs_vm_bmap+0x66/0x90
> Jun 19 10:58:16 phoenix [<ffffffff8025cecc>] bmap+0x1c/0x20
> Jun 19 10:58:16 phoenix [<ffffffff802a684e>] sys_swapon+0x6ae/0xae0
> Jun 19 10:58:16 phoenix [<ffffffff8025e11e>] system_call+0x7e/0x83
> 
> What does it tell me?

That you've got a fragemented swap file and that sys_swapon()
does not yield the CPU in it's main loop that maps the extents
in the swap file.

Harmless, AFAICT.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
