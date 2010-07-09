Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o69N4j1d137438 for <xfs@oss.sgi.com>; Fri, 9 Jul 2010 18:04:45 -0500
Received: from ucsc.edu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id C912ABA2808
	for <xfs@oss.sgi.com>; Fri,  9 Jul 2010 16:13:22 -0700 (PDT)
Received: from ucsc.edu (email-prod-out-1.ucsc.edu [128.114.129.85]) by
	cuda.sgi.com with ESMTP id 6rCS5T8tcAfH7Bw7 for
	<xfs@oss.sgi.com>; Fri, 09 Jul 2010 16:13:22 -0700 (PDT)
Received: from [128.114.125.121] (HELO ucsc.edu)
	by email-prod-out-1.ucsc.edu (CommuniGate Pro SMTP 5.2.13)
	with ESMTPS id 14930414 for xfs@oss.sgi.com;
	Fri, 09 Jul 2010 16:07:37 -0700
Received: from [98.234.26.5] (account ermorris@ucsc.edu HELO [10.0.1.3])
	by email-prod-fe-2.ucsc.edu (CommuniGate Pro SMTP 5.2.13)
	with ESMTPSA id 374271125 for xfs@oss.sgi.com;
	Fri, 09 Jul 2010 16:07:30 -0700
From: Eli Morris <ermorris@ucsc.edu>
Subject: filesystem shrinks after using xfs_repair
Date: Fri, 9 Jul 2010 16:07:29 -0700
Message-Id: <F2D7937E-43FC-47F4-B041-B9C5C2CBCCD4@ucsc.edu>
Mime-Version: 1.0 (Apple Message framework v1081)
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

Hi All,

I've got this problem where if I run xfs_repair, my filesystem shrinks by 11 TB, from a volume size of 62 TB to 51 TB. I can grow the filesystem again with xfs_growfs, but then rerunning xfs_repair shrinks it back down again. The first time this happened was a few days ago and running xfs_repair took about 7 TB of data with it. That is, out of the 11 TB of disk space that vanished, 7 TB had data on it, and 4 TB was empty space. XFS is running on top of an LVM volume. It's on an Intel/Linux system running Centos 5 (2.6.18-128.1.14.el5). Does anyone have an idea on what would cause such a thing and what I might try to keep it from continuing to happen. I could just never run xfs_repair again, but that doesn't seem like a good thing to count on. Major bonus points if anyone has any ideas on how to get my 7 TB of data back also. It must be there somewhere and it would be very bad to lose.

thanks for any help and ideas. I'm just stumped right now.

Eli
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
