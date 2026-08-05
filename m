Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09DCF3DDDCD;
	Wed,  5 Aug 2026 06:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785911399; cv=none; b=jIi08UwAJ5UiWhlOoWrAHN+3AdYyUnBG9m0RI8oC63fs04Dmx+NmybsWpwToYWWPiMtzIh5DlGdP7IfoxrXvT/r0q/cR4+FKZltfAP9gKEKSTcvGz+xVBKZ1DF3V0+tysalFxS+WZn9deR7TmE7SaJLJ2qnMY7M809zWpwQs/zM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785911399; c=relaxed/simple;
	bh=i+bmx0L3bAhVnnyCIjjbNz5uCjMEmBoG8XakvHhL6qg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=myTSBdW5WsboCkdMWen0VeYLe4u1uXeuAbLzxP6uv/1dlyqvGK+/qcrPFuSj21GhAj0qrOpMqKrrj8KyqSoC+rGKR8QR3aeH736pDg42VsOvgv4JJJ+ApukGqMDMOFnxhzCBsUNM/a0bh1CcoJZFJQpAHopCFGvo3lnlICNV4Kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=eA9vtZBy; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="eA9vtZBy"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6755mUSp3057676;
	Wed, 5 Aug 2026 06:29:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=Zz5TTy6EEa7tg69Wf
	qzIDGIlVymyhC4BQmeTiGjvCPc=; b=eA9vtZByIb4Hj2Jip4yiVieTx4oQeAa20
	6Nf/y9V4bl7IMlfG0el4F6qk9ggBe/RlfC916q4IKhZQAPTMG7MSJpFYN0kSvU77
	9WrgF5RaywOISoIaLMS5BsI31AbnrwAuHGXW/e0kztxjHKOhRwSkrf7bMjfG6/mm
	oJW3vtjuMrfJUuObrMN6Z/V4hl8K4w0vdMUFYzUFZhKwf6gzSC3b6T766MhNvBZK
	B0cbXl2XscsxqYewjB8rTineddwvAUGvFYj8sXfyvzhIsIDstfU7UdsMPjB/vZrh
	+skk0A5QmTwafXxEXE1RunUfuLS65BcUwZqjs6GJtLvcUl9QW9IzA==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fs8eus4f3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Aug 2026 06:29:17 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6756QIYw032086;
	Wed, 5 Aug 2026 06:29:16 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fsv4k5ayv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Aug 2026 06:29:16 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6756TE9e31916372
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 5 Aug 2026 06:29:14 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 868122004D;
	Wed,  5 Aug 2026 06:29:14 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3289D20040;
	Wed,  5 Aug 2026 06:29:10 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.211.239])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  5 Aug 2026 06:29:09 +0000 (GMT)
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
Subject: [RFC PATCH v3 10/11] iomap: Avoid folio dirtying in case of RWF_WRITETHROUGH
Date: Wed,  5 Aug 2026 11:58:16 +0530
Message-ID: <a6fcdf05d11c954d2d277844b6db3b11d97d63e0.1785908600.git.ojaswin@linux.ibm.com>
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
X-Proofpoint-ORIG-GUID: HKXEHg4sQSXRf1lFCxUZ2J0r5qRupu2i
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA1MDA0NyBTYWx0ZWRfXzU0Yek79UgMU
 MQVwRm5dCa+ACL1eNmYBUIedf3OOdeYmdsdXiCEJZuM3OEPQmSrd3P+xg1WWcZOurQvUb0ovuyx
 2MaRAKaVvY5Lyq1ewn4d114vIKXbSlw=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA1MDA0NyBTYWx0ZWRfX5x3aRStL73li
 3nWwUK1e9hIvnR1zb1+amhth1BbWn8v8+hZkzQQkvs5HO008RPPaXe7E8eBTb/F1/7DUD6chSEO
 R1fkVXuglLSfA/R2KOwquhMCws2IEo+n+DfG/U4bHXuEqfUPkSrKmpSUs9CkWHeoMgU4T0/w0Te
 Ouv6gTpDJtyMFvIRby86pakoKqpRBbYS6I87lywo8DRzzJtgJPl/8gbkEVrT5xnp2js6zzZ/XFv
 gnuDAWgROR4mb3eKLZwXCls+yhzyqSOp2bp1Qs/n05x06gEZXBqntrw8JbzKHAPCHd8lk7dzooc
 H46y5uIEwPB9ooYV2See268iutZ8HcYC5+3jPYqsRQG7h2X6FQtqMX0ldwSEyNNj/CFM1XL64Cz
 iAe/aCOtWaAf/i55mVloyEZ5kK7z+rL/UOzQnPHAaquNIFJuhpMPWF/CxuzgjcuxR9E+qJkEjDJ
 qOWFn4CKHx1NCOOi+rQ==
X-Proofpoint-GUID: eLqPA66YBny84cHtUH1UZG4FWFEvxOqf
X-Authority-Analysis: v=2.4 cv=KfzidwYD c=1 sm=1 tr=0 ts=6a72d83e cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=RzCfie-kr_QcCd8fBx8p:22 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8
 a=0PHH8OhPgAe37TY-rOQA:9
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_02,2026-08-04_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 bulkscore=0 impostorscore=0 suspectscore=0 malwarescore=0
 adultscore=0 clxscore=1015 priorityscore=1501 phishscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608050047

RWF_WRITETHROUGH dirties the folio only to send it for IO immediately,
in the same context. Due to this, we can optimize away the folio
dirtying and clearing step usually seen in buffered IO. Althrough we can
do away with most of the accounting there are a couple of counters we
need to take care of which we do during IO submission/completion.

Co-developed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 fs/iomap/buffered-io.c  | 64 +++++++++++++++++++++++++++++++++--------
 include/linux/pagemap.h |  1 +
 mm/filemap.c            | 21 ++++++++++++++
 3 files changed, 74 insertions(+), 12 deletions(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index d16694dd9995..0844361fe0f1 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -11,6 +11,9 @@
 #include <linux/fserror.h>
 #include <linux/fsverity.h>
 #include <linux/rmap.h>
+#include <linux/task_io_accounting_ops.h>
+#include "linux/pagemap.h"
+#include "linux/page-flags.h"
 #include "internal.h"
 #include "trace.h"
 
@@ -1162,6 +1165,34 @@ static bool iomap_write_end_inline(const struct iomap_iter *iter,
 	return true;
 }
 
+/*
+ * __iomap_writethrough_end() is almost same as __iomap_write_end() but with the difference
+ * that we don't mark folio dirty since we are about to issue it for IO anyways.
+ * Consequently, most of the accounting is skipped.
+ */
+static bool __iomap_writethrough_end(struct inode *inode, loff_t pos, size_t len,
+		size_t copied, struct folio *folio)
+{
+	flush_dcache_folio(folio);
+
+	/*
+	 * The blocks that were entirely written will now be up-to-date, so we
+	 * don't have to worry about a read_folio reading them and overwriting a
+	 * partial write.  However, if we've encountered a short write and only
+	 * partially written into a block, it will not be marked up-to-date, so a
+	 * read_folio might come in and destroy our partial write.
+	 *
+	 * Do the simplest thing and just treat any short write to a
+	 * non-uptodate page as a zero-length write, and force the caller to
+	 * redo the whole thing.
+	 */
+	if (unlikely(copied < len && !folio_test_uptodate(folio)))
+		return false;
+	iomap_set_range_uptodate(folio, offset_in_folio(folio, pos), len);
+	return true;
+}
+
+
 /*
  * Returns true if all copied bytes have been written to the pagecache,
  * otherwise return false.
@@ -1183,7 +1214,10 @@ static bool iomap_write_end(struct iomap_iter *iter, size_t len, size_t copied,
 		return bh_written == copied;
 	}
 
-	return __iomap_write_end(iter->inode, pos, len, copied, folio);
+	if (iter->flags & IOMAP_WRITETHROUGH)
+		return __iomap_writethrough_end(iter->inode, pos, len, copied, folio);
+	else
+		return __iomap_write_end(iter->inode, pos, len, copied, folio);
 }
 
 static ssize_t iomap_writethrough_complete(struct iomap_writethrough_ctx *wt_ctx)
@@ -1254,7 +1288,7 @@ static void iomap_writethrough_bio_end_io(struct bio *bio)
 		cmpxchg(&wt_ctx->error, 0,
 			blk_status_to_errno(bio->bi_status));
 	bio_for_each_folio_all(fi, bio)
-		folio_end_writeback(fi.folio);
+		folio_end_writethrough(fi.folio, wt_ctx->error);
 
 	bio_put(bio);
 	if (atomic_dec_and_test(&wt_ctx->ref))
@@ -1299,9 +1333,11 @@ iomap_writethrough_submit_bio(struct iomap_writethrough_ctx *wt_ctx,
 
 	/*
 	 * In case of error we still need the I/O completion to run so we can
-	 * release references and end writeback on the folios.
+	 * release references, handle accounting and end writeback on the
+	 * folios.
 	 */
 	if (error) {
+		task_io_account_cancelled_write(len);
 		bio->bi_status = errno_to_blk_status(error);
 		bio_endio(bio);
 		return error;
@@ -1351,6 +1387,7 @@ static void iomap_folio_prepare_writethrough(struct folio *folio, size_t off,
 {
 	bool fully_written;
 	u64 zero = 0;
+	u64 tmp_off = off;
 
 	if (folio_test_writeback(folio))
 		folio_wait_writeback(folio);
@@ -1359,17 +1396,20 @@ static void iomap_folio_prepare_writethrough(struct folio *folio, size_t off,
 		folio_mark_dirty(folio);
 
 	/*
-	 * We might either write through the complete folio or a partial folio
-	 * writethrough might result in all blocks becoming non-dirty, so we need to
-	 * check and mark the folio clean if that is the case.
+	 * For writethrough, we don't mark the write range dirty but we still
+	 * need clear the dirty range if someone else has dirtied it before.
+	 * Further, if the clearing results in folio becoming completely clean,
+	 * then we need to take care of accounting.
 	 */
-	fully_written = (off == 0 && len == folio_size(folio));
-	iomap_clear_range_dirty(folio, off, len);
-	if (fully_written ||
-	    !iomap_find_dirty_range(folio, &zero, folio_size(folio)))
-		folio_clear_dirty_for_writethrough(folio);
+	if (iomap_find_dirty_range(folio, &tmp_off, tmp_off + len)) {
+		iomap_clear_range_dirty(folio, off, len);
 
-	folio_start_writeback(folio);
+		if (!iomap_find_dirty_range(folio, &zero, folio_size(folio)))
+			folio_clear_dirty_for_writethrough(folio);
+	}
+
+	task_io_account_write(folio_nr_pages(folio) * PAGE_SIZE);
+	folio_test_set_writeback(folio);
 }
 
 /**
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index b20e38cc0fa0..774a2e57a9e0 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1257,6 +1257,7 @@ void folio_wait_writeback(struct folio *folio);
 int folio_wait_writeback_killable(struct folio *folio);
 void end_page_writeback(struct page *page);
 void folio_end_writeback(struct folio *folio);
+void folio_end_writethrough(struct folio *folio, bool error);
 void folio_end_writeback_no_dropbehind(struct folio *folio);
 void folio_end_dropbehind(struct folio *folio);
 void folio_wait_stable(struct folio *folio);
diff --git a/mm/filemap.c b/mm/filemap.c
index 58eb9d240643..a1a5f8837e03 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -1695,6 +1695,27 @@ void folio_end_writeback(struct folio *folio)
 }
 EXPORT_SYMBOL(folio_end_writeback);
 
+/**
+ * folio_end_writethrough - End writethrough against a folio
+ * @folio: The folio.
+ * error: Was there an error in IO.
+ *
+ * Context: May be called from process or interrupt context.
+ */
+void folio_end_writethrough(struct folio *folio, bool error)
+{
+	long nr = folio_nr_pages(folio);
+
+	VM_BUG_ON_FOLIO(!folio_test_writeback(folio), folio);
+
+	if (!error)
+		node_stat_mod_folio(folio, NR_WRITTEN, nr);
+
+	if (folio_xor_flags_has_waiters(folio, 1 << PG_writeback))
+		folio_wake_bit(folio, PG_writeback);
+}
+EXPORT_SYMBOL(folio_end_writethrough);
+
 /**
  * __folio_lock - Get a lock on the folio, assuming we need to sleep to get it.
  * @folio: The folio to lock
-- 
2.55.0

