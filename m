Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B194B95C3;
	Mon, 28 Sep 2026 12:04:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790597084; cv=none; b=XYPXYEglCN0e/PP1K76uhY8rEkCT1dSAB/ywyP3SRPK6lOIGWB6Eq+YGZGMnpLnvVjhhHFgDNaFEx9JX1APqyjQAf97mDUrocZN6FxUzJu7sw1P7irMXg+v3m0xw/Lc3gcY8klZvT2/Tpu7jOXeFsRAQXLP+i0de8QHNfHUNI6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790597084; c=relaxed/simple;
	bh=2sH0kPavUkzuh30VAvqOfGI+6PtQgKxPzaex5Hio6cQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PvbYiy7qmW1609RNV11Bh8AIjHwrhu0VZUMHrIOeo+Xa2YRq1ysvnNg3Qgly7qGaOUNV1iLSjdCOWjNnUo7xNdEHlzsrh+f9RgMGNJbLQa7FskPteVa+9OgbEFrz0qiksim2XhvPIlkw7l8VzlPLXdRUicd9G3veq6xrGkE0+1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=PfFRrpcR; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="PfFRrpcR"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68SBZUuj3374968;
	Mon, 28 Sep 2026 12:04:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=F0UMG1PQ3wjUrEKVL
	k9UXUjrFunwbDAz80oLKcLuXa0=; b=PfFRrpcRNYG6N0t1Gs8Wf6uD1BhErri0G
	FISkPLlUlAV3+fL7EaU/QBZW673Ur0MKFsQAodOcaEF907PifMnboGzaMwY5mezV
	geLQP+W1qchsRqkz58ZZuLQC/WksxEk3YaE9op5HIeANlWLpPDM2HDpS9mcXXvpU
	i+jrmor160IMHk6kqkmaE6uTLfJFnyziRZQ5IY5WXGdzy8k+WVGAwNMgjxsSGzRP
	JVnvxBuPYjrvUTZ/VHZXcl4nhVgsy6uhpig41S+dxR3eL7ygxH8hbHQ3mqH6wR+a
	WTW7xrScjEsLwvewnaA9P08cGoAaQI7coQ57Dl/NfrLQEEWkVe59g==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gx5qr13p6-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 28 Sep 2026 12:04:09 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68SBHWAk017606;
	Mon, 28 Sep 2026 12:04:08 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gxsck53aw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 28 Sep 2026 12:04:07 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68SC45Z346661958
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 28 Sep 2026 12:04:05 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BDC6F2004D;
	Mon, 28 Sep 2026 12:04:05 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6DB3F20040;
	Mon, 28 Sep 2026 12:04:00 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.20.95])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Mon, 28 Sep 2026 12:04:00 +0000 (GMT)
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
        linux-mm@kvack.org, Andres Freund <andres@anarazel.de>,
        Dave Chinner <dgc@kernel.org>
Subject: [RFC PATCH v4 08/12] iomap: Add DSYNC support to RWF_WRITETHROUGH
Date: Mon, 28 Sep 2026 17:33:09 +0530
Message-ID: <ced8ea2c2bc9109837723ff3938a0359ffae834e.1790596383.git.ojaswin@linux.ibm.com>
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
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTI4MDA0NiBTYWx0ZWRfX9c9fx1B8GUbt
 u/DWHqXni+0pjptK/FBm1AXyvx3j814nAdP35B/ob262//lZ419cn3HVO8dGhcNe4a3qBhzMA4h
 MsTOd34ick62pMLsjhSDRZUNVdOHlMtRnX3uQ6opkyh+mxP3/fWunR0s+JDAbbPLQy2hzfe3qiP
 NMycB3zpDZr7EGn8o1ZTzDaEbSV5rcdzcQsdIzlkTnO2cyBoW1XVE9NmPPuz7/hjOMhqNTPm4jI
 I0/yGG2NN522Akw9kdXKLICw4kMnKpkDb8hZVzWYt9cltrFC/n/NNegyvYklT63C7Wf1/SaouMi
 BnmPXTQCeZfuQs3R6M8H3TBtxiEkYVovar0H0h69dmP+fuR8zZ0y4ONjXK660VJPojYGvLqXhUP
 /mY0VXdoOPYEnLWMOyGeXdM5z3vwyMx2EgGbtnJaL0jjFd7YQtZxBgsKK1ugoYAqucM1Y1mmcrF
 mempcEJn6MD/3uyFBAg==
X-Authority-Analysis: v=2.4 cv=SPbXx+vH c=1 sm=1 tr=0 ts=6aba57b9 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8
 a=nOap7FSNCsi5F2RPnIcA:9
X-Proofpoint-ORIG-GUID: BmQwRke5PYynaDMPZup2Jfz3l7Vbwz8S
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTI4MDA0NiBTYWx0ZWRfX9SxHBtZGPtuT
 XoXseZclEBxEl8o4qO8kdnvri0wZU7dm2t9OTZ0sgsOQZkc3eFlx8C50sQatxj2iS9b1oe0kC+C
 aaX6hnXRRB0CkDXrtG0mO/w4KBJKzEU=
X-Proofpoint-GUID: 95YSuNK76ub_zn3gsK-hZbGYX4WUj9cq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-28_03,2026-09-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 clxscore=1015 spamscore=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 bulkscore=0 impostorscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609280046

Add DSYNC support to writethrough buffered writes. Unlike the usual
buffered writes where we call generic_write_sync() inline during the
syscall path, for writethrough we instead sync the data during IO
completion path, just like dio.

This allows aio writethrough to be truly async where the syscall can
return after IO submission and the sync can then be done asynchronously
during IO completion time.

Further, just like dio, we utilize the FUA optimization, if available,
to avoid syncing the data for DSYNC operations.

Suggested-by: Dave Chinner <dgc@kernel.org>
Co-developed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 fs/iomap/buffered-io.c | 35 ++++++++++++++++++++++++++++++++++-
 include/linux/iomap.h  |  1 +
 2 files changed, 35 insertions(+), 1 deletion(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 2ea45ab67bd9..91dad3550398 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -1208,7 +1208,17 @@ static ssize_t iomap_writethrough_complete(struct iomap_writethrough_ctx *wt_ctx
 	if (!ret) {
 		ret = wt_ctx->written;
 		iocb->ki_pos += ret;
-	} else
+
+		/*
+		 * If this is a DSYNC write and we couldn't optimize it, make
+		 * sure we push it to stable storage now that we've written
+		 * data.
+		 */
+		if (iocb_is_dsync(wt_ctx->iocb) && !wt_ctx->use_fua)
+			ret = generic_write_sync(iocb, ret);
+	}
+
+	if (ret < 0)
 		mapping_set_error(inode->i_mapping, ret);
 
 	kfree(wt_ctx);
@@ -1270,6 +1280,9 @@ iomap_writethrough_submit_bio(struct iomap_writethrough_ctx *wt_ctx,
 	for (i = 0; i < wt_ctx->nr_bvecs; i++)
 		len += wt_ctx->bvec[i].bv_len;
 
+	if (wt_ctx->use_fua)
+		opf |= REQ_FUA;
+
 	bio = bio_alloc(iomap->bdev, wt_ctx->nr_bvecs, opf, GFP_NOFS);
 	bio->bi_iter.bi_sector	= iomap_sector(iomap, wt_ctx->bio_pos);
 	bio->bi_end_io		= iomap_writethrough_bio_end_io;
@@ -1406,6 +1419,19 @@ static int iomap_writethrough_iter(struct iomap_writethrough_ctx *wt_ctx,
 	if (iter->iomap.type == IOMAP_INLINE)
 		return -EINVAL;
 
+	/*
+	 * If we realise that cache flush is necessary (eg FUA is not present
+	 * or we need metadata updates) then we turn off the optimization.
+	 */
+	if (wt_ctx->use_fua) {
+		if (iter->iomap.type != IOMAP_MAPPED ||
+		    (iter->iomap.flags &
+		     (IOMAP_F_NEW | IOMAP_F_SHARED | IOMAP_F_DIRTY)) ||
+		    (bdev_write_cache(iter->iomap.bdev) &&
+		     !bdev_fua(iter->iomap.bdev)))
+			wt_ctx->use_fua = false;
+	}
+
 	do {
 		struct folio *folio;
 		size_t offset;		/* Offset into folio */
@@ -1825,6 +1851,13 @@ ssize_t iomap_file_writethrough_write(struct kiocb *iocb, struct iov_iter *i,
 	wt_ctx->is_aio = !is_sync_kiocb(iocb);
 	atomic_set(&wt_ctx->ref, 1);
 
+	/*
+	 * Similar to dio, we optimistically set use_fua=true to avoid explicit
+	 * sync. In case we later realise cache flush is needed we set it back
+	 * to false.
+	 */
+	wt_ctx->use_fua = iocb_is_dsync(iocb) && !(iocb->ki_flags & IOCB_SYNC);
+
 	if (!wt_ctx->is_aio)
 		wt_ctx->waiter = current;
 	else
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 691f48bc8afa..b1c6707c25a4 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -570,6 +570,7 @@ struct iomap_writethrough_ctx {
 	unsigned int		flags;
 	int			error;
 	bool			is_aio;
+	bool			use_fua;
 
 	union {
 		/* used during submission and for non-aio completion */
-- 
2.55.0

