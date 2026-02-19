Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F06526D4F9
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 14:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771512479; cv=none; b=LKdIWzbs16WVZM/RuK9ZmcP2oqvtSAWZFuwrNII08Aw1QwK3YdqUQaDJHSGAr9T7qz+v0CfG2E2wz9nqaJAdwToHwT+3OL5Fn+Ug39yy7jjSPfWXoAnPLZY6jNF2jOaiS+N6kSJi5wyERfFntSTvep6sgECZ6Veu2ormiuw3u9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771512479; c=relaxed/simple;
	bh=ylqiIvdaZ03xxf+rViPRyg/I0v4U9wQ2tAZ+igE3IvY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YfthQFgaO8iip4FlbEN/IUdU44vd8x96wKQUxOM2dK7ODG6L4MMtO/OxH2gQ0uBeHMGgVk9ngqLO+KdKsR2Pb6ge8T36fMMYXMhDdT3gDMKs3q5ScnXZma09/A8BJkqojiGZKmBymfD3j+E7lY93DSOQWnoVGVSC8zZZwK580k4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=b/XFoWym; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="b/XFoWym"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61J9A1bV1273446;
	Thu, 19 Feb 2026 14:47:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=LnybRLTqa7Guyx0/l
	rdaYnMJZMD8um0EDrtCjWxcG8g=; b=b/XFoWymbAyervCAfrDS+PseKWCHOWNKX
	cW/i4yhP3VdxV6iHk9yf859ceCCSuPARvEpmwb9Wm6dEWVwl+nZE3XTEhtlM84Bl
	7Z+iRs7ALw7mkeLXZiZTpC9cwnRra4Ak3bNmvu3amQterapqgv5JQvI+siuNJDiF
	aMFJ4YjottyC1spXMbf4aSwhFPZIQd6MykQQQ5Q7f3gqe64gb8FpMP2fRetzACqc
	Gzb9Z520sGBwz1VbBZ0DuCxdFkdsvQoh8KNBV0Xyt2NDhIpXo4ZYHWjkgchKppuN
	p22UWbyB+FfgwjCLgOorad6VsZZP8hDjVJthNdRzzRr0v9mqzZ5SQ==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4caj6uxhuw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Feb 2026 14:47:44 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61JE0QRn015715;
	Thu, 19 Feb 2026 14:47:43 GMT
Received: from smtprelay06.wdc07v.mail.ibm.com ([172.16.1.73])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ccb45chuk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Feb 2026 14:47:42 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay06.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61JElfoM21103286
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Feb 2026 14:47:41 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2E12758059;
	Thu, 19 Feb 2026 14:47:41 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BE8DC58043;
	Thu, 19 Feb 2026 14:47:38 +0000 (GMT)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com.com (unknown [9.39.21.217])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 19 Feb 2026 14:47:38 +0000 (GMT)
From: "Nirjhar Roy (IBM)" <nirjhar@linux.ibm.com>
To: djwong@kernel.org, hch@infradead.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com,
        nirjhar.roy.lists@gmail.com, nirjhar@linux.ibm.com
Subject: [PATCH v3 1/4] xfs: Fix xfs_last_rt_bmblock()
Date: Thu, 19 Feb 2026 20:16:47 +0530
Message-ID: <018c051440dc24200a223358b7ec302b88a8fde4.1771512159.git.nirjhar.roy.lists@gmail.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1771512159.git.nirjhar.roy.lists@gmail.com>
References: <cover.1771512159.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=E+/AZKdl c=1 sm=1 tr=0 ts=69972290 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=pGLkceISAAAA:8 a=H-yo5W6s28MVsVE4pSYA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE5MDEzNCBTYWx0ZWRfX1NGMnCGXrcKp
 CvqlFWcrZTL0riqW1cDgnyANQgZK+XGyDOHs4mMTGDqtu8h3M1nGFIEuWeGHsqhMI8ZjdVdTfBL
 GsjKAfE8yMJUhlEBUe2yk6gw9n8CeHm4Si+lFIeSyyw0MEHlNn5v1O7QMsckyX+qgsWV9U7xobY
 /kLpxY7UfyVsuN3Nsxg/9dPxpPQ+ntwQb3oebg1QlbuE2eUmCpSre7647SOzb6g+/6IJyF3r2d+
 gKaYw0UXU5/OAG46s0YyFkQZLHoVsJ2iQMnZ0ue4mtLGCtC3GbNtRNA0KYwtlyfXwK+aQiIpfM7
 n7m1uwUu3R5NPbUjsJIWfQADp+xsv78sWfkrJUcKG+mv7qNu53Nc6MK0fkqAzbZxuw9XJArli4I
 QGt2xsmMV3ATJiwoQDNYijtQt7R95Boz2nAtmxeGx+4x7/b9iu9rrJ0vWXDimIgLWPuVLbSTX4m
 t2P/Gji41gPtU3G0Ybg==
X-Proofpoint-ORIG-GUID: JxInaWlzlKReDGYxMuvgVLxidd-xAFMZ
X-Proofpoint-GUID: kZURmYA13HLwL0X62cIQRhOwU_-NMsjN
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-19_04,2026-02-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 phishscore=0 bulkscore=0
 suspectscore=0 spamscore=0 clxscore=1015 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602190134

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
index 90a94a5b6f7e..decbd07b94fd 100644
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

