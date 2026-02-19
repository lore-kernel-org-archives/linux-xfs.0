Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C986617ADE0
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 14:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771510998; cv=none; b=oozQh7ge+KxtcRMrLwqHV2l9khYmpi2Ach057Jy8K3V7lQ+JOgTqDnnnQ07QAbkoCgsLziEuHgMxaXNzWjhbWvQUzdRXNEOs+O+CCbPsDpbP2sU1YO4cQxe0k4tjuCKaoCSICG/dYywAT3lGzhdtBgl0HHypj0a/pvCR+luPxqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771510998; c=relaxed/simple;
	bh=ZrKSzVTQMlzjhHHLkggaBkEKCBxQTXU9GuPjLSZmUro=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LyWLCPUljlJ+aWB1m1a15Eljl8iCT11UVSZmiQTA2JEZlh40takHTnmWhBkcGXH6R4sj2Y9zZrx1Up52iuW0XH4EexTjpHo2diTjoHRVME8Nb667tKhrkcpbkC25frfb5MHFfBPL3XSxARsmCvzfixa3A+6cmb2PGu6pY2ETO6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GKYrwKUs; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=MwzmhfR0; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GKYrwKUs";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="MwzmhfR0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771510995;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FbHvuuKoNJAJaoIiQsSzhjqIeQ7NdHJUqSJNAtbvmAg=;
	b=GKYrwKUsEbOllo3B+GDVFpywTEfTqXv9VG8Xy7HqcDkcwHXG6zSMkxh90ZjkIjSm1rkpcQ
	J+u1QiM1Y+t/Lodf7msJ6P3SxLIoSqs4c/2KWsaimBNqhBfP9+ldYCjxTTxHGfmn8UpyUK
	ATJzSwlGVarIym52w6CUb4lAFJIzZ/U=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-272-EbJvF9rnN1qsSlRaxY0Zjg-1; Thu, 19 Feb 2026 09:23:14 -0500
X-MC-Unique: EbJvF9rnN1qsSlRaxY0Zjg-1
X-Mimecast-MFC-AGG-ID: EbJvF9rnN1qsSlRaxY0Zjg_1771510994
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4832c4621c2so11641085e9.3
        for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 06:23:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771510993; x=1772115793; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FbHvuuKoNJAJaoIiQsSzhjqIeQ7NdHJUqSJNAtbvmAg=;
        b=MwzmhfR0Zy6CSbE7SJSxjsLvqaUUiBLcnNMJny/BAkrni/rSK6a7N8+TEPBpqvqfFB
         Jwn7FZm7CF9t8EbfxvEfa1JoZJjHHfVj8dv0IKOoe5uWdV82HbkhbiWrZu3Ub7rPBoTf
         B9WSM/eTHC1znzpZsf8vpXA6UAQhujtgStLsXP18G5bt1iFMaEV8uebr+uBZr2PKqF+X
         OCgit151JTNpUn18f/EMfg8eiAqyb5jFsJs4Vu9ZsRIqsCwh+WHugUHxp992r+kQ2d8B
         kXygspLuHA8KQwpeV0PrEogQXaqVQVsIpCmb//+F35OKHXmNJNx+cQfjnN/4JueOQYHl
         PC4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771510993; x=1772115793;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FbHvuuKoNJAJaoIiQsSzhjqIeQ7NdHJUqSJNAtbvmAg=;
        b=igyINApiWxmrn7fs+4EnnpZy/zRDYNPPVrbxXVOTbShJVqMTQlTcbnxqIcBj84Dwmv
         vrvoCLjaCjBcV8XusZ/ZOWmbeh5zBYiffmKmtWCSdEA0y+WHNzewA+B+LbuMqkrvTfDd
         5spiCffXOcqf029ND7h0wuuGxeFEybLnrkrO+ucEYkhRo6OxNnP8fBhxdQ0tck1tCRY/
         MsjWb6YrHBpzI5R/fe7DCCmda0tvZ0qAkJMr8nJoSRZ609gamqFAoIxSBF6QX1PBY9UH
         q5GcW+oYMlp84f3PrehKaOzSV8vtnIyBgppvH6oDR23ePmHY+2mL/O1LuuRAqefKjT8/
         tLyw==
X-Forwarded-Encrypted: i=1; AJvYcCUY1l1S1ZrThQnItUW3GSZd7ybUa2IpD6JNz4NjnmPYabXgYAam/Y1ltafICyb/wNbJYbZugJCWZ2o=@vger.kernel.org
X-Gm-Message-State: AOJu0Yzd5ua/j+U6EE+W6pG3OUGqvbUlWLfe6wA+AQm9bDDixWjL83RR
	C40Q0Pjf5KP1JC71meSDAASm74153FGf7BlEHdBz5Nn01RRpqLCPUm88egvUZY9sLKc75yOuTHM
	NcBH4KeaXjEEGy7RkKhhNN2iLduYvqzktG/Q6XbVuX+7AE+Py7HO1hD2Q11ImzxGLz20D
X-Gm-Gg: AZuq6aJ0RKLCHNvtCC6Q9wH3dFKMMqFG0zMbWKPt2tGtdd2wc95sB+sgQ0NU9s6cRQU
	ajED7fJWqodNQfgIbGifDSNJZ5kO6F5ct2EgvXynD16JhvuowAzcFP3J24uO1luthvEaO4o65hC
	DsFStiauB1JjGdYfjFWrs4keP8BTWB+sKYXV4PKm2ND/3dkXNRKFSmngvGEwLnEkvR5yBZHbjEn
	57uQk0gc0m1ExN0wVolqhKd/H/JmWf188PQCktYln+qWcLWklKuHJ8z0DNm+PdceA+mOje0R9yV
	v7yAFERWJ93kR330pBM5dVChqiwWdugtl7XmPcXORhXj4LYYPVmXgJGMaJRD9qJGfMTaXiVwnXj
	f6NQiauKT7Cc=
X-Received: by 2002:a05:600c:458a:b0:483:6f37:1b33 with SMTP id 5b1f17b1804b1-48373a58babmr320615165e9.30.1771510993030;
        Thu, 19 Feb 2026 06:23:13 -0800 (PST)
X-Received: by 2002:a05:600c:458a:b0:483:6f37:1b33 with SMTP id 5b1f17b1804b1-48373a58babmr320614575e9.30.1771510992342;
        Thu, 19 Feb 2026 06:23:12 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483a31c56d8sm10551145e9.8.2026.02.19.06.23.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Feb 2026 06:23:11 -0800 (PST)
Date: Thu, 19 Feb 2026 15:23:11 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, 
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, 
	djwong@kernel.org
Subject: Re: [PATCH v3 11/35] iomap: allow filesystem to read fsverity
 metadata beyound EOF
Message-ID: <bltgc6uliclhzkuqd4la2tzp6x7vsww73nvjedxh7s624tby3k@jw4ij5irh6ni>
References: <20260217231937.1183679-1-aalbersh@kernel.org>
 <20260217231937.1183679-12-aalbersh@kernel.org>
 <20260218063606.GD8600@lst.de>
 <hfteu6bonpv7djecbf3d6ekh56ktgcl4c2lvtjtrjfetzaq5dw@scsrvxx5rgig>
 <20260219060420.GC3739@lst.de>
 <qheg77kxcl4ecqdrsnmz4acfvszjlamlb7ilgxxyf3pmt4r7ah@5fzzmcpurdfp>
 <20260219133829.GA11935@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260219133829.GA11935@lst.de>

On 2026-02-19 14:38:29, Christoph Hellwig wrote:
> On Thu, Feb 19, 2026 at 12:11:18PM +0100, Andrey Albershteyn wrote:
> > > > fsverity descriptor. This is basically the case as for EOF folio.
> > > > Descriptor is the end of the fsverity metadata region. If we have 1k
> > > > fs blocks (= merkle blocks) we can have [descriptor | hole ] folio.
> > > > As we are not limited by i_size here, iomap_block_needs_zeroing()
> > > > won't fire to zero this hole. So, this case is to mark this tail as
> > > > uptodate.
> > > 
> > > How do we end up in that without ctx->vi set?
> > 
> > We're reading it
> 
> Did a part of that sentence get lost?

I mean that to have ctx->vi we need to read fsverity descriptor
first. When iomap is reading fsverity descriptor inode won't have
any fsverity_info yet.

> >  
> > -               /* zero post-eof blocks as the page may be mapped */
> > -               if (iomap_block_needs_zeroing(iter, pos) &&
> > -                   !(iomap->flags & IOMAP_F_FSVERITY)) {
> > +               /*
> > +                * Handling of fsverity "holes". We hits this for two case:
> > +                *   1. No need to go further, the hole after fsverity
> > +                *      descriptor is the end of the fsverity metadata.
> > +                *
> > +                *   2. This folio contains merkle tree blocks which need to be
> 
> Overly long line here.
> 
> > +                *      synthesized and fsverity descriptor.
> > +                */
> > +               if ((iomap->flags & IOMAP_F_FSVERITY) &&
> > +                   iomap->type == IOMAP_HOLE) {
> > +                       /*
> > +                        * Synthesize the hash value for a zeroed folio if we
> > +                        * are reading merkle tree blocks.
> > +                        */
> 
> .. and we'll probably want to merge this into the above comment.

sure

> 
> > +                       if (ctx->vi)
> > +                               fsverity_folio_zero_hash(folio, poff, plen,
> > +                                                        ctx->vi);
> > +                       iomap_set_range_uptodate(folio, poff, plen);
> > +               } else if (iomap_block_needs_zeroing(iter, pos) &&
> > +                          !(iomap->flags & IOMAP_F_FSVERITY)) {
> > +                       /* zero post-eof blocks as the page may be mapped */
> >                         folio_zero_range(folio, poff, plen);
> > +                       if (fsverity_active(iter->inode) &&
> > +                           !fsverity_verify_blocks(ctx->vi, folio, plen, poff))
> 
> Another overly long line here.  Also we should avoid the
> fsverity_active check here, as it causes a rhashtable lookup.  F2fs
> and ext4 just check ctx->vi, but based on the checks above, we seem
> to set this also for (some) reads of the fsverity metadata.  But as
> we exclude IOMAP_F_FSVERITY above, we might actually be fine with a
> ctx->vi anyway.

Don't you confused this with fsverity_get_info()? I don't see how it
could cause lookup.

> 
> Please document the rules for ctx->vi while were it.
> 

Hmm, the vi is set in iomap_read_folio() [1] and then used down
through I/O up to ioend completion. What info you would like to see
there?

https://lore.kernel.org/fsverity/20260217231937.1183679-10-aalbersh@kernel.org/T/#u

-- 
- Andrey

