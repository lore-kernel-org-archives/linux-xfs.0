Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE624405FB;
	Fri, 11 Oct 2024 14:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728658484; cv=none; b=nOpV9nuTk0M1HpSV+jtj95NQUEdbRQbXz6O5aPHyB6Jy+otrWIuOccCV+/4a7nv0iYw+UuKMOjJQyTM6yQLAh8FOjDPAHV+Er1V8rS3JV0fIxwVeEvix9UZlzUpvxQVsFxPgXLhVBWYKs6ghIfuEktpJbnIbp4CZPM2b1ARvgIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728658484; c=relaxed/simple;
	bh=HbD+0DZ7uSOon6FsWTus1Wp4ty2aeDZ8yPUIDdFm6ks=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=uk9vI/HcyYT14lLIgeskQRC1UV7fJP08Q1Ri/jEVucfK/Ed6HLH/o2Lua4oQbRzkb+aBsQY72gdvMKKajxStpJwTVio/U071moVkAWRR29BI3rMX0DId+MmzG6sNXb9zNfOvOf0wMI+j77S6DQXxg9mGjqDQrH+GJ81iF+H/4T0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=j2McDrjL; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="j2McDrjL"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49BEp9B2020953;
	Fri, 11 Oct 2024 14:54:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:mime-version
	:content-transfer-encoding; s=pp1; bh=1nW3ns0be370qJXLUWaF0DIVtw
	d5rFgqdUauE+6ZAcw=; b=j2McDrjLUoLwnCBwU/WsOJ5ZK9IwaGLGPZJ95AK48T
	K+hop6quAfE3jEdZIZTlK0temM0NJ/0MluuVCGwhsJFjq8gdI2g4TavQusdwipFT
	XgOwgMP/vhLrkrC0Q58j5FTPI6vTu20MgZmD1CzwGG5OLRElQxQFnMa24ayqYJ4L
	apO/9CpAW7MsFd6eE5CXggeyoQPVkM0IgtJBR3tjNQEd6/Y+2WB+020chiydV1bg
	mtunB7zofclI5AE33Ryu7/sEZFq7/enoJ2aekaphWjy59QCyZL7xJn+zwvaZf0tL
	7Cwa6mCUmNbaufguMMfEzGkberVnyp3hfGooCq2UNYxA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4275gqg8gb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Oct 2024 14:54:35 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49BErXlk026175;
	Fri, 11 Oct 2024 14:54:34 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4275gqg8g2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Oct 2024 14:54:34 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49BE5N0n030152;
	Fri, 11 Oct 2024 14:54:33 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 423gsn6563-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 11 Oct 2024 14:54:33 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49BEsVOQ53281102
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Oct 2024 14:54:31 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 77B1920040;
	Fri, 11 Oct 2024 14:54:31 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 10E1C20043;
	Fri, 11 Oct 2024 14:54:30 +0000 (GMT)
Received: from li-bb2b2a4c-3307-11b2-a85c-8fa5c3a69313.ibm.com.com (unknown [9.124.219.114])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 11 Oct 2024 14:54:29 +0000 (GMT)
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: linux-xfs@vger.kernel.org
Cc: Ritesh Harjani <ritesh.list@gmail.com>, linux-kernel@vger.kernel.org,
        "Darrick J . Wong" <djwong@kernel.org>, dchinner@redhat.com,
        Chandan Babu R <chandan.babu@oracle.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH v3] xfs: Check for delayed allocations before setting extsize
Date: Fri, 11 Oct 2024 20:24:27 +0530
Message-ID: <20241011145427.266614-1-ojaswin@linux.ibm.com>
X-Mailer: git-send-email 2.43.5
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: bPrMwPXMmJBFfcoOwa7l8cDmQG9zqlTz
X-Proofpoint-GUID: cTJ-vbu4Cn0SE4xAfc9NRpNcVd9cWmgY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-11_12,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 spamscore=0
 impostorscore=0 priorityscore=1501 clxscore=1015 suspectscore=0
 lowpriorityscore=0 adultscore=0 mlxscore=0 mlxlogscore=912 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410110100

Extsize is allowed to be set on files with no data in it. For this,
we were checking if the files have extents but missed to check if
delayed extents were present. This patch adds that check.

While we are at it, also refactor this check into a helper since
its used in some other places as well like xfs_inactive() or
xfs_ioctl_setattr_xflags()

**Without the patch (SUCCEEDS)**

$ xfs_io -c 'open -f testfile' -c 'pwrite 0 1024' -c 'extsize 65536'

wrote 1024/1024 bytes at offset 0
1 KiB, 1 ops; 0.0002 sec (4.628 MiB/sec and 4739.3365 ops/sec)

**With the patch (FAILS as expected)**

$ xfs_io -c 'open -f testfile' -c 'pwrite 0 1024' -c 'extsize 65536'

wrote 1024/1024 bytes at offset 0
1 KiB, 1 ops; 0.0002 sec (4.628 MiB/sec and 4739.3365 ops/sec)
xfs_io: FS_IOC_FSSETXATTR testfile: Invalid argument

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 fs/xfs/xfs_inode.c | 2 +-
 fs/xfs/xfs_inode.h | 5 +++++
 fs/xfs/xfs_ioctl.c | 4 ++--
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index bcc277fc0a83..19dcb569a3e7 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1409,7 +1409,7 @@ xfs_inactive(
 
 	if (S_ISREG(VFS_I(ip)->i_mode) &&
 	    (ip->i_disk_size != 0 || XFS_ISIZE(ip) != 0 ||
-	     ip->i_df.if_nextents > 0 || ip->i_delayed_blks > 0))
+	     xfs_inode_has_filedata(ip)))
 		truncate = 1;
 
 	if (xfs_iflags_test(ip, XFS_IQUOTAUNCHECKED)) {
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 97ed912306fd..03944b6c5fba 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -292,6 +292,11 @@ static inline bool xfs_is_cow_inode(struct xfs_inode *ip)
 	return xfs_is_reflink_inode(ip) || xfs_is_always_cow_inode(ip);
 }
 
+static inline bool xfs_inode_has_filedata(const struct xfs_inode *ip)
+{
+	return ip->i_df.if_nextents > 0 || ip->i_delayed_blks > 0;
+}
+
 /*
  * Check if an inode has any data in the COW fork.  This might be often false
  * even for inodes with the reflink flag when there is no pending COW operation.
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index a20d426ef021..2567fd2a0994 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -481,7 +481,7 @@ xfs_ioctl_setattr_xflags(
 
 	if (rtflag != XFS_IS_REALTIME_INODE(ip)) {
 		/* Can't change realtime flag if any extents are allocated. */
-		if (ip->i_df.if_nextents || ip->i_delayed_blks)
+		if (xfs_inode_has_filedata(ip))
 			return -EINVAL;
 
 		/*
@@ -602,7 +602,7 @@ xfs_ioctl_setattr_check_extsize(
 	if (!fa->fsx_valid)
 		return 0;
 
-	if (S_ISREG(VFS_I(ip)->i_mode) && ip->i_df.if_nextents &&
+	if (S_ISREG(VFS_I(ip)->i_mode) && xfs_inode_has_filedata(ip) &&
 	    XFS_FSB_TO_B(mp, ip->i_extsize) != fa->fsx_extsize)
 		return -EINVAL;
 
-- 
2.43.5

