Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id E4E9A7F3F
	for <xfs@oss.sgi.com>; Tue, 15 Oct 2013 08:54:33 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id B28D030405F
	for <xfs@oss.sgi.com>; Tue, 15 Oct 2013 06:54:30 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id WiH8wMwm1iIG2O26 for
	<xfs@oss.sgi.com>; Tue, 15 Oct 2013 06:54:29 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r9FDsTRS030844
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Tue, 15 Oct 2013 09:54:29 -0400
Received: from orion.maiolino.org (ovpn-113-159.phx2.redhat.com [10.3.113.159])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r9FDsPhL016647
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 15 Oct 2013 09:54:28 -0400
Date: Tue, 15 Oct 2013 10:54:25 -0300
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: xfs corruption - structure need cleaning
Message-ID: <20131015135424.GA32104@orion.maiolino.org>
References: <CAMg3XqqJgxnc2+ZkuMaK9RC1_Basfh9AzcqCpNdvmPpCXgNHZg@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAMg3XqqJgxnc2+ZkuMaK9RC1_Basfh9AzcqCpNdvmPpCXgNHZg@mail.gmail.com>
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
To: xfs@oss.sgi.com

I'm not the best person with the xfs journal, but I don't think the information
you sent is enough to help with the problem, all I can see is a failure to mount
a filesystem that looks to have some kind of log corruption and couldn't replay
the log, I'd say that in this case you'd need to clear the log with -L option as
you said, but you'll possibly lose some data.
What happened before you needed to mount the fs, i.e how it was umounted, if any
errors happened before that will be more useful to identify possible issues that
led to a log corruption.

This is a good guide of what kind information might be useful:

http://www.xfs.org/index.php/XFS_FAQ#Q:_What_information_should_I_include_when_reporting_a_problem.3F


On Tue, Oct 15, 2013 at 09:45:27PM +0800, Roy Zhang wrote:
> Hi,
> I met a problem that cannot mount xfs, log as below.
> I got know xfs_repair -L will fix this situation, I want to know how
> and why cause it, it's a bug in xfs or hdd? Is there any patch to fix
> it?
> 
> Thanks
> Roy
> 
> Oct  9 18:26:52 mcluster-alpha-node3 kernel: [11840.232985] XFS
> (dm-3): Mounting Filesystem
> Oct  9 18:26:52 mcluster-alpha-node3 kernel: [11840.327773] XFS
> (dm-3): Internal error xlog_clear_stale_blocks(2) at line 1353 of file
> fs/xfs/xfs_log_recover.c.  Caller 0xffffffffa01f894d
> Oct  9 18:26:52 mcluster-alpha-node3 kernel: [11840.327776]
> Oct  9 18:26:52 mcluster-alpha-node3 kernel: [11840.400435] Pid:
> 20055, comm: mount Not tainted 2.6.32-902.279.9.1.letv.el6.x86_64 #1
> Oct  9 18:26:52 mcluster-alpha-node3 kernel: [11840.400437] Call Trace:
> Oct  9 18:26:52 mcluster-alpha-node3 kernel: [11840.400477]
> [<ffffffffa01e0f1f>] ? xfs_error_report+0x3f/0x50 [xfs]
> Oct  9 18:26:52 mcluster-alpha-node3 kernel: [11840.400503]
> [<ffffffffa01f894d>] ? xlog_find_tail+0x38d/0x3c0 [xfs]
> Oct  9 18:26:52 mcluster-alpha-node3 kernel: [11840.400526]
> [<ffffffffa01f5266>] ? xlog_clear_stale_blocks+0x156/0x190 [xfs]
> Oct  9 18:26:52 mcluster-alpha-node3 kernel: [11840.400549]
> [<ffffffffa01f894d>] ? xlog_find_tail+0x38d/0x3c0 [xfs]
> Oct  9 18:26:52 mcluster-alpha-node3 kernel: [11840.400570]
> [<ffffffffa01f899e>] ? xlog_recover+0x1e/0x90 [xfs]
> Oct  9 18:26:52 mcluster-alpha-node3 kernel: [11840.400592]
> [<ffffffffa01f04dc>] ? xfs_log_mount+0xac/0x190 [xfs]
> Oct  9 18:26:52 mcluster-alpha-node3 kernel: [11840.400615]
> [<ffffffffa01fbb8b>] ? xfs_mountfs+0x36b/0x680 [xfs]
> Oct  9 18:26:52 mcluster-alpha-node3 kernel: [11840.400640]
> [<ffffffffa02137b4>] ? xfs_fs_fill_super+0x234/0x360 [xfs]
> Oct  9 18:26:52 mcluster-alpha-node3 kernel: [11840.400647]
> [<ffffffff811ed4ca>] ? disk_name+0xba/0xc0
> Oct  9 18:26:52 mcluster-alpha-node3 kernel: [11840.400653]
> [<ffffffff8117e54e>] ? get_sb_bdev+0x18e/0x1d0
> Oct  9 18:26:52 mcluster-alpha-node3 kernel: [11840.400675]
> [<ffffffffa0213580>] ? xfs_fs_fill_super+0x0/0x360 [xfs]
> Oct  9 18:26:52 mcluster-alpha-node3 kernel: [11840.400698]
> [<ffffffffa02113a8>] ? xfs_fs_get_sb+0x18/0x20 [xfs]
> Oct  9 18:26:52 mcluster-alpha-node3 kernel: [11840.400703]
> [<ffffffff8117dfdb>] ? vfs_kern_mount+0x7b/0x1b0
> Oct  9 18:26:52 mcluster-alpha-node3 kernel: [11840.400707]
> [<ffffffff8117e182>] ? do_kern_mount+0x52/0x130
> Oct  9 18:26:52 mcluster-alpha-node3 kernel: [11840.400713]
> [<ffffffff8119c852>] ? do_mount+0x2d2/0x8d0
> Oct  9 18:26:52 mcluster-alpha-node3 kernel: [11840.400719]
> [<ffffffff81136014>] ? strndup_user+0x64/0xc0
> Oct  9 18:26:52 mcluster-alpha-node3 kernel: [11840.400723]
> [<ffffffff8119cee0>] ? sys_mount+0x90/0xe0
> Oct  9 18:26:52 mcluster-alpha-node3 kernel: [11840.400730]
> [<ffffffff8100b0f2>] ? system_call_fastpath+0x16/0x1b
> Oct  9 18:26:52 mcluster-alpha-node3 kernel: [11840.400734] XFS
> (dm-3): failed to locate log tail
> Oct  9 18:26:52 mcluster-alpha-node3 kernel: [11840.400737] XFS
> (dm-3): log mount/recovery failed: error 117
> Oct  9 18:26:52 mcluster-alpha-node3 kernel: [11840.400816] XFS
> (dm-3): log mount failed
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Carlos

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
