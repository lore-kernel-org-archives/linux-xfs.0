Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BEBF33D6FF
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 11:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771499488; cv=none; b=G3G0xeV+saV8m9fskOlh+FAGcZk2KGuXQ5b2Z0QBdnrLmxhu/RxhpH48bls9h+8OC9Q68UVKQzDgtdiuzcPt5CkMCs2t9NPpYIHCAEcLMxoehKMYQBKcdA9B4Nz/MvKpggUHwWyrzwKhYG26blmZs0ogk/OOorqGdSZuOPUSbnQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771499488; c=relaxed/simple;
	bh=nB0bTsF21LZ1FMr3dpBbHwJVzpYmVbgqeukyG/vW3pQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oNwamqE4oAYtzNuFrQM86zh7g3eKmQ4UWmPae+fi7QyuoKJd7thTEBevBHkO4rrQ5pP1dbDDH7jTba30KiCz6pC5IUn/F4hseTGb5T9ZWNIWyYn7Z8Q/wuwl0d9ubJdLbZ7mcR5qzqyqK4Z9KoJkMfU1NgPFuD8rub0Tm/4sy70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RIJzEomr; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=BXh90YZ0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RIJzEomr";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="BXh90YZ0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771499486;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=A5XAF0Aaeg8lBO1DxOELBnxRYVsQIoZJWshuHqIQFsA=;
	b=RIJzEomrTdU52TxKNTW8GKZwmjIwgj3YSPl9YmvxUNgvPYWRfujQHeqAySMUWCL1aRwyRf
	KKa0yTQ+/QTNTfsR/NM/U80JHxA8sRbuH+Eb9tVkfolaEkPKNoswQe0BLVyQJOuzOAZko/
	s4+3q+OjpkNxDoCBDZusShBoO5GosSs=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-663-6rQPuaEgPB6AP5GULFGvqQ-1; Thu, 19 Feb 2026 06:11:22 -0500
X-MC-Unique: 6rQPuaEgPB6AP5GULFGvqQ-1
X-Mimecast-MFC-AGG-ID: 6rQPuaEgPB6AP5GULFGvqQ_1771499481
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4839fc4cef6so4105345e9.0
        for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 03:11:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771499481; x=1772104281; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=A5XAF0Aaeg8lBO1DxOELBnxRYVsQIoZJWshuHqIQFsA=;
        b=BXh90YZ0i5Z7RatEh/UhrBwyMu97e75d+bBk+UJnsl/FIe2oJlSX438qyia3FREfdk
         XKclxgxpo34jPWOLzlElj6oT5KR6n7NAAI/b6QSGV0DanzwwNXo5wac6eOFpCIsKXqOm
         rZT8fBnEHRlozTZY5BzK+wycj7h7C6val+nrfRWMBNkxGMp2hI7QrIQQEzovS/6/5Gee
         /Zb7Bs2knICU4wR7/yardK+/PXBCP09VbHUDhjux1itB+eTiNhXnb2I+tEwUeJRJnA9d
         83hmdMAl0gao3+TR2Coe1z11WEL29R2lWv7tAvjMpTuz2GGKCyOrjM0f7M0bF8EK8Z2Q
         8mhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771499481; x=1772104281;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=A5XAF0Aaeg8lBO1DxOELBnxRYVsQIoZJWshuHqIQFsA=;
        b=S5AbQfxFL+vYTfnDyCvzObhhknA+oMOA/qqqerXG8bfE1vKVuFED4++n78Sq86/gfy
         y3sGDrvkqLjA4qJOpPbj9yAY6ICr4cXkIKIvjfz4QxGFEhQkYrMCpgY95Bx65jeXYw9s
         AouC7q5kKK/rBUsE2XsVkC9F2OdVDkAF5hRcTLHeWiVRa03OJCAvZbBdBHiv/5tQZ+uN
         Zsy+MbObMIdgFoLBvy0+ae6er2kYIDDEMvNIR/kHw6Ojl/lC1+dHowQV5UzRpWcNdivG
         ZSf7ndDIUJPSUAwy3nHIQN9m8feA5YxwFi+LAlXnR8fyejd2N1gQB1LHV+CFKxGgHH8n
         El9w==
X-Forwarded-Encrypted: i=1; AJvYcCWOthO0DT2ckxE5UanW0kDh+zFgOxBItAgFGR2xAvA7rFfgUMOhEcUNCNdgtMj11TtFHz7KxrcXp/4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxcap1xnpLixzojW071t+2svUwxbQ8A4MdIsbeuMCkpLIC+uv63
	SNhlV3KTMkt+hvEyjwDE8CqGD+jFtFYbefKXSH2iXT6EWVXbcrM0Y9Ugzig2siJWlcKTGNtgD6Z
	GKxagcnv8RrYjXWn+cyzR+ml/AYAC9aZxxdFwIVPkBZWNvQSZq60TamuUk4Rp
X-Gm-Gg: AZuq6aLwlaxxoaOK4gULqojiFeWcTmOEL432t1Z2uYgyTp4hKNFpKv4onqUSQ+3Gt1w
	Vf1d/EfDXO2dS3crIT41e5Q7hXUSY2lyy0PwmclVejYjE1siDyPnDvirJK5j8xGdDwmkzSJV7ON
	mPh7lbsK+kmIF0cmo+8isAKCsUNcQdjXeLTUhEM+ErCL0xwJBNSoEQ2BRek+zgy9FrHvWNUQX/F
	lDx22oa+40LpUuvuogPO5vZ/XU9udoLqnd48GfA9bOetF/DR56DCY7F6VZtfvGI/oJaqyiAV3gC
	FahloSblJFZOkrJWZH5rx8F5SD+0O/rNBF8NsGP8R37IsSWKkHhN6VgAi/7bJbNBuXS/ldPL6qG
	hU1GaZ5pWbEE=
X-Received: by 2002:a05:600c:3b22:b0:477:9a61:fd06 with SMTP id 5b1f17b1804b1-4839fe97501mr21343325e9.8.1771499480389;
        Thu, 19 Feb 2026 03:11:20 -0800 (PST)
X-Received: by 2002:a05:600c:3b22:b0:477:9a61:fd06 with SMTP id 5b1f17b1804b1-4839fe97501mr21342205e9.8.1771499479443;
        Thu, 19 Feb 2026 03:11:19 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4839f90c27fsm32768655e9.2.2026.02.19.03.11.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Feb 2026 03:11:19 -0800 (PST)
Date: Thu, 19 Feb 2026 12:11:18 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, 
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, 
	djwong@kernel.org
Subject: Re: [PATCH v3 11/35] iomap: allow filesystem to read fsverity
 metadata beyound EOF
Message-ID: <qheg77kxcl4ecqdrsnmz4acfvszjlamlb7ilgxxyf3pmt4r7ah@5fzzmcpurdfp>
References: <20260217231937.1183679-1-aalbersh@kernel.org>
 <20260217231937.1183679-12-aalbersh@kernel.org>
 <20260218063606.GD8600@lst.de>
 <hfteu6bonpv7djecbf3d6ekh56ktgcl4c2lvtjtrjfetzaq5dw@scsrvxx5rgig>
 <20260219060420.GC3739@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260219060420.GC3739@lst.de>

On 2026-02-19 07:04:20, Christoph Hellwig wrote:
> On Wed, Feb 18, 2026 at 10:41:14AM +0100, Andrey Albershteyn wrote:
> > > +		 * Handling of fsverity "holes". We hits this for two case:
> > > +		 *   1. No need to go further, the hole after fsverity
> > > +		 *	descriptor is the end of the fsverity metadata.
> > > +		 *
> > > +		 *	No ctx->vi means we are reading a folio with descriptor.
> > > +		 *	XXX: what does descriptor mean here?  Also how do we
> > > +		 *	even end up with this case?  I can't see how this can
> > > +		 *	happe based on the caller?
> > 
> > fsverity descriptor. This is basically the case as for EOF folio.
> > Descriptor is the end of the fsverity metadata region. If we have 1k
> > fs blocks (= merkle blocks) we can have [descriptor | hole ] folio.
> > As we are not limited by i_size here, iomap_block_needs_zeroing()
> > won't fire to zero this hole. So, this case is to mark this tail as
> > uptodate.
> 
> How do we end up in that without ctx->vi set?

We're reading it

> 
> > I think this could be split into two cases by checking if (poff +
> > plen) cover everything to the folio end. This means that we didn't
> > get the case with tree holes and descriptor in one folio.
> 
> That might be more clear.
> 
> > > +		    	if (!ctx->vi) {
> > > +				iomap_set_range_uptodate(folio, poff, plen);
> > > +				/*
> > > +				 * XXX: why return to the caller early here?
> > > +				 */
> > 
> > To not hit hole in the tree (which means synthesize the block). The
> > fsverity_folio_zero_hash() case.
> 
> Well, I mean return early from the function and not just move on
> to the next loop iteration (which based on everything else you
> wrote would then terminate anyway), і.e., why is this not:
> 
> 		if (!ctx->vi)
> 			fsverity_folio_zero_hash(folio, poff, plen, ctx->vi)
> 		iomap_set_range_uptodate(folio, poff, plen);
> 	} else if ...

yes this would work

I've attached the current patch, with all the changes.

+               } else if (iomap_block_needs_zeroing(iter, pos) &&
+                          !(iomap->flags & IOMAP_F_FSVERITY)) {

This check is still needed as we should not hit it when we're
reading normal merkle tree block. iomap_block_needs_zeroing is
checking if offset is beyond i_size and will fire here for merkle
blocks.

Let me know if you prefer to split the first case further, or the
current patch is good enough.

-- 
- Andrey

diff --git a/fs/iomap/buffered-io.c b/fs/iomap/buffered-io.c
index 47356c763744..af7b79073879 100644
--- a/fs/iomap/buffered-io.c
+++ b/fs/iomap/buffered-io.c
@@ -533,10 +533,31 @@ static int iomap_read_folio_iter(struct iomap_iter *iter,
                if (plen == 0)
                        return 0;
 
-               /* zero post-eof blocks as the page may be mapped */
-               if (iomap_block_needs_zeroing(iter, pos) &&
-                   !(iomap->flags & IOMAP_F_FSVERITY)) {
+               /*
+                * Handling of fsverity "holes". We hits this for two case:
+                *   1. No need to go further, the hole after fsverity
+                *      descriptor is the end of the fsverity metadata.
+                *
+                *   2. This folio contains merkle tree blocks which need to be
+                *      synthesized and fsverity descriptor.
+                */
+               if ((iomap->flags & IOMAP_F_FSVERITY) &&
+                   iomap->type == IOMAP_HOLE) {
+                       /*
+                        * Synthesize the hash value for a zeroed folio if we
+                        * are reading merkle tree blocks.
+                        */
+                       if (ctx->vi)
+                               fsverity_folio_zero_hash(folio, poff, plen,
+                                                        ctx->vi);
+                       iomap_set_range_uptodate(folio, poff, plen);
+               } else if (iomap_block_needs_zeroing(iter, pos) &&
+                          !(iomap->flags & IOMAP_F_FSVERITY)) {
+                       /* zero post-eof blocks as the page may be mapped */
                        folio_zero_range(folio, poff, plen);
+                       if (fsverity_active(iter->inode) &&
+                           !fsverity_verify_blocks(ctx->vi, folio, plen, poff))
+                               return -EIO;
                        iomap_set_range_uptodate(folio, poff, plen);
                } else {
                        if (!*bytes_submitted)

