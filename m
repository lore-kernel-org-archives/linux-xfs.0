Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49AE338E8BA
	for <linux-xfs@vger.kernel.org>; Tue, 12 May 2026 11:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778587185; cv=none; b=lbgOTwmvABdN6io0ASjiXoU7jnicTR9JXwE2XYN2WC0SsvMwFXCSxEynCYIx2XKOM/kbyKDoepabdaxmzDQ8WSP1g8SyClMsZuBEWIeTH/8MHcBKE5BRwPFcSA7Vkw6LNXEl+PU0HkBTM5E7aB0cgz3ga3ehf4bKJFxU+wqwVbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778587185; c=relaxed/simple;
	bh=jM2L0IFNUlbmRiQHvkZh69ZSMx90Kwh8w09xvVtJzMk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fV25lprrbpSxuudPbDfLUyfEFChYPPWSe48EBHlSnbw4XMVMYPIKjEcrFoE4HPTzLwBN1AG3YxOQhudcuc+OGtimrfUYiD7eM1p5Whs8ptqUTbBldS/1cu6Ccf8kPd3ZsIAyBoHx909Yg+p2/U1Zka75TFKthUkvt8f8dQWvCYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=P6e04J7F; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=RrZg9yBg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="P6e04J7F";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="RrZg9yBg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778587183;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ohwwFBF+0tQgrLxHXfaauyqGIFnlel0+8KgTRF7og5Y=;
	b=P6e04J7FiiqiNL4Q5JfstVKVC/vzUCatCyKbi8gULBYclGPngBTJz9sx3dpb435LYPMB8z
	y/nLYFkW1SPUzfWC9ELsrFtrSsLANf51tNSXtrM9CjqQjBx3G0yUN/zxuq4pLE5jWhW7El
	RlxMYf3Osuzk/mPX1faCvuR4zm74YfA=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-399-fN8ttf8ANGezhtEcx1ctVg-1; Tue, 12 May 2026 07:59:42 -0400
X-MC-Unique: fN8ttf8ANGezhtEcx1ctVg-1
X-Mimecast-MFC-AGG-ID: fN8ttf8ANGezhtEcx1ctVg_1778587181
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-48a55de6fb0so37644415e9.3
        for <linux-xfs@vger.kernel.org>; Tue, 12 May 2026 04:59:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1778587180; x=1779191980; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ohwwFBF+0tQgrLxHXfaauyqGIFnlel0+8KgTRF7og5Y=;
        b=RrZg9yBgc4gGjGQwjs7zXxwFIbRLkOwbzVqFKSNfzvZyIWKpwhYTWIP03d14hmYHTG
         YR0Abydbr8QeakSP4xJ9XzpGdR+4my7tXsbMoe5WiOCjEJt500hn1U4JwoMcJDw/DsS3
         lwW1zVR3IbNzE20gi+2FCvadTLSFVam0PDz1dNnd+mOAO9kGsgQkmednvo5O/zaHKW31
         eHU6ASmVuzs6ln+npK60kg4uM8tPAWd7C9GgwNjrrdhyxTH98YQROeI1TuUS7dJSnubn
         obhdRRuYSs+MDymtWpjkJggIhPZTYSWcWcHK0Sa1R4pn6aRRmtVPYw1GiUHlyTb2ooxA
         BEIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778587180; x=1779191980;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ohwwFBF+0tQgrLxHXfaauyqGIFnlel0+8KgTRF7og5Y=;
        b=MGT6KqcORfUAqP7TPALxwNFOePJcUsB/jejMJbkJcJkB91gB+FV0A+C/LmVCBkRwvy
         iM33bpnTXEZvkFO5HIgFBpYTjgt4ncXLmdCbCSeXBNfrtYlIhOf8QFzbzD4ZegOH1Xeb
         dnIzOzZN9Bjk+sbw631ToHFh+RTBE9utUnNVRtiMjqmoiAcYhRCFsvc+KDgIFlVZ92V5
         vpsc5PX8dZI7E9LCKE+Wlsw2QcxaY6U1pxoT67DX8mOB+o8MJlFkkglhmQBZvyehR5q7
         Z1blInsO0FoaaKFQXlz411eC+qv1Wunj1p6lcm7wYHIIeGvCSTA7rX9CItUyOPFYJh/q
         Iecg==
X-Forwarded-Encrypted: i=1; AFNElJ+U0tk8G7OffeeumjmW1pP1+B2ERH4siHlXwvwJbhE7ellYkUVIS8b/kpMJHfPHRfakmeqNEY9i7yI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxsYER2Ra7BbF6mZgAVtFoRtOoN1cM0vmnpdvYfxR/Kv+YhwBUv
	Mrg7qxmQNGdVwU+Cizxz6+v8PvwvNWv8yZYf5bKyLXbZr1QJ+0zcxcdpi3HJt92gxWFIf5L3b6f
	i3NanipicsNiSL9q3cd6EmP25LSSJ5Fd93FLg+AsnpcnIsjTkfMXlwyD+olKrXo9L97ns
X-Gm-Gg: Acq92OHeiip7W4qn5YGxKUMd+mcDtSqa0HBiAVYR18HSoPXN3KAOv7BWNCHsXDuCTP6
	Se5yIjZxIbrFa1fTJ3Dy+W0mv55wwO2bAzXRtwulCO5JaTOLHn3EBoydtfM13LjKgMa6eq9TvuN
	+5lBHFUE1MSh5lAxZBKYeFECm2fzWw28qxSz6LGuwNMy5ej6AfSV6XLFbhV0WEkLGV9AqU7AuXx
	xwdhfKXNyi9HbAcHdeBbvxPMPSlfJNWDJTAJY/3pmYy7vDpZ2zHehwNYJFY8u1lXNqxJRweuhfV
	Fyzg0/iY4/bj60E/ao7QZtt4aawIBWaEqiJxezLViGei3VcnwPE4n3ga5bwZ2UApPh68Q0870Sf
	oJNHY6Cz8e5M=
X-Received: by 2002:a05:600c:c094:b0:487:5c0:671f with SMTP id 5b1f17b1804b1-48e51e1a7c4mr325890045e9.9.1778587180077;
        Tue, 12 May 2026 04:59:40 -0700 (PDT)
X-Received: by 2002:a05:600c:c094:b0:487:5c0:671f with SMTP id 5b1f17b1804b1-48e51e1a7c4mr325889675e9.9.1778587179521;
        Tue, 12 May 2026 04:59:39 -0700 (PDT)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4549217b782sm28466065f8f.35.2026.05.12.04.59.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 May 2026 04:59:39 -0700 (PDT)
Date: Tue, 12 May 2026 13:59:38 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: "Darrick J. Wong" <djwong@kernel.org>, aalbersh@kernel.org, 
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] platform_defs.h: fix __counted_by_ptr annotation
Message-ID: <danujgrrdi5yfobdhkzoeplh5ulog4iz7uaq74c6s5gwymxm3y@5zqfgdifduoy>
References: <177819182629.3486034.5026297034156212262.stgit@frogsfrogsfrogs>
 <177819182658.3486034.17713563256078765686.stgit@frogsfrogsfrogs>
 <af2lN1mpbsExz7oz@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <af2lN1mpbsExz7oz@infradead.org>

On 2026-05-08 01:56:23, Christoph Hellwig wrote:
> On Thu, May 07, 2026 at 03:11:27PM -0700, Darrick J. Wong wrote:
> > diff --git a/include/platform_defs.h b/include/platform_defs.h
> > index 5a829db66e0899..5d1bfb1baf94db 100644
> > --- a/include/platform_defs.h
> > +++ b/include/platform_defs.h
> > @@ -331,6 +331,8 @@ struct kvec {
> >  #endif
> >  
> >  /* xfs_attr.h */
> > +#ifndef __counted_by_ptr
> >  #define __counted_by_ptr(member)
> > +#endif
> 
> As a fix this is obviously ok, but I wonder if we should provide
> the full kernel version here that actually checks?  Or just not
> bother as sooner or later the kernel version will be in most
> builds?

I think kernel's macro won't check anything as it's gcc/clang
attribute. Here's kernel commit which add it:

150a04d817d8 ("compiler_types.h: Attributes: Add __counted_by_ptr macro")

To make the check work we need to add compiler version check to the
build system and then add these attributes. But I don't this much
done in xfsprogs, so I just went with stub.

-- 
- Andrey

