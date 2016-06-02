Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1FBD97CA6
	for <xfs@oss.sgi.com>; Thu,  2 Jun 2016 08:23:42 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E6BB8304066
	for <xfs@oss.sgi.com>; Thu,  2 Jun 2016 06:23:38 -0700 (PDT)
Received: from mail-ph.de-nserver.de (mail-ph.de-nserver.de [85.158.179.214])
	by cuda.sgi.com with ESMTP id yugvCOP0DGLA1JGp (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 02 Jun 2016 06:23:33 -0700 (PDT)
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: _xfs_buf_ioapply: no ops on block 0x188e78/0x8 on vanilla 4.4.11
Message-ID: <57503353.2050402@profihost.ag>
Date: Thu, 2 Jun 2016 15:23:31 +0200
MIME-Version: 1.0
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
To: "xfs-masters@oss.sgi.com" <xfs-masters@oss.sgi.com>
Cc: holger@applied-asynchrony.com, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hi,

another issue i'm having with 4.4.11 is the following trace after a reboot:
[  541.661121] XFS (dm-0): _xfs_buf_ioapply: no ops on block 0x188e78/0x8
[  541.662423] ffff88013a3b3000: 44 51 01 01 00 00 00 00 00 00 00 00 00
00 00 00  DQ..............
[  541.663258] ffff88013a3b3010: 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00  ................
[  541.664156] ffff88013a3b3020: 00 00 00 00 00 00 00 00 00 00 00 00 00
0b db fd  ................
[  541.664930] ffff88013a3b3030: 00 00 00 00 00 01 9e 82 00 00 00 00 00
00 00 00  ................
[  541.665704] CPU: 0 PID: 489 Comm: xfsaild/dm-0 Not tainted 4.4.11 #1
[  541.666486] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
BIOS rel-1.8.2-0-g33fbe13 by qemu-project.org 04/01/2014
[  541.667276]  0000000000000000 ffff880037a57c70 ffffffffbe3b3c33
0000000000000001
[  541.668094]  ffff880139d16900 ffff880037a57d18 ffffffffbe31c681
0000000000000000
[  541.668896]  ffff880139d16980 0000000000000000 0000000000000000
0000000000000000
[  541.669705] Call Trace:
[  541.670491]  [<ffffffffbe3b3c33>] dump_stack+0x63/0x90
[  541.671286]  [<ffffffffbe31c681>] _xfs_buf_ioapply+0x3e1/0x440
[  541.672113]  [<ffffffffbe0aaba0>] ? wake_up_q+0x70/0x70
[  541.672901]  [<ffffffffbe31df99>] ? __xfs_buf_delwri_submit+0x179/0x270
[  541.673704]  [<ffffffffbe31dcc4>] xfs_buf_submit+0x64/0x1c0
[  541.674506]  [<ffffffffbe31df99>] __xfs_buf_delwri_submit+0x179/0x270
[  541.675321]  [<ffffffffbe31eea0>] ?
xfs_buf_delwri_submit_nowait+0x20/0x30
[  541.676129]  [<ffffffffbe31eea0>] xfs_buf_delwri_submit_nowait+0x20/0x30
[  541.676930]  [<ffffffffbe3495f6>] xfsaild+0x2a6/0x710
[  541.677738]  [<ffffffffbe349350>] ? xfs_trans_ail_cursor_first+0x90/0x90
[  541.678557]  [<ffffffffbe349350>] ? xfs_trans_ail_cursor_first+0x90/0x90
[  541.679357]  [<ffffffffbe09f36b>] kthread+0xdb/0x100
[  541.680136]  [<ffffffffbe09f290>] ? kthread_park+0x60/0x60
[  541.680912]  [<ffffffffbe6972cf>] ret_from_fork+0x3f/0x70
[  541.681708]  [<ffffffffbe09f290>] ? kthread_park+0x60/0x60

I found a bug report from redhat here
https://bugzilla.redhat.com/show_bug.cgi?id=1234586 pointing to this commit:
xfs: handle dquot buffer readahead in log recovery correctly

which isn't part of 4.4. Is it missing from linux-stable?

i'm using XFS V5 with root quotas on in this case.

Greets,
Stefan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
