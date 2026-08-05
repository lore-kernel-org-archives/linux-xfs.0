Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E533DD87B;
	Wed,  5 Aug 2026 06:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785911383; cv=none; b=Tt8eA48AICew1TlzkX+bEWaTAHVOMVdblMnjoJkGetee9125njzNqB9g3eoQ7VRCqDw1gZm/pKloCjWmHK4XJ8yTsrHSSo6IEFpAs6kfJ614GVhBXtmjer6/Avj+GuqsoUVGErog/u/yP2ewYwMqZr8tCNb3L6uB9CrA249opoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785911383; c=relaxed/simple;
	bh=v0R4+xsxsKsl1Oq5p/PdWg5SrI9vIKQWgK/dQyVj+k0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AvDdpuj2kt3bg9Th6lc+VK5DaQveWlvWwjAY8ZgwFLfnM0U1e2PxV133xLF5uZ+1mLAV8heTwWEqOWvM9/2km9m/bDgEHOh/w84cttpqvqdgs8idjN32JlPKA+lcxYn49KzXXPhvUN6F6lARpA0E96VlU4yVZSC7y8UhjgwPPfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=X5OUoKqw; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="X5OUoKqw"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6755lYWs3005211;
	Wed, 5 Aug 2026 06:28:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=89Qwln5dUFF/hnghQ
	LFiFdYuy9CZVGKkNR3U5GtxljQ=; b=X5OUoKqwIQdpiceBUc0iSJQCRBpIAf68I
	yGAEk51CgWfQ4f6L72iHrnoBrjDnfVPnDD4X3aziqYWjRX90M3bRb/DOTV6u8k+/
	AZRmDPzpQsrZmszdQWwKN9jxF3I4i3PGDg2zn1pjOLY4i8sEum9v3VCC1AYHaK+W
	swnrujDoFHkqHVZnAr/f2ehQDkgEMEdxdBqEQB/rYP3FhMVQepGSQkk/uWVA5My+
	IkYPZroq2Y2I9ghWPncualTyQgMHuQMEY2FUptn6OLsffYELUNXFo2+JK91Mva1r
	U1K8Y3QahB87y5G5l/4+zztKBmB01Uw3ChgtklURwIj2MqHHbs3JQ==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fs8h51n66-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Aug 2026 06:28:57 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6756QIXO001978;
	Wed, 5 Aug 2026 06:28:56 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fswtyn3b4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Aug 2026 06:28:56 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6756Sshi44630382
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 5 Aug 2026 06:28:54 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3ACF62004D;
	Wed,  5 Aug 2026 06:28:54 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 99B3F20040;
	Wed,  5 Aug 2026 06:28:49 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.211.239])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  5 Aug 2026 06:28:49 +0000 (GMT)
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
Subject: [RFC PATCH v3 06/11] iomap: Add aio support to RWF_WRITETHROUGH
Date: Wed,  5 Aug 2026 11:58:12 +0530
Message-ID: <04cfaa7cf0e704d156f5accf6fb3f44921473612.1785908600.git.ojaswin@linux.ibm.com>
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
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA1MDA0NyBTYWx0ZWRfX7kKh22eMCGH/
 7VCokRaExW58RJNGfgxtfvdVxhbvvqAem17eR+uo+kERSQGgyJooqB717vwRHWan0JbXE0ntGK7
 KIfbKXmLoGV1G5aS1x23HCJtJTbZ52Q=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA1MDA0NyBTYWx0ZWRfX/IcSK8aqzhG6
 W7rW1GbFVNJ4riUWTy1iBxNweCJIxd9CeTeLDlJsDcUP8KGWhwJHw3y36WexGGJsC/SH654LK3x
 QMFaXblZZalBOAzdD4SwfSN4u3e5DMSXbY/7Eaf7fDK1rqNEl5yUpnEU5CedoFAcsTY9Kf2DRRQ
 vKsgA8H0A/nFmUzCJcKyQ6H3ZVpB0+Ln54bQhncPkgjKFsx/fZiD5eek94LGlIQJSQvSZ6YXQHo
 YLME3ByXawmjCW1/QBhs3k0L8IjYW2fapFea/TKhVs2cNZBD1Ktd1GUm0fSv7/rmV4SvRLLNulh
 AGq9YNRKwCqgAp6CV3Ey68D2lvIjuEcK8Hv51mvdrIbtjYtJ4yHlAlwANkNFDXHJU/ckxx6IaCR
 8XD8uDjc4A+MtVWuEFoonff7ttRxy1YGacELe+v1O6fwqxwvrp9LJ49CYG8n155FjQ8UsmYTb4V
 dA2lbJnSPv+OI9yNQ2w==
X-Authority-Analysis: v=2.4 cv=SI1ykuvH c=1 sm=1 tr=0 ts=6a72d829 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8
 a=NGqb3fQY2RvKY4TqIeQA:9
X-Proofpoint-ORIG-GUID: Ds9PeaMLnIiSzO7nln_jjkDhrwwC0XeE
X-Proofpoint-GUID: b90vshZtcTaJfVzD0Lz5KUt3jm1InLyl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_02,2026-08-04_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 bulkscore=0 suspectscore=0 impostorscore=0 spamscore=0
 phishscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 malwarescore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608050047

With aio the only thing we need to be careful of is that writethrough
can be in progress even after dropping inode and folio lock. Due to
this, we need a way to synchronise with other paths where stable write
is not enough, example:

1. Truncate to 0 in xfs sets i_size = 0 before waiting for writeback to
   complete. In case of writethrough, the end io completion can again
   push the i_size to a non-zero value.
2. Dio reads might race with aio writethrough ->end_io() and read 0s if
   unwritten conversion is yet to happen.

Hence use the dio begin/end as it gives us the required guarantees.

Co-developed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 fs/iomap/buffered-io.c | 54 ++++++++++++++++++++++++++++++++++++------
 include/linux/iomap.h  | 11 +++++++--
 2 files changed, 56 insertions(+), 9 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 3178e8c0fa13..22e4252dff4d 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1202,6 +1202,9 @@ static ssize_t iomap_writethrough_complete(struct iomap_writethrough_ctx *wt_ctx
 
 	mapping_dec_inflight_stable_writes(inode->i_mapping);
 
+	if (wt_ctx->is_aio)
+		inode_dio_end(inode);
+
 	if (!ret) {
 		ret = wt_ctx->written;
 		iocb->ki_pos += ret;
@@ -1211,12 +1214,27 @@ static ssize_t iomap_writethrough_complete(struct iomap_writethrough_ctx *wt_ctx
 	return ret;
 }
 
+static void iomap_writethrough_complete_work(struct work_struct *work)
+{
+	struct iomap_writethrough_ctx *wt_ctx =
+		container_of(work, struct iomap_writethrough_ctx, aio_work);
+	struct kiocb *iocb = wt_ctx->iocb;
+
+	iocb->ki_complete(iocb, iomap_writethrough_complete(wt_ctx));
+}
+
 static void iomap_writethrough_done(struct iomap_writethrough_ctx *wt_ctx)
 {
-	struct task_struct *waiter = wt_ctx->waiter;
+	if (!wt_ctx->is_aio) {
+		struct task_struct *waiter = wt_ctx->waiter;
 
-	WRITE_ONCE(wt_ctx->waiter, NULL);
-	blk_wake_io_task(waiter);
+		WRITE_ONCE(wt_ctx->waiter, NULL);
+		blk_wake_io_task(waiter);
+		return;
+	}
+
+	INIT_WORK(&wt_ctx->aio_work, iomap_writethrough_complete_work);
+	queue_work(wt_ctx->inode->i_sb->s_dio_done_wq, &wt_ctx->aio_work);
 }
 
 static void iomap_writethrough_bio_end_io(struct bio *bio)
@@ -1729,9 +1747,6 @@ ssize_t iomap_file_writethrough_write(struct kiocb *iocb, struct iov_iter *i,
 	if (iocb_is_dsync(iocb))
 		/* D_SYNC support not implemented yet */
 		return -EOPNOTSUPP;
-	if (!is_sync_kiocb(iocb))
-		/* aio support not implemented yet */
-		return -EOPNOTSUPP;
 
 	/*
 	 * +1 to max bvecs to account for unaligned write spanning multiple
@@ -1750,11 +1765,33 @@ ssize_t iomap_file_writethrough_write(struct kiocb *iocb, struct iov_iter *i,
 	wt_ctx->end_io = wt_ops->end_io;
 	wt_ctx->old_i_size = i_size_read(inode);
 	wt_ctx->max_bvecs = max_bvecs;
+	wt_ctx->is_aio = !is_sync_kiocb(iocb);
 	atomic_set(&wt_ctx->ref, 1);
-	wt_ctx->waiter = current;
+
+	if (!wt_ctx->is_aio)
+		wt_ctx->waiter = current;
+	else
+		/*
+		 * With aio, writethrough can be in progress even after dropping
+		 * inode and folio lock. Due to this, we need a way to
+		 * synchronise with other paths where stable write is not enough
+		 * (example truncate). Hence use the dio begin/end as it gives
+		 * us the required guarantees.
+		 */
+		inode_dio_begin(inode);
 
 	mapping_inc_inflight_stable_writes(inode->i_mapping);
 
+	if (wt_ctx->is_aio && !inode->i_sb->s_dio_done_wq) {
+		ret = sb_init_dio_done_wq(inode->i_sb);
+		if (ret < 0) {
+			mapping_dec_inflight_stable_writes(inode->i_mapping);
+			inode_dio_end(inode);
+			kfree(wt_ctx);
+			return ret;
+		}
+	}
+
 	blk_start_plug(&plug);
 
 	while ((ret = iomap_iter(&iter, wt_ops->ops)) > 0) {
@@ -1769,6 +1806,9 @@ ssize_t iomap_file_writethrough_write(struct kiocb *iocb, struct iov_iter *i,
 		cmpxchg(&wt_ctx->error, 0, ret);
 
 	if (!atomic_dec_and_test(&wt_ctx->ref)) {
+		if (wt_ctx->is_aio)
+			return -EIOCBQUEUED;
+
 		for (;;) {
 			set_current_state(TASK_UNINTERRUPTIBLE);
 			if (!READ_ONCE(wt_ctx->waiter))
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 427a2763221c..7203c4d92170 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -572,9 +572,16 @@ struct iomap_writethrough_ctx {
 	atomic_t		ref;
 	unsigned int		flags;
 	int			error;
+	bool			is_aio;
+
+	union {
+		/* used during submission and for non-aio completion */
+		struct task_struct	*waiter;
+
+		/* used during aio completion */
+		struct work_struct	aio_work;
+	};
 
-	/* used during submission and for non-aio completion */
-	struct task_struct	*waiter;
 	int (*end_io)(struct iomap_writethrough_ctx *wt_ctx, ssize_t size,
 		      int error, unsigned int flags);
 
-- 
2.55.0

