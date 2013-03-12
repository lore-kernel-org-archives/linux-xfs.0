Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 616537F56
	for <xfs@oss.sgi.com>; Tue, 12 Mar 2013 01:20:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2FA9F8F8035
	for <xfs@oss.sgi.com>; Mon, 11 Mar 2013 23:20:13 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	TpkSnytZCwDQt3bx for <xfs@oss.sgi.com>;
	Mon, 11 Mar 2013 23:20:03 -0700 (PDT)
Received: from dave by dastard with local (Exim 4.76)
	(envelope-from <david@fromorbit.com>) id 1UFIZ8-0000cu-1O
	for xfs@oss.sgi.com; Tue, 12 Mar 2013 17:20:02 +1100
Date: Tue, 12 Mar 2013 17:20:02 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [ASSERT failure] transaction reservations changes bad?
Message-ID: <20130312062001.GJ21651@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Folks,

I just got this ASSERT failure running xfstests on a 3.1.8 xfsprogs
and a 3.9-rc1 kernel running test 297:

[ 2593.733005] XFS: Assertion failed: BTOBB(need_bytes) < log->l_logBBsize, file: fs/xfs/xfs_log.c, line: 1451
[ 2593.736988] ------------[ cut here ]------------
[ 2593.738177] kernel BUG at fs/xfs/xfs_message.c:100!
[ 2593.739192] invalid opcode: 0000 [#1] SMP
[ 2593.740081] Modules linked in:
[ 2593.740786] CPU 0
[ 2593.741221] Pid: 1385, comm: mkdir Not tainted 3.8.0-dgc+ #472 Bochs Bochs
[ 2593.742630] RIP: 0010:[<ffffffff8146a1f2>]  [<ffffffff8146a1f2>] assfail+0x22/0x30
[ 2593.744173] RSP: 0018:ffff880038c23c98  EFLAGS: 00010292
[ 2593.745234] RAX: 000000000000005f RBX: ffff88003cfec800 RCX: 0000000000005251
[ 2593.746635] RDX: 0000000000005151 RSI: 0000000000000096 RDI: 0000000000000246
[ 2593.748048] RBP: ffff880038c23c98 R08: 000000000000000a R09: 0000000000000889
[ 2593.749471] R10: 0000000000000000 R11: 0000000000000888 R12: 0000000000000dcb
[ 2593.750862] R13: ffff88003cfec800 R14: 0000000000000003 R15: 0000000000000001
[ 2593.752276] FS:  00007f0e64cb97a0(0000) GS:ffff88003fc00000(0000) knlGS:0000000000000000
[ 2593.753895] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 2593.755039] CR2: 000000000066c004 CR3: 000000003cf26000 CR4: 00000000000006f0
[ 2593.756472] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2593.757877] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2593.759285] Process mkdir (pid: 1385, threadinfo ffff880038c22000, task ffff88003cb483c0)
[ 2593.760914] Stack:
[ 2593.761345]  ffff880038c23cb8 ffffffff814c9a11 ffff88002fa170a8 ffff880007ac7420
[ 2593.762881]  ffff880038c23d18 ffffffff814cb608 0000000000000000 000111b838c23fd8
[ 2593.764429]  ffff880038c23fd8 ffff8800055733d0 ffff880005573000 0000000000000000
[ 2593.765964] Call Trace:
[ 2593.766449]  [<ffffffff814c9a11>] xlog_grant_push_ail+0x41/0xf0
[ 2593.767577]  [<ffffffff814cb608>] xfs_log_reserve+0xe8/0x270
[ 2593.768676]  [<ffffffff814c740e>] xfs_trans_reserve+0x2ee/0x300
[ 2593.769832]  [<ffffffff814c6ec7>] ? _xfs_trans_alloc+0x37/0xa0
[ 2593.770950]  [<ffffffff8146ed05>] xfs_create+0x185/0x660
[ 2593.771975]  [<ffffffff8118cadd>] ? lookup_real+0x1d/0x60
[ 2593.773028]  [<ffffffff814678c6>] xfs_vn_mknod+0xa6/0x1b0
[ 2593.774093]  [<ffffffff814679e6>] xfs_vn_mkdir+0x16/0x20
[ 2593.775112]  [<ffffffff81190ece>] vfs_mkdir+0x9e/0xf0
[ 2593.776092]  [<ffffffff81192862>] sys_mkdirat+0x62/0xe0
[ 2593.777111]  [<ffffffff811928f9>] sys_mkdir+0x19/0x20
[ 2593.778084]  [<ffffffff81be0f99>] system_call_fastpath+0x16/0x1b
[ 2593.779233] Code: e8 f4 fb ff ff 0f 0b 66 90 0f 1f 44 00 00 55 48 89 f1 41 89 d0 48 89 e5 48 89 fa 48 c7 c6 40 f9 f2 81 31 ff 31 c0 e8 1e fc ff ff <0f> 0b 66 66 66
[ 2593.784186] RIP  [<ffffffff8146a1f2>] assfail+0x22/0x30
[ 2593.785224]  RSP <ffff880038c23c98>
[ 2593.786366] ---[ end trace bf0cb9ec29b256a6 ]---

This implies that the permanent transaction reservation ended up
larger than the log itself:

$ sudo xfs_info /mnt/scratch/
[sudo] password for dave: 
meta-data=/dev/vdb               isize=256    agcount=16, agsize=1441792 blks
         =                       sectsz=512   attr=2
data     =                       bsize=512    blocks=23068672, imaxpct=25
         =                       sunit=512    swidth=6144 blks
naming   =version 2              bsize=4096   ascii-ci=0
log      =internal               bsize=512    blocks=2560, version=2
         =                       sectsz=512   sunit=512 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0

Can someone please check that the before/after mkdir transaction
reservation sizes are unchanged for such a configuration?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
