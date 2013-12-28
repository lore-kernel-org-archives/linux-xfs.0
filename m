Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 288297F3F
	for <xfs@oss.sgi.com>; Sat, 28 Dec 2013 05:19:55 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EAB27304051
	for <xfs@oss.sgi.com>; Sat, 28 Dec 2013 03:19:51 -0800 (PST)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id FVuOJMFgXZLTUyyx (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sat, 28 Dec 2013 03:19:47 -0800 (PST)
Received: from ucsinet21.oracle.com (ucsinet21.oracle.com [156.151.31.93])
	by userp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id rBSBJk7U030070
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Sat, 28 Dec 2013 11:19:46 GMT
Received: from aserz7022.oracle.com (aserz7022.oracle.com [141.146.126.231])
	by ucsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rBSBJj5M001492
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Sat, 28 Dec 2013 11:19:46 GMT
Received: from abhmp0017.oracle.com (abhmp0017.oracle.com [141.146.116.23])
	by aserz7022.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rBSBJj4O024859 for <xfs@oss.sgi.com>; Sat, 28 Dec 2013 11:19:45 GMT
Message-ID: <52BEB3CE.5000303@oracle.com>
Date: Sat, 28 Dec 2013 19:19:42 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH 0/10] xfs: xfs_ioc_bulkstat refactoring and consolidation
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
To: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hi Folks,

The parallel quota check is still in progress because I observed performance number
varies greatly, I suspect that is related to the hardward problem of my laptop.

Thus, I have to delay that for a period of time until I can get a reasonable results.
Meantime, there are some patches could be posted for the review which are focus on
code refactoring and consolidations in xfs_ioc_bulkstat() related functions, i.e,
xfs_bulkstat(), xfs_inumbers(), etc...

It mainly implemented per AG bulkstat that we have discussed in parallel quota check
thread, and fix several problems regarding to the error handling for inode btree
operations in xfs_bulkstat() and xfs_inumbers() as per Christoph's suggestion.

Moreover, I introduced another per AG inumber strategy, which can be used to scan
multiple AGs with a new ioctl(2) in the future.


Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
