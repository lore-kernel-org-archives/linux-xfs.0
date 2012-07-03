Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q637t6NQ070086
	for <linux-xfs@oss.sgi.com>; Tue, 3 Jul 2012 02:55:07 -0500
Received: from plane.gmane.org (plane.gmane.org [80.91.229.3]) by cuda.sgi.com
	with ESMTP id d4ULH6smpWFvZHLX (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <linux-xfs@oss.sgi.com>;
	Tue, 03 Jul 2012 00:55:05 -0700 (PDT)
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <sgi-linux-xfs@m.gmane.org>) id 1Slxwt-0002lA-JI
	for linux-xfs@oss.sgi.com; Tue, 03 Jul 2012 09:55:03 +0200
Received: from 44-162.0-85.cust.bluewin.ch ([85.0.162.44])
	by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
	id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Tue, 03 Jul 2012 09:55:03 +0200
Received: from ramonhofer by 44-162.0-85.cust.bluewin.ch with local (Gmexim
	0.1 (Debian)) id 1AlnuQ-0007hv-00
	for <linux-xfs@oss.sgi.com>; Tue, 03 Jul 2012 09:55:03 +0200
From: Ramon Hofer <ramonhofer@bluewin.ch>
Subject: Use whole disk
Date: Tue, 3 Jul 2012 07:50:49 +0000 (UTC)
Message-ID: <jsu88p$t01$1@dough.gmane.org>
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
To: linux-xfs@oss.sgi.com

Hi all

I hope this is the right place to ask this:

I wanted to use a 2 TB disk (as mythtv recordings drive) with the xfs 
filesystem. Until now I had jfs but I wanted to switch it.

Since I have two drives of the same type I formatted the new drive with 
xfs and copied the recordings onto it. Today I saw that I created the 
filesystem over the disk instead of the partition:

~# mkfs.xfs /dev/sdk

These are my two disks:

/dev/sdi1      jfs    1.9T  1.9T  3.9G 100% /mnt/recordings
/dev/sdk       xfs    1.9T  1.9T  3.3G 100% /mnt/recordings_temp

Is it ok to use the disk instead of the partition or why do I have to 
create the filesystem on a partition?


Best regards
Ramon

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
