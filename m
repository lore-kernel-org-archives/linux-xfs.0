Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n753xktb213779 for <xfs@oss.sgi.com>; Tue, 4 Aug 2009 22:59:46 -0500
Received: from mail.vpac.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 321623A7162
	for <xfs@oss.sgi.com>; Tue,  4 Aug 2009 21:00:35 -0700 (PDT)
Received: from mail.vpac.org (mail.vpac.org [202.158.218.6]) by cuda.sgi.com
	with ESMTP id VKMYtQD6VXdYrZpH for <xfs@oss.sgi.com>;
	Tue, 04 Aug 2009 21:00:35 -0700 (PDT)
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.vpac.org (Postfix) with ESMTP id 676C846D010F
	for <xfs@oss.sgi.com>; Wed,  5 Aug 2009 14:00:33 +1000 (EST)
Received: from mail.vpac.org ([127.0.0.1])
	by localhost (mail.vpac.org [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id TQIfVqB5630O for <xfs@oss.sgi.com>;
	Wed,  5 Aug 2009 14:00:29 +1000 (EST)
Received: from mail.vpac.org (mail.vpac.org [202.158.218.6])
	by mail.vpac.org (Postfix) with ESMTP id 9705246D010E
	for <xfs@oss.sgi.com>; Wed,  5 Aug 2009 14:00:29 +1000 (EST)
Date: Wed, 5 Aug 2009 14:00:29 +1000 (EST)
From: Chris Samuel <csamuel@vpac.org>
Message-ID: <1367391532.793061249444829356.JavaMail.root@mail.vpac.org>
In-Reply-To: <816101050.793011249444717925.JavaMail.root@mail.vpac.org>
Subject: XFS filesystem shutting down on linux 2.6.28.10 (xfs_rename)
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_68988_1821615652.1249444829354"
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

------=_Part_68988_1821615652.1249444829354
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit

Hi folks,

I believe we've been hitting the same issue that
Gabriel Barazer reported in 2.6.28.9 on the 22nd
of July on our NFS server for our HPC Linux clusters.

Here is the backtrace we got this morning:

Aug  5 11:44:27 stg7 kernel: [680506.864506] Pid: 5271, comm: nfsd Not tainted 2.6.28.10-vpac-1 #1
Aug  5 11:44:27 stg7 kernel: [680506.864508] Call Trace:
Aug  5 11:44:27 stg7 kernel: [680506.864541]  [<ffffffffa032c8d5>] xfs_rename+0x5ac/0x5af [xfs]
Aug  5 11:44:27 stg7 kernel: [680506.864567]  [<ffffffffa032d793>] xfs_trans_cancel+0x56/0xee [xfs]
Aug  5 11:44:27 stg7 kernel: [680506.864589]  [<ffffffffa032c8d5>] xfs_rename+0x5ac/0x5af [xfs]
Aug  5 11:44:27 stg7 kernel: [680506.864609]  [<ffffffffa033b8d0>] xfs_vn_rename+0x61/0x69 [xfs]
Aug  5 11:44:27 stg7 kernel: [680506.864615]  [<ffffffff8029a798>] vfs_rename+0x28a/0x404
Aug  5 11:44:27 stg7 kernel: [680506.864642]  [<ffffffffa045322c>] nfsd_rename+0x2ba/0x35f [nfsd]
Aug  5 11:44:27 stg7 kernel: [680506.864654]  [<ffffffffa045a898>] nfsd3_proc_rename+0x120/0x131 [nfsd]
Aug  5 11:44:27 stg7 kernel: [680506.864681]  [<ffffffffa044f23b>] nfsd_dispatch+0xdd/0x1b9 [nfsd]
Aug  5 11:44:27 stg7 kernel: [680506.864706]  [<ffffffffa03b3cdd>] svc_process+0x3e6/0x70e [sunrpc]
Aug  5 11:44:27 stg7 kernel: [680506.864711]  [<ffffffff8022f9f2>] default_wake_function+0x0/0xe
Aug  5 11:44:27 stg7 kernel: [680506.864717]  [<ffffffff8040dfac>] __down_read+0x15/0x99
Aug  5 11:44:27 stg7 kernel: [680506.864740]  [<ffffffffa044f7d1>] nfsd+0x1a0/0x26c [nfsd]
Aug  5 11:44:27 stg7 kernel: [680506.864750]  [<ffffffffa044f631>] nfsd+0x0/0x26c [nfsd]
Aug  5 11:44:27 stg7 kernel: [680506.864754]  [<ffffffff802470de>] kthread+0x47/0x73
Aug  5 11:44:27 stg7 kernel: [680506.864757]  [<ffffffff80232f9a>] schedule_tail+0x27/0x60
Aug  5 11:44:27 stg7 kernel: [680506.864761]  [<ffffffff8020ccd9>] child_rip+0xa/0x11
Aug  5 11:44:27 stg7 kernel: [680506.864764]  [<ffffffff80247097>] kthread+0x0/0x73
Aug  5 11:44:27 stg7 kernel: [680506.864766]  [<ffffffff8020cccf>] child_rip+0x0/0x11
Aug  5 11:44:27 stg7 kernel: [680506.864770] xfs_force_shutdown(md25,0x8) called from line 1165 of file fs/xfs/xfs
_trans.c.  Return address = 0xffffffffa032d7ac

Here's another backtrace from a week ago (same kernel):

Jul 28 13:27:22 stg7 kernel: [3528649.232700] Pid: 5414, comm: nfsd Not tainted 2.6.28.10-vpac-1 #1
Jul 28 13:27:22 stg7 kernel: [3528649.232702] Call Trace:
Jul 28 13:27:22 stg7 kernel: [3528649.232734]  [<ffffffffa03728d5>] xfs_rename+0x5ac/0x5af [xfs]
Jul 28 13:27:22 stg7 kernel: [3528649.232756]  [<ffffffffa0373793>] xfs_trans_cancel+0x56/0xee [xfs]
Jul 28 13:27:22 stg7 kernel: [3528649.232778]  [<ffffffffa03728d5>] xfs_rename+0x5ac/0x5af [xfs]
Jul 28 13:27:22 stg7 kernel: [3528649.232809]  [<ffffffffa03818d0>] xfs_vn_rename+0x61/0x69 [xfs]
Jul 28 13:27:22 stg7 kernel: [3528649.232814]  [<ffffffff8029a798>] vfs_rename+0x28a/0x404
Jul 28 13:27:22 stg7 kernel: [3528649.232829]  [<ffffffffa03f822c>] nfsd_rename+0x2ba/0x35f [nfsd]
Jul 28 13:27:22 stg7 kernel: [3528649.232855]  [<ffffffffa03ff898>] nfsd3_proc_rename+0x120/0x131 [nfsd]
Jul 28 13:27:22 stg7 kernel: [3528649.232879]  [<ffffffffa03f423b>] nfsd_dispatch+0xdd/0x1b9 [nfsd]
Jul 28 13:27:22 stg7 kernel: [3528649.232902]  [<ffffffffa03abcdd>] svc_process+0x3e6/0x70e [sunrpc]
Jul 28 13:27:22 stg7 kernel: [3528649.232907]  [<ffffffff8022f9f2>] default_wake_function+0x0/0xe
Jul 28 13:27:22 stg7 kernel: [3528649.232912]  [<ffffffff8040dfac>] __down_read+0x15/0x99
Jul 28 13:27:22 stg7 kernel: [3528649.232922]  [<ffffffffa03f47d1>] nfsd+0x1a0/0x26c [nfsd]
Jul 28 13:27:22 stg7 kernel: [3528649.232948]  [<ffffffffa03f4631>] nfsd+0x0/0x26c [nfsd]
Jul 28 13:27:22 stg7 kernel: [3528649.232952]  [<ffffffff802470de>] kthread+0x47/0x73
Jul 28 13:27:22 stg7 kernel: [3528649.232955]  [<ffffffff80232f9a>] schedule_tail+0x27/0x60
Jul 28 13:27:22 stg7 kernel: [3528649.232959]  [<ffffffff8020ccd9>] child_rip+0xa/0x11
Jul 28 13:27:22 stg7 kernel: [3528649.232962]  [<ffffffff80247097>] kthread+0x0/0x73
Jul 28 13:27:22 stg7 kernel: [3528649.232964]  [<ffffffff8020cccf>] child_rip+0x0/0x11
Jul 28 13:27:22 stg7 kernel: [3528649.232967] xfs_force_shutdown(md25,0x8) called from line 1165 of file fs/xfs/xf
s_trans.c.  Return address = 0xffffffffa03737ac

This kernel is built with XFS as a kernel module so I've
been able to attach the objdump output that Eric Sandeen
had originally requested from Gabriel.

Like Gabriel we're stuck on 2.6.28.x as the last working
NFS exporting XFS kernel due to kernel bug #13375 (the
radix bug), so I hope this helps!

cheers,
Chris
-- 
Christopher Samuel - (03) 9925 4751 - Systems Manager
 The Victorian Partnership for Advanced Computing
 P.O. Box 201, Carlton South, VIC 3053, Australia
VPAC is a not-for-profit Registered Research Agency

------=_Part_68988_1821615652.1249444829354
Content-Type: text/plain; name=xfs_objdump.txt
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=xfs_objdump.txt

00000000000452ed <xfs_rename_unlock4>:
   452fc:	e8 00 00 00 00       	callq  45301 <xfs_rename_unlock4+0x14>
   45309:	74 19                	je     45324 <xfs_rename_unlock4+0x37>
   45310:	74 08                	je     4531a <xfs_rename_unlock4+0x2d>
   45315:	e8 00 00 00 00       	callq  4531a <xfs_rename_unlock4+0x2d>
   45322:	75 dd                	jne    45301 <xfs_rename_unlock4+0x14>
0000000000045329 <xfs_rename>:
   4538e:	74 21                	je     453b1 <xfs_rename+0x88>
   45393:	75 1c                	jne    453b1 <xfs_rename+0x88>
   4539a:	74 15                	je     453b1 <xfs_rename+0x88>
   453ab:	0f 87 e6 04 00 00    	ja     45897 <xfs_rename+0x56e>
   453fd:	e8 00 00 00 00       	callq  45402 <xfs_rename+0xd9>
   45466:	e8 00 00 00 00       	callq  4546b <xfs_rename+0x142>
   45474:	75 32                	jne    454a8 <xfs_rename+0x17f>
   45499:	e8 00 00 00 00       	callq  4549e <xfs_rename+0x175>
   454aa:	74 0f                	je     454bb <xfs_rename+0x192>
   454b6:	e9 15 04 00 00       	jmpq   458d0 <xfs_rename+0x5a7>
   454d6:	74 12                	je     454ea <xfs_rename+0x1c1>
   454e5:	e9 e6 03 00 00       	jmpq   458d0 <xfs_rename+0x5a7>
   454f9:	e8 00 00 00 00       	callq  454fe <xfs_rename+0x1d5>
   45507:	74 3f                	je     45548 <xfs_rename+0x21f>
   4551d:	74 29                	je     45548 <xfs_rename+0x21f>
   4552c:	e8 bc fd ff ff       	callq  452ed <xfs_rename_unlock4>
   4553e:	e8 00 00 00 00       	callq  45543 <xfs_rename+0x21a>
   45543:	e9 4f 03 00 00       	jmpq   45897 <xfs_rename+0x56e>
   45560:	e8 00 00 00 00       	callq  45565 <xfs_rename+0x23c>
   4556a:	74 1e                	je     4558a <xfs_rename+0x261>
   45585:	e8 00 00 00 00       	callq  4558a <xfs_rename+0x261>
   455a9:	e8 00 00 00 00       	callq  455ae <xfs_rename+0x285>
   455b1:	74 3a                	je     455ed <xfs_rename+0x2c4>
   455cb:	e8 00 00 00 00       	callq  455d0 <xfs_rename+0x2a7>
   455e2:	0f 85 be 00 00 00    	jne    456a6 <xfs_rename+0x37d>
   455e8:	e9 9b 00 00 00       	jmpq   45688 <xfs_rename+0x35f>
   45601:	e8 00 00 00 00       	callq  45606 <xfs_rename+0x2dd>
   4560a:	0f 85 a0 02 00 00    	jne    458b0 <xfs_rename+0x587>
   4563a:	e8 00 00 00 00       	callq  4563f <xfs_rename+0x316>
   45644:	0f 84 66 02 00 00    	je     458b0 <xfs_rename+0x587>
   4564c:	0f 85 65 02 00 00    	jne    458b7 <xfs_rename+0x58e>
   4565a:	e8 00 00 00 00       	callq  4565f <xfs_rename+0x336>
   45664:	0f 84 bb 00 00 00    	je     45725 <xfs_rename+0x3fc>
   4566d:	0f 84 b2 00 00 00    	je     45725 <xfs_rename+0x3fc>
   4567e:	e8 00 00 00 00       	callq  45683 <xfs_rename+0x35a>
   45683:	e9 93 00 00 00       	jmpq   4571b <xfs_rename+0x3f2>
   4568b:	e8 00 00 00 00       	callq  45690 <xfs_rename+0x367>
   45692:	0f 84 13 02 00 00    	je     458ab <xfs_rename+0x582>
   456a0:	0f 87 05 02 00 00    	ja     458ab <xfs_rename+0x582>
   456d0:	e8 00 00 00 00       	callq  456d5 <xfs_rename+0x3ac>
   456d9:	0f 85 d8 01 00 00    	jne    458b7 <xfs_rename+0x58e>
   456e7:	e8 00 00 00 00       	callq  456ec <xfs_rename+0x3c3>
   456f7:	e8 00 00 00 00       	callq  456fc <xfs_rename+0x3d3>
   45700:	0f 85 b1 01 00 00    	jne    458b7 <xfs_rename+0x58e>
   45709:	74 1a                	je     45725 <xfs_rename+0x3fc>
   45716:	e8 00 00 00 00       	callq  4571b <xfs_rename+0x3f2>
   4571f:	0f 85 92 01 00 00    	jne    458b7 <xfs_rename+0x58e>
   4572d:	74 3e                	je     4576d <xfs_rename+0x444>
   45732:	74 39                	je     4576d <xfs_rename+0x444>
   4575e:	e8 00 00 00 00       	callq  45763 <xfs_rename+0x43a>
   45767:	0f 85 4a 01 00 00    	jne    458b7 <xfs_rename+0x58e>
   45777:	e8 00 00 00 00       	callq  4577c <xfs_rename+0x453>
   4577f:	74 24                	je     457a5 <xfs_rename+0x47c>
   45784:	75 05                	jne    4578b <xfs_rename+0x462>
   45789:	74 1a                	je     457a5 <xfs_rename+0x47c>
   45796:	e8 00 00 00 00       	callq  4579b <xfs_rename+0x472>
   4579f:	0f 85 12 01 00 00    	jne    458b7 <xfs_rename+0x58e>
   457cf:	e8 00 00 00 00       	callq  457d4 <xfs_rename+0x4ab>
   457d8:	0f 85 d9 00 00 00    	jne    458b7 <xfs_rename+0x58e>
   457e6:	e8 00 00 00 00       	callq  457eb <xfs_rename+0x4c2>
   45802:	e8 00 00 00 00       	callq  45807 <xfs_rename+0x4de>
   4580a:	74 1d                	je     45829 <xfs_rename+0x500>
   45824:	e8 00 00 00 00       	callq  45829 <xfs_rename+0x500>
   45839:	74 0c                	je     45847 <xfs_rename+0x51e>
   4585f:	e8 00 00 00 00       	callq  45864 <xfs_rename+0x53b>
   45868:	74 17                	je     45881 <xfs_rename+0x558>
   4586d:	e8 00 00 00 00       	callq  45872 <xfs_rename+0x549>
   4587f:	eb 4f                	jmp    458d0 <xfs_rename+0x5a7>
   45890:	e8 00 00 00 00       	callq  45895 <xfs_rename+0x56c>
   458b5:	eb 05                	jmp    458bc <xfs_rename+0x593>
   458c1:	e8 00 00 00 00       	callq  458c6 <xfs_rename+0x59d>
   458d0:	e8 00 00 00 00       	callq  458d5 <xfs_rename+0x5ac>
   458d5:	eb c0                	jmp    45897 <xfs_rename+0x56e>
   46738:	e9 00 00 00 00       	jmpq   4673d <xfs_trans_cancel>
000000000004673d <xfs_trans_cancel>:
   4674f:	74 0d                	je     4675e <xfs_trans_cancel+0x21>
   46762:	74 48                	je     467ac <xfs_trans_cancel+0x6f>
   4676b:	75 3f                	jne    467ac <xfs_trans_cancel+0x6f>
   4678e:	e8 00 00 00 00       	callq  46793 <xfs_trans_cancel+0x56>
   467a7:	e8 00 00 00 00       	callq  467ac <xfs_trans_cancel+0x6f>
   467c5:	74 06                	je     467cd <xfs_trans_cancel+0x90>
   467d4:	74 13                	je     467e9 <xfs_trans_cancel+0xac>
   467e4:	e8 00 00 00 00       	callq  467e9 <xfs_trans_cancel+0xac>
   46812:	e8 00 00 00 00       	callq  46817 <xfs_trans_cancel+0xda>
   4681a:	e8 00 00 00 00       	callq  4681f <xfs_trans_cancel+0xe2>

------=_Part_68988_1821615652.1249444829354
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs

------=_Part_68988_1821615652.1249444829354--
