Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794246258;
	b=qIbQfuOQf/hjZXN6Sdx/qiVg1D/NXSIU8YFGNcbs6fpF4PalLn9QurghGVb4aABoABCo
	 BRw21ytDTVzeopyZs/KRk1xAuSw0JjVY6ICn2DRwudFwKffoyMuHPP22nRt1+QbyGexPf
	 fbpswyBkakhSsFnP74d4NpMp8DOOV5M/zdQAF8MGMezwNYecPX96Yj1993Js7UuTCKDIr
	 IkN6G0V5IrFUhy7dO4xV76ylUbUXlXcbBGQWxoPEXLK3xQtaVRyu5fMfHBX0MVtIVHBK9
	 UpNlH6DYx0P2rs/g9MW2Xj2CTUcGJiLrcF1XI7xBESU9v3h8PNS611DtURNh/MFX6WA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794246258;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Scanned-By;
	bh=eVAHGU5PSbZXKclTl1jGH8UX/dsV2fmTA+WOr1aEOQU=;
	b=EfodvRIawV3FHCGJo5k7GhR7BJtKG+FtSdpAzQQwu7Vv4OizYXCk82S7nIEhEo/8sJCo
	 +2HSV4D6uq0Y/kcWnIi5zYkAQXGw/UES+iBRN2ehEmKD7YyznkiTHL2CcWFpA9Utx/jBw
	 FaGOMesoug8fWwpVDOfs0oUGVgYHrmpv8gqgOdcKGYXQdL3VeconvE8F6AyrB2urqrGg+
	 n1n3dlvZvb4VP3ymoUAW9sazV5a4Sazi+lnYLq0dEHybJmdD7Tui7vNVEvCHuf/pnM1yw
	 Fenltssb8SaEZJgZrMHnbLkD4mSmbtRKWWIQlRJlCaGShN05EHUvtI7NHzFtTtfKDxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ghzGWHSt;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84317606A31C
	for <linux-xfs@vger.kernel.org>; Mon,  9 Nov 2026 17:44:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 84317606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=ghzGWHSt
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1794246256;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eVAHGU5PSbZXKclTl1jGH8UX/dsV2fmTA+WOr1aEOQU=;
	b=ghzGWHStHzuW5EsNyEmC4PhDziKZw5/bKuXwtbLftRlZl0M8zaAiu/EA9P5o7cn6LV3Lwc
	vbw18ckGSBFi7euycBLUcqDIElbmYVaTbitEdzVyyvg1tirs1JyeS8Rg6oOhcMaGatehTW
	5qf4EHYS9InnufmdMqX9kkRJkaCEx2M=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-21-pBjjCsViOXmzSb4IHp4UOw-1; Mon,
 09 Nov 2026 12:44:14 -0500
X-MC-Unique: pBjjCsViOXmzSb4IHp4UOw-1
X-Mimecast-MFC-AGG-ID: pBjjCsViOXmzSb4IHp4UOw_1794246252
Received: from mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.95])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7E1661801337;
	Mon,  9 Nov 2026 17:44:11 +0000 (UTC)
Received: from bfoster (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-10.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CDA39431;
	Mon,  9 Nov 2026 17:44:09 +0000 (UTC)
Date: Mon, 9 Nov 2026 12:44:07 -0500
From: Brian Foster <bfoster@redhat.com>
To: daejun7.park@samsung.com
Cc: Carlos Maiolino <cem@kernel.org>, linux-xfs@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, Dave Chinner <david@fromorbit.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Amir Goldstein <amir73il@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] xfs: number the cache flushes submitted to each
 buftarg
Message-ID: <avIGZ9ABd_pXSy1L@bfoster>
References: <20261105-xfs-fsync-flush-seq-v1-0-299bdf5e28c3@samsung.com>
 <20261105-xfs-fsync-flush-seq-v1-1-299bdf5e28c3@samsung.com>
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
In-Reply-To: <20261105-xfs-fsync-flush-seq-v1-1-299bdf5e28c3@samsung.com>
X-Scanned-By: MIMEDefang 3.6 on 10.30.177.95

On Thu, Nov 05, 2026 at 11:49:12AM +0900, Daejun Park via B4 Relay wrote:
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
>  fs/xfs/xfs_log.c      | 25 +++++++++++++++++++------
>  fs/xfs/xfs_log_priv.h |  1 +
>  4 files changed, 54 insertions(+), 6 deletions(-)
> 
...
> diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
> index 74b324f915a..734daa4e99b 100644
> --- a/fs/xfs/xfs_log.c
> +++ b/fs/xfs/xfs_log.c
...
> @@ -1688,6 +1698,9 @@ xlog_write_iclog(
>  		iclog->ic_bio.bi_opf |= REQ_PREFLUSH;
>  	if (iclog->ic_flags & XLOG_ICL_NEED_FUA)
>  		iclog->ic_bio.bi_opf |= REQ_FUA;
> +	iclog->ic_flush_seq = 0;
> +	if (iclog->ic_bio.bi_opf & REQ_PREFLUSH)
> +		iclog->ic_flush_seq = xfs_buftarg_flush_start(log->l_targ);

Bit of a nit, but it looks like this would be cleaner if we moved both
of these a bit further up. I.e., zero ->ic_flush_seq right after where
we init the iclog->ic_bio fields, and then move the assignment under the
same block where we set the PREFLUSH flag. Hm?

Brian

>  
>  	iclog->ic_flags &= ~(XLOG_ICL_NEED_FLUSH | XLOG_ICL_NEED_FLUSH_LOG |
>  			     XLOG_ICL_NEED_FUA);
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

