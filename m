Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B1A9175A6;
	Tue, 15 Oct 2024 09:45:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728985525; cv=none; b=X3qnitJPANgD7h9cuekfaR0o1D2U73AvTA/HRHxGL9r3mQ3JYRd0DDvpbQWfvSyju7fziy+dHeMZaHvL1NhWR6Lb886of17TenDpzaCmAiOxiXcqz+Tkhd9AXnTChp54Sy4g8VEaSmt7Cu0ZDTRx027VdcOC/tbIv86NjQCKkR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728985525; c=relaxed/simple;
	bh=4RiRQQsmWZGqpK1avX+sy+vZrXlZ8QQr9Pdm3Sc/f4U=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=LssEU6RyX411s2kGqHcmpE0YIahaNxBQ0CGj69vRX37ae8Ozzbj927P29CI313oEgTpRk9KrLzAYhRS/hZ8vVL5YiENoS17u+hIW4SN4ydGiztsBtdsQYmEC0K4tUFb/+jHhYiN2tMlUSdfPaA/4Ev1m/vErpJfqcTJ06eQ2Py0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=RtfZVmIL; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="RtfZVmIL"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49F7oHFK030593;
	Tue, 15 Oct 2024 09:45:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=uhZpS/JU1oZO01yQykI99ONMtmmttJgO9HPkR+3N9
	GI=; b=RtfZVmILi8ihdTh7dgWsOUEknlT4FqDwBDTiF8rP1oQJf3lDBEiqxqod9
	yUjNz3GYjk4EUhfcWlh4Liakd4yJEFtZlH4XBazA4mAo7wX5DJlFaCnmPmeT6Z3q
	LLvBAcbkZM4+ICgxMCzG+AVV4UMpfs/w4Ta9+gEuwUThYvDuxqgMbDliLpQS1vab
	tOcVfQ+jGB6FyiLTwriUC90oARrfFFxREJF6R8N27eFH4CmACl9hoRpRfLLsZT6J
	9XPPuJVi4T0z3MFnClzCcLtwxFQirvVJpjfuAz7PomTuFWxogwfBKW7I2eS5SpbQ
	kaIoSPInVESyVJ3JVZSGL88g8Z/1w==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 429mbmrjvv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 09:45:15 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 49F9jE3p012428;
	Tue, 15 Oct 2024 09:45:14 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 429mbmrjvu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 09:45:14 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 49F8snAT005965;
	Tue, 15 Oct 2024 09:45:13 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 428650tqbt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 15 Oct 2024 09:45:13 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 49F9jCEp51249508
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 15 Oct 2024 09:45:12 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 298A620043;
	Tue, 15 Oct 2024 09:45:12 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8004620040;
	Tue, 15 Oct 2024 09:45:10 +0000 (GMT)
Received: from li-bb2b2a4c-3307-11b2-a85c-8fa5c3a69313.in.ibm.com (unknown [9.109.253.82])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 15 Oct 2024 09:45:10 +0000 (GMT)
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: linux-xfs@vger.kernel.org
Cc: Ritesh Harjani <ritesh.list@gmail.com>, linux-kernel@vger.kernel.org,
        "Darrick J . Wong" <djwong@kernel.org>, dchinner@redhat.com,
        Christoph Hellwig <hch@lst.de>, nirjhar@linux.ibm.com,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH v4] xfs: Check for delayed allocations before setting extsize
Date: Tue, 15 Oct 2024 15:15:09 +0530
Message-ID: <20241015094509.678082-1-ojaswin@linux.ibm.com>
X-Mailer: git-send-email 2.43.5
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: -vELbFqQrokLMypRtjR5omUBs_nR7lyK
X-Proofpoint-ORIG-GUID: moJnglwlDK8xmH0SM2g47cSE1nVKrYcC
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
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 mlxlogscore=999 malwarescore=0 suspectscore=0 bulkscore=0 clxscore=1015
 spamscore=0 impostorscore=0 lowpriorityscore=0 mlxscore=0 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2409260000 definitions=main-2410150063

Extsize should only be allowed to be set on files with no data in it.
For this, we check if the files have extents but miss to check if
delayed extents are present. This patch adds that check.

While we are at it, also refactor this check into a helper since
it's used in some other places as well like xfs_inactive() or
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

Fixes: e94af02a9cd7 ("[XFS] fix old xfs_setattr mis-merge from irix; mostly harmless esp if not using xfs rt")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---

Changes since v3:

* Add Fixes tags
* Minor rewording of commit message 

v3:
https://lore.kernel.org/linux-xfs/20241011145427.266614-1-ojaswin@linux.ibm.com/

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

