Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n4CN21EK102243 for <xfs@oss.sgi.com>; Tue, 12 May 2009 18:02:02 -0500
Received: from web65608.mail.ac4.yahoo.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with SMTP id 6211AF9FBEA
	for <xfs@oss.sgi.com>; Tue, 12 May 2009 16:06:44 -0700 (PDT)
Received: from web65608.mail.ac4.yahoo.com (web65608.mail.ac4.yahoo.com
	[76.13.9.76]) by cuda.sgi.com with SMTP id y8QkJy2CXB7Hlvyr for
	<xfs@oss.sgi.com>; Tue, 12 May 2009 16:06:44 -0700 (PDT)
Message-ID: <283244.29270.qm@web65608.mail.ac4.yahoo.com>
Date: Tue, 12 May 2009 16:02:05 -0700 (PDT)
From: p v <pvlogin@yahoo.com>
Subject: file preallocation without unwritten flag being set
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



Hello,

I need to create large files fast without initializing them - in the past I used these steps -

mkfs -t xfs -f -d unwritten=0 /dev/sda1
mount -t xfs -o noatime /dev/sda1 /hay
touch /hay/foo
xfs_io /hay/foo
xfs_io> resvsp 0 1024g
xfs_io> quit
ls -i /hay/foo
131 /hay/foo
umount /hay
xfs_db -x /dev/sda1
xfs_db> inode 131
xfs_db> write core.size 1099511627776
core.size = 1099511627776
xfs_db> q

But unwritten=0 is failing as unrecognized option now (was it deprecated????) so I tried to clear the unwritten extent flag directly -

xfs_db> a u.bmbt.ptrs[1]
xfs_db> write recs[1].extentflag 0
recs[1].extentflag = 1
xfs_db> 

It just won't change to 0 - any way to do this? Or is there any straightforward way to preallocate a large file and set it's file size without the unwritten flags being turned on?

Thanks

Peter Vajgel



      

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
