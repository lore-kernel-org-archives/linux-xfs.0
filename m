Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F069140395
	for <linux-xfs@vger.kernel.org>; Thu, 18 Jul 2024 16:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721318555; cv=none; b=Jd5lSlvFs8SpcRKSdTmglAGTbWn78k9cYLawb7Y5lotk28RJau6XEPPhN2EzVQH+Vl8gEA6VFchibydQobZ52uU2kzKb9ZaKFJ4uMI+qlnOWzCCJ0Ce5zNWUO5hOunAU/MQX18d0tv6NtC+/wu/TJnnr2InWgJWHTA8TtZZnYyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721318555; c=relaxed/simple;
	bh=kTi4dUgLC8YUr0POxrTXfi21GpXdO189xH16r1nyASc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TGO/oYgwrMug/2CC9+XYrQQfoQSutmLccHrgddTihQ/LoclFqPoE8KVnKHxVfCZWrYfqZSiq4KZ3Edt3acsjU/ou5liDspfxMb8v3aSfESg7M7jGWiSrm1D0pNdQEO638eJwb3h84hfAZo3NLbYg1B071sHKHSQwZU6TZo04J0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VtNRAgRj; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VtNRAgRj"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721318551;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=V17pkOr67HE5ddMy84FN2AmyZs78Njz4HtNeG5kaTx0=;
	b=VtNRAgRjZooUQ4S8dntth/f7xbnyda1tdHo3iuHGQ4KyGAuQeWQRA9/UWCaUXXAqiX5JJU
	tRJzrIfRoRyPNsvWS/cw3QwYReMtP5blujsvECeV+RXgfdN1DbImSc1cBnvN25YTgjyrU4
	ejXKkYuJFCwl09tLd5dVMuhRA0CoYjU=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-669-YjXgJyJpMzmCnRF9NZR5SQ-1; Thu,
 18 Jul 2024 12:02:28 -0400
X-MC-Unique: YjXgJyJpMzmCnRF9NZR5SQ-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B5B7D19560A2;
	Thu, 18 Jul 2024 16:02:26 +0000 (UTC)
Received: from bfoster (unknown [10.22.16.39])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 873071955F40;
	Thu, 18 Jul 2024 16:02:25 +0000 (UTC)
Date: Thu, 18 Jul 2024 12:03:09 -0400
From: Brian Foster <bfoster@redhat.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH 1/4] filemap: return pos of first dirty folio from
 range_has_writeback
Message-ID: <Zpk8vSx6AI53Cxyo@bfoster>
References: <20240718130212.23905-1-bfoster@redhat.com>
 <20240718130212.23905-2-bfoster@redhat.com>
 <ZpkwD2-q9_XRfX5P@casper.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZpkwD2-q9_XRfX5P@casper.infradead.org>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Thu, Jul 18, 2024 at 04:09:03PM +0100, Matthew Wilcox wrote:
> On Thu, Jul 18, 2024 at 09:02:09AM -0400, Brian Foster wrote:
> > @@ -655,6 +655,8 @@ bool filemap_range_has_writeback(struct address_space *mapping,
> >  				folio_test_writeback(folio))
> >  			break;
> >  	}
> > +	if (folio)
> > +		*start_byte = folio_pos(folio);
> >  	rcu_read_unlock();
> >  	return folio != NULL;
> >  }
> 
> Distressingly, this is unsafe.
> 
> We have no reference on the folio at this point (not one that matters,
> anyway).  We have the rcu read lock, yes, but that doesn't protect enough
> to make folio_pos() safe.
> 
> Since we do't have folio_get() here, the folio can be freed, sent back to
> the page allocator, and then reallocated to literally any purpose.  As I'm
> reviewing patch 1/4, I have no idea if this is just a hint and you can
> survive it being completely wrong, or if this is going to cause problems.
> 

Ah, thanks. I was unsure about this when I hacked it up but then got
more focused on patch 3. I think for this implementation I'd want it to
be an accurate pos of the first dirty/wb folio. I think this could
possibly use filemap_range_has_writeback() (without patch 1) as more of
a hint/optimization, but that might involve doing the FGP_NOCREAT thing
from the previous variant of this prototype has and I was trying to
avoid that.

Do you think it would be reasonable to create a variant of this function
that did the relevant bits from __filemap_get_folio():

        if (!folio_try_get(folio))
                goto repeat;

        if (unlikely(folio != xas_reload(&xas))) {
                folio_put(folio);
                goto repeat;
        }
	/* check dirty/wb etc. */

... in order to either return a correct pos or maybe even a reference to
the folio itself? iomap_zero_iter() wants the locked folio anyways, but
that might be too ugly to pass through the iomap_folio_ops thing in
current form.

If that doesn't work, then I might chalk this up as another reason to
just do the flush thing I was rambling about in the cover letter...

Brian

