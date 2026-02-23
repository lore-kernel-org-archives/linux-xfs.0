Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B96EC361DB2
	for <linux-xfs@vger.kernel.org>; Mon, 23 Feb 2026 15:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771859431; cv=none; b=AlRcuuVedGdSikv7RYvdyh8fPgqRl1DLwhtz6YDEHI/DzT2SwZmTn5H5mKS8RsVfnzmxp9jrtyDjohnRTFiwa5i1S0fOAk/eWFcezy7qMAmio7SN7k6ah74SuLPfScRt6YkZKpii61FBLDb9T5OirLCAiDJVh8u5PMNQltgwMF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771859431; c=relaxed/simple;
	bh=ajbFxcQIg7kiK+LNtaEKR4J6yZsldAS3Pd3wK1n42zo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mhEwpO18bn7sxs2vtAjtXX9FcpOncf0DBTO/yhS5z9Nv3mIFCIVoSN/+pwIOhgJCFpUA16Ep5Dc0CWIC15e4HidEv5FATGsmyFKwdkjS/LRspszTI7PJYT8pYomne7c8BNqzro7sVC0DwcIoaXmS2Blm8MTIj+8GDi7/tmNJ0uE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XD0YEjmJ; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=evBfy0fw; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XD0YEjmJ";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="evBfy0fw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771859428;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7toYPkkmoQQ1IjdzTLbC2+SMDXKjnI0hCgkq/dBEBHU=;
	b=XD0YEjmJGWosH7URDPLqMbUMyj6IrdCNSOhungdPMBpkQSv/KGnMsyDK5WDotjI4Am1W5H
	QSoWgzi5PNrea592M5x4bH4fpjSS9IINUDT5p1oRBIdwGuLJAgpd0V/XOSlSLw5lpKPK5x
	V8ToJGKGaY5tgUgbAOcXNfNbD0N9xBE=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-68-cJW3KKNkOk6vISs7Xx5vMQ-1; Mon, 23 Feb 2026 10:10:26 -0500
X-MC-Unique: cJW3KKNkOk6vISs7Xx5vMQ-1
X-Mimecast-MFC-AGG-ID: cJW3KKNkOk6vISs7Xx5vMQ_1771859425
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4836b7fbf4fso41987975e9.2
        for <linux-xfs@vger.kernel.org>; Mon, 23 Feb 2026 07:10:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771859425; x=1772464225; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7toYPkkmoQQ1IjdzTLbC2+SMDXKjnI0hCgkq/dBEBHU=;
        b=evBfy0fws96FzP2lwLkAs0u90azno9jSAvnysYphzwz7Ta0qxSBeQu7qUmO5kg9TU/
         Tvi+2kmyViJFT8tHsZ8PGhEheZt16trncDmdEqgpr+/CvgOGBJ5/qmbtkPY0kC/JBuHO
         pT0KMUjXnDtDk38FIvJQ1obf4N1geN6m4VyVNL06T6wpWbrxfwgWHZOo9ZFqqRO5B6ep
         3M+SV7wjSUW8I0GuuhRYC5xl+0RgXExYzwL6I2rt1i4Ao7VOr2LitSK7LOk4qf+GyJoi
         VhVL4edfd0w3tAYGcWrRtzr3fHZa6qV2urgosc9vkOkyQbXL3HCVXSrX4VwtsUTh5FzZ
         eAmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771859425; x=1772464225;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7toYPkkmoQQ1IjdzTLbC2+SMDXKjnI0hCgkq/dBEBHU=;
        b=ePx2CafST4sMvDMNzFGfXc40iyx/jlngwfOH6iInT69EKthyg1iO7wYPU3Udw2hm92
         O2mRHmrFBJM2JqW7FyAfEe9p4M443wRrf8lLjXRDrCX7NfLZFJ+oRHgFbvDMHQ/gZ/dD
         kPf63eUSMbiedmDyyUCfRnUOEVi6kjDifv5Xk7tfHPVkfFPybqT9iL0KC1jpuPnV7Lhk
         IdkDMZFha26Z+qrixHfaUrOj4mEYCYnwU+Qg4kafyGZZ2FUhRyCbKXUFuDHCZtGPvqEJ
         jnlSsG87e4By08ZwtNw5bbcOgJqcdsl6O4W9mhecqlmCtEp98BeUx2iP3VwYKhV/m33f
         Yyrg==
X-Forwarded-Encrypted: i=1; AJvYcCUZFKQmYBmCedZk+50htBZSOSwRMl+ZSAAR9TmiFknXXs7hpObagdAi9we6G1CFJq8lHSMO9l5Ausc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/Qvnyfn2aQbsGrxWtTYnMnTAlXxJdax4+6jUO+M4Qttd3c8Bh
	y4zt6IpLS88WhREHcajdUo2E2eMpdaThqAzY1+EBSCswVqHEc5oa5bvwbrGwnr2lrGK9+0cVYL2
	qFCykGagqe9kiv3A9NeLip/xxeJGNMn5FYLavtWiOqC+OdDO8hcO/hdbjsJCV
X-Gm-Gg: AZuq6aLPd78JXhOsq/dVaOr+eDBibzkMW4bKg9lDY5O18vEw8P0GVVOnaQmL3SUg9HN
	ZSCnFb/SjI70vt16sI+748bg3iRH35PUX9epCi3wVWq7eSGyf1ifSOLdexzyU5LaukKBW8ROaIm
	ZXshwE0xeaZX9M4u7uXO8l5I2vGIo+GBdzq4Ymyq+CLFslJdmhN3pT08ItiuLyPW7QyqHwbP7nW
	TaU5q/4KH9FBUA9neaTuCcxNwzxQxeYlh6znzicDXie0SrE4vCrxk0l8BJvVnnnbXxgwSfGm5pG
	3DNS+xWl+QZMQcj+1pof3pjgafbIsFqX5h0KA3fkK2XpSB0GyXURMNsoyw42nH7iA++Hj6jrEGs
	C10rMJsEEYe4=
X-Received: by 2002:a05:600c:3f14:b0:483:703e:4ad5 with SMTP id 5b1f17b1804b1-483a95e2563mr126160855e9.22.1771859425031;
        Mon, 23 Feb 2026 07:10:25 -0800 (PST)
X-Received: by 2002:a05:600c:3f14:b0:483:703e:4ad5 with SMTP id 5b1f17b1804b1-483a95e2563mr126159955e9.22.1771859424262;
        Mon, 23 Feb 2026 07:10:24 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483a31f9475sm249120765e9.14.2026.02.23.07.10.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 07:10:23 -0800 (PST)
Date: Mon, 23 Feb 2026 16:10:23 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, 
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, 
	djwong@kernel.org
Subject: Re: [PATCH v3 11/35] iomap: allow filesystem to read fsverity
 metadata beyound EOF
Message-ID: <ujwgs5xb6rienyskr7qbekmsbyn5qea2ew4untas5drqdufirp@2qea2ndmnchs>
References: <20260217231937.1183679-1-aalbersh@kernel.org>
 <20260217231937.1183679-12-aalbersh@kernel.org>
 <20260218063606.GD8600@lst.de>
 <hfteu6bonpv7djecbf3d6ekh56ktgcl4c2lvtjtrjfetzaq5dw@scsrvxx5rgig>
 <20260219060420.GC3739@lst.de>
 <qheg77kxcl4ecqdrsnmz4acfvszjlamlb7ilgxxyf3pmt4r7ah@5fzzmcpurdfp>
 <20260219133829.GA11935@lst.de>
 <bltgc6uliclhzkuqd4la2tzp6x7vsww73nvjedxh7s624tby3k@jw4ij5irh6ni>
 <20260220153113.GA14359@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260220153113.GA14359@lst.de>

On 2026-02-20 16:31:13, Christoph Hellwig wrote:
> On Thu, Feb 19, 2026 at 03:23:11PM +0100, Andrey Albershteyn wrote:
> > On 2026-02-19 14:38:29, Christoph Hellwig wrote:
> > > On Thu, Feb 19, 2026 at 12:11:18PM +0100, Andrey Albershteyn wrote:
> > > > > > fsverity descriptor. This is basically the case as for EOF folio.
> > > > > > Descriptor is the end of the fsverity metadata region. If we have 1k
> > > > > > fs blocks (= merkle blocks) we can have [descriptor | hole ] folio.
> > > > > > As we are not limited by i_size here, iomap_block_needs_zeroing()
> > > > > > won't fire to zero this hole. So, this case is to mark this tail as
> > > > > > uptodate.
> > > > > 
> > > > > How do we end up in that without ctx->vi set?
> > > > 
> > > > We're reading it
> > > 
> > > Did a part of that sentence get lost?
> > 
> > I mean that to have ctx->vi we need to read fsverity descriptor
> > first. When iomap is reading fsverity descriptor inode won't have
> > any fsverity_info yet.
> 
> So for ext4/f2fs the pattern is that it is set by:
> 
> 	if (folio->index < DIV_ROUND_UP(inode->i_size, PAGE_SIZE))
> 		vi = fsverity_get_info(inode);
> 
> i.e., only for reading the data.  OTOH, for iomap we do:
> 
> 	if (fsverity_active(iter.inode)) {
> 		ctx->vi = fsverity_get_info(iter.inode);
> 
> which means it now is set for all I/O on fsverity files, which
> is subtly different.

I see, I will clarify this.

> 
> (You don't actually need the fsverity_active chck, fsverity_get_info
> already does that, btw).

Sure, will drop this

> 
> I'm still not sure what "When iomap is reading fsverity descriptor
> inode" means.

"When iomap is reading fsverity descriptor, inode won't have any
fsverity_info yet."

sorry, missing comma

> 
> > > Another overly long line here.  Also we should avoid the
> > > fsverity_active check here, as it causes a rhashtable lookup.  F2fs
> > > and ext4 just check ctx->vi, but based on the checks above, we seem
> > > to set this also for (some) reads of the fsverity metadata.  But as
> > > we exclude IOMAP_F_FSVERITY above, we might actually be fine with a
> > > ctx->vi anyway.
> > 
> > Don't you confused this with fsverity_get_info()? I don't see how it
> > could cause lookup.
> 
> Yeah.  Still, having ctx->vi implies fsverity_active, and follows
> what we're doing elsewhere.
> 
> > 
> > > 
> > > Please document the rules for ctx->vi while were it.
> > > 
> > 
> > Hmm, the vi is set in iomap_read_folio() [1] and then used down
> > through I/O up to ioend completion. What info you would like to see
> > there?
> 
> See above, unlike ext4/f2fs we set it for all I/O on fsverity inodes.
> And afaik we don't actually need it, the only use in the fsverity
> metadata path is the fill zeroes hash values check (which I'm still
> totally confused about).

Yeah, for metadata the only use is to fill zero hash blocks. I will
try to split it so lookup happens for data and holes in fsverity
metadata. This way we would have less lookups for metadata.

-- 
- Andrey

