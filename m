Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DDE42D9EE2
	for <linux-xfs@vger.kernel.org>; Fri, 20 Feb 2026 06:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771570547; cv=none; b=kopApE6jr5mBrcrS2FsKmKQnaTz6mWMeKkvYbYQSbzoxvNdIHzcYRkp3K86GVTFdAvvIBxj9u3ENd2RPNkZePlOQuFfjytQvUXDIupWryWefQ1qcvarTVykafB7ZCKFODuivGfmKDkE/iLK35SzykJt1hsmglG1nSiR2LoSmgfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771570547; c=relaxed/simple;
	bh=fd3HeoLGn/dwKPEIRrf/WSXZwudAuZJ20IIAm8j/XAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BTBxamuaiSEL0oJ1He+oBf/Zp0B4PQO5QPyY+m3QfEsEpwrB0+2NB1mF0Fsg7qHeHb54a34DUBppXgTyz7kohPD0+28lSZnt43IE5V/7BQ8mpVXOrgKEZcnc7jPnt/3f4sYcOrLS3sJeHBoMoTdIcJdLwdnoe7X1U2QHyHX+xA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=R6Hf9dEY; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="R6Hf9dEY"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61JLqpe51260041;
	Fri, 20 Feb 2026 06:55:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=frG/423keRGrI8zgC
	abBVceXHSIUe+7p8gJOQkJxSU0=; b=R6Hf9dEY7TIlUayIlwu1xUU+73b5yh1OX
	oihF7/F7exVzQNmbHehNGVKZgSvVxBPTKb2fiChlk3deBEGVAFnHA/GajrJsRMi1
	hgXpvlVC9HtVhpsfLvA7HBZphYJ/sxX76W7b1KPi4zaVlnN7GX83KeenhAGYSAqq
	N/nh2oNr4sPvKoLLqOWvRW+3PVH3uVhohGQMKBQnrNNiKyXaki6r7P28x+OQAWEI
	pCHU5h3eMBu9QdRGx8sLdbenTSg2oIVXJ9PCquXPN888e/3EA/pV8fPYq6g+Y83X
	io5pTpbnJ9FQUA++XF7modiqwAC6DCi76t6lSKpXx/DKl+tJ//0Zw==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4caj6s9smh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 20 Feb 2026 06:55:24 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61K343TO023899;
	Fri, 20 Feb 2026 06:55:23 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ccb45fenk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 20 Feb 2026 06:55:23 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61K6tLgL6292000
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 20 Feb 2026 06:55:21 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C67E3580C9;
	Fri, 20 Feb 2026 06:55:21 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1F0F2580C7;
	Fri, 20 Feb 2026 06:55:19 +0000 (GMT)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com.com (unknown [9.39.30.51])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 20 Feb 2026 06:55:18 +0000 (GMT)
From: "Nirjhar Roy (IBM)" <nirjhar@linux.ibm.com>
To: djwong@kernel.org, hch@infradead.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com,
        nirjhar.roy.lists@gmail.com, nirjhar@linux.ibm.com
Subject: [PATCH v4 1/4] xfs: Fix xfs_last_rt_bmblock()
Date: Fri, 20 Feb 2026 12:23:58 +0530
Message-ID: <4835f9cb9bb51993b4b4dcc5444b0c0e29fe3fd4.1771570164.git.nirjhar.roy.lists@gmail.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1771570164.git.nirjhar.roy.lists@gmail.com>
References: <cover.1771570164.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=dvvWylg4 c=1 sm=1 tr=0 ts=6998055c cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8
 a=H-yo5W6s28MVsVE4pSYA:9
X-Proofpoint-GUID: mLdlg6WTlQpJ_7T-lJSu8FUCSACczpG0
X-Proofpoint-ORIG-GUID: VVx2xzPwdkiSngD3jV35WpS43E0WJirp
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjIwMDA1NyBTYWx0ZWRfX+wMscJgB+XvH
 rv7p3QJbI+egapHxmPorJO5MSm4GG6Upm9nmTrvSeNb+MDUzLKhalVdA2nx+3pUpORc8yr2545A
 mY+ZLtsz8RYypLMCfHwAynhTOx8iyHmB8wlIFOn8CaQL2BgpaHatoAu7GinOl+JURaIm+tbFV+b
 pwiTetmf4ST5luyBNeIZHWh/LKxCZdnIwZZ2ZPWSBygMuuqaOoKHMJD0rMA55X63NrSWsiXT87f
 /EuIoCV2gLtaf1RIXwTdZKgp4i9w5mEZ/CgXRGnrnbRPudlnvPFq3t9dvau1usZuo86B3PopJSo
 N9uLIPHeedsL0DxR2I6FKLwWSiyPhxuaEzfWEQ62edbGJod8p4Gb3eRK7xp9qxFBFe1vIYNhdS5
 HTC9h8M133VjAS8tVeB4ePmAPS5XXM9ZXUl3TMf7jhNh42jBmWzAkfRymcgh/HexTdveyxBF3y2
 yIb/4njOHMttXdASEEg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-19_06,2026-02-20_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 impostorscore=0 adultscore=0
 priorityscore=1501 clxscore=1015 malwarescore=0 phishscore=0 suspectscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602200057

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
	-r size=32769b -f
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
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
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

