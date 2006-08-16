Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 15 Aug 2006 23:20:30 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k7G6JoDW029011
	for <xfs@oss.sgi.com>; Tue, 15 Aug 2006 23:20:04 -0700
Date: Wed, 16 Aug 2006 16:18:33 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [xfs-masters] [BUG]: soft lock detected
Message-ID: <20060816061833.GH51703024@melbourne.sgi.com>
References: <OFE45AA35E.CBCEE6A2-ON482571CB.00362A71-482571CB.003716BA@cn.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OFE45AA35E.CBCEE6A2-ON482571CB.00362A71-482571CB.003716BA@cn.ibm.com>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs-masters@oss.sgi.com
Cc: nathans@sgi.com, xfs@oss.sgi.com

On Tue, Aug 15, 2006 at 06:04:21PM +0800, Yi CDL Yang wrote:
> 
> Hi,
> 
> When I stress XFS filesystem, I find a bug, I can regenerate it on
> 2.6.18-rc3 and 2.6.18-rc4, my steps is:
> # mount /dev/sda5 /mnt/sda5
> #su oneuser
> $ mkdir /mnt/sda5/xfstest
> $ cd /mnt/sda5
> $ bonnie++ -d xfstest -s 2048 -r 512

Is that single threaded?

> After a while, kernel will output the following debug information:
> 
> BUG: soft lockup detected on CPU#0!
> Call Trace:
> [C0000001C7E5EEA0] [D000000000973018] .xfs_icsb_disable_counter+0x90/0x1ac
> [xfs]
> [C0000001C7E5EF60] [D000000000973274] .xfs_icsb_balance_counter+0x70/0x294
> [xfs]
> [C0000001C7E5F010] [D000000000973870]
> .xfs_icsb_modify_counters_int+0x188/0x1f4 [xfs]

We take spinlocks in these functions - but unless you've got lots of
CPUs they aren't taken for very long. We haven't seen these reports on
large CPU count machines, so I'm not sure off the top of my head
what would cause this.

FWIW, what type of machine and how many CPUs do you have?

> /////////////////////
> BUG: soft lockup detected on CPU#2!
> Call Trace:
> --- Exception: 901 at .xfs_alloc_fix_freelist+0x7c/0x4c4 [xfs]
>     LR = .xfs_alloc_vextent+0x2f0/0x494 [xfs]
> [C0000001C10CAF00] [0000000000000000] 0x0 (unreliable)
> [C0000001C10CB040] [D000000000933298] .xfs_alloc_vextent+0x2f0/0x494 [xfs]
> [C0000001C10CB110] [D000000000942F9C] .xfs_bmapi+0xd18/0x1834 [xfs]
> [C0000001C10CB390] [D0000000009688F8] .xfs_iomap_write_allocate+0x264/0x470

And we don't even hold spinlocks in that function. We do nothing that
would hold off interrupts or the scheduler in these functions....

> According to these information, I can't find the reason of the problem, for
> soft lockup, I think
> only preemption disabling or interrupt disabling can result in this, but
> the above functions don't
> run such an operation, I don't know what is your idea?

Spinlocks disable preemption so that could cause it, but I cannot see
how that second trace is at all valid....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
