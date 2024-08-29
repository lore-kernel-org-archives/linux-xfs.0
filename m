Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36A941898E5
	for <linux-xfs@vger.kernel.org>; Thu, 29 Aug 2024 22:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724971729; cv=none; b=hXZvkg/8B3CkA4WsHFxCo8bpLHBvmZN0maXRAUi0KVcIDblL71BhaGzRSGXlm6meuoj27qm3jiQZGDg5ysN6HoZCUF5yW7doUgnOfBCSa2xpHDVMCOKXVVVCM+LJvXOj7sufuzDIP/jh68WiQYla48fsbdZ8y627RnR37+dpHZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724971729; c=relaxed/simple;
	bh=5LyIdIpym5JPFlXA3T3zirn8fplluI8QdEukYA00HR8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FSPc7A97T2X3t7p4+HjVopADSYXuOY9Yh0UrzTKOXNfCHeaXYGpWDDuf64yA/+smuDo3WgjM73kFXj3kDm4BPKlOgedbONglf+Sd6m0AljX/Kp5YFm80kz+SfQjBdT45D6UT6kPKi+2MnI+XDTEn7WK/YATzWfm7Q4Hh7Yq3GnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Tn45mmm5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Tn45mmm5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1724971726;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qgTHn9knMz1BjU9ksDiUmgqcxXQSfvWbEWVy2lsFwC8=;
	b=Tn45mmm5mk4ld5zfEje0IMA835uVB9v0JWujVzAmFPeBfQuIK57XEfZ+0X/BF01HsQRssb
	Mtm0huXJW140lWcJy4WavcY5C1JB3WluG0zLEVOUY0QSC+6NGw4h0mgtYTTXah2FUTbBUE
	y+jVP1mLBm1MBV8ipdJ46BLf6t4PSkY=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-523-f34-FATFOqipBIjxRlvdTA-1; Thu,
 29 Aug 2024 18:48:43 -0400
X-MC-Unique: f34-FATFOqipBIjxRlvdTA-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D0E301956080;
	Thu, 29 Aug 2024 22:48:41 +0000 (UTC)
Received: from redhat.com (unknown [10.22.33.32])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6773419560A3;
	Thu, 29 Aug 2024 22:48:40 +0000 (UTC)
Date: Thu, 29 Aug 2024 17:48:37 -0500
From: Bill O'Donnell <bodonnel@redhat.com>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, djwong@kernel.org
Subject: Re: [PATCH] xfsdump: prevent use-after-free in fstab_commit()
Message-ID: <ZtD6xQmXRd9BF0HE@redhat.com>
References: <20240829175925.59281-1-bodonnel@redhat.com>
 <c2ca3889-1a25-434b-a990-c75dd79aed39@sandeen.net>
 <ZtDQTKc336_Y_FcD@redhat.com>
 <ZtDbOSVV8k__YxMx@redhat.com>
 <5e5e4f37-2cac-416c-844e-1b2bbb426f91@sandeen.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5e5e4f37-2cac-416c-844e-1b2bbb426f91@sandeen.net>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Thu, Aug 29, 2024 at 04:56:01PM -0500, Eric Sandeen wrote:
> On 8/29/24 3:34 PM, Bill O'Donnell wrote:
> > On Thu, Aug 29, 2024 at 02:47:24PM -0500, Bill O'Donnell wrote:
> 
> ...
> 
> >>>> +	free(list_cpy);
> >>>
> >>> and then this would double-free that same memory address.
> >>
> >> I see that now. This code is indeed difficult to grok.
> >>
> >> Perhaps (if this a legitimate finding of use after free), instead of having the memory
> >> freed in invidx_commit(), it should instead be freed once in fstab_commit() after the iterations
> >> of the for-loops in that function. I'll have a look at that possibility.
> > 
> > i.e., Removing what Coverity tags as the culprit (node_free(list_del(dst_n)) from
> > invidx_commit(), and adding free(list) following the for-loop iteration in fstab_commit() may be
> > a better solution.
> 
> I don't think that's the right approach.
> 
> invidx_commit() has this while loop, which is where coverity thinks the passed-in "list"
> might get freed, before the caller uses it again:
> 
>                 /* Clean up the mess we just created */
>                 /* find node for dst_fileidx */
>                 dst_n = find_invidx_node(list, dst_fileidx);
>                 tmp_parent = ((data_t *)(dst_n->data))->parent;
>                 while(dst_n != NULL) {
>                     node_t *tmp_n1;
> 
>                     dst_d = dst_n->data;
> 
>                     /* close affected invidx file and stobj files */
>                     for(i = 0; i < dst_d->nbr_children; i++) {
>                         close_stobj_file(((data_t *)(dst_d->children[i]->data))->file_idx, BOOL_FALSE);
>                     }
> 
>                     /* free_all_children on that node */
>                     free_all_children(dst_n);
>                     tmp_n1 = find_invidx_node(dst_n->next, dst_fileidx);
>                     node_free(list_del(dst_n));
>                     dst_n = tmp_n1;
>                 }
> 
> "list" is presumably the head of a list of items, and this is cleaning up / freeing items
> within that list. Coverity seems to think that the while loop can end up getting back to
> the head and freeing it, which the caller then uses again in a loop.
> 
> My guess is that coverity is wrong, but I don't think you're going to be able to prove that
> (or fix this) without at least getting a sense of what this code is actually doing, and
> how this list is shaped and managed...

That's my take on it as well. I'm leaning towards a false positive. I'll have another look.
Thanks for reviewing.
-Bill

