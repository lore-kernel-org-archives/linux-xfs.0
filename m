Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F2EF2E4263;
	Thu, 19 Feb 2026 06:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771481160; cv=none; b=fanbWjKd1KLOzr3TurQsH67/+/y4CPIF1i+sRiUhqf3jD6MbDIEXEb5uKT02HPo/lbc0Nn/kEnkjCJsRt0cgHKZH7OhtKhc5n+N34AVmV9hTKPm3qhyRtO+Eq8ChRDYfxlIIctNfH3LQC/0J9gAz0yzne4MIwlDYPvPHh2gwr9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771481160; c=relaxed/simple;
	bh=T12nJNzpNNo56xNHHOpPNtb91XncNoLPGChFK+ZgOUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ta3RhyRRMitfyH5eX147ZMepUCW2UF08EgREIyP23Isq5bp+maByTd90fNjfS32EvrBqPR2ldIRuvIXHPAR+4ABb+8vbfzJZgry+veyn9VlYAFFqckMF3/1SN5CGw96rqp7bi5D5hzw4xoJ2S69s73YuJr39g42h/jH9U8nGjWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=HXfqDBTz; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="HXfqDBTz"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61INBvM53475047;
	Thu, 19 Feb 2026 06:05:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=QS6oGURR7WPXoplHD
	4qTAKG2d9ebT4ppwSUgPYBFbRQ=; b=HXfqDBTz4Bn+vwUqoOdg3QOdpvNImNVKp
	kzJoCPaUpA71aEqC6rePaIQI0qB4K0GIIdLJmDx8hI2j9PdwDnJZfwM2NG85UjFU
	RaRRRoQq7YN5n41E5QkfI85lxbRV9uQ3R3OhF0nF2Aface2DFS4j0/8v1zK2W7R5
	yg95wkA+du6uTrQDz9QFAHOysvXtm4Re9LfO6jD/6HjCEhu8V8eFi1kgNdWLWU43
	eDqDk4z7m2xzU4rruUNb0D427Xnyjo8LIpS0d2fp2oWoTH7zKdVXvYEr/HdiHVK3
	NoNA3FYb2l2uy/0D0L8JdhoMAuPIxiEoDUH1bNv0hjp/6sQ5QqUWw==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4caj6uvp5a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Feb 2026 06:05:37 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61J3ha9M030187;
	Thu, 19 Feb 2026 06:05:37 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4ccb45ayj7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Feb 2026 06:05:36 +0000
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61J65YsU33751776
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Feb 2026 06:05:35 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9FB075805D;
	Thu, 19 Feb 2026 06:05:34 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 50B2758052;
	Thu, 19 Feb 2026 06:05:31 +0000 (GMT)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com.com (unknown [9.124.222.193])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 19 Feb 2026 06:05:31 +0000 (GMT)
From: "Nirjhar Roy (IBM)" <nirjhar@linux.ibm.com>
To: djwong@kernel.org, hch@infradead.org, cem@kernel.org, david@fromorbit.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, ritesh.list@gmail.com,
        ojaswin@linux.ibm.com, nirjhar@linux.ibm.com,
        nirjhar.roy.lists@gmail.com, hsiangkao@linux.alibaba.com
Subject: [RFC v1 2/4] xfs: Introduce xfs_rtginodes_ensure_all()
Date: Thu, 19 Feb 2026 11:33:52 +0530
Message-ID: <38947e4ca2d01828e7e7033f115770efe6ac9651.1771418537.git.nirjhar.roy.lists@gmail.com>
X-Mailer: git-send-email 2.43.5
In-Reply-To: <cover.1771418537.git.nirjhar.roy.lists@gmail.com>
References: <cover.1771418537.git.nirjhar.roy.lists@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=E+/AZKdl c=1 sm=1 tr=0 ts=6996a832 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=pGLkceISAAAA:8 a=gwPi2OJmvFB6HA2KTooA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE5MDA0OSBTYWx0ZWRfX/iPb47A1qJkc
 aF9O+CfWWA140tRaVUuOxpI155IXIe6h48fnEtSRv8vW/3HGjigIrfUYzuXYvy8piDOxavX4zPb
 tlWTZ++3/NMfgmUyy+Ns79LYGq9zMuxlAC+Rs2Li7ZIKqhX4EWptk6tfC4a+uTPCXJVSLFqj8WR
 BFIMdeyp6EVkhOaEbD8Ct4sN0cRtLea4ysa7dsiCQoWdHR1+gGLJS9t2+puCjjrtNoqMoNXL1qL
 +AKmcqJWZKFvZ5bP6MISHQc5AYmyqncj4j8dCRNLrMHs0GLZPXQjzMi39AOEbE6TwU4H0kpakdJ
 dRxmb60vpdExbF1UktKWnTY1QXHNscBggzh6lqwXZzX+EZ/BmSstqdZ4fbOHFMTtYl4J/CHwyLw
 l0lDARAOletA1Gi9DwX3qfJmZ9Kj4OvoUVw4SQsiU2RyX6jXrSzXbubbOr8fd7vA592mYDxBpNu
 rsC26peCs5V3N9yWNQA==
X-Proofpoint-ORIG-GUID: Bsh9QIC2qG-xL2Tju5KkEs7p9B4gYtFe
X-Proofpoint-GUID: HrHmtNqGTqkouyo_6Qa18HvQkE3R6bcX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-19_01,2026-02-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 priorityscore=1501 malwarescore=0 phishscore=0 bulkscore=0
 suspectscore=0 spamscore=0 clxscore=1011 impostorscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602190049

From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>

This is just a wrapper to load and initialize all the realtime metadata
inodes. This will be used in the later patches for realtime xfs shrink.
No functional changes.

Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
---
 fs/xfs/libxfs/xfs_rtgroup.h |  2 ++
 fs/xfs/xfs_rtalloc.c        | 25 +++++++++++++++++++------
 2 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_rtgroup.h b/fs/xfs/libxfs/xfs_rtgroup.h
index 73cace4d25c7..6cab338007a2 100644
--- a/fs/xfs/libxfs/xfs_rtgroup.h
+++ b/fs/xfs/libxfs/xfs_rtgroup.h
@@ -109,6 +109,8 @@ static inline struct xfs_inode *rtg_refcount(const struct xfs_rtgroup *rtg)
 	return rtg->rtg_inodes[XFS_RTGI_REFCOUNT];
 }
 
+int xfs_rtginodes_ensure_all(struct xfs_rtgroup *rtg);
+
 /* Passive rtgroup references */
 static inline struct xfs_rtgroup *
 xfs_rtgroup_get(
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index d484c0b5bea7..83bebddb9ea8 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1192,18 +1192,15 @@ xfs_growfs_rtg(
 	xfs_extlen_t		bmblocks;
 	xfs_fileoff_t		bmbno;
 	struct xfs_rtgroup	*rtg;
-	unsigned int		i;
 	int			error;
 
 	rtg = xfs_rtgroup_grab(mp, rgno);
 	if (!rtg)
 		return -EINVAL;
 
-	for (i = 0; i < XFS_RTGI_MAX; i++) {
-		error = xfs_rtginode_ensure(rtg, i);
-		if (error)
-			goto out_rele;
-	}
+	error = xfs_rtginodes_ensure_all(rtg);
+	if (error)
+		goto out_rele;
 
 	if (xfs_has_zoned(mp)) {
 		error = xfs_growfs_rt_zoned(rtg, nrblocks);
@@ -1300,6 +1297,22 @@ xfs_growfs_check_rtgeom(
 	return -EINVAL;
 }
 
+int
+xfs_rtginodes_ensure_all(struct xfs_rtgroup *rtg)
+{
+	int	i = 0;
+	int	error = 0;
+
+	ASSERT(rtg);
+
+	for (i = 0; i < XFS_RTGI_MAX; i++) {
+		error = xfs_rtginode_ensure(rtg, i);
+		if (error)
+			break;
+	}
+	return error;
+}
+
 /*
  * Compute the new number of rt groups and ensure that /rtgroups exists.
  *
-- 
2.43.5

