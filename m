Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB0BC3B8BA5;
	Mon,  8 Jun 2026 10:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780914231; cv=none; b=nfqZnwGJq5Qbtvd2inHrI98V+BM+6cU6E7TLq2LXAtD5q2xcwLncY8hpg+V8007WXxstA/nCykD2SMoHSL75unl7eZYUn8V5J0ZIid5Q7buHE4gKhptDDCJyieF98KN5a5WGLMA16qFfo7DpiWTgx2MsH/RuXHHDM3wKfhmW+Is=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780914231; c=relaxed/simple;
	bh=yFroTsxMoyGyLVbYUE4ZAISy4tR84QoNnQ6Pd2QnGiY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=PDQpYTGJuZPXNIp1tjkkmWyA5EJvFEhqMX5nbZ+HdJzrLIy4b2+TUPE7lBMbwHilOPwTK7tggcpd4Te28KmRJIToUyuQZVUclCSsiFKPnaD2kiIJkj3znJfZ0/hPFD8l56U9ACrXwWawVghPKF1SMZ1F9KiaUYGX4oqOwEH/ioM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=MNxAD268; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="MNxAD268"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 657JF1CO3711216;
	Mon, 8 Jun 2026 10:23:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=Xh9qce66+IJFbnXRatQkRCySdWtsqLisqhjzMZqwu
	PY=; b=MNxAD268UqhJiTkpGM9EmxBCgIyzkO6x4sYrIcLTHT+9/ZpdQAYD49W+Z
	JZCgnVqCocXpBlN9xY8LlcFpEqV4mOCSmWSoQhdKHYyXzKcw6wBXIaSyxDULUF0A
	VuSc4gNdzHS/Tk+l0xOv5EGfg6mfrPNayF2g8eMwxof0QjX3ykwVywtCoaJE4PYV
	64uRs3qhPLlFjZyuAwp2FweJXtTYC3heg7Hlk2L7UJcNVx3C0z1VRCvL9o3CWjSt
	GtHFmQH2bcIIKqLLRXfC/e4/7Q5rEoo1DZq/GSJHSprD3G/GZoGR2GMHSEIjQGdh
	cK7r9yKyPOSpsMiRkZwpg7bkrkMFQ==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4emb23psut-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 08 Jun 2026 10:23:48 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 658AJdNp009127;
	Mon, 8 Jun 2026 10:23:47 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4emx8vvy90-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 08 Jun 2026 10:23:47 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 658ANhpe57344426
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 8 Jun 2026 10:23:43 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 89A3E2004E;
	Mon,  8 Jun 2026 10:23:43 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 86C4F20040;
	Mon,  8 Jun 2026 10:23:41 +0000 (GMT)
Received: from localhost.localdomain (unknown [9.39.26.125])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon,  8 Jun 2026 10:23:41 +0000 (GMT)
From: Disha Goel <disgoel@linux.ibm.com>
To: fstests@vger.kernel.org
Cc: linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, ritesh.list@gmail.com,
        ojaswin@linux.ibm.com, djwong@kernel.org,
        Disha Goel <disgoel@linux.ibm.com>
Subject: [PATCH v3] common/defrag: skip defrag tests on DAX-enabled filesystems
Date: Mon,  8 Jun 2026 15:53:28 +0530
Message-ID: <20260608102328.40916-1-disgoel@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=b4uCJNGx c=1 sm=1 tr=0 ts=6a269834 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8
 a=2rdxVvfoxuaEPwCrBBkA:9
X-Proofpoint-ORIG-GUID: 4ii1CnxzA8vtLckAbLZqJ8d3HSKTa5kJ
X-Proofpoint-GUID: TgcKqz0t2BK30RAAgJdOw7s3tf1xfPZp
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA4MDA5NCBTYWx0ZWRfX2JZd5nHWfkUk
 73DfNB+TciWzhL1XiPE4LYhvmGFbllidhKgz6iVy6Ias2eHaMmrdEozSCsj1ha5GfgG5zagX0OI
 W6Y6xXQFQlVXhh4pL5gxQXXgNPPJaZcBqAX06cbvsp6VSZCuqo0eQAM6ZyaebBwCYDDtKNkrCA6
 Iu+QCO5TBfMj2DkksF5jHseQX/83pS0uLWFi27JU2uZvhXyLcd4Twgb7EIrIbqF9v+37ju37pE+
 ehhQk8FC6M3P9FMop/sWx/U3AbuoN5W88vezBahWzCit0EZ1IN+fiILZly8624i7vqtLUI5Ezzq
 RUpDfk2ZPcZltzqOICrDkQiy2s0mz8a0FMfEkr1uq+0bJNL8SkJrrn+n3nlKUTmZsOhgn1k8ANF
 CvoRTvIz7im8tQ6ZejZ1lU498TOIrYLm5XOtMdvLsswO3p1Gs4Q0k4ZnC4lQxljzOw0slE+s7vd
 6roo+OLScZiD4rtZ7Kw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-08_02,2026-06-05_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 bulkscore=0 phishscore=0 priorityscore=1501
 lowpriorityscore=0 adultscore=0 malwarescore=0 impostorscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605210000 definitions=main-2606080094

Online defragmentation is not supported on ext4 DAX-enabled filesystems.
The ext4 defrag ioctl (EXT4_IOC_MOVE_EXT) returns EOPNOTSUPP when used
on DAX files.

Add an ext4-specific check in _require_defrag() to skip tests when DAX
is enabled, avoiding false failures on ext4/301-304, ext4/308, and
generic/018.

XFS defrag works with DAX, so this check is ext4-specific.

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Disha Goel <disgoel@linux.ibm.com>
Reviewed-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
Changes in v3:
- Move the DAX check inside the ext4 case statement as
  suggested by Darrick

 common/defrag | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/common/defrag b/common/defrag
index 055d0d0e..baf05d94 100644
--- a/common/defrag
+++ b/common/defrag
@@ -13,6 +13,8 @@ _require_defrag()
         DEFRAG_PROG="$XFS_FSR_PROG"
 	;;
     ext4)
+        __scratch_uses_fsdax && _notrun "ext4 online defrag not supported with DAX"
+
 	testfile="$TEST_DIR/$$-test.defrag"
 	donorfile="$TEST_DIR/$$-donor.defrag"
 	bsize=`_get_block_size $TEST_DIR`
-- 
2.45.1

