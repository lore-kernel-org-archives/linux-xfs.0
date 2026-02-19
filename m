Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A43A2E62A2;
	Thu, 19 Feb 2026 06:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771481516; cv=none; b=n/y7yv8kFiBl1/HG4+QEHN2rqbtA5h0s4e+WXeaoO+lDlVFPUA79jGptkfLaOZcGlMuI/z75/Nt2TTgEHBNEaPsONWtDc7JooU/9ixXTy3UYKK9Ji62fg9PZhKHfszH57OyMLDzS2yfpfBTgI5b8DIA+GJje3JD7oHzL+NrZCRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771481516; c=relaxed/simple;
	bh=mzBzp8aUnTIm0AhdAqT1KHSErSIafEwfhMtb6OLtIko=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=cFKPcln4FieOAXMGg7mrP/YlFyANUA+Fin/6qoGmNykEQj+MHpOtjJqu/BAEpJ/ciPGCySUzcigRrOdZGrzFc1MMaDtpCYzVLSkQehAH6G+X0FHlzz4v6/43Dez9VpAkrYY8lXRodhtuzRFTBq1dwocEdQhBSwhMBTau1kY5EmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=UvJeENCM; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="UvJeENCM"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61IKCj4w3183117;
	Thu, 19 Feb 2026 06:11:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=dw5JApVPQ6v4H9nKt
	X+CInwce4fHPbvxZNtGCgig44Y=; b=UvJeENCMM4/XozEbnK0OuJvB+xR1o3AhF
	phwUxQJUb6NQi82VtKUhxn4ZKMUbdMDKR6BjbcMyDAjX6Sa2/cbxM92D7piAm0sA
	z+aYDPM+FYGNASa2XCtRfhcHI349ox5Id5PsirlEP34ABk1MVJ4MDTJwRAIGPTpW
	nHzmYCToOZZIbc2FSCiJBHpXt9209Rj4Ru9JUk7U35tbuuyuxymq//mT4HXpJCqt
	zq2bsMNoBqA/xmkXVCI5gFB9CiKhKR90EiKacDXE4ji+Ng0NKkAXqI1FPK7mfK6O
	bSGehgnOUC8hZccxIsBHeN7fvxk09dUIi+u0py/O6FqM0LQtGT6VA==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4caj6uvpn9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Feb 2026 06:11:44 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61J3PI5m030217;
	Thu, 19 Feb 2026 06:11:43 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ccb45b035-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Feb 2026 06:11:43 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61J6BfJD9503328
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Feb 2026 06:11:41 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8BDBC5805C;
	Thu, 19 Feb 2026 06:11:41 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1F6A458059;
	Thu, 19 Feb 2026 06:11:38 +0000 (GMT)
Received: from citest-1.. (unknown [9.124.222.193])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 19 Feb 2026 06:11:37 +0000 (GMT)
From: "Nirjhar Roy (IBM)" <nirjhar@linux.ibm.com>
To: djwong@kernel.org, hch@infradead.org, cem@kernel.org, david@fromorbit.com,
        zlang@kernel.org
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, ritesh.list@gmail.com,
        ojaswin@linux.ibm.com, nirjhar@linux.ibm.com,
        nirjhar.roy.lists@gmail.com, hsiangkao@linux.alibaba.com
Subject: [PATCH v1 2/7] xfs: Introduce helpers to count the number of bitmap and summary inodes
Date: Thu, 19 Feb 2026 06:10:50 +0000
Message-Id: <bca3cf4a5659d2b6cba335ff49ccb619fb3ba290.1771425357.git.nirjhar.roy.lists@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1771425357.git.nirjhar.roy.lists@gmail.com>
References: <cover.1771425357.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=E+/AZKdl c=1 sm=1 tr=0 ts=6996a9a0 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=pGLkceISAAAA:8 a=NkK74HL60EAE9lsErwIA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE5MDA1NCBTYWx0ZWRfX05JXPyDMIK5V
 dx1KEJkI8ZQ5M8EiEnBFofHvhb0tFpsGP4EX9RPpTyfOC7isJ4s6+LjtMo411WVpAn2YY/LERGy
 QXhICudWPGwQ2wPODy9y8y7YKNoE6I+1EX35fqwX0WylsCrX8y7Fu9fgfKmGz5q+RRk+uCPsMCx
 P4FfRz7Er17ok5G7bYXyq6rFjZjjJ5lkj+YPAKRWsBiATpwGJb6gEYiBGL7Gy/CkRnRfZruNt0i
 GY1m+6HvYGkTH2ErO7mf7ZORGNdTCgYdAAqVsqM+e+oQ/prg06rmc43tk6+BbTtt0GFU7usjzC2
 M8mMDZATsHcdsxVeRLea3ej94igvN3iHo/xycXom107uAVNhkP6p/dsWPZEWKCDV+HSqBx3gURi
 2E3eBQ8547W7KHTPYT/cRr9nW81Byiijn3A/b5egzQtD3oCsnvBPPiO5zqKPD+kHHce7oLWDd3n
 HqeDNlbF8RESfR4O7Vw==
X-Proofpoint-ORIG-GUID: Orp2Ie5aPuBOlUmKcbIHLd4YurrG6C7L
X-Proofpoint-GUID: uSphhdU5rcAzxRMDJ2ku2yUO8hMt2QBo
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-19_01,2026-02-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 phishscore=0 bulkscore=0
 suspectscore=0 spamscore=0 clxscore=1015 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602190054

From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>

With -metadir=1, we need some helpers that will count the number of
bitmap and summary inodes for realtime XFS. This will be used in
the tests for upcoming patches.

Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
---
 common/xfs | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/common/xfs b/common/xfs
index 8e4425b4..87839265 100644
--- a/common/xfs
+++ b/common/xfs
@@ -1375,6 +1375,18 @@ _require_no_xfs_always_cow()
 	fi
 }
 
+# Counts number of bitmap files present in the metadata directory
+_scratch_xfs_get_rt_bitmap_count()
+{
+	_scratch_xfs_db -r -c "ls -m /rtgroups" | grep "\.bitmap" | wc -l
+}
+
+# Counts number of summary files present in the metadata directory
+_scratch_xfs_get_rt_summary_count()
+{
+	_scratch_xfs_db -r -c "ls -m /rtgroups" | grep "\.summary" | wc -l
+}
+
 # Get a metadata field
 # The first arg is the field name
 # The rest of the arguments are xfs_db commands to find the metadata.
-- 
2.34.1

