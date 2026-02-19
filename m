Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA262E4263;
	Thu, 19 Feb 2026 06:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771481140; cv=none; b=EbAzdqinYjngNfX5b10sD2Qfv3/nEsSX/6F35Af68hdqe1LVCQhRS5aJWaN24wrtvcIgmJ69Rau9E1g+F1WZ7tIDwSxVj2iY/8tpSf10vVSdJPM8IfP8/HhzkbI78HfzYhngtReafDNnKC9PjYsAmQpRexKhaP71IvSmQxWAyJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771481140; c=relaxed/simple;
	bh=LTlj6+C4Lr06hW+HT2fRw0hO6FIGtaqeC6UpJYN5as8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q6T79BaN26t+y1nB4QAxDHz0cu+L6wJ3/MJVhHURhzvY2rMm9JtcslkUSS5mpvGIgwlfADsjixN1TpjhKg9NMzyTj+GBmyK8tMJjtbqpFmeHBNGQ+33kPgoWnxoWlJ4YnjcQ/XNbFKmX7KeyFs5KXak4JQvp4jYwEi95/v1JFsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=cZL7G4u3; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="cZL7G4u3"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61IHm6M21991245;
	Thu, 19 Feb 2026 06:05:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=dgedBxLak4wXIEWI8
	5Kh46rR+J5E3PwD3hR/KHbP8LE=; b=cZL7G4u3OEKGA5z0cRvr//8otJvvGzfz0
	AvHRf43ehX/2G6dhDwKqgDk7oFUfHgIw83r5JcVm7fEiQcGm0NimCw+KtN/7gc2f
	P6qDdfb1wN3eqH8aaBYMYeM/dWjo0Rywz7DTkmYW1ShMln9wHnnOPfujHCUpPRIB
	xkwBBpZecXuQ2tAcogkDYT8kKQrRZYanpydhmbsL4b/N6eCUo/1qUnBmgjF85x5F
	IS23ZomrZkuEjZfkGzPO+AFg7uUimZLsk9rij4Jyifcjs9qe2lMllnWEeF941yLL
	ybbZbxWqHVoQTRr76SoyziJzMGS6qpgleW9dMPjYqAjVIoaErh0dw==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4caj4kkenv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Feb 2026 06:05:27 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61J3REHM017891;
	Thu, 19 Feb 2026 06:05:27 GMT
Received: from smtprelay04.dal12v.mail.ibm.com ([172.16.1.6])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4ccb28k04u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 19 Feb 2026 06:05:27 +0000
Received: from smtpav05.dal12v.mail.ibm.com (smtpav05.dal12v.mail.ibm.com [10.241.53.104])
	by smtprelay04.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61J65PKV11076172
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Feb 2026 06:05:25 GMT
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CAFFE58056;
	Thu, 19 Feb 2026 06:05:25 +0000 (GMT)
Received: from smtpav05.dal12v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B1D2458052;
	Thu, 19 Feb 2026 06:05:22 +0000 (GMT)
Received: from li-5d80d4cc-2782-11b2-a85c-bed59fe4c9e5.ibm.com.com (unknown [9.124.222.193])
	by smtpav05.dal12v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 19 Feb 2026 06:05:22 +0000 (GMT)
From: "Nirjhar Roy (IBM)" <nirjhar@linux.ibm.com>
To: djwong@kernel.org, hch@infradead.org, cem@kernel.org, david@fromorbit.com
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, ritesh.list@gmail.com,
        ojaswin@linux.ibm.com, nirjhar@linux.ibm.com,
        nirjhar.roy.lists@gmail.com, hsiangkao@linux.alibaba.com
Subject: [RFC v1 1/4] xfs: Re-introduce xg_active_wq field in struct xfs_group
Date: Thu, 19 Feb 2026 11:33:51 +0530
Message-ID: <da5ba9783ebf0641e2edd4229162f5c138e0a3d1.1771418537.git.nirjhar.roy.lists@gmail.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjE5MDA0OSBTYWx0ZWRfX5QcdHpU6hzTG
 012gao62F1OlP2lEaPdT8nCApRrkruIr4TNj/epCSE+dyhDUwH5yq6GPtBYIjjXhwqXT9ovIPsu
 7xy5FNN/SBTSel6hAhZVJJNFzKPbEZzLmeRdRL/+yrtnGZa0ndDL2rKNpPIKeL0ztoFSp6RxS94
 VpuZsV/h8svV9zH8aKD66A58WYGw9Jo7SvNNDuqRKruV0BvlMxwrAwKnKkPXwHYzi/+OwHCWela
 w8fUYtcVmCP3evaFxGlZBqKiCGB0lKjVZvCZA5gIDUluZQydAu8M5ZZ4ZIUCqMemh67oCGWKr4c
 2hWiXb5ByjOBIeU5O02DLg6TEmm+fX0Uq4VfenXZGcJ2EZh7iV1DObRPvcqoS65gxyIJm/iaTK+
 7Rv4inosAvLlnhA8tQkSh4l9zylQyFY+FhwME7KYoghyHle2ZFEQcoxHnXIH8krw97YuGdBcNAE
 Qodjg3qtIuG0f2pa9qg==
X-Proofpoint-ORIG-GUID: Vj5lAhQJ8Mu5Cg29W6Q4Sn-0VtiM2W1F
X-Proofpoint-GUID: Xifwssls32T8yy-kCkFFlwfRaquo2YvG
X-Authority-Analysis: v=2.4 cv=M7hA6iws c=1 sm=1 tr=0 ts=6996a828 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8
 a=KmRw2oSSn3x4R6L4L7QA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-19_01,2026-02-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 malwarescore=0 lowpriorityscore=0 clxscore=1011 phishscore=0
 impostorscore=0 suspectscore=0 priorityscore=1501 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602190049

From: "Nirjhar Roy (IBM)" <nirjhar.roy.lists@gmail.com>

pag_active_wq was removed in
commit 9943b4573290
	("xfs: remove the unused pag_active_wq field in struct xfs_perag")
because it was not waited upon. Re-introducing this in struct xfs_group.
This patch also replaces atomic_dec() in xfs_group_rele() with

if (atomic_dec_and_test(&xg->xg_active_ref))
	wake_up(&xg->xg_active_wq);

The reason for this change is that the online shrink code will wait
for all the active references to come down to zero before actually
starting the shrink process (only if the number of rtextents that
we are trying to remove is worth 1 or more rtgroups).

Signed-off-by: Nirjhar Roy (IBM) <nirjhar.roy.lists@gmail.com>
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_group.c | 4 +++-
 fs/xfs/libxfs/xfs_group.h | 2 ++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_group.c b/fs/xfs/libxfs/xfs_group.c
index 792f76d2e2a0..51ef9dd9d1ed 100644
--- a/fs/xfs/libxfs/xfs_group.c
+++ b/fs/xfs/libxfs/xfs_group.c
@@ -147,7 +147,8 @@ xfs_group_rele(
 	struct xfs_group	*xg)
 {
 	trace_xfs_group_rele(xg, _RET_IP_);
-	atomic_dec(&xg->xg_active_ref);
+	if (atomic_dec_and_test(&xg->xg_active_ref))
+		wake_up(&xg->xg_active_wq);
 }
 
 void
@@ -202,6 +203,7 @@ xfs_group_insert(
 	xfs_defer_drain_init(&xg->xg_intents_drain);
 
 	/* Active ref owned by mount indicates group is online. */
+	init_waitqueue_head(&xg->xg_active_wq);
 	atomic_set(&xg->xg_active_ref, 1);
 
 	error = xa_insert(&mp->m_groups[type].xa, index, xg, GFP_KERNEL);
diff --git a/fs/xfs/libxfs/xfs_group.h b/fs/xfs/libxfs/xfs_group.h
index 4ae638f1c2c5..692cb9266457 100644
--- a/fs/xfs/libxfs/xfs_group.h
+++ b/fs/xfs/libxfs/xfs_group.h
@@ -11,6 +11,8 @@ struct xfs_group {
 	enum xfs_group_type	xg_type;
 	atomic_t		xg_ref;		/* passive reference count */
 	atomic_t		xg_active_ref;	/* active reference count */
+	/* woken up when xg_active_ref falls to zero */
+	wait_queue_head_t	xg_active_wq;
 
 	/* Precalculated geometry info */
 	uint32_t		xg_block_count;	/* max usable gbno */
-- 
2.43.5

