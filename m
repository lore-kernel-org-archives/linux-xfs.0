Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50FBB3446AF
	for <linux-xfs@vger.kernel.org>; Mon, 13 Jul 2026 08:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783930606; cv=none; b=qSYTDfSmRMG8ixB0NnqUmUH/u+1WY2/2UE55VFAgrHKWpw/bTBshDlm2JmjHH+oQXdBSeyYuoNuLoYDseEND4F7iaoKQAHmLxgXK8jAGHvqlyPVrKdqRRibwujg7vjVW/Kuk8y3PDgCyGgRgmGtlMi0UuUEcVqiAH+mSetcUUrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783930606; c=relaxed/simple;
	bh=ZtGi/8vtQN7HKCumPKvrusANeC8z6jPebDpLjTiSNQA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PtWf4aTDCSfHiEixfa163pdNCTw98DwyOAeCec6kv9F0ASZTD4RNhnEnANUpsFvuK/OBJASvspHpNUtbXGqgp57MMNcqJ0efWaoP8TTa3colbMuHD/PXyOEj/q+ZDXYzu9Cp/V6HDC2htZbYNx1DF4ijOLTfpSVLQFuLYLuHu3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=IjF7/HKC; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ah8VXeeJ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="IjF7/HKC";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ah8VXeeJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783930603;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qitVlXfkVbLZ19rYAoRnVT8+321wabtilZzFTJ/EX/8=;
	b=IjF7/HKCR/qjv96qzWsH/k/tx49fge58hjdVAHConhqrDl86W5cPt2iFUp2k1UE/Qx3yxL
	xr4vRNSk3dsg4EUn+pXuvRgZVdXwaVC9u2FU/o9w7vDsMy4mxdw7MeYpxBZ9r2ZvUzr5P/
	lM2yq/fojRNb32FyWCqzGiF1E0S+7Bw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-249-D72TN0OdOOC7-M2fu4_QSA-1; Mon, 13 Jul 2026 04:16:41 -0400
X-MC-Unique: D72TN0OdOOC7-M2fu4_QSA-1
X-Mimecast-MFC-AGG-ID: D72TN0OdOOC7-M2fu4_QSA_1783930601
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4926596eebcso26648195e9.3
        for <linux-xfs@vger.kernel.org>; Mon, 13 Jul 2026 01:16:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1783930601; x=1784535401; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qitVlXfkVbLZ19rYAoRnVT8+321wabtilZzFTJ/EX/8=;
        b=Ah8VXeeJGOw0XQVq1ZYidspkmBReREDtx7ohyuKpTgHNqpiSs34MirMgPNHH6u9mqw
         lfSf6CM22kENUSiZQ+nnW3qnxgDGG0vm1AkxjyqiY7J6+q+reA3muQFD5Lgi4Xg0Yyav
         hjLknYi2dtuyV1AEE/bPsE4VSTI+1KoqwrIlLzB8YnZgUnFxi9s02xZzP92S/tUTlauj
         Xla2xojRKzVwhfrM0PennNaaj6KG5z7iKPaWsWe6y0H+aN9YLdd2/PJLTyolSi5870l/
         fFynCHylBAItWy7/6YBnvgHzsnJ74APtV4B1gICh2LJoGq73HfRUBCII8cwUq6VHsdfx
         BhZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783930601; x=1784535401;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qitVlXfkVbLZ19rYAoRnVT8+321wabtilZzFTJ/EX/8=;
        b=q9hm9kQ2Gkex8lao87RWlg6QjIxA6AwN2lGMAmNPlv2yCIkZBdo9osHg2fplD3fclk
         NWYlmL6TlE6VclayzATQRnfYF5qqMx6gTbEZxXK6AICzxtKPMd4ea3gxWZVRQWzZaNVE
         5YucNwVz+mkCdRt01IxwhmVVo4mwd5Ta+b5dX6APSMWCQdJ7mBHqgYCftkWM8jobDyym
         mVJmHG49osyxHF7/k74UdZfvIaeY32U9oOXb8JI7hHFUXTqqFFD6azZ0+PqiD1SR2kaI
         q45Wp1KqoBRhoI8eaZ3p45FSuJhh1ZfMD4Z0RNBapIaJPfGGY/KIpmI1ElJeLA64emL8
         ACUQ==
X-Forwarded-Encrypted: i=1; AHgh+Rr5uTjFuW63Z/veYkVqr0WsSpom9GmAg3hVad6L2IqzsEcnP+TLKsg3oU3/8dK7sWGEpKyAqnTuHZI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yww9tN2KgY6Ecy53SfMXg+7jDj0iKgJ6zRKppM0EZtisFOvB9Yl
	O4Jb7T+48qhimSGxhygLdFq7jKA4Pra0q9Z2OCws78FF3jfxhmpsVwnnxHeY6lc+cGWsd25SzEv
	b1Fz6cqXzrkZyKQUjH4Lvod85JSclyRXHuoEFngYbXW+/jE8fEbBKLRjKgqvI
X-Gm-Gg: AfdE7cmym0QLzPYVXxwLGsYisG8D2ZBoyOK2jESYRX9E2Iyb+i+nSleLCr1cn1+jUQQ
	sjj3hFhrs4kPlUh6OUuT90gXcOM/iwcs5MUmEntUyxZ79+9Ld0N52ti2X/Tu8l9xaBpTIPQAFs3
	QmQWd2c41HLjFtuJLcQ2EM9w15lx/i918ZARQg5Rt26Za/QJAQyD6DSUs35s6AJkEOmZ+LtMV5E
	B8hzI3RFwWRCpRPTeofLDYfPBix2RdcexSAT+CHfUDNhUYhAizCrXNET7//RxIqxL1ykF98K/sy
	Kdi1wT6SP15hdW8knZ1hNVw4UjhB41iW2H7Whh2LT362Bq5zKYgSlCTFaWQKrLk2SbDuAfj6wmr
	t1SyU1UmQ4SMLrn+8LZzeAh8ZBh6Fhz+2zebZ19BU1Sloew==
X-Received: by 2002:a05:600c:674a:b0:493:f80c:5455 with SMTP id 5b1f17b1804b1-493f87d85a9mr80792585e9.5.1783930600533;
        Mon, 13 Jul 2026 01:16:40 -0700 (PDT)
X-Received: by 2002:a05:600c:674a:b0:493:f80c:5455 with SMTP id 5b1f17b1804b1-493f87d85a9mr80792235e9.5.1783930600066;
        Mon, 13 Jul 2026 01:16:40 -0700 (PDT)
Received: from aalbersh-thinkpadx1carbongen13.rmtcz.csb ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47a9de1e785sm82014266f8f.8.2026.07.13.01.16.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2026 01:16:39 -0700 (PDT)
Date: Mon, 13 Jul 2026 10:16:39 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, 
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, hch@lst.de, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-btrfs@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v11 06/20] fsverity: don't allow setting DAX file
 attribute on fsverity files
Message-ID: <alSdUBiA6n40PKim@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <20260710085256.3464201-1-aalbersh@kernel.org>
 <20260710085256.3464201-7-aalbersh@kernel.org>
 <20260710234643.GF1911@quark>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710234643.GF1911@quark>

On 2026-07-10 19:46:43, Eric Biggers wrote:
> On Fri, Jul 10, 2026 at 10:52:34AM +0200, Andrey Albershteyn wrote:
> > When fsverity is enabled on the file, with FS_IOC_ENABLE_VERITY ioctl(),
> > it checks if file has DAX enabled and fails if that's true. However, the
> > opposite case is not checked.
> > 
> > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> > ---
> >  fs/file_attr.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/fs/file_attr.c b/fs/file_attr.c
> > index bfb00d256dd5..5424ec4e3949 100644
> > --- a/fs/file_attr.c
> > +++ b/fs/file_attr.c
> > @@ -246,6 +246,11 @@ static int fileattr_set_prepare(struct inode *inode,
> >  	if (fa->fsx_cowextsize == 0)
> >  		fa->fsx_xflags &= ~FS_XFLAG_COWEXTSIZE;
> >  
> > +	/* Can not enable DAX on fsverity file */
> > +	if ((old_ma->fsx_xflags & FS_XFLAG_VERITY) &&
> > +			fa->fsx_xflags & FS_XFLAG_DAX)
> > +		return -EINVAL;
> > +
> 
> This sounds like a bug fix.  But actually ext4 already checks this in
> dax_compatible(), and the other filesystems that already supported
> fsverity (f2fs and btrfs) don't support DAX.  So I guess this is really
> lifting that to common code?  

yes

> But the existing check is still being left
> in place because it's still needed for ext4 specific flags anyway?

The flag mask seems to be used only in dax_compatible(), but I
suppose this's fine to leave verity flag if EXT4_DAX_MUT_EXCL will
be used elsewhere in future.

-- 
- Andrey

