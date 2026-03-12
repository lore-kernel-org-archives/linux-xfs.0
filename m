Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52C793D76
	for <linux-xfs@vger.kernel.org>; Thu, 12 Mar 2026 13:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773323464; cv=none; b=RL0ZpmpJhR+3XcW/n6s2QbTKHWN7OfU9vUPxQa+ugujwOnWraZUw/e/niadOkwkjItg7MMDyuQjzbm56FSLAXI0uIa1YO+m2P/30evfDBNdE1XKc9Zryzc7hRrIJePTYRUrgYRJWPmJV9jIFYafrLczvGnvx3mQ+QTKUYvQkN04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773323464; c=relaxed/simple;
	bh=m79QPg3lZxtO3qB8FGmL4feJvOHf6hv0uj9IuHB+gbQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JyEHWrucRLBJ4uKJkfAQS46wjj8QtCLFnzoXnpjnkdwNChlsJgs2FWMsNCDZ+/pUMfM14AiA6PkCHQlBFnYuz6439LN5KdsjperWKBsbsHieM7GFgrxTHb2dT5Cwx+q75rB6cqFHAhHeU9OLlP2L8G2s3rezMG07lmMn8dPXWlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WlsVTztL; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=UKkFTRLV; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WlsVTztL";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="UKkFTRLV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773323462;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lusPCuwgPIO7EacrWQT9X+JN0PBRkgLuOI7TKiRgdsk=;
	b=WlsVTztL9Q7LVBAKNoZOhRHsqYJFjMRLCEzzuXMvsNKwQYfyT1pwl/DnxPa9WNqHvUDBJo
	vyf28QBR4OzI7ioOciTAFIJxcTMoMe+DuhlB1u0efcGmlCkJP+4RnZN4MbtnH6hQCaHPg4
	TaKkerjrhWVgTFnzT0gTWQzXRiAvog0=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-58-n1cVy0edPRCYPl8NwAGjOw-1; Thu, 12 Mar 2026 09:51:01 -0400
X-MC-Unique: n1cVy0edPRCYPl8NwAGjOw-1
X-Mimecast-MFC-AGG-ID: n1cVy0edPRCYPl8NwAGjOw_1773323460
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-4852fbfc379so12912145e9.0
        for <linux-xfs@vger.kernel.org>; Thu, 12 Mar 2026 06:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1773323460; x=1773928260; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lusPCuwgPIO7EacrWQT9X+JN0PBRkgLuOI7TKiRgdsk=;
        b=UKkFTRLV/0FpcgXxXaAqKqccZ+9UaoVYGX+kZeHJOOWrZj1hl4Pm7YWUH46/PUxJpR
         JiHomMvQ9oq2nntEilD//7XxR2aeabWZujfCvZvx+y/D6LFXN3130DKQl5bQR9jCn0Nk
         luCI6ukJKDwcMELQQFIKt90G3QIDBejsjAAFW8ge22JgldGzs3sRD2xxBUEb1FSPOhjr
         bhkAbZyY6BVEUvWXfHfdXBiYE5Boodi3Xeuz0E79EcAcLYH4cDiuE21xHpiitsXzt7jc
         yrR+1ajoWsiUsOqXxcpNCTQAFZFYKR/Fkuxy4D7CxUgHgGbg8i3gklud+A/F53XZG9DE
         cGrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773323460; x=1773928260;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lusPCuwgPIO7EacrWQT9X+JN0PBRkgLuOI7TKiRgdsk=;
        b=kSF5tbjdxxAsadGgWaFnjEICvrhcl4luFgRhGR/ISjb+cGEw6yZFXUsJBPT1AwFFwn
         Mvxyulgc+Zw3LpNRaNKCjIwLdSfrITwoFivBrnWrXt/SfJkr9ivyb5uqv/MVX97DHY0Y
         ShuAYnjAVUz6weJfmHRewSy66tX+tVu1ySssTZXxyFbg/VZuy8A6GD+PzsNJTUVs0bpg
         xJ3PvXUv/WzevD+E1qp8pVvP3ThTd9yJ1WX2kuLQUc6jxto2KsT2iWr8J7Y8tkSmvSyv
         tk2pL0c5hHRJCPdr8ZkD36cOBmq4qON65nAny5so79CIUQGmEHR/IHpoFpZg0mB43xdv
         jaFA==
X-Forwarded-Encrypted: i=1; AJvYcCVLfJQMjH7O3f9P4ybwyrxEhB+93UOGNBbEyR16bUAa/LgtRC8BvP7qNXuG5GAgP4W2fdSv6mimrpk=@vger.kernel.org
X-Gm-Message-State: AOJu0YycOeyMF0gusj8Vr+xQKaToFB2h9NrC30YREtz4YgiwzXN1VgM8
	HpzWyGvqO8Nb5ASCfHbOI+cnX7z58BgxT8+vLhTSxZJBmgVUxlcXfL/KSyb4MUitjnIXSie911l
	rXMXQgxaaBgv3H6h05CiO+L78U9AiaX1j7IgfTaBEIjFGvcjGJ0k3uD4m7SpC
X-Gm-Gg: ATEYQzxMvQwKIh6y2jRwvV1OB/8oz9+8b5UiwYf8QvcEsOgL0MDIXLnJdmze7gRNNiO
	iaNT9eyv6dzq5xn4JwWUYSNsw9Ib870bhmHoGXa3c0retxHzPDg7uCr2z1OKDsH/lrRJmAzp83y
	P3ftBw/vdgFcecdEdYTk6oxvKMMGWL4tUbvLcSPchU7cWnb9l80t1JY+lKihcOKAz8wN2lb/1Dy
	v3h/Wjqzs2J0nXcpUlmjFNGKYPIOhSyn2jZ5uV8tc6jS1cMoHAZzhCqHPta1rglmdvVm16uQuh9
	RzqU2QupksHrGGmnjU1EDfGFDFO17pTV6k7WcncmtVqRJXusvWwWMBcqFVMIK6wGQfNX7u9SAli
	ZWcHYdg19qxM=
X-Received: by 2002:a05:600c:1e8f:b0:485:2ce2:4c8a with SMTP id 5b1f17b1804b1-4854b0a4c24mr109097965e9.1.1773323459797;
        Thu, 12 Mar 2026 06:50:59 -0700 (PDT)
X-Received: by 2002:a05:600c:1e8f:b0:485:2ce2:4c8a with SMTP id 5b1f17b1804b1-4854b0a4c24mr109097485e9.1.1773323459224;
        Thu, 12 Mar 2026 06:50:59 -0700 (PDT)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439fdf09abesm8106385f8f.0.2026.03.12.06.50.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 06:50:58 -0700 (PDT)
Date: Thu, 12 Mar 2026 14:50:57 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, 
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de, 
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
	linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v4 19/25] xfs: remove unwritten extents after
 preallocations in fsverity metadata
Message-ID: <ymisdrze3ohdnxa4inqfwp4riaz4qk5nmtil33adn5ukhngq7v@f3tcv3hbzobz>
References: <20260309192355.176980-1-aalbersh@kernel.org>
 <20260309192355.176980-20-aalbersh@kernel.org>
 <20260310012914.GG1105363@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310012914.GG1105363@frogsfrogsfrogs>

On 2026-03-09 18:29:14, Darrick J. Wong wrote:
> > XFS preallocates spaces during writes. In normal I/O this space, if
> > unused, is removed by truncate. For files with fsverity, XFS does not
> > use truncate as fsverity metadata is stored past EOF.
> > 
> > After we're done with writing fsverity metadata iterate over extents in
> > that region and remove any unwritten ones. These would be preallocation
> > leftovers in the merkle tree holes and past fsverity descriptor.
> > 
> > Signed-off-by: Andrey Albershteyn <aalbersh@kernel.org>
> > ---

> There's an upper limit on the number of blocks you can unmap/free in a
> single transaction.  Maybe move the xfs_trans_{alloc,commit} into the
> loop body?
> 
> Oh wait, you skip the written extents.  Ok, so maybe just roll it after
> you've done a bunmapi.

I see, I will add a rolling transaction. Btw, why skipping the
written extents let's us use rolling here?

> 
> Do you need to purge the cow fork too?

hmm, what case are you thinking about here? The fsverity is written
in past EOF region, I don't see how COW extent could be left there.
Can they somehow be left mapped for blocks past i_size?

-- 
- Andrey

