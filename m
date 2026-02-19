Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 532DB2BDC16
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 07:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771486830; cv=none; b=q5PFvJZjpGxM0tWg7F62lroewe1yGgV/RmAOCFZhBsucrC82Mg/NdVJjDiCG9DXQ4IU+hIG+eItgLo7djUGOQwxHBxPAJ7c+Nj18Y18CXnPqILm0UcBGxlrx+F6s5unVmmR/v1r08M9uxh5tqEFh+VirqKAzgEHvPM73jV4YRBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771486830; c=relaxed/simple;
	bh=Uqy3smWATZN+Mx00wfjM8OFfjHqpAVvdtyf9tfIIoIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fow9oCHVwzwD6aaCgvxvalUT900qRE09r5e7L6vitsBSI2rsD9FrtOICYlQ3V3Anfgkw1HEj6T6QZazLvgEI2FRbXChy8vL0+LEnJhwVuFV+zw8w7AIXDUDATjwtA41jCMOL0WVW0TLjERcwl1yNi2eD+vK5k799p6mf7/Y+qQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=W3nNkH/P; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="W3nNkH/P"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61J0DLFR256852;
	Thu, 19 Feb 2026 07:40:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=fw3S/ku5kTpUIRs4W
	Hw6akRxobSJeWItV3xnEoKrgug=; b=W3nNkH/Pzx5rkHYGimQQpawlfTtcqWOkE
	0j1lDpADBjeSU0kZF1H49t5ToJSmWyQxtPKJ7l0aamXpUYCe8gKWA73rxuIcoSX2
	Z7g62eo/cPTHM+d2JuWXAETT4nHpKZIWHZUzo7lBfQJQldUeaDgWWB8b3u9Y2LRC
	hzNB05YTlj4cuLeeXgLmd0+R6kDnPZLioLrwHYfIy17XYuJGd6bwIXbq0bnM2vLJ
	LmNnjCK9c2fey1YsNunFxQr+rUGN7HT7h8eXbHxhOS6fYnaOb6xG8Q7zKTmejEkM
	9yDbVF/NppGqIEyRV8Tec9+PFF9tP+Y05BwajRGm4Mc3kYnKFsxMQ==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4caj64bsa6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Feb 2026 07:40:22 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61J3auYS015846;
	Thu, 19 Feb 2026 07:40:21 GMT
Received: from smtprelay03.wdc07v.mail.ibm.com ([172.16.1.70])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ccb45b8hs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Feb 2026 07:40:21 +0000
Received: from smtpav03.dal12v.mail.ibm.com (smtpav03.dal12v.mail.ibm.com [10.241.53.102])
	by smtprelay03.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61J7dxr428901904
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Feb 2026 07:39:59 GMT
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CBD665805A;
	Thu, 19 Feb 2026 07:40:19 +0000 (GMT)
Received: from smtpav03.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 456FD5803F;
	Thu, 19 Feb 2026 07:40:17 +0000 (GMT)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com.com (unknown [9.39.28.60])
	by smtpav03.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 19 Feb 2026 07:40:16 +0000 (GMT)
From: "Nirjhar Roy (IBM)" <nirjhar@linux.ibm.com>
To: djwong@kernel.org, hch@infradead.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com,
        nirjhar.roy.lists@gmail.com, nirjhar@linux.ibm.com
Subject: [PATCH v2 1/4] xfs: Fix xfs_last_rt_bmblock()
Date: Thu, 19 Feb 2026 13:08:49 +0530
Message-ID: <2a4b0a279ef11a43241d478147c6c942730bd640.1771486609.git.nirjhar.roy.lists@gmail.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1771486609.git.nirjhar.roy.lists@gmail.com>
References: <cover.1771486609.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: WsNGqdVvazk_0jCb1P92xfdh93z-n5-d
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE5MDA2OSBTYWx0ZWRfXxZghGRGPW7kC
 oXzokF0RQEY44FFJWgWhmmRTSpjZ+DoWSHAV9wF6cTM4oTmyGvECJuZA6ntrJYgXDuqBFBCs2Ia
 s/i6JrW7cerMn0vpJwI3VlcbItUZn+O6V4FeSbOt+13Uh7YPxFZORUa+T3Uc0NBqip7Bx4NFEYH
 BVqlpSRZUlhx/2Oa4y6GfeVfFlx5tcDvh0MYr7qiV0yNoK8fva8GYkVa3cS/+ChrDO1MibMXrwG
 76oWMKhHoRZKsfz5rl9Q0U5I1ZuX3iX/Ph07AQNOMt0iP9UntdoTa17Zs/PONC8ALdgVLNsBkG2
 F02dyUnHZxdKQQ08mKsYehde24WKowBBbogdZ4VJCMkPNdmjcUX2N8JcPVPp34w2bVhwD5c5V5j
 qJ3P7lW6pbX2nXiN/wR5jEFE67iucbOtNjmGHMKmT3WOwjxqdrDxRKaa1mUhOn2FrTy+SqUDkA+
 2s7hjBJ7SvOXxTIeRMw==
X-Proofpoint-GUID: 95cGmr51Gn11XlbiEBB7LNYYvGMTHlqr
X-Authority-Analysis: v=2.4 cv=U+mfzOru c=1 sm=1 tr=0 ts=6996be66 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=pGLkceISAAAA:8 a=H-yo5W6s28MVsVE4pSYA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-19_02,2026-02-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 bulkscore=0 impostorscore=0 malwarescore=0 spamscore=0
 adultscore=0 phishscore=0 lowpriorityscore=0 priorityscore=1501
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602190069

From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>

Bug description:

If the size of the last rtgroup i.e, the rtg passed to
xfs_last_rt_bmblock() is such that the last rtextent falls in 0th word
offset of a bmblock of the bitmap file tracking this (last) rtgroup,
then in that case xfs_last_rt_bmblock() incorrectly returns the next
bmblock number instead of the current/last used bmblock number.
When xfs_last_rt_bmblock() incorrectly returns the next bmblock,
the loop to grow/modify the bmblocks in xfs_growfs_rtg() doesn't
execute and xfs_growfs basically does a nop in certain cases.

xfs_growfs will do a nop when the new size of the fs will have the same
number of rtgroups i.e, we are only growing the last rtgroup.

Reproduce:
$ mkfs.xfs -m metadir=0 -r rtdev=/dev/loop1 /dev/loop0 \
	-r rgsize=32768b,size=32769b -f
$ mount -o rtdev=/dev/loop1 /dev/loop0 /mnt/scratch
$ xfs_growfs -R $(( 32769 + 1 )) /mnt/scratch
$ xfs_info /mnt/scratch | grep rtextents
$ # We can see that rtextents hasn't changed

Fix:
Fix this by returning the current/last used bmblock when the last
rtgroup size is not a multiple xfs_rtbitmap_rtx_per_rbmblock()
and the next bmblock when the rtgroup size is a multiple of
xfs_rtbitmap_rtx_per_rbmblock() i.e, the existing blocks are
completely used up.
Also, I have renamed xfs_last_rt_bmblock() to
xfs_last_rt_bmblock_to_extend() to signify that this function
returns the bmblock number to extend and NOT always the last used
bmblock number.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
---
 fs/xfs/xfs_rtalloc.c | 30 ++++++++++++++++++++++++------
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index a12ffed12391..a7a0859ed47f 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1079,17 +1079,27 @@ xfs_last_rtgroup_extents(
 }
 
 /*
- * Calculate the last rbmblock currently used.
+ * This will return the bitmap block number (indexed at 0) that will be
+ * extended/modified. There are 2 cases here:
+ * 1. The size of the rtg is such that it is a multiple of
+ *    xfs_rtbitmap_rtx_per_rbmblock() i.e, an integral number of bitmap blocks
+ *    are completely filled up. In this case, we should return
+ *    1 + (the last used bitmap block number).
+ * 2. The size of the rtg is not an multiple of xfs_rtbitmap_rtx_per_rbmblock().
+ *    Here we will return the block number of last used block number. In this
+ *    case, we will modify the last used bitmap block to extend the size of the
+ *    rtgroup.
  *
  * This also deals with the case where there were no rtextents before.
  */
 static xfs_fileoff_t
-xfs_last_rt_bmblock(
+xfs_last_rt_bmblock_to_extend(
 	struct xfs_rtgroup	*rtg)
 {
 	struct xfs_mount	*mp = rtg_mount(rtg);
 	xfs_rgnumber_t		rgno = rtg_rgno(rtg);
 	xfs_fileoff_t		bmbno = 0;
+	unsigned int		mod = 0;
 
 	ASSERT(!mp->m_sb.sb_rgcount || rgno >= mp->m_sb.sb_rgcount - 1);
 
@@ -1097,9 +1107,16 @@ xfs_last_rt_bmblock(
 		xfs_rtxnum_t	nrext = xfs_last_rtgroup_extents(mp);
 
 		/* Also fill up the previous block if not entirely full. */
-		bmbno = xfs_rtbitmap_blockcount_len(mp, nrext);
-		if (xfs_rtx_to_rbmword(mp, nrext) != 0)
-			bmbno--;
+		/* We are doing a -1 to convert it to a 0 based index */
+		bmbno = xfs_rtbitmap_blockcount_len(mp, nrext) - 1;
+		div_u64_rem(nrext, xfs_rtbitmap_rtx_per_rbmblock(mp), &mod);
+		/*
+		 * mod = 0 means that all the current blocks are full. So
+		 * return the next block number to be used for the rtgroup
+		 * growth.
+		 */
+		if (mod == 0)
+			bmbno++;
 	}
 
 	return bmbno;
@@ -1204,7 +1221,8 @@ xfs_growfs_rtg(
 			goto out_rele;
 	}
 
-	for (bmbno = xfs_last_rt_bmblock(rtg); bmbno < bmblocks; bmbno++) {
+	for (bmbno = xfs_last_rt_bmblock_to_extend(rtg); bmbno < bmblocks;
+			bmbno++) {
 		error = xfs_growfs_rt_bmblock(rtg, nrblocks, rextsize, bmbno);
 		if (error)
 			goto out_error;
-- 
2.43.5

