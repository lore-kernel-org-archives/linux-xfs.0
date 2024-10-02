Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 663DF1D0955
	for <linux-xfs@vger.kernel.org>; Wed,  2 Oct 2024 16:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727884808; cv=none; b=INtoZwDEqA3dr6olpSdpZ5gTm5YAXbsRjbGcIRUqyBLY/ngyKmlNWH9W5cvlqdWIkU6aHYIPMQEDCeoMUdwrczAz5kfwUS4FhwpVg78X1NMCEyyMkQZ8HP2ryGSREJiVywslTJierK1Ws4alK6mkbZARRxFSbIXel4XXtBr2SKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727884808; c=relaxed/simple;
	bh=Hc4NOz11li6iqYY1qNrW5JM7POqLrrdY7jYdL3LgsmQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GwHQBt1v/iqGyx6d/nydHUAAzxiaHihc4MzriJaxzcg1b7j1zQfxosv0BFIYCiWRhHPofu6ZqNCZ3nW6c7xNOAAXR6UAUsKg4DNNhPbMwZufce8xHblgQRqYNtid7Q4yVeD35KEnVy9pez9gaJhkST/pTiNh30KMfkRdjVm73kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NccYlGal; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NccYlGal"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1727884804;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=StoTLplwuzbofwA7QSDgQVkNnb8SCbPquRqfWb0+PTY=;
	b=NccYlGalwE9AiVGWmLBrRCMrkkstuA3kQIlDSLg8NrvXmcSD0KJ8VHL/oRKZvJZgHcyAhR
	SoQbCkl3VjtPtRkpX+G6pEkMi+O+HZCEmbWqxQjb1amBwwbfmDQdpcnp5oSa9HvnYmr25w
	WDdZVuHTyJHbG111H9e966xbaV4kQ/0=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-686-wpmaGUh9PC-UQwqYLsKacA-1; Wed,
 02 Oct 2024 12:00:00 -0400
X-MC-Unique: wpmaGUh9PC-UQwqYLsKacA-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4945A1944CC3;
	Wed,  2 Oct 2024 15:59:58 +0000 (UTC)
Received: from bfoster (unknown [10.22.32.70])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2821219560A2;
	Wed,  2 Oct 2024 15:59:57 +0000 (UTC)
Date: Wed, 2 Oct 2024 12:01:06 -0400
From: Brian Foster <bfoster@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	xfs <linux-xfs@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/2] iomap: don't bother unsharing delalloc extents
Message-ID: <Zv1uQnLdM_GgIEo3@bfoster>
References: <20241002150040.GB21853@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241002150040.GB21853@frogsfrogsfrogs>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Wed, Oct 02, 2024 at 08:00:40AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If unshare encounters a delalloc reservation in the srcmap, that means
> that the file range isn't shared because delalloc reservations cannot be
> reflinked.  Therefore, don't try to unshare them.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  fs/iomap/buffered-io.c |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
> index 11ea747228aee..c1c559e0cc07c 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -1321,7 +1321,7 @@ static loff_t iomap_unshare_iter(struct iomap_iter *iter)
>  		return length;
>  
>  	/*
> -	 * Don't bother with holes or unwritten extents.
> +	 * Don't bother with delalloc reservations, holes or unwritten extents.
>  	 *
>  	 * Note that we use srcmap directly instead of iomap_iter_srcmap as
>  	 * unsharing requires providing a separate source map, and the presence
> @@ -1330,6 +1330,7 @@ static loff_t iomap_unshare_iter(struct iomap_iter *iter)
>  	 * fork for XFS.
>  	 */
>  	if (iter->srcmap.type == IOMAP_HOLE ||
> +	    iter->srcmap.type == IOMAP_DELALLOC ||
>  	    iter->srcmap.type == IOMAP_UNWRITTEN)
>  		return length;
>  
> 

IIUC in the case of shared blocks srcmap always refers to the data fork
(so delalloc in the COW fork is not an issue). If so:

Reviewed-by: Brian Foster <bfoster@redhat.com>

