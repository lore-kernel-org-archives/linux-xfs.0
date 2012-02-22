Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q1MM1fvG050980 for <xfs@oss.sgi.com>; Wed, 22 Feb 2012 16:01:42 -0600
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id RbcMwJdG2hk04fEy (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 22 Feb 2012 14:01:40 -0800 (PST)
Received: from relay2.suse.de (unknown [195.135.220.254])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mx2.suse.de (Postfix) with ESMTP id F026B90B49
	for <xfs@oss.sgi.com>; Wed, 22 Feb 2012 23:01:38 +0100 (CET)
Date: Wed, 22 Feb 2012 23:01:37 +0100
From: Jan Kara <jack@suse.cz>
Subject: Warning from unlock_new_inode
Message-ID: <20120222220137.GB3650@quack.suse.cz>
MIME-Version: 1.0
Content-Disposition: inline
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

  Hello,

  while running fsstress on XFS partition with 3.3-rc4 kernel + my freeze
fixes (they do not touch anything relevant AFAICT) I've got the following
warning:

[   62.699499] ------------[ cut here ]------------
[   62.699531] WARNING: at fs/inode.c:967 unlock_new_inode+0x70/0x80()
[   62.699538] Hardware name: Bochs
[   62.699543] Modules linked in: xfs exportfs ipv6 mperf loop processor thermal_sys 8250_pnp button 8250 serial_core
[   62.699572] Pid: 2397, comm: fsstress Not tainted 3.3.0-rc4-xen+ #9
[   62.699578] Call Trace:
[   62.699588]  [<ffffffff81131130>] ? unlock_new_inode+0x70/0x80
[   62.699598]  [<ffffffff8103667a>] warn_slowpath_common+0x7a/0xb0
[   62.699606]  [<ffffffff810366c5>] warn_slowpath_null+0x15/0x20
[   62.699613]  [<ffffffff81131130>] unlock_new_inode+0x70/0x80
[   62.699668]  [<ffffffffa00b787f>] xfs_setup_inode+0x20f/0x2f0 [xfs]
[   62.699696]  [<ffffffffa00b3614>] xfs_iget+0x884/0x8c0 [xfs]
[   62.699721]  [<ffffffffa00b2e78>] ? xfs_iget+0xe8/0x8c0 [xfs]
[   62.699748]  [<ffffffffa00b8898>] xfs_bulkstat_one_int+0xa8/0x350 [xfs]
[   62.699775]  [<ffffffffa00b8770>] ? xfs_inumbers_fmt+0x70/0x70 [xfs]
[   62.699803]  [<ffffffffa00b8b5b>] xfs_bulkstat_one+0x1b/0x20 [xfs]
[   62.699832]  [<ffffffffa00b8f0a>] xfs_bulkstat+0x3aa/0x810 [xfs]
[   62.699858]  [<ffffffffa00b8b40>] ? xfs_bulkstat_one_int+0x350/0x350 [xfs]
[   62.699899]  [<ffffffffa00b4266>] xfs_ioc_bulkstat+0xe6/0x180 [xfs]
[   62.699925]  [<ffffffffa00b5756>] xfs_file_ioctl+0x426/0xa30 [xfs]
[   62.699945]  [<ffffffff810f7edb>] ? might_fault+0x3b/0x90
[   62.699958]  [<ffffffff81110191>] ? kfree_debugcheck+0x11/0x30
[   62.699966]  [<ffffffff81111d6e>] ? kmem_cache_free+0x13e/0x150
[   62.699975]  [<ffffffff8112954c>] do_vfs_ioctl+0x9c/0x590
[   62.699987]  [<ffffffff81114df0>] ? fd_install+0x30/0x60
[   62.699997]  [<ffffffff8138b5a5>] ? sysret_check+0x22/0x5d
[   62.700005]  [<ffffffff81129a8a>] sys_ioctl+0x4a/0x80
[   62.700012]  [<ffffffff8138b579>] system_call_fastpath+0x16/0x1b
[   62.700020] ---[ end trace 0a20034268e46d92 ]---

It is the first time I've got this warning and I'm already testing for
quite some time so it doesn't look easily reproducible...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
