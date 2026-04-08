Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39B9C3D903D;
	Wed,  8 Apr 2026 18:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674008; cv=none; b=gQUg6trBQdYM3ocebzNliurE2/K+x+g26bpTI5/AHMB9zmI93ML0RDMRgzO5zmyJrwCmSY35nUTipDKkRdF2BXaEwYIoM94o4CpvQ41a8v3kFZdWwrWgJpnFJag9jIhG8GtnQzW40qfkFkzLZdXyDvcE4NJyVefqa3BLmztQ6VE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674008; c=relaxed/simple;
	bh=qcw4FPYg7qWdUZnBoQY51rm+iVriJqHOzFlgGDj3CUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ajzlDesrAxXoOwfwdeUbiK8cSAw/33SjEXO6oXL70v6E6oXnQZ/C0IwjqwoRgNh+bDjJ9UtsFeQElq0v0HVvCoy5kdrCbfxy45Pga60qe2J9i5KNnI97Ign08ISEuQRyH8fibkg8Nwp18X/7G5o2+T7yv7pQMWtDLlazykWMoWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=frl1QSWI; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="frl1QSWI"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6386b4oD2594681;
	Wed, 8 Apr 2026 18:46:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=u/FVAs3+nVWCm7Mn/
	SYzhNu6ZuycBrO+O7t3Y1hxAIE=; b=frl1QSWIgWbCzXh2eO2VxQ6p369BuMfAE
	+JRQck/GJgLmyznmq2g7moNamZNJ7zJfoxoFQ74Vm/LqUY4bzIcjYatPmsMvczl8
	P8efBCmHBmktoPlv9wkHA01Ke+jRxd9y+q2W7qp1k/YQ+Dynu1TjPbp14AMdBGcn
	fD1VaOT7/LVUDzRtJUOT6T7aruXh3GAz8ZPqbEL8kM40rCJEjQRxI1uiggkIz81I
	VVcYQ13fJ+7T54D55d9nhaWmhsRDDvRkuMrnuNxu9jwJMKdofhzjCOMYTTXClpHl
	0+XkWogOLOutsRoyZDrte7bzityTTpk9sry1lqxufNYtspQUKOM9Q==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dcn2e9jcv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Apr 2026 18:46:26 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 638G9FuQ007942;
	Wed, 8 Apr 2026 18:46:25 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dcmg2gkmp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 08 Apr 2026 18:46:24 +0000
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 638IkNe150725326
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 8 Apr 2026 18:46:23 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EB8642004B;
	Wed,  8 Apr 2026 18:46:22 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4B2BE20040;
	Wed,  8 Apr 2026 18:46:19 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.212.72])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  8 Apr 2026 18:46:19 +0000 (GMT)
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org,
        hch@lst.de, ritesh.list@gmail.com, jack@suse.cz,
        Luis Chamberlain <mcgrof@kernel.org>, dgc@kernel.org, tytso@mit.edu,
        p.raghav@samsung.com, andres@anarazel.de, brauner@kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [RFC PATCH v2 4/5] iomap: Add aio support to RWF_WRITETHROUGH
Date: Thu,  9 Apr 2026 00:15:45 +0530
Message-ID: <dcb4a5bfb8872c38c263290c124bbfc8a0f8b3c7.1775658795.git.ojaswin@linux.ibm.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1775658795.git.ojaswin@linux.ibm.com>
References: <cover.1775658795.git.ojaswin@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: JhEyvaM_pp-26pRFxK6A_oTXKQ3pEitz
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA4MDE3MCBTYWx0ZWRfX4OHy3uIx0ZyM
 Rj8kp4GLHq/ZSKc5r3LXAqUyXLXsURyI3ayhwtCM+rpfOgz9QjKNBrRI9MPymi4kLypFsMUmNJH
 T130L8+dNbKSxDaPXhV2XUC2mIFC3neqTYLeGTD7605rRUV8WM6a39RZokTmHvh5axb5C0FMdKN
 WMhMO5QpzREhizcHSWuA+7euBWiz8lt9nZFaIZUQlZHslKAeJ+LHr7oU6kKJwAl+ObM+FHhTrLj
 4vXLw30qxaTKcg6asK3+JpsKLcysNFGDuNm6ztoJqVmw3Ir3lVkRJeuMrPSte0S/5ShqyRoHoBt
 AMH4gcZAksfijQKh2m7pEftVyLBej8fhpVys3y0OlO+VWaboBN0iLz6QOwzFAlHX7V+OYTxe7fP
 UON6PkqUybL+aYD6USJLop5mu03gQJ4QzzVqkle6MuX6AXx6svxm4+sxelccq/A3Nbtz95gqgAn
 By4CRlWVjNo7w8arymw==
X-Authority-Analysis: v=2.4 cv=Cfw4Irrl c=1 sm=1 tr=0 ts=69d6a282 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8
 a=dGFhD9eEaN_uTI8HWPQA:9
X-Proofpoint-GUID: mTjuhj2a_Ms-PfKakK7_N4KuIFlR8Lsd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-08_05,2026-04-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 phishscore=0 clxscore=1015 adultscore=0 suspectscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 spamscore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604010000 definitions=main-2604080170

With aio the only thing we need to be careful off is that writethrough
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
 fs/iomap/buffered-io.c | 53 ++++++++++++++++++++++++++++++++++++------
 include/linux/iomap.h  | 10 ++++++--
 2 files changed, 54 insertions(+), 9 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 74e1ab108b0f..6937f10e2782 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1113,6 +1113,9 @@ static ssize_t iomap_writethrough_complete(struct iomap_writethrough_ctx *wt_ctx
 
 	mapping_clear_stable_writes(inode->i_mapping);
 
+	if (wt_ctx->is_aio)
+		inode_dio_end(inode);
+
 	if (!ret) {
 		ret = wt_ctx->written;
 		iocb->ki_pos = wt_ctx->pos + ret;
@@ -1122,12 +1125,27 @@ static ssize_t iomap_writethrough_complete(struct iomap_writethrough_ctx *wt_ctx
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
 	return;
 }
 
@@ -1530,9 +1548,6 @@ ssize_t iomap_file_writethrough_write(struct kiocb *iocb, struct iov_iter *i,
 	if (iocb_is_dsync(iocb))
 		/* D_SYNC support not implemented yet */
 		return -EOPNOTSUPP;
-	if (!is_sync_kiocb(iocb))
-		/* aio support not implemented yet */
-		return -EOPNOTSUPP;
 
 	/*
 	 * +1 to max bvecs to account for unaligned write spanning multiple
@@ -1557,11 +1572,32 @@ ssize_t iomap_file_writethrough_write(struct kiocb *iocb, struct iov_iter *i,
 	wt_ctx->pos = iocb->ki_pos;
 	wt_ctx->new_i_size = i_size_read(inode);
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
 
 	mapping_set_stable_writes(inode->i_mapping);
 
+	if (wt_ctx->is_aio && !inode->i_sb->s_dio_done_wq) {
+		ret = sb_init_dio_done_wq(inode->i_sb);
+		if (ret < 0) {
+			mapping_clear_stable_writes(inode->i_mapping);
+			kfree(wt_ctx);
+			return ret;
+		}
+	}
+
 	while ((ret = iomap_iter(&iter, wt_ops->ops)) > 0) {
 		WARN_ON(iter.iomap.type != IOMAP_UNWRITTEN &&
 			iter.iomap.type != IOMAP_MAPPED);
@@ -1571,6 +1607,9 @@ ssize_t iomap_file_writethrough_write(struct kiocb *iocb, struct iov_iter *i,
 		cmpxchg(&wt_ctx->error, 0, ret);
 
 	if (!atomic_dec_and_test(&wt_ctx->ref)) {
+		if (wt_ctx->is_aio)
+			return -EIOCBQUEUED;
+
 		for (;;) {
 			set_current_state(TASK_UNINTERRUPTIBLE);
 			if (!READ_ONCE(wt_ctx->waiter))
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 661233aa009d..e99f7c279dc6 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -486,9 +486,15 @@ struct iomap_writethrough_ctx {
 	atomic_t		ref;
 	unsigned int		flags;
 	int			error;
+	bool			is_aio;
 
-	/* used during submission and for non-aio completion */
-	struct task_struct	*waiter;
+	union {
+		/* used during submission and for non-aio completion */
+		struct task_struct	*waiter;
+
+		/* used during aio completion */
+		struct work_struct	aio_work;
+	};
 
 	loff_t			bio_pos;
 	unsigned int		nr_bvecs;
-- 
2.53.0

