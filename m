Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9953D0924
	for <linux-xfs@vger.kernel.org>; Wed, 18 Mar 2026 11:45:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773834330; cv=none; b=ZhID5qDC5bUymQrfSN5N0Bw1issJYgBd3231K+n2TKvwQ/1x9UjofddAQruYWdvlxSJwY9mYJF8qFPyZoDsYI29xViYoXTeAYYui3nSnDA/V00s2vngwsYKZgl5m72JLfPgexEMGp6FFoTeV7VRp5ntknQW1MfLAV/OqwMqUeFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773834330; c=relaxed/simple;
	bh=P+nAC2LsHtJlcdJ/wNpCD3r0q/7IIG3qoBvo9h4BgO8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k3OJmkg3Z3p0e/kCyYM3uwqIVVcYKhlsio/zVAtSa2ENl24kThhtkrk01bo9zq8p2GbAdAO2kZETT4jxihM/vn2CtMSkkuPA1aTVT8RGMTivyrwB0HHCsQHMcsqVO5/Mx8jXCDMz8fL7OLTF4VboBikBFOHYZplmXHyz8EzqdXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GHLCLf7Z; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GHLCLf7Z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773834327;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=g50Mk3dTdPPNDjDYQ/cdBvSmQdclo5DpjQ0yiNmKwNk=;
	b=GHLCLf7ZYv41EOmTv6Ir0bhbEQd6la3l7SQJr013skGAfGGj/5NPc3LB1X6mPd6PY5HQlh
	HUV0QJpvnWUDMD7/4nt3kALJMjTyKfAQROD5MeAlS7DTLeKbQamxWY/gklnGbfCYVFXysr
	LTtl6bJxp3BZ1sF2T2UQSiLMT8gVQq4=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-121-Q7jpz2_lMyKM160CodyD9g-1; Wed,
 18 Mar 2026 07:45:24 -0400
X-MC-Unique: Q7jpz2_lMyKM160CodyD9g-1
X-Mimecast-MFC-AGG-ID: Q7jpz2_lMyKM160CodyD9g_1773834323
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 095A7195608B;
	Wed, 18 Mar 2026 11:45:23 +0000 (UTC)
Received: from bfoster (unknown [10.22.89.178])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9065419560AB;
	Wed, 18 Mar 2026 11:45:21 +0000 (UTC)
Date: Wed, 18 Mar 2026 07:45:19 -0400
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH 4/4] xfs: don't decrement the buffer LRU count for in-use
 buffers
Message-ID: <abqQT9dzn4NdsaPH@bfoster>
References: <20260317134110.1691097-1-hch@lst.de>
 <20260317134110.1691097-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260317134110.1691097-5-hch@lst.de>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Tue, Mar 17, 2026 at 02:40:55PM +0100, Christoph Hellwig wrote:
> XFS buffers are added to the LRU when they are unused, but are only
> removed from the LRU lazily when the LRU list scan finds a used buffer.
> So far this only happen when the LRU counter hits 0, which is suboptimal
> as buffers that were added to the LRU, but are in use again still consume
> LRU scanning resources and are aged while actually in use.
> 
> Fix this by checking for in-use buffers and removing the from the LRU
> before decrementing the LRU counter.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/xfs_buf.c | 22 ++++++++++++----------
>  1 file changed, 12 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
> index c0a4d0a37f57..8ba9b74339a7 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1523,6 +1523,18 @@ xfs_buftarg_isolate(
>  	if (!spin_trylock(&bp->b_lockref.lock))
>  		return LRU_SKIP;
>  
> +	/*
> +	 * If the buffer is in use, remove it from the LRU for now.  We can't
> +	 * free it while someone is using it, and we should also not count
> +	 * eviction passed for it, just as if it hadn't been added to the LRU
> +	 * yet.
> +	 */
> +	if (bp->b_lockref.count > 0) {
> +		list_lru_isolate(lru, &bp->b_lru);
> +		spin_unlock(&bp->b_lockref.lock);
> +		return LRU_REMOVED;
> +	}
> +
>  	/*
>  	 * Decrement the b_lru_ref count unless the value is already
>  	 * zero. If the value is already zero, we need to reclaim the
> @@ -1533,16 +1545,6 @@ xfs_buftarg_isolate(
>  		return LRU_ROTATE;
>  	}
>  	
> -	/*
> -	 * If the buffer is in use, remove it from the LRU for now as we can't
> -	 * free it.  It will be freed when the last reference drops.
> -	 */
> -	if (bp->b_lockref.count > 0) {
> -		list_lru_isolate(lru, &bp->b_lru);
> -		spin_unlock(&bp->b_lockref.lock);
> -		return LRU_REMOVED;
> -	}
> -
>  	lockref_mark_dead(&bp->b_lockref);
>  	list_lru_isolate_move(lru, item, dispose);
>  	spin_unlock(&bp->b_lockref.lock);
> -- 
> 2.47.3
> 
> 

