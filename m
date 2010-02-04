Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o14B9IJa031753 for <xfs@oss.sgi.com>; Thu, 4 Feb 2010 05:09:19 -0600
Received: from mx2.informatik.uni-tuebingen.de (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5FF1813790FA
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2010 03:10:27 -0800 (PST)
Received: from mx2.informatik.uni-tuebingen.de
	(mx2.Informatik.Uni-Tuebingen.De [134.2.12.9]) by cuda.sgi.com
	with ESMTP id pn2iDz0vRTdrwri1 for <xfs@oss.sgi.com>;
	Thu, 04 Feb 2010 03:10:27 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
	by mx2.informatik.uni-tuebingen.de (Postfix) with ESMTP id 8B5DB345B
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2010 12:10:26 +0100 (MET)
Received: from mx2.informatik.uni-tuebingen.de ([127.0.0.1])
	by localhost (mx2.informatik.uni-tuebingen.de [127.0.0.1]) (amavisd-new,
	port 10024) with ESMTP id SONXO4gZcVjr for <xfs@oss.sgi.com>;
	Thu,  4 Feb 2010 12:10:26 +0100 (MET)
Received: from imap.informatik.uni-tuebingen.de
	(bluff.Informatik.Uni-Tuebingen.De [134.2.9.80])
	by mx2.informatik.uni-tuebingen.de (Postfix) with ESMTP id 5FE173441
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2010 12:10:26 +0100 (MET)
Received: from zcs-bs.informatik.uni-tuebingen.de
	(zcs-bs.Informatik.Uni-Tuebingen.De [134.2.12.62])
	by imap.informatik.uni-tuebingen.de (Postfix) with ESMTP id 4C0AC4CB8
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2010 12:10:26 +0100 (MET)
Received: from zcs-bs.informatik.uni-tuebingen.de
	(zcs-bs.Informatik.Uni-Tuebingen.De [134.2.12.62])
	by zcs-bs.informatik.uni-tuebingen.de (Postfix) with ESMTP id
	6CF4C364E8F
	for <xfs@oss.sgi.com>; Thu,  4 Feb 2010 12:10:26 +0100 (CET)
Date: Thu, 4 Feb 2010 12:10:26 +0100 (CET)
From: Jan Schulze <schulze@informatik.uni-tuebingen.de>
Message-ID: <13543215.8311265281826308.JavaMail.root@zcs-bs.Informatik.Uni-Tuebingen.De>
Subject: re-enabling quota enforcement => invalid argument
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

Hi all,

I have an XFS filesystem with pquota accounting and enforcement. It was working well, but recently I had to disable enforcement for a short time. Now I want to switch it back on, but I get the error "XFS_QUOTAON: Invalid argument".

Does anyone know, what to do? Any suggestions are welcome. Thanks in advance.

[root@coffein raid]# xfs_quota -x -c "state -a" /raid
User quota state on /raid (/dev/sdb1)
  Accounting: OFF
  Enforcement: OFF
  Inode: #18446744073709551615 (0 blocks, 0 extents)
Group quota state on /raid (/dev/sdb1)
  Accounting: OFF
  Enforcement: OFF
  Inode: #259 (24 blocks, 3 extents)
Project quota state on /raid (/dev/sdb1)
  Accounting: ON
  Enforcement: OFF
  Inode: #259 (24 blocks, 3 extents)
Blocks grace time: [7 days 00:00:30]
Inodes grace time: [7 days 00:00:30]
Realtime Blocks grace time: [7 days 00:00:30]

[root@coffein raid]# xfs_quota -x -c "enable -p -v" /raid
XFS_QUOTAON: Invalid argument


Best Regards,
Jan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
