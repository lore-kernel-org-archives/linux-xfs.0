Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id D01047F51
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 01:37:52 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5E68FAC008
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 23:37:49 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id MuqPCSShpyeEYh11 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 11 Dec 2013 23:37:48 -0800 (PST)
Received: from acsinet21.oracle.com (acsinet21.oracle.com [141.146.126.237])
	by aserp1040.oracle.com (Sentrion-MTA-4.3.1/Sentrion-MTA-4.3.1) with
	ESMTP id rBC7bkXO025773
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 07:37:47 GMT
Received: from aserz7021.oracle.com (aserz7021.oracle.com [141.146.126.230])
	by acsinet21.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rBC7bjBr017823
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 07:37:46 GMT
Received: from abhmp0012.oracle.com (abhmp0012.oracle.com [141.146.116.18])
	by aserz7021.oracle.com (8.14.4+Sun/8.14.4) with ESMTP id
	rBC7bjMA017818 for <xfs@oss.sgi.com>; Thu, 12 Dec 2013 07:37:45 GMT
Message-ID: <52A967C6.1050303@oracle.com>
Date: Thu, 12 Dec 2013 15:37:42 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v2 0/8] xfs: Introduce a common helper to calculate the number
	of blocks per cluster
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

Here is the v2 patch series to introduce a common helper which could be used
to calculate the number of file system blocks in an inode cluster.

v2->v1:
* Rename xfs_ialloc_blks_per_cluster() to xfs_icluster_size_fsb() as per dave's
  suggestion.
* Remove three macros XFS_IALLOC_INODES/XFS_INODE_CLUSTER_SIZE/XFS_IALLOC_BLOCKS
  separately as preparation steps.
* s/ninodes/inodes_per_cluster/g, as the later is more meaningful.
* Remove wrong commit notes I previously written for using xfs_ialloc_blks_per_cluster
  in xfs_imap(). 

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
