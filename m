Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4D6CEEC3
	for <linux-xfs@vger.kernel.org>; Fri, 30 Aug 2024 15:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725032929; cv=none; b=q8KcxRk0w8mR3RJ3ye8GsfRTspwF/tkb+wjYzLvocRyLxbpFfx18JeexreomgXzj4uizxxPF/ZCiQkb2Da1Mm+9CoMAb6qG0j4znQ1tO6z2jWt5axZxoCL0qvlNo7isoYWXJjFDz4ag1DHwymUVs0YTjensd13qTeKxBtF2Pekc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725032929; c=relaxed/simple;
	bh=g6uuQAe0Ax6zgF3MdWth/y8UBGRnxpWeLJVS1OHYGbo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Iu41A49RzUJ74G4ZGIrVL9gle8Go9QY/qxmeKZl3IpEIviKuB+pTdFjn+KaqhZGDMxfR9OAH4XJ/jCDqL8IOLMdcdatJHiCWY3nPK/DrV2ZZTTZaQ6E6tk5a4H/49xt9JtTOEXeelpMQBoctX3F+LALqjt8Ww/Oy0cRndgWUSLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fKPm8mMV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fKPm8mMV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725032925;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oxb0ZzklRnBQEgWBtjfkdjtyjx5U8m0jxzzDkAF6ZAk=;
	b=fKPm8mMVGcJLif19KMqLscY59gGI8J4A9js5w5uKiPHmboApznl9USWEELQJZ/8VpJgs33
	SWTw2ykj/iR+eJ9Wf6NIZbceBZTfzcsdfx38gFYbkbIhxJIKQGPLSx7yGklam0wzJ50znA
	ZHG7aXV7g9uqEoQ+bpNazgJPkJv71go=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-345-MRIn1YPDOsaJzlyoRXMYOQ-1; Fri,
 30 Aug 2024 11:48:40 -0400
X-MC-Unique: MRIn1YPDOsaJzlyoRXMYOQ-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CAD861955BEF;
	Fri, 30 Aug 2024 15:48:39 +0000 (UTC)
Received: from redhat.com (unknown [10.22.33.32])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 4328B19560A3;
	Fri, 30 Aug 2024 15:48:38 +0000 (UTC)
Date: Fri, 30 Aug 2024 10:48:35 -0500
From: Bill O'Donnell <bodonnel@redhat.com>
To: Bill O'Donnell <bodonnel@redhat.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, djwong@kernel.org,
	sandeen@sandeen.net
Subject: Re: [PATCH] xfsdump: prevent use-after-free in fstab_commit()
Message-ID: <ZtHp09bArPxV-7_m@redhat.com>
References: <20240829175925.59281-1-bodonnel@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240829175925.59281-1-bodonnel@redhat.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Thu, Aug 29, 2024 at 12:59:25PM -0500, Bill O'Donnell wrote:
> Fix potential use-after-free of list pointer in fstab_commit().
> Use a copy of the pointer when calling invidx_commit().
> 
> Coverity CID 1498039.
> 
> Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>

NACK. Deeming this finding as a false positive.

> ---
>  invutil/fstab.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/invutil/fstab.c b/invutil/fstab.c
> index 88d849e..fe2b1f9 100644
> --- a/invutil/fstab.c
> +++ b/invutil/fstab.c
> @@ -66,6 +66,7 @@ fstab_commit(WINDOW *win, node_t *current, node_t *list)
>      data_t *d;
>      invt_fstab_t *fstabentry;
>      int fstabentry_idx;
> +    node_t *list_cpy = list;
>  
>      n = current;
>      if(n == NULL || n->data == NULL)
> @@ -77,8 +78,10 @@ fstab_commit(WINDOW *win, node_t *current, node_t *list)
>  
>      if(d->deleted == BOOL_TRUE && d->imported == BOOL_FALSE) {
>  	for(i = 0; i < d->nbr_children; i++) {
> -	    invidx_commit(win, d->children[i], list);
> +		list_cpy = list;
> +		invidx_commit(win, d->children[i], list_cpy);
>  	}
> +	free(list_cpy);
>  	mark_all_children_commited(current);
>  
>  	fstabentry_idx = (int)(((long)fstabentry - (long)fstab_file[fidx].mapaddr - sizeof(invt_counter_t)) / sizeof(invt_fstab_t));
> @@ -101,8 +104,10 @@ fstab_commit(WINDOW *win, node_t *current, node_t *list)
>  	invt_fstab_t *dest;
>  
>  	for(i = 0; i < d->nbr_children; i++) {
> -	    invidx_commit(win, d->children[i], list);
> +		list_cpy = list;
> +		invidx_commit(win, d->children[i], list_cpy);
>  	}
> +	free(list_cpy);
>  	mark_all_children_commited(current);
>  
>  	if(find_matching_fstab(0, fstabentry) >= 0) {
> -- 
> 2.46.0
> 

