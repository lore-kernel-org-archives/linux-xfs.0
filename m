Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794406939;
	b=1yhtoaBb97fxMCPNYe6wwNR3brsLxVg2t5vSp2Wpdh3/7SASPHQMCEJ280HBkTdVKs5t
	 h0ZSnJsWpKtcBCgfHqQ/x/3vZTonuXnu1yM0JDSVen488sXlnMteWeIAJJBAQgiGCAV7R
	 n+fz36m+rLUMyyU4OO1zHU47Sb0IHY+XYOb2l+2VwUl5q6RskIh+WUBWl05f6knF14NWs
	 zcysywxMDvBqjGH+Bvfkz/zvJO4LHJEGpxvdS0PXsWbOXiFLkWaKidP9YkjSRvZJL9f/5
	 4saAnlm+MxDw1GeHwMm7LJVPmm1IxAV6tobcRxeEsnoEvgqMZqJsXIAr79ESMd3jLBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794406939;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Scanned-By;
	bh=s9mQE25+Qfpx9tF12B/fqXT+5fZAl/3JqrfvD0xw+WA=;
	b=4qQ54nUkcn7zdI8Ego2NLM1F7mXUQUSJ2yt6hJl0/WX9uYHfeCFeBsQXHgtAWRR1DJMK
	 9cq5PD6GzwLHrJWys1LSht2mQZnODTEnJhFPEGi4a2TdZBy2HA3xe3zbUam2M3ZqZEMzP
	 fQZV4oB60nUw4e4MdUeSA/DrnWPZ1bChSRqHHB2ImJexeDX2PNKZ8XPL4RjBg2p7kE4a+
	 xkj4XpGBlcVS2F9wUD1bA4NKaBTKueTqhzJsYcIf0B58G5Jfz03JuNc19TD0CDVBa5L76
	 StnkfPHu6YLzqeB6I8KoYf27KqLIPH5KpdcUIezBa3WaYTrTPUJ4DK5cYkNYYxZSK+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=gjULlZhJ;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39611606A33E
	for <linux-xfs@vger.kernel.org>; Wed, 11 Nov 2026 14:22:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 39611606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=gjULlZhJ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794406938;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=s9mQE25+Qfpx9tF12B/fqXT+5fZAl/3JqrfvD0xw+WA=;
	b=gjULlZhJNvFKYsqmYXVwibVSGfkg8/I83081YboD8cZj719PTeJEE5H/tbLTrUrDpL46hg
	AW+ZAidpyawUozUzONAJgipEfKKxkTUYeUb91FwBmqXOFbMyBipv+x6eMZnqOM41b3bX9U
	MBN0KByHyW7U9j8/eig+84oLZNGrz4k=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-673-wAzdZVctPd-82sdroRI-zA-1; Wed,
 11 Nov 2026 09:22:15 -0500
X-MC-Unique: wAzdZVctPd-82sdroRI-zA-1
X-Mimecast-MFC-AGG-ID: wAzdZVctPd-82sdroRI-zA_1794406934
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E7D781956060;
	Wed, 11 Nov 2026 14:22:13 +0000 (UTC)
Received: from bfoster (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0F4DD195608C;
	Wed, 11 Nov 2026 14:22:11 +0000 (UTC)
Date: Wed, 11 Nov 2026 09:22:09 -0500
From: Brian Foster <bfoster@redhat.com>
To: daejun7.park@samsung.com
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] xfs: number the cache flushes submitted to each
 buftarg
Message-ID: <avR6EXipxwKzRlRN@bfoster>
References: <20261111-xfs-fsync-flush-seq-v2-0-b5c00c25d276@samsung.com>
 <20261111-xfs-fsync-flush-seq-v2-1-b5c00c25d276@samsung.com>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261111-xfs-fsync-flush-seq-v2-1-b5c00c25d276@samsung.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Wed, Nov 11, 2026 at 12:17:11PM +0900, Daejun Park via B4 Relay wrote:
> From: Daejun Park <daejun7.park@samsung.com>
> 
> fsync can only skip its own cache flush when its log force wrote out
> the iclog. It cannot tell whether a flush that another task submitted
> covers its data.
> 
> Number the cache flushes that the log code submits to each buftarg,
> and record the highest number that completed without error. Nothing
> reads the numbers yet.
> 
> Signed-off-by: Daejun Park <daejun7.park@samsung.com>
> ---
>  fs/xfs/xfs_buf.c      | 13 +++++++++++++
>  fs/xfs/xfs_buf.h      | 21 +++++++++++++++++++++
>  fs/xfs/xfs_log.c      | 28 +++++++++++++++++++++-------
>  fs/xfs/xfs_log_priv.h |  1 +
>  4 files changed, 56 insertions(+), 7 deletions(-)
> 
...
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 74b324f915a..d99a5b678cf 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
> @@ -1211,6 +1211,8 @@ xlog_ioend_work(
>  		xlog_force_shutdown(log, SHUTDOWN_LOG_IO_ERROR);
>  	}
>  
> +	if (!error && iclog->ic_flush_seq)
> +		xfs_buftarg_flush_done(log->l_targ, iclog->ic_flush_seq);

Taking another look at this I started to also wonder whether to store
this flush seq in the xlog_flush_done struct. It looks like we reuse
that for multiple async flushes in flight, however, so probably not
worth the complication to try and track all that there.

Thanks for the tweaks and this all looks reasonable to me:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  	xlog_state_done_syncing(iclog);
>  	bio_uninit(&iclog->ic_bio);
>  
> @@ -1570,19 +1572,21 @@ xlog_flush_end_io(
>  	bio_put(bio);
>  }
>  
> -static void
> +static s64
>  xlog_flush_async(
>  	struct xlog_flush_done	*done,
> -	struct block_device	*bdev)
> +	struct xfs_buftarg	*btp)
>  {
>  	struct bio		*bio;
> +	s64			seq = xfs_buftarg_flush_start(btp);
>  
> -	bio = bio_alloc(bdev, 0, REQ_OP_WRITE | REQ_PREFLUSH | REQ_SYNC,
> +	bio = bio_alloc(btp->bt_bdev, 0, REQ_OP_WRITE | REQ_PREFLUSH | REQ_SYNC,
>  			GFP_NOFS);
>  	bio->bi_private = done;
>  	bio->bi_end_io = xlog_flush_end_io;
>  	atomic_inc(&done->pending);
>  	submit_bio(bio);
> +	return seq;
>  }
>  
>  /*
> @@ -1605,16 +1609,17 @@ xlog_flush_data_caches(
>  		.pending	= ATOMIC_INIT(1),
>  		.done		= COMPLETION_INITIALIZER_ONSTACK(done.done),
>  	};
> +	s64			dseq = 0, rseq = 0, lseq;
>  
>  	*did_flush = false;
>  	if (mp->m_ddev_targp != mp->m_logdev_targp &&
>  	    bdev_write_cache(mp->m_ddev_targp->bt_bdev)) {
> -		xlog_flush_async(&done, mp->m_ddev_targp->bt_bdev);
> +		dseq = xlog_flush_async(&done, mp->m_ddev_targp);
>  		*did_flush = true;
>  	}
>  	if (mp->m_rtdev_targp && mp->m_rtdev_targp != mp->m_ddev_targp &&
>  	    bdev_write_cache(mp->m_rtdev_targp->bt_bdev)) {
> -		xlog_flush_async(&done, mp->m_rtdev_targp->bt_bdev);
> +		rseq = xlog_flush_async(&done, mp->m_rtdev_targp);
>  		*did_flush = true;
>  	}
>  
> @@ -1623,12 +1628,17 @@ xlog_flush_data_caches(
>  		 * If we flushed any other device, also use an async flush for
>  		 * the log device so that all flushes happen in parallel.
>  		 */
> -		xlog_flush_async(&done, mp->m_logdev_targp->bt_bdev);
> +		lseq = xlog_flush_async(&done, mp->m_logdev_targp);
>  
>  		xlog_flush_done(&done);
>  		wait_for_completion(&done.done);
>  		if (done.status)
>  			return -EIO;
> +		if (dseq)
> +			xfs_buftarg_flush_done(mp->m_ddev_targp, dseq);
> +		if (rseq)
> +			xfs_buftarg_flush_done(mp->m_rtdev_targp, rseq);
> +		xfs_buftarg_flush_done(mp->m_logdev_targp, lseq);
>  	}
>  
>  	return 0;
> @@ -1678,14 +1688,18 @@ xlog_write_iclog(
>  	iclog->ic_bio.bi_iter.bi_sector = log->l_logBBstart + bno;
>  	iclog->ic_bio.bi_end_io = xlog_bio_end_io;
>  	iclog->ic_bio.bi_private = iclog;
> +	iclog->ic_flush_seq = 0;
>  
>  	if (iclog->ic_flags & XLOG_ICL_NEED_FLUSH) {
>  		if (xlog_flush_data_caches(log->l_mp, &did_flush))
>  			goto shutdown;
>  	}
>  	if (!did_flush &&
> -	    (iclog->ic_flags & (XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FLUSH_LOG)))
> +	    (iclog->ic_flags &
> +	     (XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FLUSH_LOG))) {
>  		iclog->ic_bio.bi_opf |= REQ_PREFLUSH;
> +		iclog->ic_flush_seq = xfs_buftarg_flush_start(log->l_targ);
> +	}
>  	if (iclog->ic_flags & XLOG_ICL_NEED_FUA)
>  		iclog->ic_bio.bi_opf |= REQ_FUA;
>  
> diff --git a/fs/xfs/xfs_log_priv.h b/fs/xfs/xfs_log_priv.h
> index 529720a4984..df0f13c4e04 100644
> --- a/fs/xfs/xfs_log_priv.h
> +++ b/fs/xfs/xfs_log_priv.h
> @@ -222,6 +222,7 @@ struct xlog_in_core {
>  #endif
>  	struct semaphore	ic_sema;
>  	struct work_struct	ic_end_io_work;
> +	s64			ic_flush_seq;	/* buftarg flush number */
>  	struct bio		ic_bio;
>  	struct bio_vec		ic_bvec[];
>  };
> 
> -- 
> 2.43.0
> 
> 
> 

