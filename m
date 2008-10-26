Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 25 Oct 2008 17:54:32 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9Q0rtfI022448
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 17:53:56 -0700
Received: from ipmail01.adl6.internode.on.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6BE467AC2F2
	for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 17:53:54 -0700 (PDT)
Received: from ipmail01.adl6.internode.on.net (ipmail01.adl6.internode.on.net [203.16.214.146]) by cuda.sgi.com with ESMTP id FRPjRVo0wa6QlIsW for <xfs@oss.sgi.com>; Sat, 25 Oct 2008 17:53:54 -0700 (PDT)
Date: Sun, 26 Oct 2008 11:53:51 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: deadlock with latest xfs
Message-ID: <20081026005351.GK18495@disturbed>
References: <4900412A.2050802@sgi.com> <20081023205727.GA28490@infradead.org> <49013C47.4090601@sgi.com> <20081024052418.GO25906@disturbed> <20081024064804.GQ25906@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081024064804.GQ25906@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>, Christoph Hellwig <hch@infradead.org>, xfs-oss <xfs@oss.sgi.com>

On Fri, Oct 24, 2008 at 05:48:04PM +1100, Dave Chinner wrote:
> OK, I just hung a single-threaded rm -rf after this completed:
> 
> # fsstress -p 1024 -n 100 -d /mnt/xfs2/fsstress
> 
> It has hung with this trace:
> 
> # echo w > /proc/sysrq-trigger
....
> [42954211.590000] 794877f8:  [<6002e40a>] update_curr+0x3a/0x50
> [42954211.590000] 79487818:  [<60014f0d>] _switch_to+0x6d/0xe0
> [42954211.590000] 79487858:  [<60324b21>] schedule+0x171/0x2c0
> [42954211.590000] 794878a8:  [<60324e6d>] schedule_timeout+0xad/0xf0
> [42954211.590000] 794878c8:  [<60326e98>] _spin_unlock_irqrestore+0x18/0x20
> [42954211.590000] 79487908:  [<60195455>] xlog_grant_log_space+0x245/0x470
> [42954211.590000] 79487920:  [<60030ba0>] default_wake_function+0x0/0x10
> [42954211.590000] 79487978:  [<601957a2>] xfs_log_reserve+0x122/0x140
> [42954211.590000] 794879c8:  [<601a36e7>] xfs_trans_reserve+0x147/0x2e0
> [42954211.590000] 794879f8:  [<60087374>] kmem_cache_alloc+0x84/0x100
> [42954211.590000] 79487a38:  [<601ab01f>] xfs_inactive_symlink_rmt+0x9f/0x450
> [42954211.590000] 79487a88:  [<601ada94>] kmem_zone_zalloc+0x34/0x50
> [42954211.590000] 79487aa8:  [<601a3a6d>] _xfs_trans_alloc+0x2d/0x70
....

I came back to the system, and found that the hang had gone away - the
rm -rf had finished sometime in the ~36 hours between triggering the
problem and coming back to look at the corpse....

So nothing to report yet.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
