Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADAA13DC4B3;
	Wed,  5 Aug 2026 06:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785911466; cv=none; b=G21jvS9oMe5ijoOq1kB9Q2pqjL+9d7U7HBeM/NlP18onB+tx+h9MFIIOpKCXPXmgh4upaeBxbr7fjO/xIZJyW34du93CrIYdT2QrAsI+j+80aJFSZnzv9wPeWBJbSm/xUcUiWNuG/tSs+HZIf0CI6SqqI5+8BSZoDYGGgZs4BLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785911466; c=relaxed/simple;
	bh=SmPTURlB2CNqSYfYUmO+BqlxCqbDAMxql061z0A4d7M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k1kcrOnFrAaJ1cCfAypsRHwWBmJwyN8WyjX23JR+WuzI9gNf9lrwtmqoBxTG093sKDevbznWy9iyd5CiYSWGQ/fvAb++S7+ZeBIDtwm+j9dMZwPzRVCoMfcV0/AfQ/DWjAH9Jc1OeTa5e/xl2yipe1Hpo2tTqLLP0MjNQNq89Hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=WwXWcHE8; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="WwXWcHE8"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6755lrxa1121596;
	Wed, 5 Aug 2026 06:29:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=095QS7upVPuSHTC8a
	3xiMOI0ni0TS77b5nrnsLPg5w0=; b=WwXWcHE8zersWTROIS/lWp2pNcCZ62BlJ
	q0/uX4Fkz7Rp9ayC6yyUoxSg+MO/PffWXmiAO4Mqx36Elm1JSlS5pSmSHVCd7uPE
	JIKVLjFmmwNgjFtdvygQhPB7uhhzKvRFmBcHcX8g+KPvXSpkJxh6/xvZh3hV/+MY
	BsZEpftbLw0Yhf4ydx2R4CJJsKPx1HvAnEIYp6t2Vqe6YL/IdIICDk08PrxsNIxd
	nqBDKDmYXOnJtynD+P2ykWEof5PSmv412su4auKt/aeme6QG8SEaIz8gGwWYj+nJ
	+XxmATjpdfJQnPXNVdGWzZ8MP11Dcje0ht9ncZQzb1LTsHdvQDumQ==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fs8fqsjdq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Aug 2026 06:29:22 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6756QFeP001943;
	Wed, 5 Aug 2026 06:29:21 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4fswtyn3du-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Aug 2026 06:29:21 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6756TJMZ16711962
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 5 Aug 2026 06:29:19 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 682D620043;
	Wed,  5 Aug 2026 06:29:19 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0697020040;
	Wed,  5 Aug 2026 06:29:15 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.211.239])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  5 Aug 2026 06:29:14 +0000 (GMT)
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
Subject: [RFC PATCH v3 11/11] iomap: Handle deadlock due to repeating folios in RWF_WRITETHROUGH
Date: Wed,  5 Aug 2026 11:58:17 +0530
Message-ID: <7eb663a29c18e40d0000422792543ab3512c5a7e.1785908600.git.ojaswin@linux.ibm.com>
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
X-Proofpoint-GUID: SPXSXqyhPvFwPef82RKiMuNzwMeR5-Ch
X-Proofpoint-ORIG-GUID: aFxx8t1NCBaaen8xHPZ-fdaFxQOl4vLd
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA1MDA0NyBTYWx0ZWRfX6eAuWzQHDpRr
 R2qOTHDtgR5OiyzdWVJgrGDxpk16QRR5kKFq56ulmWg9iVHHJ+74Yh9D57EP4Rns4NzQHbFjs7f
 EIOarrUvspL6qnID0G4pwERs1h4BiKs=
X-Authority-Analysis: v=2.4 cv=K8cS2SWI c=1 sm=1 tr=0 ts=6a72d842 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8
 a=2R8uCszOOhyw9zs8MNsA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA1MDA0NyBTYWx0ZWRfX/YKbZ8sa0jQK
 dN9yhXJyqVxKbEaEm7mNWtHA7fYNkN8GfdHYq6nIfrnbTkbujt0hKd5xatg+4Sux66N63vG7fW4
 NsL5lQD/xcC+Fa0PLsr/xGJty2Qo0xqBA6nqjriMW4/PHnNXVxIFPotef1QN0OoWn94LfNM9PWH
 tjdOECD4nmfqmKsITMMcf64tFaDsrwsU5EtOvFaZH+iWLykbOLepw+qJAB6diPN2lsRf5ybrp+j
 XljEuYrP+pe2xa6Irn2lnkAvTX+hvz7k8VrMFQa0vqw9ild136hkSN6Sdde+Mqt5DQv5cRrbIro
 KdstbJQ1/1GmK4ZgNqCI419wpVTL/bzzndjdzPgamJ5Egl4D0OjsmVpEc9KP9D7ZSAOQNULeUGJ
 VjP+X8Bh/NMyEDokK+JanIRQNZMHKyfoaDJYhYY6vL5UATRjHUudX9k/EdOY5pc/emmbnM4u07I
 gQ63yecp/+kCySsbZWA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_02,2026-08-04_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 spamscore=0 impostorscore=0 bulkscore=0 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 phishscore=0 suspectscore=0 adultscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608050047

In iomap_writethrough_iter() we might encounter repeating folios across
multiple iterations. Repeating folios can occur if, example,
copy_folio_from_iter_atomic() does a short copy due to userspace pages
not faulted in. This is an issue because a previous loop might have
started writeback on them but not yet issued the IO. In the next
iteration trying to get the same folio with FGP_STABLE will result in a
deadlock. Since repeating folios will always be encountered back to
back, we can just use a simple cur != prev check to detect them.

Use this to avoid waiting for writeback or starting writeback on folios
we have already processed. Note that in ->endio() we might end up
calling folio_end_writethrough() twice on the same folio which can cause
issues with folio_xor_flags_has_waiters(). For simplicity, just change
the folio_xor_flags_has_waiters() call to an idempotent variant.

Reported-by: Pankaj Raghav <pankaj.raghav@linux.dev>
Co-developed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 fs/iomap/buffered-io.c | 37 ++++++++++++++++++++++++++++++-------
 mm/filemap.c           |  3 ++-
 2 files changed, 32 insertions(+), 8 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 0844361fe0f1..70c1565e5416 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -804,6 +804,13 @@ struct folio *iomap_get_folio(struct iomap_iter *iter, loff_t pos, size_t len)
 {
 	fgf_t fgp = FGP_WRITEBEGIN;
 
+	/*
+	 * For writethrough, we open code the FGP_STABLE logic directly in
+	 * iomap_writhrethrough_iter() so disable it here.. See
+	 * iomap_writethrough_iter() for details.
+	 */
+	if (iter->flags & IOMAP_WRITETHROUGH)
+		fgp &= ~FGP_STABLE;
 	if (iter->flags & IOMAP_NOWAIT)
 		fgp |= FGP_NOWAIT;
 	if (iter->flags & IOMAP_DONTCACHE)
@@ -1383,15 +1390,12 @@ iomap_writethrough_try_submit(struct iomap_writethrough_ctx *wt_ctx,
  * need to clear the master dirty bit.
  */
 static void iomap_folio_prepare_writethrough(struct folio *folio, size_t off,
-					     size_t len)
+					     size_t len, bool already_prepared)
 {
 	bool fully_written;
 	u64 zero = 0;
 	u64 tmp_off = off;
 
-	if (folio_test_writeback(folio))
-		folio_wait_writeback(folio);
-
 	if (folio_mkclean(folio))
 		folio_mark_dirty(folio);
 
@@ -1409,7 +1413,8 @@ static void iomap_folio_prepare_writethrough(struct folio *folio, size_t off,
 	}
 
 	task_io_account_write(folio_nr_pages(folio) * PAGE_SIZE);
-	folio_test_set_writeback(folio);
+	if (!already_prepared)
+		folio_test_set_writeback(folio);
 }
 
 /**
@@ -1426,6 +1431,17 @@ static void iomap_folio_prepare_writethrough(struct folio *folio, size_t off,
  * Folio handling note: We might be writing through a partial folio so we need
  * to be careful to not clear the folio dirty bit unless there are no dirty blocks
  * in the folio after the writethrough.
+ *
+ * **A corner case to be careful about**
+ *
+ * For writethrough, we open code the stable write behavior to handle the case
+ * where we encounter a folio that we already started writeback on but have not
+ * yet submitted. In that case we must not wait for writeback again to avoid
+ * deadlocking. Repeating folios can occur if, example,
+ * copy_folio_from_iter_atomic() does a short copy due to userspace pages not
+ * faulted in. Also, repeating folios will always be encountered back to back so
+ * we can just use a simple cur != prev check to detect them.
+
  */
 static int iomap_writethrough_iter(struct iomap_writethrough_ctx *wt_ctx,
 				   struct iomap_iter *iter, struct iov_iter *i,
@@ -1439,6 +1455,7 @@ static int iomap_writethrough_iter(struct iomap_writethrough_ctx *wt_ctx,
 	size_t chunk = mapping_max_folio_size(mapping);
 	unsigned int bdp_flags = (iter->flags & IOMAP_NOWAIT) ? BDP_ASYNC : 0;
 	unsigned int bs = i_blocksize(iter->inode);
+	struct folio *prev_folio = NULL;
 
 	/* copied over based on how DIO handles these flags */
 	if (iter->iomap.type == IOMAP_UNWRITTEN)
@@ -1530,6 +1547,10 @@ static int iomap_writethrough_iter(struct iomap_writethrough_ctx *wt_ctx,
 		if (mapping_writably_mapped(mapping))
 			flush_dcache_folio(folio);
 
+		 /* Open coding stable write behavior, see comment on top. */
+		if (prev_folio != folio)
+			folio_wait_writeback(folio);
+
 		copied = copy_folio_from_iter_atomic(folio, offset, bytes, i);
 		written = iomap_write_end(iter, bytes, copied, folio) ?
 			  copied : 0;
@@ -1544,8 +1565,10 @@ static int iomap_writethrough_iter(struct iomap_writethrough_ctx *wt_ctx,
 		off_aligned = round_down(offset, bs);
 		len_aligned = round_up(offset + written, bs) - off_aligned;
 
-		iomap_folio_prepare_writethrough(folio, off_aligned,
-						 len_aligned);
+		iomap_folio_prepare_writethrough(
+			folio, off_aligned, len_aligned, prev_folio == folio);
+
+		prev_folio = folio;
 
 		if (!wt_ctx->nr_bvecs) {
 			wt_ctx->bio_pos = round_down(pos, bs);
diff --git a/mm/filemap.c b/mm/filemap.c
index a1a5f8837e03..fc3ed0619838 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1711,7 +1711,8 @@ void folio_end_writethrough(struct folio *folio, bool error)
 	if (!error)
 		node_stat_mod_folio(folio, NR_WRITTEN, nr);
 
-	if (folio_xor_flags_has_waiters(folio, 1 << PG_writeback))
+	folio_test_clear_writeback(folio);
+	if (folio_test_waiters(folio))
 		folio_wake_bit(folio, PG_writeback);
 }
 EXPORT_SYMBOL(folio_end_writethrough);
-- 
2.55.0

