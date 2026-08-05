Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EC7E3DCD80;
	Wed,  5 Aug 2026 06:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785911360; cv=none; b=qZVf7XgZs8PQ/0JpH1MIwiGGYDgqQ5vvxG174szqMgqc6lKwhbN5L970LM4gVYxCIkGOrmkX6OXtEx/fs9FvWKjUryIvbjOFOWpfmioMNJyO4dsfk1mDrQv3IG67byLVlSr+LIVccS7bLFOJvSOwD5YvHStJnqHivh3rqQ1F/VI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785911360; c=relaxed/simple;
	bh=Ioh6XhoBQbHS2rflLBrH+uePfanYFNrptMQr/+txJB4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SwA2ZMcyaHtUD47FlNLp0k5f//xcls6N7Kqvkf9denJN+C82pcPDMVRumMu5NeGDlajOYZUwy7K+IaPpsxnRZzryvGR+sCfFYk+XaQ6L1IlpQdnqypWdMOVrZOLNXzOeHZsHLEvzpA8gHS+F4Dn3TYt83sR8t4Ce8Lt2e1t+ydY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=sUdiUIGO; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="sUdiUIGO"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6755llhl2973321;
	Wed, 5 Aug 2026 06:28:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=voH7uIva5aChHIbaJ
	51UAuhU5U/XSg80MnqMWEh84Cw=; b=sUdiUIGOB3EHGmJa2AB9OOtTlrazR7qX5
	MO3EfH9iR9WEHfk1qFZV1q8F9YddEwzPsiEI5eZ4qEEzNoyH/4EoEupuOOCwBL3b
	AJRaQJ8bbefz9JbExrNn0Upo8yQCFll6RMlfg2SwxmqPAqdHfEAltT/LDPUppcnC
	YjyJBAkqsVTPxFzBig9R9A1Wa+KrCp0XD3qy5x5o4KXFgdey3jCQCnFQIzsvqQpI
	Zn9r3K7eHR9XwK7As66NVJYJN80vDm7O21+3i/fhESR3OJdLaON69mpn0RHN6LtH
	qLgFzB3hPPCT0x1vJ/Ewjhm87qCq8LZN8Mh19XOxbvVUVv8pHhOsA==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4fs8a41mr5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Aug 2026 06:28:47 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 6756QIBR019933;
	Wed, 5 Aug 2026 06:28:46 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4fsvmhd8rt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Aug 2026 06:28:46 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 6756Sis116712168
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 5 Aug 2026 06:28:44 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 49E452004B;
	Wed,  5 Aug 2026 06:28:44 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9098420040;
	Wed,  5 Aug 2026 06:28:39 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.211.239])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  5 Aug 2026 06:28:39 +0000 (GMT)
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
        linux-mm@kvack.org, Dave Chinner <dgc@kernel.org>
Subject: [RFC PATCH v3 04/11] iomap: Add initial support for buffered RWF_WRITETHROUGH
Date: Wed,  5 Aug 2026 11:58:10 +0530
Message-ID: <c108df815e3330e76f2d6adfde791a6e20a498b9.1785908600.git.ojaswin@linux.ibm.com>
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
X-Authority-Analysis: v=2.4 cv=E6P9Y6dl c=1 sm=1 tr=0 ts=6a72d820 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=Sv0fKeRqtYgA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8
 a=JjhpDi1jizst4QKIiw0A:9
X-Proofpoint-ORIG-GUID: mwghkPdwfzsJfGcGOZ_fqG1ncJdTv1Pj
X-Proofpoint-GUID: LUHfteGxd35IVFMRofxcJa0EEmXMboVH
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA1MDA0NyBTYWx0ZWRfXxfKzAn4SYSqi
 AHCFW6Ry5Cs5j1qW4hliuc302G89jTpip8bUHJYtxhmVKv81ygdUha8p/njrEAvTi2KPCwfI1Pk
 DdpKy0q+l/JmkUbAkbgdpePThtSIQDg=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA1MDA0NyBTYWx0ZWRfX38OF/grlxWSQ
 DugseEhojoEi16L6MIlXz5ltalixQ7qYJhVWwurL0+6BmLXCQ0KjcReXhaJtgovtcyMPmZ1JGrf
 t/z2RtUahLAiW2xMsBfANkLkKwM4tVDOKGbcI8kMexEwuYZY+cf3PtZbB0zhViVjSSe6TdZP7jS
 /g7BnO3VVt0xIYP4S620nNxPNeAK5+LH9bt02kP5Ot0FAlmYtCgSzZkm4QzGWb3i0xtvAACO2GK
 M5isEba1LeFVUv8ixEyoicozLLJrGPdy9LkhvV7JC/o7Jw7twqJN3PjHRudOC6n0ylBcoJ6AlvY
 LAceMtE3QBY5Fz0ZEZcDFRtwPJd8apQnkZKui8iLTUfvNVP506QV3QuJzGptf/ZYES7Nh2AICDk
 sSTCmR3q7rIB3vHyjhQ/x6Br5bG1FlMSN8PtJVlj9x0l2elmGj7nZis+J+pIAdAsN5WsXjqfDF1
 AZndSyo6uYKeXAWupWg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-05_02,2026-08-04_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 clxscore=1011 lowpriorityscore=0 priorityscore=1501
 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0 impostorscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608050047

This adds initial support for performing buffered non-aio
RWF_WRITETHROUGH write. The rough flow for a writethrough write is as
follows:

1. Acquire inode lock
2. initialize writethrough context (wt_ctx) and mark
   mapping as stable.
3. Start the iomap_iter() loop. For each iomap:
  3.1. Acquire folio and folio_lock.
  3.2. perform memcpy from user buffer to the folio and mark it
       dirty
  3.3. Wait for any current writeback to complete and then call
       folio_mkclean() to prevent mmap writes from changing it.
  3.4. Start writeback on the folio
  3.5. Add the folio range under write to wt_ctx->bvec and folio_unlock()
  3.6. If bvec is full, submit the current bvecs for IO.
  3.7. Repeat 3.2 to 3.6 till the whole iomap is processed. Submit
       the final set of bvecs for IO.
4. Repeat step 3 till we have no more data to write.
5. Finally, sleep in the syscall thread till all the IOs are
   completed (refcount == 0). Once that happens, the end io handler will
   wake us up.
6. Upon waking up, call fs ->end_io() callback (which updates inode
   size), record any errors and return.
7. inode_unlock()

This design gives buffered writethrough the same semantics as dio and
any error in the IO is directly returned to the caller. However, the
users should note that an error should be treated equivalent of a
buffered IO fsync error, since we can't always guarantee that the page
cache is consistent.

The design has deliberately open coded the IO submission and completion
flow (inspired by dio) rather than reusing the dio functions as
accommodating buffered writethrough logic in dio code was polluting it
with too many if else conditionals and special cases.

Suggested-by: Jan Kara <jack@suse.cz>
Suggested-by: Dave Chinner <dgc@kernel.org>
Co-developed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
---
 fs/iomap/buffered-io.c  | 437 ++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h      |  11 +
 include/linux/iomap.h   |  42 ++++
 include/linux/pagemap.h |   1 +
 include/uapi/linux/fs.h |   5 +-
 mm/page-writeback.c     |  10 +
 6 files changed, 505 insertions(+), 1 deletion(-)

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 0a5ebfda90f1..3178e8c0fa13 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -10,6 +10,7 @@
 #include <linux/migrate.h>
 #include <linux/fserror.h>
 #include <linux/fsverity.h>
+#include <linux/rmap.h>
 #include "internal.h"
 #include "trace.h"
 
@@ -1185,6 +1186,360 @@ static bool iomap_write_end(struct iomap_iter *iter, size_t len, size_t copied,
 	return __iomap_write_end(iter->inode, pos, len, copied, folio);
 }
 
+static ssize_t iomap_writethrough_complete(struct iomap_writethrough_ctx *wt_ctx)
+{
+	struct kiocb *iocb	= wt_ctx->iocb;
+	struct inode *inode	= wt_ctx->inode;
+	ssize_t ret		= wt_ctx->error;
+
+	if (wt_ctx->end_io) {
+		int err = wt_ctx->end_io(wt_ctx, wt_ctx->written,
+					 wt_ctx->error,
+					 wt_ctx->flags);
+		if (err)
+			ret = err;
+	}
+
+	mapping_dec_inflight_stable_writes(inode->i_mapping);
+
+	if (!ret) {
+		ret = wt_ctx->written;
+		iocb->ki_pos += ret;
+	}
+
+	kfree(wt_ctx);
+	return ret;
+}
+
+static void iomap_writethrough_done(struct iomap_writethrough_ctx *wt_ctx)
+{
+	struct task_struct *waiter = wt_ctx->waiter;
+
+	WRITE_ONCE(wt_ctx->waiter, NULL);
+	blk_wake_io_task(waiter);
+}
+
+static void iomap_writethrough_bio_end_io(struct bio *bio)
+{
+	struct iomap_writethrough_ctx *wt_ctx = bio->bi_private;
+	struct folio_iter fi;
+
+	if (bio->bi_status)
+		cmpxchg(&wt_ctx->error, 0,
+			blk_status_to_errno(bio->bi_status));
+	bio_for_each_folio_all(fi, bio)
+		folio_end_writeback(fi.folio);
+
+	bio_put(bio);
+	if (atomic_dec_and_test(&wt_ctx->ref))
+		iomap_writethrough_done(wt_ctx);
+}
+
+static int
+iomap_writethrough_submit_bio(struct iomap_writethrough_ctx *wt_ctx,
+			      struct iomap *iomap,
+			      const struct iomap_writethrough_ops *wt_ops, int error)
+{
+	struct bio *bio;
+	unsigned int i;
+	u64 len = 0;
+	blk_opf_t opf = REQ_OP_WRITE | REQ_SYNC | REQ_IDLE;
+
+	if (!wt_ctx->nr_bvecs)
+		goto exit;
+
+	for (i = 0; i < wt_ctx->nr_bvecs; i++)
+		len += wt_ctx->bvec[i].bv_len;
+
+	bio = bio_alloc(iomap->bdev, wt_ctx->nr_bvecs, opf, GFP_NOFS);
+	bio->bi_iter.bi_sector	= iomap_sector(iomap, wt_ctx->bio_pos);
+	bio->bi_end_io		= iomap_writethrough_bio_end_io;
+	bio->bi_private		= wt_ctx;
+
+	for (i = 0; i < wt_ctx->nr_bvecs; i++)
+		__bio_add_page(bio, wt_ctx->bvec[i].bv_page,
+				wt_ctx->bvec[i].bv_len,
+				wt_ctx->bvec[i].bv_offset);
+
+	if (!error && wt_ops->writethrough_submit)
+		error = wt_ops->writethrough_submit(wt_ctx->inode, iomap,
+						    wt_ctx->bio_pos, len);
+
+
+	atomic_inc(&wt_ctx->ref);
+
+	/*
+	 * In case of error we still need the I/O completion to run so we can
+	 * release references and end writeback on the folios.
+	 */
+	if (error) {
+		bio->bi_status = errno_to_blk_status(error);
+		bio_endio(bio);
+		return error;
+	}
+
+	submit_bio(bio);
+	wt_ctx->nr_bvecs = 0;
+
+exit:
+	return 0;
+}
+
+/*
+ * Submit any pending bvecs as a bio and account the written bytes.
+ * On failure, iomap_writethrough_submit_bio() has already called the
+ * endio completion handler to record the error.
+ */
+static int
+iomap_writethrough_try_submit(struct iomap_writethrough_ctx *wt_ctx,
+			      struct iomap *iomap,
+			      const struct iomap_writethrough_ops *wt_ops,
+			      ssize_t *pending)
+{
+	int ret = iomap_writethrough_submit_bio(wt_ctx, iomap, wt_ops, 0);
+
+	if (ret < 0)
+		return ret;
+	wt_ctx->written += *pending;
+	*pending = 0;
+	return 0;
+}
+
+/**
+ * iomap_writethrough_begin - prepare the various structures for writethrough
+ * @folio: folio to prepare for writethrough
+ * @off: offset of write within folio
+ * @len: len of write within folio
+ *
+ * This function does the major preparation work needed before starting the
+ * writethrough. The main task is to prepare folio for writeththrough by blocking
+ * mmap writes and setting writeback on it. Further, we must clear the write range
+ * to non-dirty. If this results in the complete folio becoming non-dirty, then we
+ * need to clear the master dirty bit.
+ */
+static void iomap_folio_prepare_writethrough(struct folio *folio, size_t off,
+					     size_t len)
+{
+	bool fully_written;
+	u64 zero = 0;
+
+	if (folio_test_writeback(folio))
+		folio_wait_writeback(folio);
+
+	if (folio_mkclean(folio))
+		folio_mark_dirty(folio);
+
+	/*
+	 * We might either write through the complete folio or a partial folio
+	 * writethrough might result in all blocks becoming non-dirty, so we need to
+	 * check and mark the folio clean if that is the case.
+	 */
+	fully_written = (off == 0 && len == folio_size(folio));
+	iomap_clear_range_dirty(folio, off, len);
+	if (fully_written ||
+	    !iomap_find_dirty_range(folio, &zero, folio_size(folio)))
+		folio_clear_dirty_for_writethrough(folio);
+
+	folio_start_writeback(folio);
+}
+
+/**
+ * iomap_writethrough_iter - perform RWF_WRITETHROUGH buffered write
+ * @wt_ctx: writethrough context
+ * @iter: iomap iter holding mapping information
+ * @i: iov_iter for write
+ * @wt_ops: the fs callbacks needed for writethrough
+ *
+ * This function copies the user buffer to folio similar to usual buffered
+ * IO path, with the difference that we immediately issue the IO. For this we
+ * utilize IO submission and completion mechanism that is inspired by dio.
+ *
+ * Folio handling note: We might be writing through a partial folio so we need
+ * to be careful to not clear the folio dirty bit unless there are no dirty blocks
+ * in the folio after the writethrough.
+ */
+static int iomap_writethrough_iter(struct iomap_writethrough_ctx *wt_ctx,
+				   struct iomap_iter *iter, struct iov_iter *i,
+				   const struct iomap_writethrough_ops *wt_ops)
+
+{
+	ssize_t total_written = 0, pending = 0;
+	loff_t submit_start_pos;
+	int status = 0;
+	struct address_space *mapping = iter->inode->i_mapping;
+	size_t chunk = mapping_max_folio_size(mapping);
+	unsigned int bdp_flags = (iter->flags & IOMAP_NOWAIT) ? BDP_ASYNC : 0;
+	unsigned int bs = i_blocksize(iter->inode);
+
+	/* copied over based on how DIO handles these flags */
+	if (iter->iomap.type == IOMAP_UNWRITTEN)
+		wt_ctx->flags |= IOMAP_DIO_UNWRITTEN;
+	if (iter->iomap.flags & IOMAP_F_SHARED)
+		wt_ctx->flags |= IOMAP_DIO_COW;
+
+	if (!(iter->flags & IOMAP_WRITETHROUGH))
+		return -EINVAL;
+
+	/*
+	 * IOMAP_INLINE mappings have NULL bdev and would cause
+	 * iomap_sector() to dereference invalid memory. Reject them.
+	 */
+	if (iter->iomap.type == IOMAP_INLINE)
+		return -EINVAL;
+
+	do {
+		struct folio *folio;
+		size_t offset;		/* Offset into folio */
+		loff_t old_size;
+		u64 bytes;		/* Bytes to write to folio */
+		size_t copied;		/* Bytes copied from user */
+		u64 written;		/* Bytes have been written */
+		loff_t pos;
+		size_t off_aligned, len_aligned;
+
+		bytes = iov_iter_count(i);
+retry:
+		offset = iter->pos & (chunk - 1);
+		bytes = min(chunk - offset, bytes);
+		status = balance_dirty_pages_ratelimited_flags(mapping,
+							       bdp_flags);
+		if (unlikely(status))
+			break;
+
+		/*
+		 * If completions already occurred and reported errors, give up
+		 * now and don't bother submitting more bios.
+		 */
+		status = data_race(wt_ctx->error);
+		if (unlikely(status)) {
+			wt_ctx->nr_bvecs = 0;
+			break;
+		}
+
+		if (bytes > iomap_length(iter))
+			bytes = iomap_length(iter);
+
+		/*
+		 * Bring in the user page that we'll copy from _first_.
+		 * Otherwise there's a nasty deadlock on copying from the
+		 * same page as we're writing to, without it being marked
+		 * up-to-date.
+		 *
+		 * For async buffered writes the assumption is that the user
+		 * page has already been faulted in. This can be optimized by
+		 * faulting the user page.
+		 */
+		if (unlikely(fault_in_iov_iter_readable(i, bytes) == bytes)) {
+			status = -EFAULT;
+			break;
+		}
+
+		status = iomap_write_begin(iter, wt_ops->write_ops, &folio,
+					   &offset, &bytes);
+		if (unlikely(status)) {
+			iomap_write_failed(iter->inode, iter->pos, bytes);
+			break;
+		}
+		if (iter->iomap.flags & IOMAP_F_STALE)
+			break;
+
+		pos = iter->pos;
+
+		if (mapping_writably_mapped(mapping))
+			flush_dcache_folio(folio);
+
+		copied = copy_folio_from_iter_atomic(folio, offset, bytes, i);
+		written = iomap_write_end(iter, bytes, copied, folio) ?
+			  copied : 0;
+
+		old_size = iter->inode->i_size;
+		if (pos + written > old_size)
+			i_size_write(iter->inode, pos + written);
+
+		if (!written)
+			goto put_folio;
+
+		off_aligned = round_down(offset, bs);
+		len_aligned = round_up(offset + written, bs) - off_aligned;
+
+		iomap_folio_prepare_writethrough(folio, off_aligned,
+						 len_aligned);
+
+		if (!wt_ctx->nr_bvecs) {
+			wt_ctx->bio_pos = round_down(pos, bs);
+			submit_start_pos = pos;
+		}
+
+		bvec_set_folio(&wt_ctx->bvec[wt_ctx->nr_bvecs], folio,
+			       len_aligned, off_aligned);
+		wt_ctx->nr_bvecs++;
+
+put_folio:
+		__iomap_put_folio(iter, wt_ops->write_ops, written, folio);
+
+		if (old_size < pos)
+			pagecache_isize_extended(iter->inode, old_size, pos);
+
+		cond_resched();
+		if (unlikely(written == 0)) {
+			iomap_write_failed(iter->inode, pos, bytes);
+			iov_iter_revert(i, copied);
+
+			if (chunk > PAGE_SIZE)
+				chunk /= 2;
+			if (copied) {
+				bytes = copied;
+				goto retry;
+			}
+		} else {
+			total_written += written;
+			pending += written;
+			iomap_iter_advance(iter, written);
+		}
+
+		/*
+		 * If we fail to submit the bio, we immediately call the
+		 * IO completion handler that records the error. We
+		 * shall not retry anymore cause this could lead to
+		 * infinite loops in case of non-transient errors.
+		 */
+		if (wt_ctx->nr_bvecs == wt_ctx->max_bvecs) {
+			status = iomap_writethrough_try_submit(wt_ctx,
+					&iter->iomap, wt_ops, &pending);
+			if (status)
+				goto submit_failed;
+		}
+
+	} while (iov_iter_count(i) && iomap_length(iter));
+
+	if (wt_ctx->nr_bvecs) {
+		status = iomap_writethrough_try_submit(wt_ctx,
+				&iter->iomap, wt_ops, &pending);
+		if (status)
+			goto submit_failed;
+	}
+
+	/*
+	 * In case of an error, we only consider the bytes we were actually able
+	 * to submit IO for as valid data and revert the iters accordingly
+	 */
+	if (status) {
+		/*
+		 * we still need to run the endio completion for cleanup work
+		 * hence call the below helper to take care of it, if we haven't
+		 * already done so. We can ignore the return value here.
+		 */
+		iomap_writethrough_submit_bio(wt_ctx, &iter->iomap, wt_ops, status);
+
+submit_failed:
+		iomap_write_failed(iter->inode, submit_start_pos, pending);
+		iomap_iter_revert(iter, pending);
+		iov_iter_revert(i, pending);
+	}
+
+	return status;
+}
+
 static int iomap_write_iter(struct iomap_iter *iter, struct iov_iter *i,
 		const struct iomap_write_ops *write_ops)
 {
@@ -1345,6 +1700,88 @@ int iomap_fsverity_write(struct file *file, loff_t pos, size_t length,
 }
 EXPORT_SYMBOL_GPL(iomap_fsverity_write);
 
+ssize_t iomap_file_writethrough_write(struct kiocb *iocb, struct iov_iter *i,
+				      const struct iomap_writethrough_ops *wt_ops,
+				      void *private)
+{
+	struct inode *inode = iocb->ki_filp->f_mapping->host;
+	struct iomap_iter iter = {
+		.inode		= inode,
+		.pos		= iocb->ki_pos,
+		.len		= iov_iter_count(i),
+		.flags		= IOMAP_WRITE | IOMAP_WRITETHROUGH,
+		.private	= private,
+	};
+	struct iomap_writethrough_ctx *wt_ctx;
+	unsigned int max_bvecs;
+	ssize_t ret;
+	struct blk_plug plug;
+	size_t min_folio_bytes = PAGE_SIZE
+				 << mapping_min_folio_order(inode->i_mapping);
+
+	/*
+	 * For now we don't support any other flag with WRITETHROUGH
+	 */
+	if (!(iocb->ki_flags & IOCB_WRITETHROUGH))
+		return -EINVAL;
+	if (iocb->ki_flags & (IOCB_DONTCACHE))
+		return -EINVAL;
+	if (iocb_is_dsync(iocb))
+		/* D_SYNC support not implemented yet */
+		return -EOPNOTSUPP;
+	if (!is_sync_kiocb(iocb))
+		/* aio support not implemented yet */
+		return -EOPNOTSUPP;
+
+	/*
+	 * +1 to max bvecs to account for unaligned write spanning multiple
+	 * folios. Guard against overflow since iov_iter_count() returns size_t.
+	 */
+	max_bvecs = (unsigned int)min_t(
+		size_t, DIV_ROUND_UP(iov_iter_count(i), min_folio_bytes) + 1,
+		BIO_MAX_VECS);
+
+	wt_ctx = kzalloc(struct_size(wt_ctx, bvec, max_bvecs), GFP_NOFS);
+	if (!wt_ctx)
+		return -ENOMEM;
+
+	wt_ctx->iocb = iocb;
+	wt_ctx->inode = inode;
+	wt_ctx->end_io = wt_ops->end_io;
+	wt_ctx->old_i_size = i_size_read(inode);
+	wt_ctx->max_bvecs = max_bvecs;
+	atomic_set(&wt_ctx->ref, 1);
+	wt_ctx->waiter = current;
+
+	mapping_inc_inflight_stable_writes(inode->i_mapping);
+
+	blk_start_plug(&plug);
+
+	while ((ret = iomap_iter(&iter, wt_ops->ops)) > 0) {
+		WARN_ON(iter.iomap.type != IOMAP_UNWRITTEN &&
+			iter.iomap.type != IOMAP_MAPPED);
+		iter.status = iomap_writethrough_iter(wt_ctx, &iter, i, wt_ops);
+	}
+
+	blk_finish_plug(&plug);
+
+	if (ret < 0)
+		cmpxchg(&wt_ctx->error, 0, ret);
+
+	if (!atomic_dec_and_test(&wt_ctx->ref)) {
+		for (;;) {
+			set_current_state(TASK_UNINTERRUPTIBLE);
+			if (!READ_ONCE(wt_ctx->waiter))
+				break;
+			blk_io_schedule();
+		}
+		__set_current_state(TASK_RUNNING);
+	}
+
+	return iomap_writethrough_complete(wt_ctx);
+}
+EXPORT_SYMBOL_GPL(iomap_file_writethrough_write);
+
 static void iomap_write_delalloc_ifs_punch(struct inode *inode,
 		struct folio *folio, loff_t start_byte, loff_t end_byte,
 		struct iomap *iomap, iomap_punch_t punch)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 5f17aa0ed4c7..bff09a5f90e8 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -344,6 +344,7 @@ struct readahead_control;
 #define IOCB_ATOMIC		(__force int) RWF_ATOMIC
 #define IOCB_DONTCACHE		(__force int) RWF_DONTCACHE
 #define IOCB_NOSIGNAL		(__force int) RWF_NOSIGNAL
+#define IOCB_WRITETHROUGH	(__force int) RWF_WRITETHROUGH
 
 /* non-RWF related bits - start at 16 */
 #define IOCB_EVENTFD		(1 << 16)
@@ -1980,6 +1981,8 @@ struct file_operations {
 #define FOP_ASYNC_LOCK		((__force fop_flags_t)(1 << 6))
 /* File system supports uncached read/write buffered IO */
 #define FOP_DONTCACHE		((__force fop_flags_t)(1 << 7))
+/* File system supports write through buffered IO */
+#define FOP_WRITETHROUGH	((__force fop_flags_t)(1 << 8))
 
 /* Wrap a directory iterator that needs exclusive inode access */
 int wrap_directory_iterator(struct file *, struct dir_context *,
@@ -3464,6 +3467,14 @@ static inline int kiocb_set_rw_flags(struct kiocb *ki, rwf_t flags,
 		if (IS_DAX(ki->ki_filp->f_mapping->host))
 			return -EOPNOTSUPP;
 	}
+	if (flags & RWF_WRITETHROUGH) {
+		/* file system must support it */
+		if (!(ki->ki_filp->f_op->fop_flags & FOP_WRITETHROUGH))
+			return -EOPNOTSUPP;
+		/* DAX mappings not supported */
+		if (IS_DAX(ki->ki_filp->f_mapping->host))
+			return -EOPNOTSUPP;
+	}
 	kiocb_flags |= (__force int) (flags & RWF_SUPPORTED);
 	if (flags & RWF_SYNC)
 		kiocb_flags |= IOCB_DSYNC;
diff --git a/include/linux/iomap.h b/include/linux/iomap.h
index 1c8f13948f81..427a2763221c 100644
--- a/include/linux/iomap.h
+++ b/include/linux/iomap.h
@@ -212,6 +212,7 @@ struct iomap_write_ops {
 #endif /* CONFIG_FS_DAX */
 #define IOMAP_ATOMIC		(1 << 9) /* torn-write protection */
 #define IOMAP_DONTCACHE		(1 << 10)
+#define IOMAP_WRITETHROUGH	(1 << 11)
 
 /*
  * Return the existing mapping at pos, or reserve space starting at pos for up
@@ -561,6 +562,29 @@ struct iomap_writepage_ctx {
 	void			*wb_ctx;	/* pending writeback context */
 };
 
+struct iomap_writethrough_ctx {
+	struct kiocb		*iocb;
+	struct inode		*inode;
+	loff_t			old_i_size;
+	loff_t			new_i_size;
+	loff_t			pos;
+	size_t			written;
+	atomic_t		ref;
+	unsigned int		flags;
+	int			error;
+
+	/* used during submission and for non-aio completion */
+	struct task_struct	*waiter;
+	int (*end_io)(struct iomap_writethrough_ctx *wt_ctx, ssize_t size,
+		      int error, unsigned int flags);
+
+	loff_t			bio_pos;
+	unsigned int		nr_bvecs;
+	unsigned int		max_bvecs;
+	struct bio_vec		bvec[];
+
+};
+
 struct iomap_ioend *iomap_init_ioend(struct inode *inode, struct bio *bio,
 		loff_t file_offset, u16 ioend_flags);
 struct iomap_ioend *iomap_split_ioend(struct iomap_ioend *ioend,
@@ -751,6 +775,24 @@ static __always_inline ssize_t iomap_dio_read_simple(struct kiocb *iocb,
 	return __iomap_dio_read_simple(iocb, iter, &iomi);
 }
 
+/*
+ * In writethrough, we copy user data to folio first and then send the folio
+ * to writeback via dio path. To achieve this, we need callbacks from iomap_ops
+ * and iomap_write_ops. This struct packs them together.
+ */
+struct iomap_writethrough_ops {
+	const struct iomap_ops *ops;
+	const struct iomap_write_ops *write_ops;
+	int (*writethrough_submit)(struct inode *inode, struct iomap *iomap,
+				   loff_t offset, u64 len);
+	int (*end_io)(struct iomap_writethrough_ctx *iocb, ssize_t size,
+		      int error, unsigned int flags);
+};
+
+ssize_t iomap_file_writethrough_write(struct kiocb *iocb, struct iov_iter *i,
+				      const struct iomap_writethrough_ops *wt_ops,
+				      void *private);
+
 #ifdef CONFIG_SWAP
 struct file;
 struct swap_info_struct;
diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index eb8b7e292478..b20e38cc0fa0 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1270,6 +1270,7 @@ static inline void folio_cancel_dirty(struct folio *folio)
 		__folio_cancel_dirty(folio);
 }
 bool folio_clear_dirty_for_io(struct folio *folio);
+bool folio_clear_dirty_for_writethrough(struct folio *folio);
 bool clear_page_dirty_for_io(struct page *page);
 void folio_invalidate(struct folio *folio, size_t offset, size_t length);
 bool noop_dirty_folio(struct address_space *mapping, struct folio *folio);
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index bd87262f2e34..9c8d91b926a7 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -451,10 +451,13 @@ typedef int __bitwise __kernel_rwf_t;
 /* prevent pipe and socket writes from raising SIGPIPE */
 #define RWF_NOSIGNAL	((__force __kernel_rwf_t)0x00000100)
 
+/* buffered IO that is asynchronously written through to disk after write */
+#define RWF_WRITETHROUGH	((__force __kernel_rwf_t)0x00000200)
+
 /* mask of flags supported by the kernel */
 #define RWF_SUPPORTED	(RWF_HIPRI | RWF_DSYNC | RWF_SYNC | RWF_NOWAIT |\
 			 RWF_APPEND | RWF_NOAPPEND | RWF_ATOMIC |\
-			 RWF_DONTCACHE | RWF_NOSIGNAL)
+			 RWF_DONTCACHE | RWF_NOSIGNAL | RWF_WRITETHROUGH)
 
 #define PROCFS_IOCTL_MAGIC 'f'
 
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 3d184ca316a8..d4f2bb60cb47 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -2944,6 +2944,16 @@ bool folio_clear_dirty_for_io(struct folio *folio)
 }
 EXPORT_SYMBOL(folio_clear_dirty_for_io);
 
+/*
+ * Clear folio dirty in preparation of writethrough. Note that for writethrough
+ * we have already done folkio_mkclean so we avoid it here
+ */
+bool folio_clear_dirty_for_writethrough(struct folio *folio)
+{
+	return __folio_clear_dirty_for_io(folio, false);
+}
+EXPORT_SYMBOL(folio_clear_dirty_for_writethrough);
+
 static void wb_inode_writeback_start(struct bdi_writeback *wb)
 {
 	atomic_inc(&wb->writeback_inodes);
-- 
2.55.0

