Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 23 Oct 2008 23:48:18 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9O6mA7o013127
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 23:48:10 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 726BE5387F3
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 23:48:08 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id 2q55Srm8wEEtnCYh for <xfs@oss.sgi.com>; Thu, 23 Oct 2008 23:48:08 -0700 (PDT)
Date: Fri, 24 Oct 2008 17:48:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: deadlock with latest xfs
Message-ID: <20081024064804.GQ25906@disturbed>
References: <4900412A.2050802@sgi.com> <20081023205727.GA28490@infradead.org> <49013C47.4090601@sgi.com> <20081024052418.GO25906@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081024052418.GO25906@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>, Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

On Fri, Oct 24, 2008 at 04:24:18PM +1100, Dave Chinner wrote:
> On Fri, Oct 24, 2008 at 01:08:55PM +1000, Lachlan McIlroy wrote:
> > Christoph Hellwig wrote:
> >> On Thu, Oct 23, 2008 at 07:17:30PM +1000, Lachlan McIlroy wrote:
> >>> another problem with latest xfs
> >>
> >> Is this with the 2.6.27-based ptools/cvs tree or with the 2.6.28 based
> >> git tree?  It does looks more like a VM issue than a XFS issue to me.
> >>
> >
> > It's with the 2.6.27-rc8 based ptools tree.  Prior to checking
> > in these patches:
> >
> > Can't lock inodes in radix tree preload region
> > stop using xfs_itobp in xfs_bulkstat
> > free partially initialized inodes using destroy_inode
> >
> > I was able to stress a system for about 4 hours before it ran out
> > of memory.  Now I hit the deadlock within a few minutes.  I need
> > to roll back to find which patch changed the behaviour.
> 
> Does it go away when you add the "XFS: Fix race when looking up
> reclaimable inodes" I sent this morning?
> 
> Also, is there a thread stuck in xfs_setfilesize() waiting on an
> ilock during I/O completion?
> 
> i.e. did the log hang because I/O completion is stuck waiting on
> an ilock that is held by a thread waiting on I/O completion?

OK, I just hung a single-threaded rm -rf after this completed:

# fsstress -p 1024 -n 100 -d /mnt/xfs2/fsstress

It has hung with this trace:

# echo w > /proc/sysrq-trigger
[42954211.590000] SysRq : Show Blocked State
[42954211.590000]   task                        PC stack   pid father
[42954211.590000] rm            D 00000000407219f0     0  2504   1155
[42954211.590000] 604692d8 6002e40a 808ad040 79484000 79487850 60014f0d 808ad040 6032b3e0
[42954211.590000]        79484000 6c8a2808 60468e00 808ad040 794878a0 60324b21 79484000 00000250
[42954211.590000]        79484000 79484000 7fffffffffffffff 79045e88 80014d28 80014df8 79487900 60324e6d <6>Call Trace:
[42954211.590000] 794877f8:  [<6002e40a>] update_curr+0x3a/0x50
[42954211.590000] 79487818:  [<60014f0d>] _switch_to+0x6d/0xe0
[42954211.590000] 79487858:  [<60324b21>] schedule+0x171/0x2c0
[42954211.590000] 794878a8:  [<60324e6d>] schedule_timeout+0xad/0xf0
[42954211.590000] 794878c8:  [<60326e98>] _spin_unlock_irqrestore+0x18/0x20
[42954211.590000] 79487908:  [<60195455>] xlog_grant_log_space+0x245/0x470
[42954211.590000] 79487920:  [<60030ba0>] default_wake_function+0x0/0x10
[42954211.590000] 79487978:  [<601957a2>] xfs_log_reserve+0x122/0x140
[42954211.590000] 794879c8:  [<601a36e7>] xfs_trans_reserve+0x147/0x2e0
[42954211.590000] 794879f8:  [<60087374>] kmem_cache_alloc+0x84/0x100
[42954211.590000] 79487a38:  [<601ab01f>] xfs_inactive_symlink_rmt+0x9f/0x450
[42954211.590000] 79487a88:  [<601ada94>] kmem_zone_zalloc+0x34/0x50
[42954211.590000] 79487aa8:  [<601a3a6d>] _xfs_trans_alloc+0x2d/0x70
[42954211.590000] 79487ac8:  [<601a3b52>] xfs_trans_alloc+0xa2/0xb0
[42954211.590000] 79487ad8:  [<60326ea9>] _spin_unlock+0x9/0x10
[42954211.590000] 79487ae8:  [<601a85ef>] xfs_inode_is_filestream+0x5f/0x80
[42954211.590000] 79487b28:  [<601ab597>] xfs_inactive+0x1c7/0x530
[42954211.590000] 79487b78:  [<601b94ec>] xfs_fs_clear_inode+0x3c/0x70
[42954211.590000] 79487b98:  [<6009e881>] clear_inode+0x91/0x150
[42954211.590000] 79487bb8:  [<6009f05f>] generic_delete_inode+0xff/0x130
[42954211.590000] 79487bd8:  [<6009f20d>] generic_drop_inode+0x17d/0x1a0
[42954211.590000] 79487bf8:  [<6009e317>] iput+0x57/0x90
[42954211.590000] 79487c18:  [<60095be3>] do_unlinkat+0x113/0x1c0
[42954211.590000] 79487c98:  [<60098e90>] sys_getdents+0x110/0x150
[42954211.590000] 79487cd8:  [<60095ded>] sys_unlinkat+0x1d/0x40
[42954211.590000] 79487ce8:  [<60018150>] handle_syscall+0x50/0x80
[42954211.590000] 79487d08:  [<6002b05e>] userspace+0x48e/0x550
[42954211.590000] 79487f58:  [<600269a7>] save_registers+0x17/0x40
[42954211.590000] 79487fc8:  [<60014df2>] fork_handler+0x62/0x70
[42954211.590000]

Which implies that the log tail is not moving forward. I'm about to jump
on a plane, so I won't be able to look at this until tomorrow....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
