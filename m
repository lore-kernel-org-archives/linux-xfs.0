Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4C2433345A;
	Sun, 20 Sep 2026 13:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789910096; cv=none; b=o7iq9C/ewTqePYE1s9dZXVbiA9B8gtRCPSvFr8Ekwp0akEnrK71/00gjB/Ig4UiQpQQKNRkZpoZtpAL6SHCVHot68x8uH3xB0SsuJR8R1Gf+p/+3LXozGd7l4ze2qVPYPuARqAATe9z+UvZLosSr1S2QEnubgjECthNQcmk6yNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789910096; c=relaxed/simple;
	bh=6v+j3hCGng1MoZWJDV8VkVKcJYOL8S3NFP2m6VdJYNk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r+L6+gGfXIrYVv43wZaV04KvT5idXgkaYzldE5O227I39k/3woqeOCw7JazaPxUW3P7Iv4e0Mn9STqHUZHpaPdYgrHeT6BHBUJVFLVzwT5zEGDQ7QZptF8mZ0lWicX3DLGcJxUf0fyUMJb+VT1LupLNH5Fb/VezNe02qMVSc5UQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=JtdXOmKd; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="JtdXOmKd"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68KC6DlA773650;
	Sun, 20 Sep 2026 13:14:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=kcjzVgllgdiYJS1YYhyUAFn2TSn0Og
	nfrWZB5sDSbgs=; b=JtdXOmKdhmb6tU+eYpd5fUV+cafYbxHwV/92ojvoLjRmdz
	36zVHj1tUIZy30boRyflEfdm2bzbNin7dI9rdyRC+sqkxDY8C6slu9IVWidjJHpw
	uIgoGrsVVPJwoH6hF6ZJMbcQYHbbdziJ3AvAOFUyv3FzobTqFQKQprLvXJmKYGlV
	2phfKmVq5CZBwR/kLAoK5AWwzDyZH5mf9lwjr7xOk5l1d6jiteTbJM7x9J0TJT8E
	yj74Lclj/xttkmUlRfLG1/iFtSkbEYgqQhoPuNIHUCHgcyl18pgIwUcFanNrlIDv
	OglW7Dk/yCMEGXdjH7S2pHQP9rys13au1vMFxZfA==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gske1cj4x-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Sun, 20 Sep 2026 13:14:06 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68KBlYZM609929;
	Sun, 20 Sep 2026 13:14:06 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4gt7dy1bxe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Sun, 20 Sep 2026 13:14:05 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68KDE46K51380570
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 20 Sep 2026 13:14:04 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2B6D820043;
	Sun, 20 Sep 2026 13:14:04 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EB40320040;
	Sun, 20 Sep 2026 13:13:57 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.124.209.136])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Sun, 20 Sep 2026 13:13:57 +0000 (GMT)
Date: Sun, 20 Sep 2026 18:43:54 +0530
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
Subject: Re: [RFC PATCH v3 04/11] iomap: Add initial support for buffered
 RWF_WRITETHROUGH
Message-ID: <aq_cEjiBs5BzGyQx@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <cover.1785908600.git.ojaswin@linux.ibm.com>
 <c108df815e3330e76f2d6adfde791a6e20a498b9.1785908600.git.ojaswin@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c108df815e3330e76f2d6adfde791a6e20a498b9.1785908600.git.ojaswin@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: 8YuEFrQQeHQVrYnTsfsCmIVN_eorOuHO
X-Authority-Analysis: v=2.4 cv=EOCTQFZC c=1 sm=1 tr=0 ts=6aafdc1f cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8
 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8 a=HuKMEexJeThaPcRw06oA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIwMDE5MCBTYWx0ZWRfX3Djf1lbx3cql
 l2pu1ZR2PeQAWtG3sqRGywoMQxMnzfNdXhinQ5XSERpdX75VgVQ30PIOu0QANTmtdLYSRaft+be
 eo1/i84AK2sdXycUyPup+kWaMDsK6Og=
X-Proofpoint-GUID: 3pMWl_B-LGD2bebX2VOWKkUZdaKQa0O7
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIwMDE5MCBTYWx0ZWRfX8+WexHwaUnqv
 y8PP8vYGUw1fI5w19/DSMxhkJqSPTXS9jeVnlJlC922adwLkl7bnlvAOhIR2SGhyplBikToSy8C
 wf/c17fJ/IKxQIn3HBwDmCFWVioRARb2+efnsz7tE5AVIqwKy5FpvGFqU6J4ZE1/oTcDbB+Wi57
 TzIfNM7ntRUuVXymZn/HFh1WyzkGMHFB86ky5QOaUiIORPHQzvp5jaa81IpyChQ7Iym+Ri9QPXn
 0iGOiWd+vuDsB/dj4cHtgM/LV/OZwdrOhWIaYMRI9TMlG3yh0ZLBF+OAHcgwL84854LqZXr2f3a
 bds4gw3MrAkiY+cDDAzuZyuHgQO+6RzR7mYAc7hpiny2YvjCVOvuiZLyBomFI1Kvib/lJO0tcMM
 atqgOaQRW/7ejPWrq7Sma6ifXe7sHUyQUaw6auOO+GM36d9ZwILoyNU87XLO7ykmlHJl8YIKbK5
 NxKQ3a150hPoduRx88w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-20_04,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 phishscore=0 priorityscore=1501 clxscore=1015 spamscore=0
 adultscore=0 impostorscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609200190

On Wed, Aug 05, 2026 at 11:58:10AM +0530, Ojaswin Mujoo wrote:
> This adds initial support for performing buffered non-aio
> RWF_WRITETHROUGH write. The rough flow for a writethrough write is as
> follows:
> 
> 1. Acquire inode lock
> 2. initialize writethrough context (wt_ctx) and mark
>    mapping as stable.
> 3. Start the iomap_iter() loop. For each iomap:
>   3.1. Acquire folio and folio_lock.
>   3.2. perform memcpy from user buffer to the folio and mark it
>        dirty
>   3.3. Wait for any current writeback to complete and then call
>        folio_mkclean() to prevent mmap writes from changing it.
>   3.4. Start writeback on the folio
>   3.5. Add the folio range under write to wt_ctx->bvec and folio_unlock()
>   3.6. If bvec is full, submit the current bvecs for IO.
>   3.7. Repeat 3.2 to 3.6 till the whole iomap is processed. Submit
>        the final set of bvecs for IO.
> 4. Repeat step 3 till we have no more data to write.
> 5. Finally, sleep in the syscall thread till all the IOs are
>    completed (refcount == 0). Once that happens, the end io handler will
>    wake us up.
> 6. Upon waking up, call fs ->end_io() callback (which updates inode
>    size), record any errors and return.
> 7. inode_unlock()
> 
> This design gives buffered writethrough the same semantics as dio and
> any error in the IO is directly returned to the caller. However, the
> users should note that an error should be treated equivalent of a
> buffered IO fsync error, since we can't always guarantee that the page
> cache is consistent.
> 
> The design has deliberately open coded the IO submission and completion
> flow (inspired by dio) rather than reusing the dio functions as
> accommodating buffered writethrough logic in dio code was polluting it
> with too many if else conditionals and special cases.
> 
> Suggested-by: Jan Kara <jack@suse.cz>
> Suggested-by: Dave Chinner <dgc@kernel.org>
> Co-developed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>

Addressing Sashiko reviews here:

> ---
>  fs/iomap/buffered-io.c  | 437 ++++++++++++++++++++++++++++++++++++++++
>  include/linux/fs.h      |  11 +
>  include/linux/iomap.h   |  42 ++++
>  include/linux/pagemap.h |   1 +
>  include/uapi/linux/fs.h |   5 +-
>  mm/page-writeback.c     |  10 +
>  6 files changed, 505 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 0a5ebfda90f1..3178e8c0fa13 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -10,6 +10,7 @@
>  #include <linux/migrate.h>
>  #include <linux/fserror.h>
>  #include <linux/fsverity.h>
> +#include <linux/rmap.h>
>  #include "internal.h"
>  #include "trace.h"
>  
> @@ -1185,6 +1186,360 @@ static bool iomap_write_end(struct iomap_iter *iter, size_t len, size_t copied,
>  	return __iomap_write_end(iter->inode, pos, len, copied, folio);
>  }
>  
> +static ssize_t iomap_writethrough_complete(struct iomap_writethrough_ctx *wt_ctx)
> +{
> +	struct kiocb *iocb	= wt_ctx->iocb;
> +	struct inode *inode	= wt_ctx->inode;
> +	ssize_t ret		= wt_ctx->error;
> +
> +	if (wt_ctx->end_io) {
> +		int err = wt_ctx->end_io(wt_ctx, wt_ctx->written,
> +					 wt_ctx->error,
> +					 wt_ctx->flags);
> +		if (err)
> +			ret = err;
> +	}
> +
> +	mapping_dec_inflight_stable_writes(inode->i_mapping);
> +
> +	if (!ret) {
> +		ret = wt_ctx->written;
> +		iocb->ki_pos += ret;
> +	}
> +
> +	kfree(wt_ctx);
> +	return ret;
> +}
> +
> +static void iomap_writethrough_done(struct iomap_writethrough_ctx *wt_ctx)
> +{
> +	struct task_struct *waiter = wt_ctx->waiter;
> +
> +	WRITE_ONCE(wt_ctx->waiter, NULL);
> +	blk_wake_io_task(waiter);
> +}
> +
> +static void iomap_writethrough_bio_end_io(struct bio *bio)
> +{
> +	struct iomap_writethrough_ctx *wt_ctx = bio->bi_private;
> +	struct folio_iter fi;
> +
> +	if (bio->bi_status)
> +		cmpxchg(&wt_ctx->error, 0,
> +			blk_status_to_errno(bio->bi_status));
> +	bio_for_each_folio_all(fi, bio)
> +		folio_end_writeback(fi.folio);
> +
> +	bio_put(bio);
> +	if (atomic_dec_and_test(&wt_ctx->ref))
> +		iomap_writethrough_done(wt_ctx);
> +}
> +
> +static int
> +iomap_writethrough_submit_bio(struct iomap_writethrough_ctx *wt_ctx,
> +			      struct iomap *iomap,
> +			      const struct iomap_writethrough_ops *wt_ops, int error)
> +{
> +	struct bio *bio;
> +	unsigned int i;
> +	u64 len = 0;
> +	blk_opf_t opf = REQ_OP_WRITE | REQ_SYNC | REQ_IDLE;
> +
> +	if (!wt_ctx->nr_bvecs)
> +		goto exit;
> +
> +	for (i = 0; i < wt_ctx->nr_bvecs; i++)
> +		len += wt_ctx->bvec[i].bv_len;
> +
> +	bio = bio_alloc(iomap->bdev, wt_ctx->nr_bvecs, opf, GFP_NOFS);
> +	bio->bi_iter.bi_sector	= iomap_sector(iomap, wt_ctx->bio_pos);
> +	bio->bi_end_io		= iomap_writethrough_bio_end_io;
> +	bio->bi_private		= wt_ctx;
> +
> +	for (i = 0; i < wt_ctx->nr_bvecs; i++)
> +		__bio_add_page(bio, wt_ctx->bvec[i].bv_page,
> +				wt_ctx->bvec[i].bv_len,
> +				wt_ctx->bvec[i].bv_offset);
> +
> +	if (!error && wt_ops->writethrough_submit)
> +		error = wt_ops->writethrough_submit(wt_ctx->inode, iomap,
> +						    wt_ctx->bio_pos, len);
> +
> +
> +	atomic_inc(&wt_ctx->ref);
> +
> +	/*
> +	 * In case of error we still need the I/O completion to run so we can
> +	 * release references and end writeback on the folios.
> +	 */
> +	if (error) {
> +		bio->bi_status = errno_to_blk_status(error);
> +		bio_endio(bio);
> +		return error;
> +	}
> +
> +	submit_bio(bio);
> +	wt_ctx->nr_bvecs = 0;
> +
> +exit:
> +	return 0;
> +}
> +
> +/*
> + * Submit any pending bvecs as a bio and account the written bytes.
> + * On failure, iomap_writethrough_submit_bio() has already called the
> + * endio completion handler to record the error.
> + */
> +static int
> +iomap_writethrough_try_submit(struct iomap_writethrough_ctx *wt_ctx,
> +			      struct iomap *iomap,
> +			      const struct iomap_writethrough_ops *wt_ops,
> +			      ssize_t *pending)
> +{
> +	int ret = iomap_writethrough_submit_bio(wt_ctx, iomap, wt_ops, 0);
> +
> +	if (ret < 0)
> +		return ret;
> +	wt_ctx->written += *pending;
> +	*pending = 0;
> +	return 0;
> +}
> +
> +/**
> + * iomap_writethrough_begin - prepare the various structures for writethrough
> + * @folio: folio to prepare for writethrough
> + * @off: offset of write within folio
> + * @len: len of write within folio
> + *
> + * This function does the major preparation work needed before starting the
> + * writethrough. The main task is to prepare folio for writeththrough by blocking
> + * mmap writes and setting writeback on it. Further, we must clear the write range
> + * to non-dirty. If this results in the complete folio becoming non-dirty, then we
> + * need to clear the master dirty bit.
> + */
> +static void iomap_folio_prepare_writethrough(struct folio *folio, size_t off,
> +					     size_t len)
> +{
> +	bool fully_written;
> +	u64 zero = 0;
> +
> +	if (folio_test_writeback(folio))
> +		folio_wait_writeback(folio);
> +
> +	if (folio_mkclean(folio))
> +		folio_mark_dirty(folio);
> +
> +	/*
> +	 * We might either write through the complete folio or a partial folio
> +	 * writethrough might result in all blocks becoming non-dirty, so we need to
> +	 * check and mark the folio clean if that is the case.
> +	 */
> +	fully_written = (off == 0 && len == folio_size(folio));
> +	iomap_clear_range_dirty(folio, off, len);
> +	if (fully_written ||
> +	    !iomap_find_dirty_range(folio, &zero, folio_size(folio)))
> +		folio_clear_dirty_for_writethrough(folio);
> +
> +	folio_start_writeback(folio);
> +}
> +
> +/**
> + * iomap_writethrough_iter - perform RWF_WRITETHROUGH buffered write
> + * @wt_ctx: writethrough context
> + * @iter: iomap iter holding mapping information
> + * @i: iov_iter for write
> + * @wt_ops: the fs callbacks needed for writethrough
> + *
> + * This function copies the user buffer to folio similar to usual buffered
> + * IO path, with the difference that we immediately issue the IO. For this we
> + * utilize IO submission and completion mechanism that is inspired by dio.
> + *
> + * Folio handling note: We might be writing through a partial folio so we need
> + * to be careful to not clear the folio dirty bit unless there are no dirty blocks
> + * in the folio after the writethrough.
> + */
> +static int iomap_writethrough_iter(struct iomap_writethrough_ctx *wt_ctx,
> +				   struct iomap_iter *iter, struct iov_iter *i,
> +				   const struct iomap_writethrough_ops *wt_ops)
> +
> +{
> +	ssize_t total_written = 0, pending = 0;
> +	loff_t submit_start_pos;

    If an error occurs on the very first iteration before any data is written,
    the loop exits early.
    Will the uninitialized stack variable submit_start_pos be passed into
    iomap_write_failed() during the error cleanup path?

Yes this seems like a valid issue and can be fixed with:

 submit_failed:
-		iomap_write_failed(iter->inode, submit_start_pos, pending);
-		iomap_iter_revert(iter, pending);
-		iov_iter_revert(i, pending);
+		if (pending) {
+			iomap_write_failed(iter->inode, submit_start_pos, pending);
+			iomap_iter_revert(iter, pending);
+			iov_iter_revert(i, pending);
+		}

If we do fail in the first iter, then pending would not have been set
and we won't hit the issue. Regardless, guarding the reverts behind
pending makes sense because if we don't have any folios pending
submission, then no point to revert anything.

> +	int status = 0;
> +	struct address_space *mapping = iter->inode->i_mapping;
> +	size_t chunk = mapping_max_folio_size(mapping);
> +	unsigned int bdp_flags = (iter->flags & IOMAP_NOWAIT) ? BDP_ASYNC : 0;
> +	unsigned int bs = i_blocksize(iter->inode);
> +
> +	/* copied over based on how DIO handles these flags */
> +	if (iter->iomap.type == IOMAP_UNWRITTEN)
> +		wt_ctx->flags |= IOMAP_DIO_UNWRITTEN;
> +	if (iter->iomap.flags & IOMAP_F_SHARED)

<...>

> +
> +		bytes = iov_iter_count(i);
> +retry:
> +		offset = iter->pos & (chunk - 1);
> +		bytes = min(chunk - offset, bytes);
> +		status = balance_dirty_pages_ratelimited_flags(mapping,
> +							       bdp_flags);
> +		if (unlikely(status))
> +			break;
> +
> +		/*
> +		 * If completions already occurred and reported errors, give up
> +		 * now and don't bother submitting more bios.
> +		 */
> +		status = data_race(wt_ctx->error);
> +		if (unlikely(status)) {
> +			wt_ctx->nr_bvecs = 0;
> +			break;
> +		}

    If an asynchronous error is detected here, the pending bvec count is zeroed
    out and the loop breaks.
    Since folios from previous iterations were already added to the bvec array and
    marked as PG_writeback, does this leak the PG_writeback state and abandon
    those folios permanently?

Yes if we set nr_bvecs = 0 here, the error handling in
iomap_writethrough_submit_bio() -> bio_endio() will pass an empty bio
and hence the references will leak. I will fix this in next verison.

<...>

> +		copied = copy_folio_from_iter_atomic(folio, offset, bytes, i);
> +		written = iomap_write_end(iter, bytes, copied, folio) ?
> +			  copied : 0;
> +
> +		old_size = iter->inode->i_size;
> +		if (pos + written > old_size)
> +			i_size_write(iter->inode, pos + written);
> +
> +		if (!written)
> +			goto put_folio;
> +
> +		off_aligned = round_down(offset, bs);
> +		len_aligned = round_up(offset + written, bs) - off_aligned;
> +
> +		iomap_folio_prepare_writethrough(folio, off_aligned,
> +						 len_aligned);
> +
> +		if (!wt_ctx->nr_bvecs) {
> +			wt_ctx->bio_pos = round_down(pos, bs);
> +			submit_start_pos = pos;
> +		}
> +
> +		bvec_set_folio(&wt_ctx->bvec[wt_ctx->nr_bvecs], folio,
> +			       len_aligned, off_aligned);

  If a short copy occurs within a single filesystem block, the offset and
  length are aligned to the block size.
  When the remainder of the short copy is processed on the next iteration,
  will this append an identical, duplicate bvec for the same block? The block
  layer would then write the duplicate segment into the next logical sector,
  potentially corrupting adjacent data on disk.

Oh right, we might end up adding the exact same block to the bvec which
is not correct, this can lead to the bio iter becoming corrupt. I think
we will have to somehow track the previous offset added to bio and make
sure that bit is not re added. I'll look into this. 

Rest are some minor comments that I'll address in next version.

Regards,
ojaswin


