Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6290733B6F0
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 13:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771506601; cv=none; b=dKcfDOpsn8fPPY+msDyD4KW+pNOIZdgNKbfgX8N4Acy0uRgAfqytqbOgxKKvQXNuziGWVvQsnDWufQnnI9rGoVTdabwrXPD6Vr4OV5Z/WJEoU9Fj175jIc+wt/0HDwS+sCPhMcGWFih3EpcmGRt4bI8BbN1PU2CuqR889mih3W0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771506601; c=relaxed/simple;
	bh=H6GbZk5mdMnT9e3o9j/Gu86s2cpxHt7MmO2p6vvqV9w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n6BSY2tQQ4VVH4tCfbKYxSk4kNUSPcWLeogIi1fTouQwigMPg3X2nA2Va84Az9lFA0sS1t2kHhraOuY8HMvmJQgObv1oTfTNhhpRoIbhkH8Q8Es0wsjNtznO+T+EHUuQb9epegPo5ddyTkaBpO3RYWXrTkmg3zjZlmkILEjTzs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P+M+Et0Z; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=IwR4ppbz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P+M+Et0Z";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="IwR4ppbz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771506598;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=86TIrp4laa0pBu7H21TRyyRDI/9QW6qy9OH6ZIij+k8=;
	b=P+M+Et0ZnVCC2psPRg3hE1rV86bhZRyVR129HdRRmct+ze5GHKjv0p4xDZ41nI+tAU4c9v
	zZiaUuwrXB4kqjlT7nGASt8jCe6608x7gQjN5mwUA/zXz6RRYWTscj74nn8/e0YEpm0LMO
	Wao/UrJ2AmYwwZBikeNBt35zlRA4ksk=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-43-E3iW01owPpCzGRKxiGyswQ-1; Thu, 19 Feb 2026 08:09:57 -0500
X-MC-Unique: E3iW01owPpCzGRKxiGyswQ-1
X-Mimecast-MFC-AGG-ID: E3iW01owPpCzGRKxiGyswQ_1771506596
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4836ff58111so11663455e9.1
        for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 05:09:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771506596; x=1772111396; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=86TIrp4laa0pBu7H21TRyyRDI/9QW6qy9OH6ZIij+k8=;
        b=IwR4ppbz1DiQyh5chN/KLNiihSCjPiAo8XuzG10Nu3zKxjP1DQSxSxidNWeT+jFLwR
         ats8HPFwBkKE2zjsjm2P8C64UHkndEAne/7BGqnvPyLf8lALyUTDG67T5SWF0gUgwM6H
         CXgO6Q6RVcx3Yet7BYjK75Hosx0UrLXBOXkj+DLKutSwxyRyYgm36x3/ES87cPT8Q1r4
         MiqySScgVx9+htiYV4Xnm3dcSNif0xrioHzHnkvQUk6vuL69PmRfzE9cgXrXwAP/ZSr4
         cOM4/n6BAzYag1AnKv5LVIk4EXsFXD1pR1WYK8q4KsDprCiDkasF02TIr1kbMasjHEzA
         CurQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771506596; x=1772111396;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=86TIrp4laa0pBu7H21TRyyRDI/9QW6qy9OH6ZIij+k8=;
        b=wVaFYzrWKxeDZxJIZnO1ZGHbbsH4GxECj0cGMSYKzlFrkthVOTZGKWCHOUrSFb56g4
         OIbCJPdpJBokA2NzD0TzAKbtKrfVXz/nBoV7/T508Oy4ZE3+ePOODHCZTJHGPTdljsb5
         qsskG7sRLeYzKAPKn4F7mjyzPf3OmAvvVhsaEr6deA9KF4pByIejl83pioPt2J40kDSO
         LJaDPH6Mf+XSgEbHOMTIuHoLYCkiNm2shfsY/U9gxOwfUXJzOigiO+yCTdxjYv6D2ULa
         3ZL+LRiC3MWfe1gIokmA3491QieTGYIQeovzkqOnyIDZE5jbY7KftuUmjxP1MgIsll3Y
         cNvw==
X-Forwarded-Encrypted: i=1; AJvYcCWhaKok3FpLwlNTQndgV/rl3gKkT+YCHTecdgjAhYUeb2uL6NDE9VT6LauAySfLqwcr+fhqjIjwT8g=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzz6LgOw/MzchGn6L8EdESq3f0QixVErSyIfoG9yzX+DaLZlcUI
	v0U2me+Hu1gDntyrwVpTGybwYiCppVMKUbFGx7JOw1Di+oAeZLeOoOTsITbyPlS/61h179wXrU8
	0NhaAX6NVaNOArN4u0nCewQuQebuDEeqWcd6Un7A2t4ie5NKJhMzZ0GbZwL+qEqt0rHAe
X-Gm-Gg: AZuq6aK6rxqg4BV2kHcyoa1gLQbCqSEPwlp1PxIp57Wg72JEFcv3z+1tMACqDo30uVv
	7JuX8MhKBHG0JSiL9y4ZoqZyloh4B0c3caaXzhuro2GoRqyN4l4Q8aXHgl1v5e8JbQ30GFiiUDW
	DXUpYCdATnK/x1Xc7YINEayGVZCvGNxhEAHdkXVZVccAJQE5XUjygO2AiOy1lPeKayfSborQDYb
	Yymt7rM99uxy7Yl/Q1vX4Od4cCsAKYfjNUi+W1ClxDRdmv38uwEVrdeFYz6wnXcoZ6WhLqihX6X
	pn9UFAJvN5C18ln/EoDCwPrV8Gb9M3cUBrHCDS8OHzpE0VFKyug7kb6K2OJfqxLWRkkoqwOkVNW
	O1eFOpdXjgP0=
X-Received: by 2002:a05:600c:8b70:b0:483:54cc:cd89 with SMTP id 5b1f17b1804b1-48398a548c5mr100843265e9.9.1771506595883;
        Thu, 19 Feb 2026 05:09:55 -0800 (PST)
X-Received: by 2002:a05:600c:8b70:b0:483:54cc:cd89 with SMTP id 5b1f17b1804b1-48398a548c5mr100842775e9.9.1771506595304;
        Thu, 19 Feb 2026 05:09:55 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4839f978328sm20400695e9.14.2026.02.19.05.09.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Feb 2026 05:09:54 -0800 (PST)
Date: Thu, 19 Feb 2026 14:09:54 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, 
	Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, fsverity@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org
Subject: Re: [PATCH v3 03/35] fsverity: add consolidated pagecache offset for
 metadata
Message-ID: <xxpvkb5cmadxkifi3onmfmnaorw3emfzr32ha5n6kma2kvg54a@ueu4zhhzrglc>
References: <20260217231937.1183679-1-aalbersh@kernel.org>
 <20260217231937.1183679-4-aalbersh@kernel.org>
 <20260218061707.GA8416@lst.de>
 <20260218215732.GC6467@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260218215732.GC6467@frogsfrogsfrogs>

On 2026-02-18 13:57:32, Darrick J. Wong wrote:
> On Wed, Feb 18, 2026 at 07:17:07AM +0100, Christoph Hellwig wrote:
> > On Wed, Feb 18, 2026 at 12:19:03AM +0100, Andrey Albershteyn wrote:
> > > Filesystems implementing fsverity store fsverity metadata on similar
> > > offsets in pagecache. Prepare fsverity for consolidating this offset to
> > > the first folio after EOF folio. The max folio size is used to guarantee
> > > that mapped file will not expose fsverity metadata to userspace.
> > > 
> > > So far, only XFS uses this in futher patches.
> > 
> > This would need a kerneldoc comment explaining it.  And unless we can
> > agree on a common offset and have the translation in all file systems,
> > it probably makes sense to keep it in XFS for now.   If you have spare
> > cycles doing this in common code would be nice, though.
> 
> fsverity_metadata_offset definitely ought to have a kerneldoc explaining
> what it is (minimum safe offset for caching merkle data in the pagecache
> if large folios are enabled).
> 
> and yes, it'd be nice to do trivial conversions, but ... I think the
> only filesystem that has fscrypt and large folios is btrfs?  And I only
> got that from dumb grepping; I don't know if it supports both at the
> same time.
> 
> OTOH I think the ext4 conversion is trivial...
> 
> static struct page *ext4_read_merkle_tree_page(struct inode *inode,
> 					       pgoff_t index,
> 					       unsigned long num_ra_pages)
> {
> 	index += fsverity_metadata_offset(inode) >> PAGE_SHIFT;

I don't think it's that easy as ondisk file offset will be the same
to this. So, this will require some offset conversion like in XFS
and handling of old 64k offset.

-- 
- Andrey

