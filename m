Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AC7D4B8260;
	Mon, 28 Sep 2026 12:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790597044; cv=none; b=Lv85mkLZEP13aBpGBcNlYycyPOJmgwi2N+gv3Y8GkHAPX9U1Sh1SLBlgXC8TxYfc83KCSoWWzL95LsM7VgDBZT2UCaQkU8b8N7+LHoiSHLqMwFVV1ugpdr8rNjFhn9gaZnccYvyYwSShUBZZ4QT6R5a0sMXA6fYdA54awuh/ZCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790597044; c=relaxed/simple;
	bh=W59qrVbm7k4cR5jhTZh/JOnJSdO7tRvTmtmCiPogzDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iwg3qMr6ng0umFjb3x+MP2ApU0NAidjNIMCAlmfpQK1DpnXBzKeaxostMIfkHDgO5n4m1FpJ/QmMcN8NK0yQ4jXIInVx4Lq+yrFKHmUv4fWPiO+XjhXavkAQJ0zHSbx3S/sxp/umvcqeLZVB2p87DUj2W7v1nYyWHJuO1BMaN/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=mRJwI6Mh; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="mRJwI6Mh"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68SBZW223971195;
	Mon, 28 Sep 2026 12:03:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=UPrT8PQRwKFYocNOz
	dGCoruRwlJo+jhllToPk78w6Qw=; b=mRJwI6MhuRRVCv4eYXKFL5hRHURKCG+Vr
	IFkY+2QjfQYbI+nbv7z+YxOjTU8IdKbUrj3jJGZg5857b956vGh5y/a+CTBPXYmQ
	4J1Iq/kq5Cu6SHXdpHtvrO0Z0uuMEMQ4kIUwJAss6BnUSC8AJvCyJa3BZnd/I6sT
	Kqb2JCqrfwmZUPL6dFGKqLkRGIbdj+56q3HsStpruXT1EaAbw25+yHafgFXZ6iWv
	/W0MYBFAsHvEzAlbFDqEPm/BhSEX61vzmBREwCoCXIsjJGp9NpMohPNydjnsQbDz
	Ng5gvqMFQBqT18AEENhjmY2yVgEO/suduQkhitoLbP2QHn+qn6b6w==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gx4fe0v2t-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 28 Sep 2026 12:03:28 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68SBHXdf027129;
	Mon, 28 Sep 2026 12:03:27 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gxrrw5616-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 28 Sep 2026 12:03:27 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68SC3PcF11207118
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Sep 2026 12:03:25 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 98EFE20043;
	Mon, 28 Sep 2026 12:03:25 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id DF67F20040;
	Mon, 28 Sep 2026 12:03:20 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.20.95])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 28 Sep 2026 12:03:20 +0000 (GMT)
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
        linux-mm@kvack.org, Andres Freund <andres@anarazel.de>
Subject: [RFC PATCH v4 01/12] xfs: reexpand iter to original count when upgrading to excl ILOCK
Date: Mon, 28 Sep 2026 17:33:02 +0530
Message-ID: <c11cc6fcf1e4f591b3b537c2146d594f5965487b.1790596383.git.ojaswin@linux.ibm.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <cover.1790596383.git.ojaswin@linux.ibm.com>
References: <cover.1790596383.git.ojaswin@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=FYWiV5+6 c=1 sm=1 tr=0 ts=6aba5790 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VnNF1IyMAAAA:8 a=6jV8uY8xD7bpsU2DslwA:9
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI4MDA0NiBTYWx0ZWRfX28VdEaHGb8Km
 yS5Vi4dq2fW60Z4UnerhNQ6wM56dYgeyxuh2nW755aW1X+8LODUYWTS6AXKVKeKYJAVh+W9lalf
 vFoyTcPvy0yq7EdXJO1sJ5/tmcpn0lQ=
X-Proofpoint-ORIG-GUID: YNVLW5hGbG0aAVPqOH93EEeN_KZYshBc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI4MDA0NiBTYWx0ZWRfX3Fb88wBxXVML
 Ts/ECfXnvbjO6rc3IYYItgYSicJWBiOxZaKU3JPbHpejyP1qEiMtXCL07dU/Af7NLOuwIZq8ZC9
 4uUtX5rMoLH/Mhlo3Dq2dXxlWFszWCIzHnhB76OyVC8Nm1HPCiZ+X+V4UioeBgb+PWq5CuceoKk
 biw2z5GcckxqfalbZy446yR37oBqSKdn4IxfrIKSaQ+EzFPN/5yW9mea6vGiI2IwhOT+dLx9Rhq
 xsWNxk72l14CSK2dRHjwD//fr44xxvSuaSW9EsWeRpugLB8D3rUI2CAT1iT4EMDovAocKlM054M
 khhFSweBArz9Mf45BpuhdSn1XtYqyh2xnNBacP8gEMwTeHG8nAlV9zSZc2qsdXKIR6BhOhtT8wV
 B7sMvXF7m7FYolJ+cE0XJckr9Wo1hzfcHEDw4vySL4laeNhqPWUfRa0hm2FLR7XGy0QCUVu5Gyx
 oN+c7aZLTS0jRnOyOsw==
X-Proofpoint-GUID: z8O8q2NLobKGJbo2TX7Si6d9-UpkKZhC
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-28_03,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 clxscore=1015 impostorscore=0 spamscore=0 phishscore=0
 priorityscore=1501 malwarescore=0 bulkscore=0 lowpriorityscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609280046

In xfs_file_write_checks() when we upgrade to an exclusive lock, we
correctly redo the write checks, but we should also reexpand the iter to
the original count incase it was trimmed. This is because a parallel
truncation/expansion, in the window where inode was unlocked, could have
changed the isize so its good to recalculate limits based on the original
count.

Also, s/count/orig_count/ while we are at it to better indicate its purpose

Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 fs/xfs/xfs_file.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index d8202da15aca..d53a329b6a58 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -450,7 +450,7 @@ xfs_file_write_checks(
 	struct xfs_zone_alloc_ctx *ac)
 {
 	struct inode		*inode = iocb->ki_filp->f_mapping->host;
-	size_t			count = iov_iter_count(from);
+	size_t			orig_count = iov_iter_count(from);
 	bool			drained_dio = false;
 	ssize_t			error;
 
@@ -482,6 +482,7 @@ xfs_file_write_checks(
 			*iolock = 0;
 			return error;
 		}
+		iov_iter_reexpand(from, orig_count);
 		goto restart;
 	}
 
@@ -496,7 +497,7 @@ xfs_file_write_checks(
 	 * the slow path when we are at or beyond the current EOF.
 	 */
 	if (iocb->ki_pos > i_size_read(inode)) {
-		error = xfs_file_write_zero_eof(iocb, from, iolock, count,
+		error = xfs_file_write_zero_eof(iocb, from, iolock, orig_count,
 				&drained_dio, ac);
 		if (error == 1)
 			goto restart;
-- 
2.55.0

