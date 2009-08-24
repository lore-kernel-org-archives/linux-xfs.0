Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7OACEDM116304 for <xfs@oss.sgi.com>; Mon, 24 Aug 2009 05:12:25 -0500
Received: from sovereign.computergmbh.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 507C81B7AABC
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2009 03:13:00 -0700 (PDT)
Received: from sovereign.computergmbh.de (sovereign.computergmbh.de
	[85.214.69.204]) by cuda.sgi.com with ESMTP id Otdsa7G6yoOsHb3y
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2009 03:13:00 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by sovereign.computergmbh.de (Postfix) with ESMTP id DD92E4179336
	for <xfs@oss.sgi.com>; Mon, 24 Aug 2009 12:12:59 +0200 (CEST)
Date: Mon, 24 Aug 2009 12:12:59 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
Subject: xfs_check does not recognize fs truncation
Message-ID: <alpine.LSU.2.00.0908241208520.1028@fbirervta.pbzchgretzou.qr>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Hi,


This I see on xfsprogs-2.10.1 with kernel 2.6.29.6:

# xfs_check /dev/loop0
# echo $?
0
# mount /dev/loop0 /mnt
Filesystem "loop0": Disabling barriers, trial barrier write failed
attempt to access beyond end of device
loop0: rw=0, want=3670016, limit=3649536
I/O error in filesystem ("loop0") meta-data dev loop0 block 0x37ffff
("xfs_read_buf") error 5 buf count 512
XFS: size check 2 failed

The fs is truncated (my fault/intention), but xfs_check returning 0 is 
unexpected.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
