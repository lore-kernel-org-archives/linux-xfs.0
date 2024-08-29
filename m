Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 896A0189F5A
	for <linux-xfs@vger.kernel.org>; Thu, 29 Aug 2024 20:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724963653; cv=none; b=uKCmSoQVlQLgRoQMVUTp7mgxUFvmynDt/0EGmJ3zuRWsV/oqABWQcrtfUv7M74JiYu1SKLqe0fBVT2f3dF5++DMEXyUgWPNrhw9fViRTJW7v/77ae8pEckT9l7OQNbaKwo7uWFXeKwE1uLJSQpOVAjUo9nCeidxs30s5hT7jRlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724963653; c=relaxed/simple;
	bh=EBMzLKz54U4/1a03j8YUnJE4yA+g+L2h64wUUaEhaxw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VrBPJqLOUgiQGihjystqxlbsq2kwHKY/3RZn0eykDdVs/GLY9t9omqSE5OxuE9uzN2/Weuv5Pc6UZhzfl9PBsZ5UfvkT8U5Mw3pMgBhqm2Xr0CLrVbREa3d2SvEzlITYrfe4O4QIs6nLjDVcxyenhMA3GRFWVyN7r+eZVh5hXiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-232-xlFl4Ii2PkCs5mDti_F6qQ-1; Thu,
 29 Aug 2024 16:34:07 -0400
X-MC-Unique: xlFl4Ii2PkCs5mDti_F6qQ-1
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2DF741955D4C;
	Thu, 29 Aug 2024 20:34:06 +0000 (UTC)
Received: from redhat.com (unknown [10.22.33.32])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 8DDCC1955F66;
	Thu, 29 Aug 2024 20:34:04 +0000 (UTC)
Date: Thu, 29 Aug 2024 15:34:01 -0500
From: Bill O'Donnell <bodonnel@redhat.com>
To: Bill O'Donnell <bodonnel@redhat.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, linux-xfs@vger.kernel.org,
	cem@kernel.org, djwong@kernel.org
Subject: Re: [PATCH] xfsdump: prevent use-after-free in fstab_commit()
Message-ID: <ZtDbOSVV8k__YxMx@redhat.com>
References: <20240829175925.59281-1-bodonnel@redhat.com>
 <c2ca3889-1a25-434b-a990-c75dd79aed39@sandeen.net>
 <ZtDQTKc336_Y_FcD@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZtDQTKc336_Y_FcD@redhat.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Thu, Aug 29, 2024 at 02:47:24PM -0500, Bill O'Donnell wrote:
> On Thu, Aug 29, 2024 at 02:35:27PM -0500, Eric Sandeen wrote:
> > On 8/29/24 12:59 PM, Bill O'Donnell wrote:
> > > Fix potential use-after-free of list pointer in fstab_commit().
> > > Use a copy of the pointer when calling invidx_commit().
> > 
> > I'm not sure how (or even if) the use after free happens -xfsdump is so hard
> > to read - but ...
> > 
> > > Coverity CID 1498039.
> > > 
> > > Signed-off-by: Bill O'Donnell <bodonnel@redhat.com>
> > > ---
> > >  invutil/fstab.c | 9 +++++++--
> > >  1 file changed, 7 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/invutil/fstab.c b/invutil/fstab.c
> > > index 88d849e..fe2b1f9 100644
> > > --- a/invutil/fstab.c
> > > +++ b/invutil/fstab.c
> > > @@ -66,6 +66,7 @@ fstab_commit(WINDOW *win, node_t *current, node_t *list)
> > >      data_t *d;
> > >      invt_fstab_t *fstabentry;
> > >      int fstabentry_idx;
> > > +    node_t *list_cpy = list;
> > >  
> > >      n = current;
> > >      if(n == NULL || n->data == NULL)
> > > @@ -77,8 +78,10 @@ fstab_commit(WINDOW *win, node_t *current, node_t *list)
> > >  
> > >      if(d->deleted == BOOL_TRUE && d->imported == BOOL_FALSE) {
> > >  	for(i = 0; i < d->nbr_children; i++) {
> > > -	    invidx_commit(win, d->children[i], list);
> > > +		list_cpy = list;
> > 
> > this copies the memory address stored in "list" into your new pointer var "list_cpy"
> > 
> > > +		invidx_commit(win, d->children[i], list_cpy);
> > 
> > If invidx_commit() frees the 2nd argument, it frees the memory address pointed
> > to by both list and list_cpy.
> > 
> > Storing the same memory address in 2 pointer variables does not prevent that memory
> > from being freed.
> > 
> > >  	}
> > > +	free(list_cpy);
> > 
> > and then this would double-free that same memory address.
> 
> I see that now. This code is indeed difficult to grok.
> 
> Perhaps (if this a legitimate finding of use after free), instead of having the memory
> freed in invidx_commit(), it should instead be freed once in fstab_commit() after the iterations
> of the for-loops in that function. I'll have a look at that possibility.

i.e., Removing what Coverity tags as the culprit (node_free(list_del(dst_n)) from
invidx_commit(), and adding free(list) following the for-loop iteration in fstab_commit() may be
a better solution.

> 
> 
> > 
> > 
> > >  	mark_all_children_commited(current);
> > >  
> > >  	fstabentry_idx = (int)(((long)fstabentry - (long)fstab_file[fidx].mapaddr - sizeof(invt_counter_t)) / sizeof(invt_fstab_t));
> > > @@ -101,8 +104,10 @@ fstab_commit(WINDOW *win, node_t *current, node_t *list)
> > >  	invt_fstab_t *dest;
> > >  
> > >  	for(i = 0; i < d->nbr_children; i++) {
> > > -	    invidx_commit(win, d->children[i], list);
> > > +		list_cpy = list;	
> > > +		invidx_commit(win, d->children[i], list_cpy);
> > >  	}
> > > +	free(list_cpy);
> > >  	mark_all_children_commited(current);
> > >  
> > >  	if(find_matching_fstab(0, fstabentry) >= 0) {
> > 
> 

