Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E5EE1A4E70;
	Thu, 10 Oct 2024 06:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728542195; cv=none; b=I+W8IIiWijHDjyFFsKbkBeRIXWSecMzC8EtzuP+oWweoCdUeAdFPonpHU1ewuZQm8jKkv6aGazfLO4vJSFakYS1WHa//7Al3uTZYyH7H5UxwFOIlgwL8phAFstgP15E1i2rVoHRbb+81+NEZKcEQIZD/Sh9vJec1gRkV4E7zREk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728542195; c=relaxed/simple;
	bh=Z8fQrFMb1nC2PllT4QPZ4bs2pAcDaZjow0DEtkXPWf0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RC5qzjJ9fxUENkJg1vEvWJBgkNRbQXMCclW6HFuVdgaIZDMsKWAGxoDDKIRg8fWTzXZOL99WoXpegiNv9F0n9lShaSkoOy+hsyvaKtoey3BHAKkZcYPvfXji75t28l2IErpCvvFTfYAWVP39xpM7Cula1MK74tFplMANrY/uXWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Nh7c8DBq; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Nh7c8DBq"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49A3pIoG010146;
	Thu, 10 Oct 2024 06:36:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from
	:to:cc:subject:date:message-id:content-transfer-encoding
	:mime-version; s=pp1; bh=GNW3p+7Wz9sS0n4wzd7TtvZAPmM+ukeiwy0LXzh
	ZIjk=; b=Nh7c8DBqoSt8QTan+QntAY49BRCH6ruGLSXjoe/hjnim/0qVba/F/tJ
	q4XxIKxqFsSjNvaji5c1BiqU7v43nQiqe9DaUH6uknxPBgyqo/bpCvTmBMEF20hG
	RWZLfFvENLyr5fK3DobVD7ruMw6h3xOq5480wHsifBHD/LkxPunjZFIzvOSiItsr
	rgq7JIXfP8tfjXN2FgoopC2K7g8Ap5L2yq9twf1z650hrEYtcAT3exh+kRa5V110
	7AnuvEdhmWDPdoje1r8miuJ1Y3tW9pNYLOc0kR8OLpr7Tr6AYOZLxqTX/AuyTf/6
	BjNHwRY/rTiNv2E3uZH6RH3UwsSiREQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4267cmrnqq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 10 Oct 2024 06:36:25 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49A6aOi9015491;
	Thu, 10 Oct 2024 06:36:24 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4267cmrnqk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 10 Oct 2024 06:36:24 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49A5c7LD030253;
	Thu, 10 Oct 2024 06:36:23 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 423gsmx6rk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 10 Oct 2024 06:36:23 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49A6aLEx50528516
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 10 Oct 2024 06:36:21 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 31A6E20043;
	Thu, 10 Oct 2024 06:36:21 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A52D920040;
	Thu, 10 Oct 2024 06:36:19 +0000 (GMT)
Received: from li-bb2b2a4c-3307-11b2-a85c-8fa5c3a69313.ibm.com.com (unknown [9.124.218.86])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 10 Oct 2024 06:36:19 +0000 (GMT)
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: linux-xfs@vger.kernel.org
Cc: Ritesh Harjani <ritesh.list@gmail.com>, linux-kernel@vger.kernel.org,
        "Darrick J . Wong" <djwong@kernel.org>, dchinner@redhat.com,
        Chandan Babu R <chandan.babu@oracle.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH v2] xfs: Check for deallayed allocations before setting extsize
Date: Thu, 10 Oct 2024 12:06:17 +0530
Message-ID: <20241010063617.563365-1-ojaswin@linux.ibm.com>
X-Mailer: git-send-email 2.43.5
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: qidPp17v_4s5F_VQrIWY4jy3t4YuS-Hg
X-Proofpoint-GUID: Q69WZaTvzXS055WeCCu9XuG0bpscRHNI
Content-Transfer-Encoding: 8bit
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-10_03,2024-10-09_02,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 bulkscore=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 priorityscore=1501
 phishscore=0 mlxlogscore=811 mlxscore=0 spamscore=0 suspectscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410100040

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

* Changes since v1 *

 - RVB by Christoph
 - Added a helper to check if inode has data instead of
   open coding.
	
v1:
https://lore.kernel.org/linux-xfs/Zv_cTc6cgxszKGy3@infradead.org/T/#mf949dafb2b2f63bea1f7c0ce5265a2527aaf22a9

 fs/xfs/xfs_inode.c | 2 +-
 fs/xfs/xfs_inode.h | 5 +++++
 fs/xfs/xfs_ioctl.c | 5 +++--
 3 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index bcc277fc0a83..3d083a8fd8ed 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -1409,7 +1409,7 @@ xfs_inactive(
 
 	if (S_ISREG(VFS_I(ip)->i_mode) &&
 	    (ip->i_disk_size != 0 || XFS_ISIZE(ip) != 0 ||
-	     ip->i_df.if_nextents > 0 || ip->i_delayed_blks > 0))
+	     xfs_inode_has_data(ip)))
 		truncate = 1;
 
 	if (xfs_iflags_test(ip, XFS_IQUOTAUNCHECKED)) {
diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
index 97ed912306fd..ae1ccf2a3c8b 100644
--- a/fs/xfs/xfs_inode.h
+++ b/fs/xfs/xfs_inode.h
@@ -292,6 +292,11 @@ static inline bool xfs_is_cow_inode(struct xfs_inode *ip)
 	return xfs_is_reflink_inode(ip) || xfs_is_always_cow_inode(ip);
 }
 
+static inline bool xfs_inode_has_data(struct xfs_inode *ip)
+{
+	return (ip->i_df.if_nextents > 0 || ip->i_delayed_blks > 0);
+}
+
 /*
  * Check if an inode has any data in the COW fork.  This might be often false
  * even for inodes with the reflink flag when there is no pending COW operation.
diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index a20d426ef021..88b9c8cf0272 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -481,7 +481,7 @@ xfs_ioctl_setattr_xflags(
 
 	if (rtflag != XFS_IS_REALTIME_INODE(ip)) {
 		/* Can't change realtime flag if any extents are allocated. */
-		if (ip->i_df.if_nextents || ip->i_delayed_blks)
+		if (xfs_inode_has_data(ip))
 			return -EINVAL;
 
 		/*
@@ -602,7 +602,8 @@ xfs_ioctl_setattr_check_extsize(
 	if (!fa->fsx_valid)
 		return 0;
 
-	if (S_ISREG(VFS_I(ip)->i_mode) && ip->i_df.if_nextents &&
+	if (S_ISREG(VFS_I(ip)->i_mode) &&
+	    xfs_inode_has_data(ip) &&
 	    XFS_FSB_TO_B(mp, ip->i_extsize) != fa->fsx_extsize)
 		return -EINVAL;
 
-- 
2.43.5

