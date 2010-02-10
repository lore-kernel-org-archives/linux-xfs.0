Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o1ACfkdO047507 for <xfs@oss.sgi.com>; Wed, 10 Feb 2010 06:41:46 -0600
Received: from pu01.news-service.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0EE671C13C2
	for <xfs@oss.sgi.com>; Wed, 10 Feb 2010 04:42:58 -0800 (PST)
Received: from pu01.news-service.com (ns1.news-service.com [195.114.240.3]) by
	cuda.sgi.com with ESMTP id 7QKqrlxiKoSGZlES for
	<xfs@oss.sgi.com>; Wed, 10 Feb 2010 04:42:58 -0800 (PST)
Message-ID: <4B72A9D1.8030101@news-service.com>
Date: Wed, 10 Feb 2010 13:42:57 +0100
From: Patrick Schreurs <patrick@news-service.com>
MIME-Version: 1.0
Subject: Re: [PATCH] Inode reclaim fixes (was Re: 2.6.31	xfs_fs_destroy_inode:
	cannot reclaim)
References: <4B0A8075.8080008@news-service.com>
	<20091211115932.GA20632@infradead.org>
	<4B3F9F88.9030307@news-service.com>
	<20100107110446.GA13802@discord.disaster>
	<4B45CFAC.4000607@news-service.com>
	<20100108113114.GA8654@discord.disaster>
	<4B504B03.7050604@news-service.com>
	<4B6706CE.1020207@news-service.com>
	<20100208194226.GD9527@infradead.org>
	<4B712166.9010701@news-service.com>
	<20100209103157.GA5197@infradead.org>
In-Reply-To: <20100209103157.GA5197@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Tommy van Leeuwen <tommy@news-service.com>, xfs@oss.sgi.com

On 9-2-2010 11:31, Christoph Hellwig wrote:
> On Tue, Feb 09, 2010 at 09:48:38AM +0100, Patrick Schreurs wrote:
>> This is a clean 2.6.32.3 with the xfs-inode-reclaim-2.6.32 patch i
>> received from Dave on January 8th (see attachment).
>
> I can't find anything interesting regarding I_RECLAIMABLE manipulation
> in there.  The only thing I could think off going wrong is i_flags
> and i_update_core sitting in the same word and the compiler causing
> some read-modify-write cycles for it.  Can you test the patch below?
> It fixes the abose issue up, and to make sure sure the assert you hit
> isn't as lethal changes it into a WARN_ON, which will still print the
> backtrace, but not crash the machine.

Thanks for the patch. After having this patch applied we saw *a lot* 
warnings. They all look like this:

Feb 10 13:20:38 sb06 kernel: ------------[ cut here ]------------
Feb 10 13:20:38 sb06 kernel: WARNING: at fs/xfs/linux-2.6/xfs_sync.c:768 
xfs_reclaim_inode_now+0x3d/0x84()
Feb 10 13:20:38 sb06 kernel: Hardware name: PowerEdge 1950
Feb 10 13:20:38 sb06 kernel: Modules linked in: acpi_cpufreq 
cpufreq_ondemand ipmi_si ipmi_devintf ipmi_msghandler bonding mptspi 
serio_raw rng_core scsi_transport_spi bnx2 thermal processor thermal_sys
Feb 10 13:20:38 sb06 kernel: Pid: 3145, comm: xfssyncd Not tainted 
2.6.32.3 #2
Feb 10 13:20:38 sb06 kernel: Call Trace:
Feb 10 13:20:38 sb06 kernel: [<ffffffff8113a897>] ? 
xfs_reclaim_inode_now+0x3d/0x84
Feb 10 13:20:38 sb06 kernel: [<ffffffff8113a897>] ? 
xfs_reclaim_inode_now+0x3d/0x84
Feb 10 13:20:38 sb06 kernel: [<ffffffff8102e8c9>] ? 
warn_slowpath_common+0x77/0xa3
Feb 10 13:20:38 sb06 kernel: [<ffffffff8113a897>] ? 
xfs_reclaim_inode_now+0x3d/0x84
Feb 10 13:20:38 sb06 kernel: [<ffffffff8113b130>] ? 
xfs_inode_ag_walk+0x68/0xa2
Feb 10 13:20:38 sb06 kernel: [<ffffffff8113a85a>] ? 
xfs_reclaim_inode_now+0x0/0x84
Feb 10 13:20:38 sb06 kernel: [<ffffffff8113b1ba>] ? 
xfs_inode_ag_iterator+0x50/0x7e
Feb 10 13:20:38 sb06 kernel: [<ffffffff8113a85a>] ? 
xfs_reclaim_inode_now+0x0/0x84
Feb 10 13:20:38 sb06 kernel: [<ffffffff8113b224>] ? 
xfs_sync_worker+0x26/0x52
Feb 10 13:20:38 sb06 kernel: [<ffffffff8113aa79>] ? xfssyncd+0x123/0x180
Feb 10 13:20:38 sb06 kernel: [<ffffffff8113a956>] ? xfssyncd+0x0/0x180
Feb 10 13:20:38 sb06 kernel: [<ffffffff8103f5cd>] ? kthread+0x79/0x81
Feb 10 13:20:38 sb06 kernel: [<ffffffff8100bcda>] ? child_rip+0xa/0x20
Feb 10 13:20:38 sb06 kernel: [<ffffffff8103f554>] ? kthread+0x0/0x81
Feb 10 13:20:38 sb06 kernel: [<ffffffff8100bcd0>] ? child_rip+0x0/0x20
Feb 10 13:20:38 sb06 kernel: ---[ end trace 1ae862ca12666a87 ]---

and some look like this:

Feb 10 13:20:38 sb06 kernel: ------------[ cut here ]------------
Feb 10 13:20:38 sb06 kernel: WARNING: at fs/xfs/linux-2.6/xfs_sync.c:768 
xfs_reclaim_inode_now+0x3d/0x84()
Feb 10 13:20:38 sb06 kernel: Hardware name: PowerEdge 1950
Feb 10 13:20:38 sb06 kernel: Modules linked in: acpi_cpufreq 
cpufreq_ondemand ipmi_si ipmi_devintf ipmi_msghandlerspes  13<f3dat? 
ff4ode_now+0x0/0x84
Feb 10 13:20:38 sb06 kernel: [<ffffffff8113b1ba>]n2r4a 
2f1>nx85k7[<4x0-[e :7we_ospes  13<f3dat? ff4ode_n]n2r4a 
2f1>nx85k7[<4x0-[e :7we_ospes  13<f3dat? xff4ode_n]n2r4a 
2f1>nx85k7[<4x0-[e :7we_ospes  13<f3dat? xff4ode_n]n2r4a 
2f1>nx85k7[<4x0-[e :7we_ospies  13<f3dat? ff4ode]n2r4a 
2f1>nx85k7[<4x0-[e :7we_ospes  13<f3dat? xff4ode_now+0x0/0x84
Feb 10 13:20:38 sb06 kernel: [<ffffff]n2r4a 2f1>nx85k7[<4x0-[e 
:7we_ospes  13<ode_]n2r4a 2f1>nx85k7[<4x0-[e :7we_ospes  13<f3dat? 
ff4ode_now+0x0/0]n2r4a 2f1>nx85k7[<4x0-[e :7we_ospes  13<f3dat? 
ff4ode_now+0x0/0x]n2r4a 2f1>nx85k7[<4x0-[e :7we_ospes  13<f3dat? 
ff4ode_no]n2r4a 2f1>nx85k7[<4x0-[e :7we_ospes  13<f3dat? ff4ode_now+0x0/0x84
Feb 10 13:20:38 sb06 kernel: [<fff]n2r4a 2f1>nx85k7[<4x0-[e :7we_ospes 
13<f3dat? ff4ode_now+]n2r4a 2f1>nx85k7[<4x0-[e :7we_ospes  13<f3dat? 
ff4>ode_no]n2r4a 2f1>nx85k7[<4x0-[e :7we_ospes  13<f3dat? 
xff4ode_now+]n2r4a 2f1>nx85k7[<4x0-[e :7we_ospes  13<f3dat? 
xff4ode_now+0x0/0x84
Feb 10 13:20:38 sb06 kernel: [<ffffffff8113b1ba>] ? 
xfs_inode_ag_iterator+0x50/0x7e
Feb 10 13:20:38 sb06 kernel: [<ffffffff8113a85a>] ? 
xfs_reclaim_inode_now+0x0/0x84
Feb 10 13:20:38 sb06 kernel: [<ffffffff8113b224>] ? 
xfs_sync_worker+0x26/0x52
Feb 10 13:20:38 sb06 kernel: [<ffffffff8113aa79>] ? xfssyncd+0x123/0x180
Feb 10 13:20:38 sb06 kernel: [<ffffffff8113a956>] ? xfssyncd+0x0/0x180
Feb 10 13:20:38 sb06 kernel: [<ffffffff8103f5cd>] ? kthread+0x79/0x81
Feb 10 13:20:38 sb06 kernel: [<ffffffff8100bcda>] ? child_rip+0xa/0x20
Feb 10 13:20:38 sb06 kernel: [<ffffffff8103f554>] ? kthread+0x0/0x81
Feb 10 13:20:38 sb06 kernel: [<ffffffff8100bcd0>] ? child_rip+0x0/0x20
Feb 10 13:20:38 sb06 kernel: ---[ end trace 1ae862ca12666b1c ]---

I hope this clarifies things. If you need more info, don't hesitate to 
contact me.

Thanks,

-Patrick

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
