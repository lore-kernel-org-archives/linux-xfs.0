Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 533B7493D38;
	Mon, 21 Sep 2026 12:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789992921; cv=none; b=fRfTIHQGCBQc9a+moKrxzRzQk21rJUUR35bEiW8wS01oru2X4PKP7B/mCQhclnxNxmNUpAJrgKBIvKCE2ASEroPmzUAnn0f9cD5s7YYu3e9Aq/ZBvXSyPdNfx2JdcVIgjO86fsGmVC7BcJcZvNYikZlSVgpOk1YoDFCPfemipWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789992921; c=relaxed/simple;
	bh=iWZdsl+xqjXJi07BT/5/PGctt7tq53qCbq75i1fxwj8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cS0x8g8Amx5cT0VQsCsoGuiAF9WJBId1kwpPDKGoPAC2e6cVt3Q8gIqP0zUJWiti1ETuOcc5ce68kMeukGse/irXk9gD5fQp+xH54P/i9pE+EMt4hkoc1UX7IiDaEfTAj8Ci0DQWkGZDwukK12EK97SnwSIvyHRoaVJE2dVMFm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=fJCZXQ79; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="fJCZXQ79"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68LB5adW1169471;
	Mon, 21 Sep 2026 12:14:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=pp1; bh=KlIoX8DBbrVxuzYYmhCQQ/DoPkWrTF
	diYOjF+pELcfk=; b=fJCZXQ79ieQVcrQPOL8zbas6wGRJlhyScxap+PX1miFbXh
	ItKRot8eF2h+H/V0XtE5KPolvKnIG7JOBwJpuvammHO/GLF/sYN+XeYuuLO97dhS
	p+rwJok8pQGMRcDTa46sEpo4VMpzKbgOjAB3wCV78YKr0PnP3FNuXjFPTITeCinn
	QLwE6ExlhMaeRmnqksR3GLlZ3FABcWe6QIQQOqwvYqFJ+CEYuaWRCFK8V0VWRgso
	HcAMRctefKp02WgwaYFmp+K9kvqBpP4m0yjLNNWSFiAh7h6MHpmQh9iI8j/HyNNu
	eJEVSMMWjlujK+NmZJOvW4CeSL5EC59KVxyAU9aQ==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4gske1892j-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Mon, 21 Sep 2026 12:14:37 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 68LAlkhF1072449;
	Mon, 21 Sep 2026 12:14:37 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4gt5qjn5rx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 21 Sep 2026 12:14:36 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 68LCEYwu43647276
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 21 Sep 2026 12:14:35 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CF0E620043;
	Mon, 21 Sep 2026 12:14:34 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2A1732004B;
	Mon, 21 Sep 2026 12:14:29 +0000 (GMT)
Received: from li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com (unknown [9.39.16.92])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 21 Sep 2026 12:14:28 +0000 (GMT)
Date: Mon, 21 Sep 2026 17:44:26 +0530
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
Subject: Re: [RFC PATCH v3 10/11] iomap: Avoid folio dirtying in case of
 RWF_WRITETHROUGH
Message-ID: <arEfolC7StyEwYDW@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
References: <cover.1785908600.git.ojaswin@linux.ibm.com>
 <a6fcdf05d11c954d2d277844b6db3b11d97d63e0.1785908600.git.ojaswin@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a6fcdf05d11c954d2d277844b6db3b11d97d63e0.1785908600.git.ojaswin@linux.ibm.com>
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: pHmRxKGPlRzG52mO4DLBalc284_Ad0VR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIxMDE3NSBTYWx0ZWRfX7z0asys1bpIq
 x8FK84wv1uFNJXF6duI/6t5NM5AvmeoV9QPqQkjZ6kfpTVx7d7e4CCJ9/ExmmCe9TFzuFPV8HYu
 h0AQQsuSuhlfC1ZLQPeY0KH2n9pG1/rmobnIiFgpqC8kQMq8+uPlISvuwXiaPiTcW6ysfiI89d5
 47piWFuF6zBSUrWT2f3QxGGC2i1svuzh+wWeGlnTUX3f/MqxFH5IhTO+E2TDkAbpyhdzMjty/A7
 E7ZNPrCxmqYSY9XG/IIG48D7UBiCqh912ETAM+SDqgkUShdMH0JRSevB43gj0cyE+xVC04fh5L+
 Npkdjd3J7E4jE/uEviva1u2Yv9Exs6isNu+dYe9ooxWzvDv+eTw3EfR9u/CrY9i/StrdVJLhdBm
 i3ctyGRODKkRwtahUmcXOPZTLZSpbt4pOsdpizLnLcS6YlioiBS99ZjmYTvcmDLh6SG/vbNMlT4
 kDGsSl7aYDf1GXdPOww==
X-Authority-Analysis: v=2.4 cv=O/KsLx9W c=1 sm=1 tr=0 ts=6ab11fae cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=kj9zAlcOel0A:10 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=pGLkceISAAAA:8
 a=VnNF1IyMAAAA:8 a=F_nSmi8lrBEryJAH2XgA:9 a=CjuIK1q_8ugA:10
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIxMDE3NSBTYWx0ZWRfX0+H0I/XXrF9g
 JYQuigv9yIl79q1BgGtlhcYmv15jXZlCyAyOllPweGC5JmMrAh73nqKOIim13gUEWLd3TeeznaF
 8/D0ooX1Un10sjMcfsGMUdxoCPNiBkI=
X-Proofpoint-GUID: yWRbclxixGgcZ_Rz6wGgD5ncCMWYPLlu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-21_04,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 phishscore=0 impostorscore=0 suspectscore=0
 bulkscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609210175

On Wed, Aug 05, 2026 at 11:58:16AM +0530, Ojaswin Mujoo wrote:
> RWF_WRITETHROUGH dirties the folio only to send it for IO immediately,
> in the same context. Due to this, we can optimize away the folio
> dirtying and clearing step usually seen in buffered IO. Althrough we can
> do away with most of the accounting there are a couple of counters we
> need to take care of which we do during IO submission/completion.
> 
> Co-developed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
> Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> ---
>  fs/iomap/buffered-io.c  | 64 +++++++++++++++++++++++++++++++++--------
>  include/linux/pagemap.h |  1 +
>  mm/filemap.c            | 21 ++++++++++++++
>  3 files changed, 74 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index d16694dd9995..0844361fe0f1 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -11,6 +11,9 @@
>  #include <linux/fserror.h>
>  #include <linux/fsverity.h>
>  #include <linux/rmap.h>
> +#include <linux/task_io_accounting_ops.h>
> +#include "linux/pagemap.h"
> +#include "linux/page-flags.h"
>  #include "internal.h"
>  #include "trace.h"
>  
> @@ -1162,6 +1165,34 @@ static bool iomap_write_end_inline(const struct iomap_iter *iter,
>  	return true;
>  }
>  
> +/*
> + * __iomap_writethrough_end() is almost same as __iomap_write_end() but with the difference
> + * that we don't mark folio dirty since we are about to issue it for IO anyways.
> + * Consequently, most of the accounting is skipped.
> + */
> +static bool __iomap_writethrough_end(struct inode *inode, loff_t pos, size_t len,
> +		size_t copied, struct folio *folio)
> +{
> +	flush_dcache_folio(folio);
> +
> +	/*
> +	 * The blocks that were entirely written will now be up-to-date, so we
> +	 * don't have to worry about a read_folio reading them and overwriting a
> +	 * partial write.  However, if we've encountered a short write and only
> +	 * partially written into a block, it will not be marked up-to-date, so a
> +	 * read_folio might come in and destroy our partial write.
> +	 *
> +	 * Do the simplest thing and just treat any short write to a
> +	 * non-uptodate page as a zero-length write, and force the caller to
> +	 * redo the whole thing.
> +	 */
> +	if (unlikely(copied < len && !folio_test_uptodate(folio)))
> +		return false;
> +	iomap_set_range_uptodate(folio, offset_in_folio(folio, pos), len);
> +	return true;
> +}
> +
> +
>  /*
>   * Returns true if all copied bytes have been written to the pagecache,
>   * otherwise return false.
> @@ -1183,7 +1214,10 @@ static bool iomap_write_end(struct iomap_iter *iter, size_t len, size_t copied,
>  		return bh_written == copied;
>  	}
>  
> -	return __iomap_write_end(iter->inode, pos, len, copied, folio);
> +	if (iter->flags & IOMAP_WRITETHROUGH)
> +		return __iomap_writethrough_end(iter->inode, pos, len, copied, folio);
> +	else
> +		return __iomap_write_end(iter->inode, pos, len, copied, folio);
>  }
>  
>  static ssize_t iomap_writethrough_complete(struct iomap_writethrough_ctx *wt_ctx)
> @@ -1254,7 +1288,7 @@ static void iomap_writethrough_bio_end_io(struct bio *bio)
>  		cmpxchg(&wt_ctx->error, 0,
>  			blk_status_to_errno(bio->bi_status));
>  	bio_for_each_folio_all(fi, bio)
> -		folio_end_writeback(fi.folio);
> +		folio_end_writethrough(fi.folio, wt_ctx->error);
>  
>  	bio_put(bio);
>  	if (atomic_dec_and_test(&wt_ctx->ref))
> @@ -1299,9 +1333,11 @@ iomap_writethrough_submit_bio(struct iomap_writethrough_ctx *wt_ctx,
>  
>  	/*
>  	 * In case of error we still need the I/O completion to run so we can
> -	 * release references and end writeback on the folios.
> +	 * release references, handle accounting and end writeback on the
> +	 * folios.
>  	 */
>  	if (error) {
> +		task_io_account_cancelled_write(len);
>  		bio->bi_status = errno_to_blk_status(error);
>  		bio_endio(bio);
>  		return error;
> @@ -1351,6 +1387,7 @@ static void iomap_folio_prepare_writethrough(struct folio *folio, size_t off,
>  {
>  	bool fully_written;
>  	u64 zero = 0;
> +	u64 tmp_off = off;
>  
>  	if (folio_test_writeback(folio))
>  		folio_wait_writeback(folio);
> @@ -1359,17 +1396,20 @@ static void iomap_folio_prepare_writethrough(struct folio *folio, size_t off,
>  		folio_mark_dirty(folio);
>  
>  	/*
> -	 * We might either write through the complete folio or a partial folio
> -	 * writethrough might result in all blocks becoming non-dirty, so we need to
> -	 * check and mark the folio clean if that is the case.
> +	 * For writethrough, we don't mark the write range dirty but we still
> +	 * need clear the dirty range if someone else has dirtied it before.
> +	 * Further, if the clearing results in folio becoming completely clean,
> +	 * then we need to take care of accounting.
>  	 */
> -	fully_written = (off == 0 && len == folio_size(folio));
> -	iomap_clear_range_dirty(folio, off, len);
> -	if (fully_written ||
> -	    !iomap_find_dirty_range(folio, &zero, folio_size(folio)))
> -		folio_clear_dirty_for_writethrough(folio);
> +	if (iomap_find_dirty_range(folio, &tmp_off, tmp_off + len)) {
> +		iomap_clear_range_dirty(folio, off, len);

   Does this fail to clear the dirty flag for filesystems without sub-folio state?
   When the filesystem lacks sub-folio state (for example, when block size equals
   page size and ifs is NULL), iomap_find_dirty_range() unconditionally returns
   the queried range length.
   This means !iomap_find_dirty_range() will evaluate to !(folio_size(folio)),
   which is always false. The folio_clear_dirty_for_writethrough() call is then
   bypassed, leaving fully overwritten folios dirty in the page cache.

Right, this is true, we need to also consider if a folio doesn't have
ifs. Will fix this.

>  
> -	folio_start_writeback(folio);
> +		if (!iomap_find_dirty_range(folio, &zero, folio_size(folio)))
> +			folio_clear_dirty_for_writethrough(folio);
> +	}
> +
> +	task_io_account_write(folio_nr_pages(folio) * PAGE_SIZE);
> +	folio_test_set_writeback(folio);

  Does this bypass setting PAGECACHE_TAG_WRITEBACK in the mapping's xarray?
  Using folio_test_set_writeback() directly sets the PG_writeback flag on the
  folio but skips the xarray tagging performed by __folio_start_writeback().
  If fsync() or filemap_fdatawait_range() is called later, they iterate over
  the xarray looking for this tag to wait for in-flight IO. Because the tag
  is missing, they will return immediately while the IO is still in progress,
  breaking data durability guarantees.

Hmm, looking into it, yes I think this is correct, the WRITEBACK tag is
definitely needed. So I think we might not be able to use just the
master bit here.

Regards,
ojaswin

>  }
>  
>  /**
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index b20e38cc0fa0..774a2e57a9e0 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -1257,6 +1257,7 @@ void folio_wait_writeback(struct folio *folio);
>  int folio_wait_writeback_killable(struct folio *folio);
>  void end_page_writeback(struct page *page);
>  void folio_end_writeback(struct folio *folio);
> +void folio_end_writethrough(struct folio *folio, bool error);
>  void folio_end_writeback_no_dropbehind(struct folio *folio);
>  void folio_end_dropbehind(struct folio *folio);
>  void folio_wait_stable(struct folio *folio);
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 58eb9d240643..a1a5f8837e03 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1695,6 +1695,27 @@ void folio_end_writeback(struct folio *folio)
>  }
>  EXPORT_SYMBOL(folio_end_writeback);
>  
> +/**
> + * folio_end_writethrough - End writethrough against a folio
> + * @folio: The folio.
> + * error: Was there an error in IO.
> + *
> + * Context: May be called from process or interrupt context.
> + */
> +void folio_end_writethrough(struct folio *folio, bool error)
> +{
> +	long nr = folio_nr_pages(folio);
> +
> +	VM_BUG_ON_FOLIO(!folio_test_writeback(folio), folio);
> +
> +	if (!error)
> +		node_stat_mod_folio(folio, NR_WRITTEN, nr);
> +
> +	if (folio_xor_flags_has_waiters(folio, 1 << PG_writeback))
> +		folio_wake_bit(folio, PG_writeback);
> +}
> +EXPORT_SYMBOL(folio_end_writethrough);
> +
>  /**
>   * __folio_lock - Get a lock on the folio, assuming we need to sleep to get it.
>   * @folio: The folio to lock
> -- 
> 2.55.0
> 
> 
