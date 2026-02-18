Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25FE63101BB
	for <linux-xfs@vger.kernel.org>; Wed, 18 Feb 2026 12:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771417079; cv=none; b=OpU9pnifvLA6gB9MBsQvwPxJ/TK+RbjYysSNwyc1V3WSMDlKK/dF9+M2/f/pRVj9kwLbbXxY4q11CDACLcEmCXYdfoSWNbvvBi92lkJB3E/vj2A2yPfNYxH+kCTBXI6qLvejC4hxn383avL7NMeJl3AmYRE5jyvEYXwONRr3OL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771417079; c=relaxed/simple;
	bh=oHxq0RfYCSn+Ri7S2yKvntEHV9eX/s1jFiqv1G6pKoM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UILhWhu11knC9PHvBM3G41cypVYmIFo4qTXx+j+1lOeiOhIWFbhbAyrDYw8LZXNhgrQoWeo1EPWmKTB/H1Khj9pGYpcjmtR7egUj1JJY5mWFs49FT6EwxESF4CzVnheb+DGlTDViVo2UBBHzkAHtt+C2RY3eWZl34zwKPw+M4Co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BmlF6Geh; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=NI1ZtNtf; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BmlF6Geh";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="NI1ZtNtf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771417077;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=A90VfYyBvXYfNQuJ+OjztcCqIsGKTH6zgy48JEKhUi4=;
	b=BmlF6Gehs4S1vSXZqz78mOzy8/bklFiIMHyOGDQ/nh1GTTVCVzCo+f1SLzA2xrLp5y1c/Y
	orPWkMq0kNx0j98ThwACW1zCM2bmQPu0vQ6IgDMCU89Hktk7Omb5KKL4B+iZjfg0OalkgG
	7CLzxbuIQRTWclyapJblwl6ExaeN5j8=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-77-JsdVSvGOM1m-6YynhHUmVQ-1; Wed, 18 Feb 2026 07:17:55 -0500
X-MC-Unique: JsdVSvGOM1m-6YynhHUmVQ-1
X-Mimecast-MFC-AGG-ID: JsdVSvGOM1m-6YynhHUmVQ_1771417075
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-4368060a5e5so5584739f8f.3
        for <linux-xfs@vger.kernel.org>; Wed, 18 Feb 2026 04:17:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771417074; x=1772021874; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=A90VfYyBvXYfNQuJ+OjztcCqIsGKTH6zgy48JEKhUi4=;
        b=NI1ZtNtfKq47tfUp7B4B/4Nopd97spFXitrFYrF0CFzMycn8+8OP5dhcujyrXYxO3p
         23b8Co/Btf23OS2ZgD4g0DAraP/ChbUy1qQR6S0eFSrMAX2Q7rh1ctHIrAMhKuUGNEab
         htNb5eKYVEDImgZpU7PwH/ENA5orDYPZnXcwvvzh19L3lWuk++SnAjM2pLFa+CBI3Atm
         qtqc9+0/7qI+vIRQaV3LNKgZXaimJ7Cdb+htcsUtLtqkCQOqUhFiTOTk5v1BTiGNRpmT
         AzcXxSXnkVHb5+h3RLjcTw4E4Egd8nTO2JTNQSLdebAMemIZ+tkU4YYTLuYya4LpvOr0
         qQZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771417074; x=1772021874;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A90VfYyBvXYfNQuJ+OjztcCqIsGKTH6zgy48JEKhUi4=;
        b=DkfQZiBZPKCJdLu+AmFPQPwzBmGmZ/RyYyamC6h6b37Z1Z/yfP70kVAZipcpqSKoTg
         r7l9D8JIxTaVOtZPmSkHYqHxLARDGEpWU0AJ/7DXoiqr7uYUwNZQrxn/5n/vZsr1irOT
         6pvhIsJWHDl39I4kLWcl8vxvlGx0+QkJNPUYmi3hmwwzObzHjuJitkUAHOXotiClcFZb
         eFu6fDnGG34jP9KvySRnhpJlHWX5gwZHSTIKzFE0w4ACry/Jc0gD0SoahLd/UCiEc5sT
         9tX3m8Xydzr77wSUWnyZOABDHLs07Mt75CgKEjYI0yr+5lbeATfkqcioqH4/VWwwUIf4
         cRKQ==
X-Forwarded-Encrypted: i=1; AJvYcCUFSflpuZ88BzAaHgaJ6vzh4dR5KSHRDA+hhNeMS6qm8Zj0A3gwO/R2uic+j/kJon6FV0qqMNY9wjg=@vger.kernel.org
X-Gm-Message-State: AOJu0YzkDHhhi4jx3yS4hFhrkcFwCub0Mn1sX+vXFloPAq0KpHScmWCG
	33f88S6zuMdYKMsX/vvLGR2Yu5uz6ZNvly0b/jXZF/Npmw7/8OiOipwtpA4ov7DAI5VPO8U9XZr
	A4bmbYsqVNjpTOxJqLF2kpTSb3ihdi2y3cTH5COTyuce7NnkGjDbdYT6P9Hn2
X-Gm-Gg: AZuq6aJfxOst7iypnPND6xHS0Fxa3OZykRdCdPaUk/oTe7y/iil2KhIOUHDcZSd/+eC
	mwNHuMtHDTtJgBuihlCvUYSd7cFNVerN68HVMLMSHB0UWkoNYabBznBpyK8sGvMDDr5ddgOHLRR
	tLG1U4GZgLMmt6qrVZ9r0FUrnonb4n3glaNwAzQ0HqM1XUOsg3MkpcvZqVyOYbN69EGl32p0J1w
	WiXw/UVkkNrCpZkYBgXcWhRDplx0rMMstls8CCoe7Av0qgCnVpV9Jpri23i3VJ/t4FItCbLPjM+
	c42yudT+VN+RBNIqD/GV86TUvLBbVIM9EnM79QtMTC7YRYCmRHuOCl9qsqzwpAhMGas38YveJmg
	WBwM0Hoq0WME=
X-Received: by 2002:a05:6000:186f:b0:436:1b1:6cbb with SMTP id ffacd0b85a97d-4379db30f9bmr22128042f8f.7.1771417074459;
        Wed, 18 Feb 2026 04:17:54 -0800 (PST)
X-Received: by 2002:a05:6000:186f:b0:436:1b1:6cbb with SMTP id ffacd0b85a97d-4379db30f9bmr22127986f8f.7.1771417073862;
        Wed, 18 Feb 2026 04:17:53 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43796ac82f7sm45619590f8f.28.2026.02.18.04.17.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 04:17:53 -0800 (PST)
Date: Wed, 18 Feb 2026 13:17:52 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, 
	fsverity@lists.linux.dev, linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, 
	djwong@kernel.org
Subject: Re: [PATCH v3 06/35] fsverity: pass digest size and hash of the
 empty block to ->write
Message-ID: <wl5dkpyqtmbdyc7w7v4kqiydpuemaccmivi37ebbzohn4bvcwo@iny5xh3qaqsq>
References: <20260217231937.1183679-1-aalbersh@kernel.org>
 <20260217231937.1183679-7-aalbersh@kernel.org>
 <20260218061834.GB8416@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260218061834.GB8416@lst.de>

On 2026-02-18 07:18:34, Christoph Hellwig wrote:
> On Wed, Feb 18, 2026 at 12:19:06AM +0100, Andrey Albershteyn wrote:
> > Let filesystem iterate over hashes in the block and check if these are
> > hashes of zeroed data blocks. XFS will use this to decide if it want to
> > store tree block full of these hashes.
> 
> Does it make sense to pass in the zero_digest vs just having a global
> symbol or accessor?  This should be static information.

I think this won't work if we have two filesystems with different
block sizes and therefore different merkle block sizes => different
hash.

-- 
- Andrey

