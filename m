Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B980B382297
	for <linux-xfs@vger.kernel.org>; Mon, 23 Mar 2026 12:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774268863; cv=none; b=IIAi/zqBw8KplmCyHQsK+8NLhkeLENm+jvSrL1NK5q7Punl+n0ZElRDO+qthR8PSjwQHfkSoNvNqULoYJUJ6FG5U7CffmCzEjUXy5OBUg8i6pOAhvQ2uoYREChkd+smEoIu27w2w+RkIfLqpHW9+L7QcgWBEfpvlepqld76kSlA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774268863; c=relaxed/simple;
	bh=FwKENay/z79iavMSt7scZlq3VLj1hHbiMqnS8SLhzHk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cXSX8gMmrtJPHVEGOvOdT7MMeKnrXmvPuGsPfNmZPMlZ/xCxdHRwUTDaCBu+BOYcMXPFOGurvinQwB2tBihLAvi5BEb1ioxjctQkWmg89hEbzh+v1lRKaV6al0XxvI6zu3ohx3XByE+nrNoM7kBHhV00Yygt45t7YxSaDKFpIL4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=USOvBCgw; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="USOvBCgw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774268860;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=d4QvX3SHHzqG/gzlUnEeZvZ3iCa6CQwpdez0wtc/5JI=;
	b=USOvBCgwXZj+qybuSILGyHBeM/6fUWu1yfaPP55xOSwvS+muQ4KI9KYllfYtJEmiFMJ95c
	wt6gVmA4CF2l4gx2PZ7V53KbGd/onAcH5sOByxpoCrPxRgksPSpJLDSvwnywuuz0m4bTt5
	WyK1YYyttheOU9oijf/vtnOBZ1Nw6zM=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-641-kxkMA_KMOFakyO1xndRjqg-1; Mon,
 23 Mar 2026 08:27:37 -0400
X-MC-Unique: kxkMA_KMOFakyO1xndRjqg-1
X-Mimecast-MFC-AGG-ID: kxkMA_KMOFakyO1xndRjqg_1774268856
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 852AD180034E;
	Mon, 23 Mar 2026 12:27:36 +0000 (UTC)
Received: from bfoster (unknown [10.22.88.82])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 895B71954102;
	Mon, 23 Mar 2026 12:27:35 +0000 (UTC)
Date: Mon, 23 Mar 2026 08:27:33 -0400
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Dave Chinner <dchinner@redhat.com>,
	linux-xfs@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>
Subject: Re: [PATCH 4/4] xfs: don't decrement the buffer LRU count for in-use
 buffers
Message-ID: <acExtTJynRQQ30dJ@bfoster>
References: <20260323075102.2952705-1-hch@lst.de>
 <20260323075102.2952705-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260323075102.2952705-5-hch@lst.de>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Mon, Mar 23, 2026 at 08:50:54AM +0100, Christoph Hellwig wrote:
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
> index e4b65d0c9ef0..ee8c3944015a 100644
> --- a/fs/xfs/xfs_buf.c
> +++ b/fs/xfs/xfs_buf.c
> @@ -1524,23 +1524,25 @@ xfs_buftarg_isolate(
>  		return LRU_SKIP;
>  
>  	/*
> -	 * Decrement the b_lru_ref count unless the value is already
> -	 * zero. If the value is already zero, we need to reclaim the
> -	 * buffer, otherwise it gets another trip through the LRU.
> +	 * If the buffer is in use, remove it from the LRU for now.  We can't
> +	 * free it while someone is using it, and we should also not count
> +	 * eviction passed for it, just as if it hadn't been added to the LRU
> +	 * yet.
>  	 */
> -	if (atomic_add_unless(&bp->b_lru_ref, -1, 0)) {
> +	if (bp->b_lockref.count > 0) {
> +		list_lru_isolate(lru, &bp->b_lru);
>  		spin_unlock(&bp->b_lockref.lock);
> -		return LRU_ROTATE;
> +		return LRU_REMOVED;
>  	}
>  
>  	/*
> -	 * If the buffer is in use, remove it from the LRU for now as we can't
> -	 * free it.  It will be freed when the last reference drops.
> +	 * Decrement the b_lru_ref count unless the value is already
> +	 * zero. If the value is already zero, we need to reclaim the
> +	 * buffer, otherwise it gets another trip through the LRU.
>  	 */
> -	if (bp->b_lockref.count > 0) {
> -		list_lru_isolate(lru, &bp->b_lru);
> +	if (atomic_add_unless(&bp->b_lru_ref, -1, 0)) {
>  		spin_unlock(&bp->b_lockref.lock);
> -		return LRU_REMOVED;
> +		return LRU_ROTATE;
>  	}
>  
>  	lockref_mark_dead(&bp->b_lockref);
> -- 
> 2.47.3
> 
> 

