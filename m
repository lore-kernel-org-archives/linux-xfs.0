Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 157F67F37
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2016 13:26:18 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CBA4F304032
	for <xfs@oss.sgi.com>; Mon,  4 Jan 2016 11:26:17 -0800 (PST)
Received: from mout.web.de (mout.web.de [212.227.17.12]) by cuda.sgi.com with
	ESMTP id KQIzDIggIjQ4HT1y (version=TLSv1.2
	cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 04 Jan 2016 11:26:13 -0800 (PST)
Received: from saldaea ([134.76.62.130]) by smtp.web.de (mrweb102) with
	ESMTPSA (Nemesis) id 0MDg9K-1aRm9q0Peg-00H4Xp for <xfs@oss.sgi.com>;
	Mon, 04 Jan 2016 20:26:12 +0100
Date: Mon, 4 Jan 2016 20:26:11 +0100
From: Julian Wollrath <jwollrath@web.de>
Subject: Suspend does not work with v4.4-rc8
Message-ID: <20160104202611.5b100540@saldaea>
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
To: xfs@oss.sgi.com

Hi,

suspending (either to RAM or disk) fails with 4.4-rc8 with the
following message while v4.3.3 worked fine:

kernel: Freezing of tasks failed after 20.006 seconds (2 tasks refusing to freeze, wq_bu_busy=0):
kernel: xfsaild/dm-1    S 0000000000014100     0   283      2 0x00000000
kernel:  ffff880213f53e10 ffffffff8180e4c0 ffff880213f05040 0000000000000000
kernel:  0000000000000000 ffff880213f54000 0000000000000000 0000000000000000
kernel:  ffff8800ca389e40 ffff8800ca392000 ffff880213f53ed0 ffffffff814cd8ac
kernel: Call Trace:
kernel:  [<ffffffff814cd8ac>] ? schedule+0x2c/0x70
kernel:  [<ffffffff8125e37d>] ? xfsaild+0x4fd/0x5b0
kernel:  [<ffffffff8125de80>] ? xfs_trans_ail_cursor_first+0x80/0x80
kernel:  [<ffffffff8125de80>] ? xfs_trans_ail_cursor_first+0x80/0x80
kernel:  [<ffffffff8108bd18>] ? kthread+0xb8/0xd0
kernel:  [<ffffffff8108bc60>] ? kthread_worker_fn+0x150/0x150
kernel:  [<ffffffff814d115f>] ? ret_from_fork+0x3f/0x70 
kernel:  [<ffffffff8108bc60>] ? kthread_worker_fn+0x150/0x150
kernel: xfsaild/sda1    S 0000000000014100     0   591      2 0x00000000
kernel:  ffff88021193be10 ffff8802159c4dc0 ffff880213ab9340 0000000000000000
kernel:  0000000000000000 ffff88021193c000 0000000000000000 0000000000000000
kernel:  ffff8800ca2a4240 ffff880214eea000 ffff88021193bed0 ffffffff814cd8ac
kernel: Call Trace:
kernel:  [<ffffffff814cd8ac>] ? schedule+0x2c/0x70
kernel:  [<ffffffff8125e37d>] ? xfsaild+0x4fd/0x5b0
kernel:  [<ffffffff8125de80>] ? xfs_trans_ail_cursor_first+0x80/0x80
kernel:  [<ffffffff8125de80>] ? xfs_trans_ail_cursor_first+0x80/0x80
kernel:  [<ffffffff8108bd18>] ? kthread+0xb8/0xd0
kernel:  [<ffffffff8108bc60>] ? kthread_worker_fn+0x150/0x150
kernel:  [<ffffffff814d115f>] ? ret_from_fork+0x3f/0x70 
kernel:  [<ffffffff8108bc60>] ? kthread_worker_fn+0x150/0x150

Please tell me what more information you need to be able to fix this
issue.

With best regards,
Julian Wollrath

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
