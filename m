Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB8101BD51B
	for <linux-xfs@vger.kernel.org>; Thu, 29 Aug 2024 19:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724960856; cv=none; b=CJhQw8he+eUYuOysGRmIUjrS4BgHxCqYmgO/OpF6FCOcAt9L3LHQ0dDTud65tM4ffIhEBTAPYDCwUJVnHdgoNr2i54tuVzlxZmSQbbVtU6v46EYNBJUa26uHZSt5vGd9KSL2Jlbx9i8fI77SW8w3gwkLcv60fLlC4bCAceChBLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724960856; c=relaxed/simple;
	bh=7tGZ7MwdIRIijBbXdiWI0V1nC/DekY6prezsF3S9jNU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cZ6nG2CLysRrkBwf5JZIdPEKsm7HN5iMpDbI3JRNQklQFWB7fvSjOmziSVw6nWaDL5Xdk/W6OSCeeH/zpZlzXkCO2Sey1QZrfmc6gciNfS3ZaUx14r1IiEr1hHQsNEfLYSoXAS08UWfTYKMQdGw3H7jdeA7FPQUuzlg2lbZQAVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OYxlNMdx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OYxlNMdx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724960853;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=K5rb27OlKDECwgoD8DdxBgq+45JxxFHBCN56P8TAD04=;
	b=OYxlNMdxl+Rdw6V2SWy99LuVUMBcCXZ3n7qRLQUK68p7kgOl5EV3sLkSUyI8DCzLtmoEdb
	t+8WrhlZPM6pQhwIAnINOFX/O9rA4AjahhnryQ0HIEOJIX+AjbbrUIfkf+PUbH5YHNUE+2
	RqbT6qkWv8wyHB06NxoaNcKJK+bqMBw=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-169-r0n2w5LZN4yK9-c33xCogg-1; Thu,
 29 Aug 2024 15:47:30 -0400
X-MC-Unique: r0n2w5LZN4yK9-c33xCogg-1
Received: from mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.15])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 12C7E1955D4E;
	Thu, 29 Aug 2024 19:47:29 +0000 (UTC)
Received: from redhat.com (unknown [10.22.33.32])
	by mx-prod-int-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8A3BF19560AA;
	Thu, 29 Aug 2024 19:47:27 +0000 (UTC)
Date: Thu, 29 Aug 2024 14:47:24 -0500
From: Bill O'Donnell <bodonnel@redhat.com>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, djwong@kernel.org
Subject: Re: [PATCH] xfsdump: prevent use-after-free in fstab_commit()
Message-ID: <ZtDQTKc336_Y_FcD@redhat.com>
References: <20240829175925.59281-1-bodonnel@redhat.com>
 <c2ca3889-1a25-434b-a990-c75dd79aed39@sandeen.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2ca3889-1a25-434b-a990-c75dd79aed39@sandeen.net>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.15

On Thu, Aug 29, 2024 at 02:35:27PM -0500, Eric Sandeen wrote:
> On 8/29/24 12:59 PM, Bill O'Donnell wrote:
> > Fix potential use-after-free of list pointer in fstab_commit().
> > Use a copy of the pointer when calling invidx_commit().
> 
> I'm not sure how (or even if) the use after free happens -xfsdump is so hard
> to read - but ...
> 
> > Coverity CID 1498039.
> > 
> > Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>
> > ---
> >  invutil/fstab.c | 9 +++++++--
> >  1 file changed, 7 insertions(+), 2 deletions(-)
> > 
> > diff --git a/invutil/fstab.c b/invutil/fstab.c
> > index 88d849e..fe2b1f9 100644
> > --- a/invutil/fstab.c
> > +++ b/invutil/fstab.c
> > @@ -66,6 +66,7 @@ fstab_commit(WINDOW *win, node_t *current, node_t *list)
> >      data_t *d;
> >      invt_fstab_t *fstabentry;
> >      int fstabentry_idx;
> > +    node_t *list_cpy = list;
> >  
> >      n = current;
> >      if(n == NULL || n->data == NULL)
> > @@ -77,8 +78,10 @@ fstab_commit(WINDOW *win, node_t *current, node_t *list)
> >  
> >      if(d->deleted == BOOL_TRUE && d->imported == BOOL_FALSE) {
> >  	for(i = 0; i < d->nbr_children; i++) {
> > -	    invidx_commit(win, d->children[i], list);
> > +		list_cpy = list;
> 
> this copies the memory address stored in "list" into your new pointer var "list_cpy"
> 
> > +		invidx_commit(win, d->children[i], list_cpy);
> 
> If invidx_commit() frees the 2nd argument, it frees the memory address pointed
> to by both list and list_cpy.
> 
> Storing the same memory address in 2 pointer variables does not prevent that memory
> from being freed.
> 
> >  	}
> > +	free(list_cpy);
> 
> and then this would double-free that same memory address.

I see that now. This code is indeed difficult to grok.

Perhaps (if this a legitimate finding of use after free), instead of having the memory
freed in invidx_commit(), it should instead be freed once in fstab_commit() after the iterations
of the for-loops in that function. I'll have a look at that possibility.

Thanks-
Bill


> 
> 
> >  	mark_all_children_commited(current);
> >  
> >  	fstabentry_idx = (int)(((long)fstabentry - (long)fstab_file[fidx].mapaddr - sizeof(invt_counter_t)) / sizeof(invt_fstab_t));
> > @@ -101,8 +104,10 @@ fstab_commit(WINDOW *win, node_t *current, node_t *list)
> >  	invt_fstab_t *dest;
> >  
> >  	for(i = 0; i < d->nbr_children; i++) {
> > -	    invidx_commit(win, d->children[i], list);
> > +		list_cpy = list;	
> > +		invidx_commit(win, d->children[i], list_cpy);
> >  	}
> > +	free(list_cpy);
> >  	mark_all_children_commited(current);
> >  
> >  	if(find_matching_fstab(0, fstabentry) >= 0) {
> 

