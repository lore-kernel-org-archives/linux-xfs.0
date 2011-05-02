Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p42GErej239551 for <xfs@oss.sgi.com>; Mon, 2 May 2011 11:14:53 -0500
Received: from legolas.restena.lu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C4447513C84
	for <xfs@oss.sgi.com>; Mon,  2 May 2011 09:18:26 -0700 (PDT)
Received: from legolas.restena.lu (legolas.restena.lu [158.64.1.34]) by
	cuda.sgi.com with ESMTP id ZJ52tCm5HmXYHSX1 for
	<xfs@oss.sgi.com>; Mon, 02 May 2011 09:18:26 -0700 (PDT)
Date: Mon, 2 May 2011 18:18:11 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
Subject: Re: xfs hang on 2.6.39-rc5
Message-ID: <20110502181811.61dd09eb@neptune.home>
In-Reply-To: <4DBD7880.2040804@gmail.com>
References: <4DBD7880.2040804@gmail.com>
Mime-Version: 1.0
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
To: Doug Nazar <nazard.lkml@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, xfs@oss.sgi.com

On Sun, 01 May 2011 Doug Nazar <nazard.lkml@gmail.com> wrote:
> On two different hosts, both running 2.6.39-rc5-00123-g33b6c92, xfs 
> seems to be locking up.
> 
> I had to revert the box from the second trace but this trace is mounted 
> with:

This looks related to at least:
  http://thread.gmane.org/gmane.linux.kernel/1130312/focus=1131769


> UUID=dcdc849e-bad8-4971-935c-223819a6dcc4               /               
> xfs             noatime         0 1
> 
> which ends up being:
> 
> /dev/sdb3 on / type xfs (rw,noatime,delaylog,noquota)
> 
> meta-data=/dev/sdb3              isize=256    agcount=16, agsize=601056 blks
>           =                       sectsz=512   attr=0
> data     =                       bsize=4096   blocks=9616896, imaxpct=25
>           =                       sunit=0      swidth=0 blks
> naming   =version 2              bsize=4096   ascii-ci=0
> log      =internal               bsize=4096   blocks=4695, version=1
>           =                       sectsz=512   sunit=0 blks, lazy-count=0
> realtime =none                   extsz=65536  blocks=0, rtextents=0
> 
> [38160.536046] INFO: task multilog:7586 blocked for more than 120 seconds.
> [38160.536052] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
> disables this message.
> [38160.536059] multilog        D 0012cfae     0  7586   7578 0x00000000
> [38160.536069]  f5bcfd18 00000086 f9a4653a 0012cfae f9a33b34 00000024 
> 6d783c2f 0000227f
> [38160.536082]  f5bcfcc8 f5bcfcd8 00000000 00000000 f5bcfd18 f5c91810 
> f5c91810 00000024
> [38160.536092]  00d2e530 f1fd2e40 00001460 00dc5000 f5c1b780 0000695d 
> 00000000 f5bcfd18
> [38160.536103] Call Trace:
> [38160.536188]  [<f9a4653a>] ? kmem_alloc+0x51/0xbe [xfs]
> [38160.536212]  [<f9a33b34>] ? xlog_space_left+0x24/0xa9 [xfs]
> [38160.536237]  [<f9a34644>] ? xlog_grant_push_ail+0xb8/0xdc [xfs]
> [38160.536262]  [<f9a34c8f>] xlog_grant_log_space+0x173/0x42a [xfs]
> [38160.536277]  [<c1028b95>] ? try_to_wake_up+0xd4/0xd4
> [38160.536302]  [<f9a34ff1>] xfs_log_reserve+0xab/0xfe [xfs]
> [38160.536329]  [<f9a40a20>] xfs_trans_reserve+0x74/0x1cb [xfs]
> [38160.536357]  [<f9a3de78>] xfs_rename+0x122/0x61a [xfs]
> [38160.536367]  [<c10bbd13>] ? link_path_walk+0x2de/0x77b
> [38160.536375]  [<c10bae07>] ? generic_permission+0x1a/0x95
> [38160.536398]  [<f9a4ee3e>] xfs_vn_rename+0x60/0x6a [xfs]
> [38160.536407]  [<c10bd680>] vfs_rename+0x313/0x350
> [38160.536415]  [<c10c290a>] ? d_lookup+0x1e/0x3d
> [38160.536422]  [<c10be874>] sys_renameat+0x203/0x219
> [38160.536431]  [<c10c889e>] ? mntput+0x13/0x1f
> [38160.536437]  [<c10b4bfd>] ? fput+0x118/0x1b0
> [38160.536443]  [<c10be8b2>] sys_rename+0x28/0x2a
> [38160.536451]  [<c12db698>] sysenter_do_call+0x12/0x28
> 
> 
> 
> [94440.552055] INFO: task nfsd:8055 blocked for more than 120 seconds.
> [94440.553587] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" 
> disables this message.
> [94440.556638] nfsd            D df5df880     0  8055      2 0x00000000
> [94440.558258]  d6fb3d78 00000046 d6941c90 df5df880 df2b1400 df5df8c0 
> 5a0961bd 000055be
> [94440.561634]  d6fb3d28 03f35714 00014f61 00000000 d6fb3d78 d6fae370 
> d6fae370 ffffff8c
> [94440.565246]  d6941cdc d6fb3d48 c10c4aa8 cb5aea80 cb918000 0004e83b 
> cb918201 e21adb34
> [94440.569039] Call Trace:
> [94440.570871]  [<c10c4aa8>] ? d_obtain_alias+0x3e/0xe6
> [94440.572813]  [<e21adb34>] ? xlog_space_left+0x24/0xa9 [xfs]
> [94440.574708]  [<e21aec08>] xlog_grant_log_space+0xec/0x42a [xfs]
> [94440.576622]  [<e21ae644>] ? xlog_grant_push_ail+0xb8/0xdc [xfs]
> [94440.578509]  [<c1028b95>] ? try_to_wake_up+0xd4/0xd4
> [94440.580451]  [<e21aeff1>] xfs_log_reserve+0xab/0xfe [xfs]
> [94440.582391]  [<e21baa20>] xfs_trans_reserve+0x74/0x1cb [xfs]
> [94440.584353]  [<e21bdd48>] xfs_remove+0xd9/0x333 [xfs]
> [94440.586270]  [<c10bad79>] ? acl_permission_check+0x1b/0x8f
> [94440.588209]  [<c10bae07>] ? generic_permission+0x1a/0x95
> [94440.590152]  [<e21c9079>] xfs_vn_unlink+0x30/0x6a [xfs]
> [94440.592083]  [<c10bd2f7>] vfs_unlink+0x60/0xae
> [94440.594006]  [<e1ebf9c5>] nfsd_unlink+0x19e/0x21b [nfsd]
> [94440.595943]  [<e1ecae80>] ? nfsd4_encode_operation+0x56/0x161 [nfsd]
> [94440.597911]  [<e1ec92a8>] nfsd4_remove+0x3e/0x114 [nfsd]
> [94440.599878]  [<e1ec96f3>] nfsd4_proc_compound+0x334/0x3e9 [nfsd]
> [94440.601853]  [<e1ecbcc7>] ? nfsd4_decode_getattr+0x8/0xa [nfsd]
> [94440.603832]  [<e1ecfdb1>] ? nfs4svc_decode_compoundargs+0x268/0x342 
> [nfsd]
> [94440.605851]  [<e1ec926a>] ? nfsd4_rename+0x1e0/0x1e0 [nfsd]
> [94440.607826]  [<e1ebc2be>] nfsd_dispatch+0xbc/0x1e9 [nfsd]
> [94440.609794]  [<e1f81f2b>] svc_process+0x401/0x740 [sunrpc]
> [94440.611715]  [<e1ebc8a4>] nfsd+0xae/0x130 [nfsd]
> [94440.613620]  [<e1ebc7f6>] ? nfsd_svc+0x197/0x197 [nfsd]
> [94440.615495]  [<e1ebc7f6>] ? nfsd_svc+0x197/0x197 [nfsd]
> [94440.617277]  [<c1043c01>] kthread+0x67/0x69
> [94440.618996]  [<c1043b9a>] ? kthreadd+0xa3/0xa3
> [94440.620641]  [<c12dbc36>] kernel_thread_helper+0x6/0xd
> 
> 
> Doug
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
