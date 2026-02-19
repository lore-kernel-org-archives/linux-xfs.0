Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F0DF2F067E
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 14:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771512479; cv=none; b=VEt6t3WFf0Fr/xGBtlGoDjUV/mIxr4L5R0CcUdH4JoK5QP5cuobtzzA9K6GdnN7eIHgNdH5hUXR2shguGcwVoRUJdp4fXFcodhrwD4K+LnhJrY7d2vpanufoZwNJU7Qy8849ueOud2l83x/LLsdsdLksF/B4Hys1t0lFbz6q0AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771512479; c=relaxed/simple;
	bh=nRDLSuRaHl78xaAjQE7c0NbO6+WjfDWE9T4sil0pw9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fIWZx3abKwpe3U0YZ96ze2uK2kMctuHDr2RA8FT9wVsl+pUsaUgvuL1NSsu0UkYEyHTsVvZdAeN6CAjYM+p5+2edzLYt4avd7T6sEzHddctQavzCVNxavnnr3kbxyfgIgBzZtxiRq36dc9BEeHPT4lKvuZvP1Irh7dycCXF/Jhs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=k97ZDekZ; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="k97ZDekZ"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61J9A1vo1601377;
	Thu, 19 Feb 2026 14:47:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=/9hMktuZ/KylOaoWq
	kPKzCNY2hDc+0/DPusQEZwf/SE=; b=k97ZDekZDRsTZWrbHY8DANerD39+hkfmw
	baPhMeEHBN0R5xkSU8Xj6WLQt26ludcP5LaX/1+SxYVJikwykLIo0j6rCbzDZKBU
	71IsX8ITODY+py7zivN6JUwIfabrMSE+0YINqfnKmCJtW9G1YI4CSkuhUM9Yzmoj
	eGWqaTlkuadLI3I7Qn0rBEvtGxkFyiNJv4z/nMQEa5lzLC3bnHfOUcGfC5qkzwJ0
	2CRxrnf0GAY/MfIR1fuQTc3OBZCPVoB0/FP9YYz6h9Lie404sEm2F9f70hbvjjjT
	KUXoW1Ps6NF0iV/o6aMZ/eNn9Rau5zP+D56X8HyOFBFaLLpl2vjbw==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4cajcr6jxs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Feb 2026 14:47:48 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61JE3JEm017774;
	Thu, 19 Feb 2026 14:47:47 GMT
Received: from smtprelay07.dal12v.mail.ibm.com ([172.16.1.9])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ccb28mhtj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Feb 2026 14:47:47 +0000
Received: from smtpav06.dal12v.mail.ibm.com (smtpav06.dal12v.mail.ibm.com [10.241.53.105])
	by smtprelay07.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61JElkIQ52101544
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Feb 2026 14:47:46 GMT
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3F25558043;
	Thu, 19 Feb 2026 14:47:46 +0000 (GMT)
Received: from smtpav06.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C5B9858059;
	Thu, 19 Feb 2026 14:47:43 +0000 (GMT)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com.com (unknown [9.39.21.217])
	by smtpav06.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 19 Feb 2026 14:47:43 +0000 (GMT)
From: "Nirjhar Roy (IBM)" <nirjhar@linux.ibm.com>
To: djwong@kernel.org, hch@infradead.org, cem@kernel.org
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com, ojaswin@linux.ibm.com,
        nirjhar.roy.lists@gmail.com, nirjhar@linux.ibm.com
Subject: [PATCH v3 2/4] xfs: Add a comment in xfs_log_sb()
Date: Thu, 19 Feb 2026 20:16:48 +0530
Message-ID: <54eccbea06953a46f37c376814a9a85539231a25.1771512159.git.nirjhar.roy.lists@gmail.com>
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
X-Proofpoint-GUID: w88k7a9H77-gRR5t_bCd6E6ei1g8w6EV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE5MDEzNCBTYWx0ZWRfX5mlJBkhyt+Yt
 rwdPJzCg3/epaeKimP0q67VTiRkg+KEzphvJBruUj2Jv8Rt9LmKdebFZKZWOG2JZhNNr5bzDiB5
 +0lBym5JYiQ4v4V78u/ws56cG6hPU+2onKpeyf72tWjdWQW4oek83BOsHqQ+bQ9/1KlYsZOkrlp
 pelMiYzparqWOxE9rim+O/OD8v6YGXDbehFKxjWIRsDJP8BLZStdiVtyWvILrN1sxiKjOpUewzz
 nSpHl53zZASCLlBWjXdxKkVRQUUr6uyFxPmHcekrCGLJHAh2CBL8dEvhHsE/Pnk3R3bQLniqKH+
 sInjEYhVGgMW7uj+Q6ksNk215nObtFXMt9L19zTVL1s4xN9OWWPE9FxC+VKQKn1XT5BjLg8zOs1
 x8Q39c5x9O8VHXjAxL5qfRY2AEyXqtooQwGtHVekr/qzFO3n4PdZK+qW/TO30xulBDPRe51V1/g
 ko2KDGnJr0du6KZDeNQ==
X-Authority-Analysis: v=2.4 cv=UPXQ3Sfy c=1 sm=1 tr=0 ts=69972294 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=pGLkceISAAAA:8 a=McGMf-V2i_Dg8NkQ6AYA:9
X-Proofpoint-ORIG-GUID: OcaxUkZLM0CzLF0_Kr3ecHwefx4h01A8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-19_04,2026-02-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 suspectscore=0 phishscore=0 impostorscore=0 adultscore=0
 bulkscore=0 clxscore=1015 lowpriorityscore=0 priorityscore=1501 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602190134

From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>

Add a comment explaining why the sb_frextents are updated outside the
if (xfs_has_lazycount(mp) check even though it is a lazycounter.
RT groups are supported only in v5 filesystems which always have
lazycounter enabled - so putting it inside the if(xfs_has_lazycount(mp)
check is redundant.

Suggested-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
---
 fs/xfs/libxfs/xfs_sb.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_sb.c b/fs/xfs/libxfs/xfs_sb.c
index 38d16fe1f6d8..47322adb7690 100644
--- a/fs/xfs/libxfs/xfs_sb.c
+++ b/fs/xfs/libxfs/xfs_sb.c
@@ -1347,6 +1347,9 @@ xfs_log_sb(
 	 * feature was introduced.  This counter can go negative due to the way
 	 * we handle nearly-lockless reservations, so we must use the _positive
 	 * variant here to avoid writing out nonsense frextents.
+	 *
+	 * RT groups are only supported on v5 file systems, which always
+	 * have lazy SB counters.
 	 */
 	if (xfs_has_rtgroups(mp) && !xfs_has_zoned(mp)) {
 		mp->m_sb.sb_frextents =
-- 
2.43.5

