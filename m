Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A261C23185E
	for <linux-xfs@vger.kernel.org>; Mon,  1 Dec 2025 19:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764615852; cv=none; b=IjJOdeE45UqzVvr6gRsDTRpnxr/QRvNcd9P/bOK/whaa+pCBhUpMShG7ckTBNfLLQDWr7IBSZ720m13bpvihfM5jppq1TxUhS5U7vNLCAsn8t6MoKkwE9ACqXzn/xdv0aWaHFysLvj1qu4qFbM5Nlon3LipmLp1pps4fIp0AKJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764615852; c=relaxed/simple;
	bh=8RoVkxqWwdCsGpCpACPR0LBF97VjM8drQnH0BRBTwDU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OLRJirt1zdUsQ0pUR8JpDVHyhA4lT+jy66CROH3VNKAHAT4tb3bj/O6bQAQEGdgLtgoKmU/Q2QpiCH7hhwW4bWgral6yGf8uvBd4l+1yUNQxLGeayIWLIjXj7aTZaDwMZFI5diGuY11MZeKXOMOYTLm21hR8qmpHB3CS+gbyuXM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=blacN9+x; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=rNRPC5eZ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="blacN9+x";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="rNRPC5eZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764615849;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2dhq9Iq6zLcY6KVQbmV1Y9UXTJPYzsjU4UV9+sKBA/A=;
	b=blacN9+x5nPbx61AEjaeGq6ItA43SasjSrabe1PJMBJ9BOQDLp3G+eZwOA+3FKMWQXXJX/
	xypg8/BlpVyP0nQmIFX1LOd7lj6tbF5nzhvvsBCVVOYKVtPFugspJmV0E+4Skzb+3FLHCR
	I/H8kqjtXfDZX7WCQgC9GROptBWMZEI=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-556-S40xalsDNgy5zTU7p9_xQg-1; Mon, 01 Dec 2025 14:03:58 -0500
X-MC-Unique: S40xalsDNgy5zTU7p9_xQg-1
X-Mimecast-MFC-AGG-ID: S40xalsDNgy5zTU7p9_xQg_1764615837
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-47910af0c8bso31547245e9.2
        for <linux-xfs@vger.kernel.org>; Mon, 01 Dec 2025 11:03:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1764615837; x=1765220637; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=2dhq9Iq6zLcY6KVQbmV1Y9UXTJPYzsjU4UV9+sKBA/A=;
        b=rNRPC5eZ7wXI6Csbe7mxyXOcqJL9FrgJhT/Ai+eES7y9R9cvcsLGCRKxVDhKm01aCD
         mE33fl+5nyIcp40U2QPcMNnVumZDR4Ww673+8bPZklUw+p8GCbDOP+d+Rc0Au8QqOPRI
         BPaYpaVOEvd9kOzgd+f53+iNFCsLvazGG6EnjrLP5Q/ebtrR9hnlbGJP4FnJw2GMznfu
         DkPp/ZSxQF3/LDGKsFsTGdLYUeWUnRcPUmkBKNdDDUzacEXYiyYmjuQ6azIXWsnCzYjX
         0waF/S262aU1MtJzT0OC6EZwBUR5dYTCcLLOgrqhkphTm4dciwVo0xp1HUC2q0YJ5YX0
         UIlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764615837; x=1765220637;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2dhq9Iq6zLcY6KVQbmV1Y9UXTJPYzsjU4UV9+sKBA/A=;
        b=sERHoBEDlAS3f9w0KSvhLE+MwOLkwsCgRDlWb4GCxq0gxj5+vuwvhs+0T8eL5ntJCn
         qPnOoBfWHeVpis0TCogLNW6EBxIdKj+dV4hq1EHI2L5NdalxNKQE8zlEJ77Gyfy8l7rU
         X8xs5Obpqid/COa1GarW7lCOZoKGCFPo+PfI5l+7xfb/nUsTS/2ctMfGTb9qDTL4ThG0
         fOLFNoc2c257mrdx7eq1PRyObLXBG4kxQYjUZqY3iNMSQVgCMaZgZMBTKDzpf71bw9gv
         bI4L3Zhfuv28rRipZQQBl9h5xBW272J84qBTdn0oEkD8UP9toaufMYc21kM2vJlJOFn+
         SLVQ==
X-Forwarded-Encrypted: i=1; AJvYcCV/ETyjIkFRJd4hoaAbyWJYoNHSZwuM7sEgy46EAUPszJbGiFydK75/4Z34x4HzUVXre5aAecwdnRc=@vger.kernel.org
X-Gm-Message-State: AOJu0YyGyLKUCUh+F5Wa7CbAPn/X1hI9DPwH+Ld15B09Qq0DbokUUw4R
	HOXKQ9Uo4g7u4bB6wwp2DVwAE6KcYmVLT1+O0RcFpkHH9SAE5Wrz9j0riqMCc41A/VHZamwrm34
	VQXkEgqAYLrnX6Ll3BPYlV+kauEcXKdFoVrvE9h+XVLGXwwUstUyFg+jfWZyL
X-Gm-Gg: ASbGncuYbYMlr8pSuZNrJxcIDo/cn824Po2YBBMPVhxEFpe5p+2cvSTQZUWg4G8/LRa
	dIZPu1GTzx1uUzq43N+ePVAa9t9RtuDiOzo/VEr9c5PhS49q8e5cAxwsGrMKUY6X8MsURnHElcC
	S1r6IUEn0fwJ7RlJ9XgPxMM+s0bZ7mUk+lzf0bZBl+tJcMnkq8SZMyUrg1YE0UIGWTKIjDcujCQ
	g4wc9YdJUl8YBG50tK5xSqBEldXa6EmzF1Kuo9tBqfzDmBgNTLctOJAiJ6mjgbuIKsJ1T6YvEi3
	ufaxEdcbWQkXql8QNIss5K1yE1ZfGe3uf9YDz7JKSttwPKJNOF5GjO8NLyOTHxqm1XV/uKL+k4s
	=
X-Received: by 2002:a05:600c:3541:b0:477:7991:5d1e with SMTP id 5b1f17b1804b1-47904b24871mr286804035e9.25.1764615836865;
        Mon, 01 Dec 2025 11:03:56 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFpkD/Qb5f2uRlmC3i1RQNeZwGCs6KdhuFtW4Hlt0oYwXh150rxONZ3NwHAr4UgXROsWIf5nA==
X-Received: by 2002:a05:600c:3541:b0:477:7991:5d1e with SMTP id 5b1f17b1804b1-47904b24871mr286803735e9.25.1764615836365;
        Mon, 01 Dec 2025 11:03:56 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4791116c0acsm257851905e9.7.2025.12.01.11.03.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 11:03:55 -0800 (PST)
Date: Mon, 1 Dec 2025 20:03:24 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: logprint cleanups, part1
Message-ID: <4zapkmkqg7no4x4bi2lfocjf6amj7sohn57x5ir72odcuo6ojk@miznyqz3vmkq>
References: <20251128063007.1495036-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251128063007.1495036-1-hch@lst.de>

On 2025-11-28 07:29:37, Christoph Hellwig wrote:
> Hi all,
> 
> I started to look at the userspace part of my war on struct typedefs,
> and while starting on logprint I got really annyoed with the quality
> of the code.
> 
> This series touches to the log_misc.c code to cleanup the typedefs,
> switch to standard formatting, and do various other low-effort and
> mechanical cleanups.
> 
> I have similar patches for the rest of logprint (which isn't quite
> as bad), as well as ideas and prototypes for some more substantial
> work.  As this will be a lot of patches I'll try to split them into
> batches.
> 
> 

this one looks good for me, with a few nits I found, I can fix them
while applying, let me know if that's good

Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey

