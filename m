Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F20F13DD50F;
	Wed,  5 Aug 2026 06:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785911387; cv=none; b=cvJm7MSmEezv2bNS6FYwsH1nArTauTB1V2Ph/PfAKnY9d6v3zfK2URLHl+50CmuBvONYNJ+dW3RYGmYevgr/Vv9mBneF/m6Xlg4ghEZqZhZS9WvC4DRNwI7LKj24rDD4czpLFkcEX0zcmSitBXcQg73BtpWk8JklRyXa3JZL2aU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785911387; c=relaxed/simple;
	bh=buyQrNlOM7YAU4cGVkAhmNiAzT2i59GO9B5AYwXgWq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O+6jw6J6MyAiFRRhjZ05y1jQjbT+mxbjeiFUcTQloTT0vlgYwP6YGxew319rveGKe/jWQUvojPqL8FG39icUgH9cAWp9uCsggcGgYleGy/i4Lcw+9IPdm4UtsMGVE8htMSd8+IaKAHVraZOiAjcaa5hPojBKkuQq9JiD/DvDcrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=qkxHJ+K9; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="qkxHJ+K9"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6755lYV53005218;
	Wed, 5 Aug 2026 06:29:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=DN/XoLF4HFzRvm+Qt
	OkdCzd7I9o/ktGE4HbJkuHIwqg=; b=qkxHJ+K9a/qMbPkt5BHIO9hv5+447+B9T
	iIgWF/4sIN6ye2aBxtnZP01wgBx1DG+jWoBWXBwie4NgaxxDTFBce3Ka3mja2VeK
	Jmdq1zd6elU0JK4rgHheh5OWZkENdZH75q4T7nbCkymVAoVnDn/y7sukh4/XA6ZH
	pQUVuu3Hz6Bku5RFTYJtdP8LTG+OzabhADWS5Yz2AeKjGZPJnFKD2bvtJQqJB8I7
	E654CM1VIPLGwVJUntnnhNIVdM+Kzg6BfjVAKPtbHMCbU8qMVD9tAuGxUJjyhUBH
	s4fuDw8kg689Zv6coU/D7iPl610E+Ip+GxGHKwZZwX0WX2prFxv6A==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fs8h51n7c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Aug 2026 06:29:07 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6756QGih028129;
	Wed, 5 Aug 2026 06:29:06 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fsu4qnfg4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Aug 2026 06:29:06 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6756T42F35914236
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 5 Aug 2026 06:29:04 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7844220040;
	Wed,  5 Aug 2026 06:29:04 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EC7A52004D;
	Wed,  5 Aug 2026 06:28:59 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.211.239])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  5 Aug 2026 06:28:59 +0000 (GMT)
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Christian Brauner <brauner@kernel.org>, linux-fsdevel@vger.kernel.org
Cc: "Darrick J . Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ritesh Harjani <ritesh.list@gmail.com>, Zhang Yi <yi.zhang@huawei.com>,
        Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
        Daniel Gomez <da.gomez@kernel.org>,
        Pankaj Raghav <pankaj.raghav@linux.dev>, Theodore Tso <tytso@mit.edu>,
        linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [RFC PATCH v3 08/11] fs: Introduce RWF_NOSERIAL flag to indicate parallel reads/writes
Date: Wed,  5 Aug 2026 11:58:14 +0530
Message-ID: <71903b5bb03b193f2ad2e407f02e6f223802b436.1785908600.git.ojaswin@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1785908600.git.ojaswin@linux.ibm.com>
References: <cover.1785908600.git.ojaswin@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA1MDA0NyBTYWx0ZWRfX2xVTIX8znp3p
 RHuNnf/iWdwNrXAe6GTCGhVQVofE+r95MA+lREbIIdpkfTxuALIxCaPvCIm0HjZtT/4bHD2/Tk0
 WNLZVdDPqYsScuemub/CgMCCp5uCSFY=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA1MDA0NyBTYWx0ZWRfX6eTjDZ7aAnEM
 qy9uZvReT1wDTnHCdm77Nl4oLZzynp7vn3lH4p9fzAIbr3H4UjxkryhG8Hk76GCytuSenZyB56y
 1pFt5WanclxgkW01SyabBmMiBOJODJtvvTmEq3zNYas1ydKEiB9OsAFcqnrkmSkJUOQ6W9aRfLJ
 EfvMaZrkr+OQsYYtol/yixzF+ShmYlw2rquR7fhGXwCzqppZ4J7eVQ/k+RGuZfsukakbpcvXB3d
 ivbna4i+OEOTbNjizhgSB8I536zvfqEUiKtr3T64xs/+Zjmw3KaX/EHh31BcStk3PgGcil8IHHu
 DAxWG/OY0eeMhZyP0vO3tbrnAtnAz+V/bd2mxkO5vxTqGwxn0YNCenEGILeXW/QClxjaQhfND6I
 fmwtSMcPYl8wcjOPnJNMNxIwQUDvDXdTrP6XMbc9uk4Znsn0bVmb+e8iMVfiQIA6P0K+ZxkQNxI
 RHNZLqCQRvt+1vlDR7w==
X-Authority-Analysis: v=2.4 cv=SI1ykuvH c=1 sm=1 tr=0 ts=6a72d833 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8
 a=S1zlp_KtrcgS9WxVI_oA:9
X-Proofpoint-ORIG-GUID: 4VnvKSaig3Wkkcc4-0zH4m0R7qbypOAK
X-Proofpoint-GUID: Y4XoatcJmv_g6eEGocKw_TDUsXyI4E9p
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_02,2026-08-04_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 bulkscore=0 suspectscore=0 impostorscore=0 spamscore=0
 phishscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608050047

Introduce RWF_NOSERIAL flag to indicate that the application is
okay with its reads and writes going in parallel to other read/writes.
This flag will allow writes and read to go in parallel (for eg, under a
shared lock) increasing performance at the cost of losing the (loosely
implemented) POSIX guarantees wrt to R/W serialization that various
filesystems provide.

In this patch we just introduce the flag and in upcoming patches we will
use it to implement parallel writes to increase performance of
RWF_WRITETHROUGH

Co-developed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 include/linux/fs.h      | 10 ++++++++++
 include/uapi/linux/fs.h |  6 +++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index bff09a5f90e8..685ffe8da6ea 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -345,6 +345,7 @@ struct readahead_control;
 #define IOCB_DONTCACHE		(__force int) RWF_DONTCACHE
 #define IOCB_NOSIGNAL		(__force int) RWF_NOSIGNAL
 #define IOCB_WRITETHROUGH	(__force int) RWF_WRITETHROUGH
+#define IOCB_NOSERIAL		(__force int) RWF_NOSERIAL
 
 /* non-RWF related bits - start at 16 */
 #define IOCB_EVENTFD		(1 << 16)
@@ -3475,6 +3476,15 @@ static inline int kiocb_set_rw_flags(struct kiocb *ki, rwf_t flags,
 		if (IS_DAX(ki->ki_filp->f_mapping->host))
 			return -EOPNOTSUPP;
 	}
+
+	/*
+	 * For now we don't allow users to pass the NOSERIAL flag
+	 * TODO: Once the semantics of this flag are finalized we can lift this
+	 * restriction.
+	 */
+	if (flags & IOCB_NOSERIAL)
+		return -EOPNOTSUPP;
+
 	kiocb_flags |= (__force int) (flags & RWF_SUPPORTED);
 	if (flags & RWF_SYNC)
 		kiocb_flags |= IOCB_DSYNC;
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 9c8d91b926a7..cde8c9492da6 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -454,10 +454,14 @@ typedef int __bitwise __kernel_rwf_t;
 /* buffered IO that is asynchronously written through to disk after write */
 #define RWF_WRITETHROUGH	((__force __kernel_rwf_t)0x00000200)
 
+/* buffered IO writes that are non sequential because they use a shared lock */
+#define RWF_NOSERIAL	((__force __kernel_rwf_t)0x00000400)
+
 /* mask of flags supported by the kernel */
 #define RWF_SUPPORTED	(RWF_HIPRI | RWF_DSYNC | RWF_SYNC | RWF_NOWAIT |\
 			 RWF_APPEND | RWF_NOAPPEND | RWF_ATOMIC |\
-			 RWF_DONTCACHE | RWF_NOSIGNAL | RWF_WRITETHROUGH)
+			 RWF_DONTCACHE | RWF_NOSIGNAL | RWF_WRITETHROUGH |\
+			 RWF_NOSERIAL)
 
 #define PROCFS_IOCTL_MAGIC 'f'
 
-- 
2.55.0

