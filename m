Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E36A14A8B
	for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 12:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771505159; cv=none; b=tWjkOExyP9v4z7yBen7n6vvih1JN0HWyuvxL3HRg6oM+bh/Y4+Q9AOwLSxWTbNogSQ8UfQsgLL1SiBGsFzQrn8f0N+vEtVgVSCJR033WBuc2FR7VS0WKEFhAb2JgD+KVXV/JP7sVh1zIk7U3GfqUKzazwTlNoPSWYNmQ/+5GgV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771505159; c=relaxed/simple;
	bh=YZj+GxGcB2P5EaA2DiPIK6jUW8TyBkFDHxcApQg7DBc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bonyrz10bl2kDogBOro0nwgzy7nftNNmFGRip5kFXWG+h6/WfEj9n4lp0XQWeF0RkvTWs/KbzoX8zfYgCB/jaN+62UGZelAWsy+mCVCrpk2l6/m0RtwJHhYOI+et6LYX3Glzrv5aEOjGLaArXgST5XIKXsoU6FEi2QYWw1gV59E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RKzzGsTx; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=gseHg9kZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RKzzGsTx";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="gseHg9kZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771505157;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HAt8PmrU86SKVM1FRxExfTh0czVVLlWni+dAt41FBrg=;
	b=RKzzGsTxhbbxzMw93lnx3CPYugEXbHnAzOeJ06A7KrrckIg/VJcmpTO0pEJABJl8QGgQuC
	u6rYTdM0axIcpJx2c0//on9PwrrI4D5w77zN6q9qBxwXe2hM2dx1IoPjrRpPDsNhKj48PH
	nSCajdnTfadZtD0MyyPyuDqVPUg3mP4=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-294-vX2eaRnnME-KYsG5Krmw8g-1; Thu, 19 Feb 2026 07:45:56 -0500
X-MC-Unique: vX2eaRnnME-KYsG5Krmw8g-1
X-Mimecast-MFC-AGG-ID: vX2eaRnnME-KYsG5Krmw8g_1771505155
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4837b6f6b93so7575955e9.3
        for <linux-xfs@vger.kernel.org>; Thu, 19 Feb 2026 04:45:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771505155; x=1772109955; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HAt8PmrU86SKVM1FRxExfTh0czVVLlWni+dAt41FBrg=;
        b=gseHg9kZ+w4ihgPM8OLhqC6nc2qnvoBiZOvTFE9i0S9r7ucwgJ+5C+scJRND8sofJs
         VNge/b7a5fcESPOdb3AuOfLWDb0TQ1oWA/9D6CzampsaeFOk9DC3X/D2vIGxMUvRXVm2
         qBB72CFn3rYcej9aDg1PwvxU+JAyhO+u5C5i14dedmkhKV4Al7fkkSYV5RYQMJB9AZj8
         JwsJNWn9z5NFxOpGT2rPamt/PcEbjWIFMKtB2JdORsnUx2I+SypTPM2sKPEiixpXWqIV
         1WuWMq2oF/SkWtbm4S9xpc/XwhaM5dui9Ocd/LlbgTGPQThe+iW8mg7itwqNdeSV9saX
         l0yQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771505155; x=1772109955;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HAt8PmrU86SKVM1FRxExfTh0czVVLlWni+dAt41FBrg=;
        b=Pmxn0I5Zk58ISj37QlXKngzgFBHdo3ktuDQB2wooEdLNrZ2twOG5g2jBy158zstCWI
         hvt7L/piIZ1PWImUOyDCbXsRcVfYmxHmdE1GyGwaThhZny9GHjD924sk5f02rN9Q3uJw
         0RSSmp7JHrcf+uYostlmcMfsvJndSe3ishf6D+T0JDH5bHRxSSwdkEl4qkbrPdKzJUa6
         giBYkvjPklM9BMCP4vC6bc45CjYxN9SyiFvGBqd1WM4uPpBMZCsMXqoWj7REHmGFppdl
         8USxWe/x9KkBWQjwLF4LtZIXK4RXaSkBZT/YYS6hvZKDyNVwFnqWxr+hqE1FvH0+kQVF
         4D7Q==
X-Forwarded-Encrypted: i=1; AJvYcCW52d8SMv6cAXqPqlfZwQ/l0e8bVYsDKX3Qss1GBZf827poT/4T+1eizy//glo9E1JFuNI7LJPfYnk=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxmz8GJo1FZuJ79DQiu3mXsCZq8dx2E8uYKXgz2kYk1MHqKOEFN
	m2zFQT5pS4TItQRxGkI0ACby1e1hcfdd/XjBfr6xPJhhcgF8ssInRt5MwigdAV743SXzXl29wt4
	eALwQTNuPU0ktnp+/rYgDas0p+Rxdl6tCnm5ApjNn1TCkxGl7RqHPyPix3D4N
X-Gm-Gg: AZuq6aI6Dohxdo7dywoavkKmzt1uL5/aZYIA+0dV18/tIYjEGByjYCqLsqBq06E97TS
	zojwgrkbDGZ75xhVNh+672GGXGkiFTKTY/Gje7VBExhNYbUPlJRRMJitDQTYLGHc+T06mK1GxTT
	rj3qFhzq2dPHRRmBDoTnihiOjnf7Nlln36UPxtMg9noxyI2vY0kxEm147NNgQ/MAK4GKr4pxvsN
	MKno77IZHHlQHXkEc7uFWvtTz66NbjpvvGkMeABOvqbyQXOsDeeDtTuNRSNqgehI6i5Q/CaCvsy
	Dn7u16KWVuyYGZcCmLX8SnvpxXTzTX9z6ukBed1ynUVNaMfUzqmZYVQ21qIWTz5hTL2FCwhdHQl
	clmXWyKyQpvE=
X-Received: by 2002:a05:600c:3496:b0:47e:e779:36d with SMTP id 5b1f17b1804b1-48379bd72a9mr274885785e9.23.1771505154956;
        Thu, 19 Feb 2026 04:45:54 -0800 (PST)
X-Received: by 2002:a05:600c:3496:b0:47e:e779:36d with SMTP id 5b1f17b1804b1-48379bd72a9mr274885405e9.23.1771505154517;
        Thu, 19 Feb 2026 04:45:54 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483a31b1712sm2281905e9.1.2026.02.19.04.45.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Feb 2026 04:45:53 -0800 (PST)
Date: Thu, 19 Feb 2026 13:45:53 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, 
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de
Subject: Re: [PATCH v3 05/35] fsverity: introduce fsverity_folio_zero_hash()
Message-ID: <rxgelentzvfkgygsyapfylqaja4dtpyh5v3yprjw4ay66bmmwc@koduf7u6tfon>
References: <20260217231937.1183679-1-aalbersh@kernel.org>
 <20260217231937.1183679-6-aalbersh@kernel.org>
 <20260218225303.GE6467@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260218225303.GE6467@frogsfrogsfrogs>

On 2026-02-18 14:53:03, Darrick J. Wong wrote:
> > +static inline void fsverity_folio_zero_hash(struct folio *folio, size_t poff,
> > +					    size_t plen,
> > +					    struct fsverity_info *vi)
> > +{
> > +	WARN_ON_ONCE(1);
> > +}
> 
> /me wonders if something this deep in the IO path really needs a stub
> version?  Otherwise this looks ok to me, in the "vaguely familiar from
> long ago" sense. :/

I thought warning would be a better option for iomap. I'm fine with
dropping this.

-- 
- Andrey

