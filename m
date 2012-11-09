Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	qA96jot8081772 for <xfs@oss.sgi.com>; Fri, 9 Nov 2012 00:45:50 -0600
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id stuMm8M06BSh8yfF (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 08 Nov 2012 22:47:48 -0800 (PST)
Received: from ucsinet22.oracle.com (ucsinet22.oracle.com [156.151.31.94])
	by aserp1040.oracle.com (Sentrion-MTA-4.2.2/Sentrion-MTA-4.2.2) with
	ESMTP id qA96lki3010637
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Fri, 9 Nov 2012 06:47:47 GMT
Received: from acsmt356.oracle.com (acsmt356.oracle.com [141.146.40.156])
	by ucsinet22.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	qA96lk83006112
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Fri, 9 Nov 2012 06:47:46 GMT
Received: from abhmt114.oracle.com (abhmt114.oracle.com [141.146.116.66])
	by acsmt356.oracle.com (8.12.11.20060308/8.12.11) with ESMTP id
	qA96ljHW027448 for <xfs@oss.sgi.com>; Fri, 9 Nov 2012 00:47:45 -0600
Message-ID: <509CA70D.6000702@oracle.com>
Date: Fri, 09 Nov 2012 14:47:41 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: XFS AG disk layout described on official doc is wrong
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

I observed that there is an issue on our official DOC for AG disk
layout, which can be found at:
http://xfs.org/docs/xfsdocs-xml-dev/XFS_Filesystem_Structure//tmp/en-US/html/Allocation_Groups.html

It shows that the IBT block is followed by the block where AGFL sector
resides.  However, it should be followed by the
CNT block according to my debug, like below:

-------------------------------
superblock
AG free block info
AG inode B+tree info
AG internal free list
-------------------------------
Root of free space B+tree
  B+tree key is block number
-------------------------------
Root of free space B+tree
  B+tree key is block count
--------------------------------
Root of inodes B+tree
--------------------------------

Maybe the DOC is old, or am I missing anything?  If not, can we correct it?


Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
