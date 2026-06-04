Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2978D409E1C;
	Thu,  4 Jun 2026 12:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780575820; cv=none; b=dFAuVi5YhaWvl04G0X0bEHHXgmCeXFAe32jHwgO42Eq9xpUOjKJPjOsg5HX1nqSqyX3yhrtRMN2xAGD5dvA0LwaWYJllN4iazdKSr9Gswpi/kCLlvc3bVzW8GvDRUIRFssGgorC4N1nvLZb3cIxygjXfkB+qSBURaVdUcZ+GOpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780575820; c=relaxed/simple;
	bh=UGKmllld54a5i1QRMwJYjBSZWmjHMmQzoBCH8BcCgnA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=arB5mpltkrIXXzghwpEaI0oECcRWHr1nB56G28PVbZOYPZq8ZSqhIDJBTEVa5Mk5PxuYU5c7pesk5vtfRuDl0SERrkfm45gvo2hLcP/LCMJItkTOw612mJnCEvXCGl6yirGmpDlowb/uCAXBd3phlhf72XaxXGwVfHawXHz0ptM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Xc+jRUHH; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Xc+jRUHH"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6548dTAr2915119;
	Thu, 4 Jun 2026 12:23:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=hTBvgFUTQSqBcqIBI9pqWr1z5cOkssZACfLgO46y0
	ug=; b=Xc+jRUHHTEzuw90f6EmsLjBV5zaTzmA8OnlFYoJlj+r1YEpHO8khOZ3R8
	fnW4odRTi6hXpTEYQK4Z8uF8PZyMAgImwyprwryFGHwsptG1b6JvOv1s6iYf5fTt
	c2Haxk0NG7eA9/igwQXSd16gWuRr0WkvjZL8xUY1pqaIcfZtsbep5AB0g5FX542m
	JWx6nir8UjQdO//So2CNP+F2UP/PnSyPXCh4AbIDOlAveRSizhCytCDRzDigAH9H
	M4sHkxGrQfow5bqLuMEoEqk4m+JLbCOAFeyXXGTMi9bVBOblGWeaxXCLhS9tvn83
	BINXuqwE03lObOycYJYRO8F5DCi1w==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4efqd4fsss-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 04 Jun 2026 12:23:36 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 654C96rO030308;
	Thu, 4 Jun 2026 12:23:35 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4egakw52hr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 04 Jun 2026 12:23:35 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 654CNVjE29294962
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 4 Jun 2026 12:23:31 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B8F3020043;
	Thu,  4 Jun 2026 12:23:31 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8F18020040;
	Thu,  4 Jun 2026 12:23:29 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.39.25.21])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  4 Jun 2026 12:23:29 +0000 (GMT)
From: Disha Goel <disgoel@linux.ibm.com>
To: fstests@vger.kernel.org
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, ritesh.list@gmail.com,
        ojaswin@linux.ibm.com, djwong@kernel.org,
        Disha Goel <disgoel@linux.ibm.com>
Subject: [PATCH v2] common/defrag: skip defrag tests on DAX-enabled filesystems
Date: Thu,  4 Jun 2026 17:53:05 +0530
Message-ID: <20260604122305.39805-1-disgoel@linux.ibm.com>
X-Mailer: git-send-email 2.45.1
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA0MDExOCBTYWx0ZWRfX5QNG5Od+Oyfu
 np3ZoKwU91WtLNciZEVNgXP1EbunJ33FK5FrbhJVnqFCT/RECc8VwKaNWdpxKZYFTq7/jqpcdHd
 GOv7kXEl1wvYUdiepzYB3Ewk80OKLEkNQ641ZCRZPyEvFYypgvqCK3LIYz1kIPn+ciblYsyULOL
 2EHgucmgwFQj+B0IGYB1kUP8fWtxt9ElhimmRyNnoEN1MZKsETXvw69PqlEdSEONql7e4FlKm2U
 Tn1i2VGU+Gje+z187gd5pUoXGXtNij5D9zzjJ4UCVoG7vERFKR9MGsaJDHIJADmwzrh8ywFZFY7
 hd6//XqssgFhHlzWIlcE60yo6GwX+/SKQceyvJtk7nH2d2xFF6dYiLyvhhKzRrfK+sW+p+5AtwZ
 DSUXs4A0h75SUFzF0vdb7h1dk5WD+tot85kxrsxWitxMbSuiqcQvJ76lZFsjm+la7cHTkExc8rM
 oekMqSxALANBCV1cTsA==
X-Proofpoint-GUID: ZFxwQG23-mmgqIu5kCHT5BR-wS3A_Sb_
X-Proofpoint-ORIG-GUID: Y4xzZWvaEx0NcgHZSlryMq78ge038jCN
X-Authority-Analysis: v=2.4 cv=DZknbPtW c=1 sm=1 tr=0 ts=6a216e49 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VnNF1IyMAAAA:8 a=2rdxVvfoxuaEPwCrBBkA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-04_03,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 clxscore=1015 suspectscore=0 impostorscore=0 lowpriorityscore=0
 phishscore=0 malwarescore=0 priorityscore=1501 bulkscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606040118

Online defragmentation is not supported on ext4 DAX-enabled filesystems.
The ext4 defrag ioctl (EXT4_IOC_MOVE_EXT) returns EOPNOTSUPP when used
on DAX files.

Add an ext4-specific check in _require_defrag() to skip tests when DAX
is enabled, avoiding false failures on ext4/301-304, ext4/308, and
generic/018.

XFS defrag works with DAX, so this check is ext4-specific.

Signed-off-by: Disha Goel <disgoel@linux.ibm.com>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
Changes in v2:
- Made the check ext4-specific as XFS defrag works with DAX
  (feedback from Darrick)
- Use __scratch_uses_fsdax() instead of grepping MOUNT_OPTIONS
- Removed unnecessary comment as _notrun message is self-explanatory

 common/defrag | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/common/defrag b/common/defrag
index 055d0d0e..f17271cd 100644
--- a/common/defrag
+++ b/common/defrag
@@ -6,6 +6,10 @@
 
 _require_defrag()
 {
+    if [ "$FSTYP" = "ext4" ] && __scratch_uses_fsdax; then
+        _notrun "ext4 online defrag not supported with DAX"
+    fi
+
     case "$FSTYP" in
     xfs)
         # xfs_fsr does preallocates, require "falloc"
-- 
2.45.1

