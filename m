Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q0EHia41228749 for <xfs@oss.sgi.com>; Sat, 14 Jan 2012 11:44:37 -0600
Received: from sam.nabble.com (sam.nabble.com [216.139.236.26]) by
	cuda.sgi.com with ESMTP id 2zdjLPUi0QBlpJDu for
	<xfs@oss.sgi.com>; Sat, 14 Jan 2012 09:44:35 -0800 (PST)
Received: from isper.nabble.com ([192.168.236.156])
	by sam.nabble.com with esmtp (Exim 4.72)
	(envelope-from <lists@nabble.com>) id 1Rm7ec-0002aO-Vt
	for xfs@oss.sgi.com; Sat, 14 Jan 2012 09:44:34 -0800
Message-ID: <33140169.post@talk.nabble.com>
Date: Sat, 14 Jan 2012 09:44:34 -0800 (PST)
From: MikeJeezy <forums@mgaccess.net>
Subject: Optimal XFS formatting options?
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


Hi, I have a 4.9 TB iSCSI LUN on a RAID 6 array with twelve 2 TB SATA disks
(4.9T is only one of the logical volumes). It will contain several million
files of various sizes, but 80% of them will be less than 50 MB.  I'm a
novice at best and I usually just use the default #mkfs.xfs /dev/sdx1

This is server will be write heavy for about 8 hours a night, but every
morning there are many reads to the disk.  There is rarely a time where it
will be write heavy and read heavy at the same time.  Are there other XFS
format options that I could use to optimize performance?

Any input is greatly appreciated. Thank you.
-- 
View this message in context: http://old.nabble.com/Optimal-XFS-formatting-options--tp33140169p33140169.html
Sent from the Xfs - General mailing list archive at Nabble.com.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
