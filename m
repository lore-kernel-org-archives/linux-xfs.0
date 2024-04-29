Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD32535C8
	for <linux-xfs@vger.kernel.org>; Mon, 29 Apr 2024 12:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714392997; cv=none; b=rsIHbMg0+ppWx+sdN9ySRaQjAQXoGArd8bx7B7SnIRqIstdTgR2AvvHC+zyRXcQpLkVKZUEZ/Mks+N94A91KnWXLQ+01SaHM9ZRaDCmNS5X0gkDDbhWhBf+UayCJr8CsA4foo96hsWD2USt3AwVoTr/XjyoKj68YmEE2yS7TAqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714392997; c=relaxed/simple;
	bh=0NfZtSzvM+rPV/GIyXt3W7n2ADT40aDodAXbDGfLOVg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U/H80DAzzbxoIiLTovByCA6HtI6BQ+eK+HPLC8L/9TF6pHvl1W44/KodSIF09MM7Oi4aTKBEwJJMdkICVEbb2MNLDkdGeS3iG+Pq8D67TIm2z6MuABLuwuab56FuX/GNEqlpF6Q61ShXwoCXOf36e7uLUcRAJoZ6zufNkgLHwTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NDLLuy0r; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NDLLuy0r"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1714392994;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eHN65QWCg/irn7GyW1FrzSpFmgST4dcEtn94mTVVhy0=;
	b=NDLLuy0rLmPqqq3S0mIhdd66uwPUpdJn+nGdWx17PLOMTJbH8KXEZMcse/vK/adE8nAauH
	hp5hFnRw4mYtaMP9A5A/sUj+O1Wz5VQKFE7lsOxpYEuzxJwCnnc6XKPPskPrNDiD5SSJze
	g/QmEx1IiFGMC8++JIRcBR3j1TWAbQ8=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-91-Y2s4jjNwN62cZBIv18-Naw-1; Mon, 29 Apr 2024 08:16:33 -0400
X-MC-Unique: Y2s4jjNwN62cZBIv18-Naw-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 930C680021A;
	Mon, 29 Apr 2024 12:16:32 +0000 (UTC)
Received: from bfoster (unknown [10.22.32.117])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id 4F2C540EE0E;
	Mon, 29 Apr 2024 12:16:32 +0000 (UTC)
Date: Mon, 29 Apr 2024 08:18:50 -0400
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Sam Sun <samsun1006219@gmail.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/3] xfs: clean up buffer allocation in
 xlog_do_recovery_pass
Message-ID: <Zi-QKgVdIyQToXpu@bfoster>
References: <20240429070200.1586537-1-hch@lst.de>
 <20240429070200.1586537-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240429070200.1586537-4-hch@lst.de>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.9

On Mon, Apr 29, 2024 at 09:02:00AM +0200, Christoph Hellwig wrote:
> Merge the initial xlog_alloc_buffer calls, and pass the variable
> designating the length that is initialized to 1 above instead of passing
> the open coded 1 directly.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_log_recover.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
> index d73bec65f93b46..d2e8b903945741 100644
> --- a/fs/xfs/xfs_log_recover.c
> +++ b/fs/xfs/xfs_log_recover.c
> @@ -3010,6 +3010,10 @@ xlog_do_recovery_pass(
>  	for (i = 0; i < XLOG_RHASH_SIZE; i++)
>  		INIT_HLIST_HEAD(&rhash[i]);
>  
> +	hbp = xlog_alloc_buffer(log, hblks);
> +	if (!hbp)
> +		return -ENOMEM;
> +
>  	/*
>  	 * Read the header of the tail block and get the iclog buffer size from
>  	 * h_size.  Use this to tell how many sectors make up the log header.
> @@ -3020,10 +3024,6 @@ xlog_do_recovery_pass(
>  		 * iclog header and extract the header size from it.  Get a
>  		 * new hbp that is the correct size.
>  		 */
> -		hbp = xlog_alloc_buffer(log, 1);
> -		if (!hbp)
> -			return -ENOMEM;
> -
>  		error = xlog_bread(log, tail_blk, 1, hbp, &offset);
>  		if (error)
>  			goto bread_err1;
> @@ -3071,16 +3071,15 @@ xlog_do_recovery_pass(
>  			if (hblks > 1) {
>  				kvfree(hbp);
>  				hbp = xlog_alloc_buffer(log, hblks);
> +				if (!hbp)
> +					return -ENOMEM;
>  			}
>  		}
>  	} else {
>  		ASSERT(log->l_sectBBsize == 1);
> -		hbp = xlog_alloc_buffer(log, 1);
>  		h_size = XLOG_BIG_RECORD_BSIZE;
>  	}
>  
> -	if (!hbp)
> -		return -ENOMEM;
>  	dbp = xlog_alloc_buffer(log, BTOBB(h_size));
>  	if (!dbp) {
>  		kvfree(hbp);
> -- 
> 2.39.2
> 
> 

