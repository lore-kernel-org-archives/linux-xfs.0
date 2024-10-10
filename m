Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B4841C9ED7
	for <linux-xfs@vger.kernel.org>; Thu, 10 Oct 2024 14:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728568981; cv=none; b=WtnVA0mhFz1WiLha8skFhIUBsOfKn40+HSIojmjZcmCIwpjVBfoIzxoC0d1Uo2muK0bddr7Of6ZbJKiLqwD3vVBo+cRnLP8uXo7osPWpHlhw7+9rcrqFc5SLq0PulZcFXLnOEbiYE6nV6STbYEa6o3AYQbH5HJg7wX9UUa2kQtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728568981; c=relaxed/simple;
	bh=Uv0F8HWNKy9F+13dzj8Eiyo0+Ov/wqOSGOn4t5AC+p0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VwNSKExOCiJJhpsQ0jfS5hK4c70fjcNW7mP0IMlRaG9zkD9B7aAn40xpIiZt+yZdZ1rK302/Ovjg5qPXkzvBS07MyEzC0JTkLYOCUY+y9pZcz9vae2k7vVaognXNoRfkEHWOB656iSPqY7pPGMyGGhAbk1quJy6ePpN8W/+wfOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=J8NObG+a; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="J8NObG+a"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1728568978;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EHlSqXUshbfdNP2jVHFwKv2wiQvUDjFokoanZk60UFs=;
	b=J8NObG+aJWKK5E8iTd2ASGngyyBTg6855iM6J6g67Ag/vrxhfg2BAeqagjhNWzHEH5/HrB
	A0YFM3i0sm0/YIW9wJKFGqNbRiZa/ng1YjzW6hD78VOaVOMCchVC40Mks0y0KexeoR2QhD
	KIlz4O1wbbCwL1Ua8WPHoadWyNRbYPY=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-657-guzEYIwVM8GqxvN0koMpFQ-1; Thu,
 10 Oct 2024 10:02:57 -0400
X-MC-Unique: guzEYIwVM8GqxvN0koMpFQ-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D68791955F42;
	Thu, 10 Oct 2024 14:02:55 +0000 (UTC)
Received: from bfoster (unknown [10.22.32.133])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EB194300018D;
	Thu, 10 Oct 2024 14:02:54 +0000 (UTC)
Date: Thu, 10 Oct 2024 10:04:10 -0400
From: Brian Foster <bfoster@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/7] xfs: don't use __GFP_RETRY_MAYFAIL in
 xfs_initialize_perag
Message-ID: <Zwfe2h88nPNFb1bC@bfoster>
References: <20240930164211.2357358-1-hch@lst.de>
 <20240930164211.2357358-6-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240930164211.2357358-6-hch@lst.de>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Mon, Sep 30, 2024 at 06:41:46PM +0200, Christoph Hellwig wrote:
> __GFP_RETRY_MAYFAIL increases the likelyhood of allocations to fail,
> which isn't really helpful during log recovery.  Remove the flag and
> stick to the default GFP_KERNEL policies.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> ---

Reviewed-by: Brian Foster <bfoster@redhat.com>

>  fs/xfs/libxfs/xfs_ag.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/xfs/libxfs/xfs_ag.c b/fs/xfs/libxfs/xfs_ag.c
> index 8fac0ce45b1559..29feaed7c8f880 100644
> --- a/fs/xfs/libxfs/xfs_ag.c
> +++ b/fs/xfs/libxfs/xfs_ag.c
> @@ -289,7 +289,7 @@ xfs_initialize_perag(
>  		return 0;
>  
>  	for (index = old_agcount; index < new_agcount; index++) {
> -		pag = kzalloc(sizeof(*pag), GFP_KERNEL | __GFP_RETRY_MAYFAIL);
> +		pag = kzalloc(sizeof(*pag), GFP_KERNEL);
>  		if (!pag) {
>  			error = -ENOMEM;
>  			goto out_unwind_new_pags;
> -- 
> 2.45.2
> 
> 

