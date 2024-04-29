Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5594854745
	for <linux-xfs@vger.kernel.org>; Mon, 29 Apr 2024 12:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714392973; cv=none; b=BuizIgC3COn4RcUEzeasiEPBp/NY4G0G4NdXjo6da9BhDsmidFvN2srgh1qWUkIKQp6jj4xX4X0iuvaUk3airVjY/eTzjvG9Uo1hDj6p8JBzr68h/Kbc+vyb0BnMMou25Tsv98/r86jB5zbIR+CzcvaCZav9JUEFzQ2AV3kj/Uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714392973; c=relaxed/simple;
	bh=14jXhHB1O9d5Gt1jBmcmPtJHiAMbuE2DMfbfyjVnJdM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n5AgUd1opCXqiDaGSEMwMvkHbIF/E8JB8fSesng4XhkWnkrTZDZUjaY727pcyYuJtfPZDaMzgOl7hFlFlw9Bf+TYJlKn0nZgDXCAEYqV1lqpR5Qj3RaJ7OALoOZEpc6AvhoKA6jDup2KppHYGmSPLTFFcSkG/wVPvs1+LtRmNpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ci3scIJC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ci3scIJC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714392969;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6oAnzUIPxo+dDwGLBnZ5GcUq5ApPoGNSNSwZRglqlvY=;
	b=ci3scIJCOtSBLAi+e2RI7Dcv4qCMz/m8QS8iiKEhDxlHl0npBeJVaLq0zgii+5GJge24dU
	zmpZv1SXee/nsscelDCdW/m6UhSDMHVNF0B8CBGKsJ9SjY6xbD1DJDeAvoMbQLf80Y2Y3r
	HJs6+FZekfX19bg95HQzrz+H5z0ZP6w=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-30-dmAKzFnlM02u6O_9HTRoYA-1; Mon, 29 Apr 2024 08:16:05 -0400
X-MC-Unique: dmAKzFnlM02u6O_9HTRoYA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4056180B704;
	Mon, 29 Apr 2024 12:16:05 +0000 (UTC)
Received: from bfoster (unknown [10.22.32.117])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id E6714400EB2;
	Mon, 29 Apr 2024 12:16:04 +0000 (UTC)
Date: Mon, 29 Apr 2024 08:18:23 -0400
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Sam Sun <samsun1006219@gmail.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] xfs: fix log recovery buffer allocation for the
 legacy h_size fixup
Message-ID: <Zi-QD8IdNCFHOyu7@bfoster>
References: <20240429070200.1586537-1-hch@lst.de>
 <20240429070200.1586537-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240429070200.1586537-2-hch@lst.de>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

On Mon, Apr 29, 2024 at 09:01:58AM +0200, Christoph Hellwig wrote:
> Commit a70f9fe52daa ("xfs: detect and handle invalid iclog size set by
> mkfs") added a fixup for incorrect h_size values used for the initial
> umount record in old xfsprogs versions.  But it is not using this fixed
> up value to size the log recovery buffer, which can lead to an out of
> bounds access when the incorrect h_size does not come from the old mkfs
> tool, but a fuzzer.
> 
> Fix this by open coding xlog_logrec_hblks and taking the fixed h_size
> into account for this calculation.
> 
> Fixes: a70f9fe52daa ("xfs: detect and handle invalid iclog size set by mkfs")
> Reported-by: Sam Sun <samsun1006219@gmail.com>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

The commit log/fixes tag are incorrect... xlog_logrec_hblks() didn't
exist at the time a70f9fe52daa was committed. I suspect this broke later
in commit 0c771b99d6c9 ("xfs: clean up calculation of LR header
blocks"), but please double check.

Otherwise the code changes look fine to me, so with the commit log fixed
up:

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_log_recover.c | 20 ++++++++++++++------
>  1 file changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index b445e8ce4a7d21..bb8957927c3c2e 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -2999,7 +2999,7 @@ xlog_do_recovery_pass(
>  	int			error = 0, h_size, h_len;
>  	int			error2 = 0;
>  	int			bblks, split_bblks;
> -	int			hblks, split_hblks, wrapped_hblks;
> +	int			hblks = 1, split_hblks, wrapped_hblks;
>  	int			i;
>  	struct hlist_head	rhash[XLOG_RHASH_SIZE];
>  	LIST_HEAD		(buffer_list);
> @@ -3055,14 +3055,22 @@ xlog_do_recovery_pass(
>  		if (error)
>  			goto bread_err1;
>  
> -		hblks = xlog_logrec_hblks(log, rhead);
> -		if (hblks != 1) {
> -			kvfree(hbp);
> -			hbp = xlog_alloc_buffer(log, hblks);
> +		/*
> +		 * This open codes xlog_logrec_hblks so that we can reuse the
> +		 * fixed up h_size value calculated above.  Without that we'd
> +		 * still allocate the buffer based on the incorrect on-disk
> +		 * size.
> +		 */
> +		if (h_size > XLOG_HEADER_CYCLE_SIZE &&
> +		    (rhead->h_version & cpu_to_be32(XLOG_VERSION_2))) {
> +			hblks = DIV_ROUND_UP(h_size, XLOG_HEADER_CYCLE_SIZE);
> +			if (hblks > 1) {
> +				kvfree(hbp);
> +				hbp = xlog_alloc_buffer(log, hblks);
> +			}
>  		}
>  	} else {
>  		ASSERT(log->l_sectBBsize == 1);
> -		hblks = 1;
>  		hbp = xlog_alloc_buffer(log, 1);
>  		h_size = XLOG_BIG_RECORD_BSIZE;
>  	}
> -- 
> 2.39.2
> 
> 

