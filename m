Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 775DC350D7C
	for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 14:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218855; cv=none; b=R3a0340I7H/KAvQQzYVeqbZdPCj96Y9nDURY9/p1DDrFSOuOiJd5mBAhn4l/6+ovsCOyyQ1PTew518pvAZIIVm1/wm0oliF8UvxH/s83wfgbkHZaGjGMqobs3JF1x/BVEk6g2VCXe9dwX0nh6fKcr6x154alqn6YQwiuZvogK3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218855; c=relaxed/simple;
	bh=IVAtbYFrJBJo3+l92CYFYeNf853uP3DhAg+om2SqUbA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IT7yYglXy0suqH82xF8aR7m14aZ/uTs8vr4YrYrDDnwSsMrCgEXBGHH/Er/SUhQhHewchOdFWhZU2ojRRgHbIpNkPThGReFsby6xAXkubjDGI77N4PCXRBkl7FwN0r9HYXicO+XzlF1LxTxxT4RAdn9wME6rfhpRsFjD5Ck0TtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HkRO4la+; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HkRO4la+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756218852;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tsYCfTHEsmnh4IU2r8RRiTMk5vL5C/FnW7HgNQZTgAk=;
	b=HkRO4la+z90UG0/tmtccKUx9+eAsS+hD13OwuUMbmS+slmIVy2mNpyRAyOc2KAJpfPsmwK
	gM/OyHqhjpZVwADVBtF/rfrVppEPb/i8P0y6EGTBZgjZ0RIn1WguaJa/iW2xYjsZVZZ4RA
	ITJRArIWsndgEcnKDk+KZXVqpxXPA5M=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-543-oG-9zsf8PwG0G9CzROoGuw-1; Tue, 26 Aug 2025 10:34:10 -0400
X-MC-Unique: oG-9zsf8PwG0G9CzROoGuw-1
X-Mimecast-MFC-AGG-ID: oG-9zsf8PwG0G9CzROoGuw_1756218849
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-45a15f10f31so43664555e9.0
        for <linux-xfs@vger.kernel.org>; Tue, 26 Aug 2025 07:34:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756218848; x=1756823648;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tsYCfTHEsmnh4IU2r8RRiTMk5vL5C/FnW7HgNQZTgAk=;
        b=VmCaETNLxYLeTACJp2rjLiCRD2uzL6wXIAVLkwtXitwDWeLVfrvlYoctD1ErmMvLfq
         UdukGDfuM2RNqRYz4ReJs8bGjQzpo/CfvnfxCSMc+dmLH2+jnLW+r+7xfAVLDmZKcABg
         EqIFTs+B3GVonRPIbP0jyOOD79g2EjQZWNpC5xUL0+O58TYvVo5vpERZyMd3UyUiIHUf
         60wtIQNevc5krJAUjcj7tR44OniEbZJfyoF/VltAAnMjOEG8UMNmQbfBpgUUG9pEUETQ
         FkMLtuYxe+j11UEk2oWp0vlPAcjJr8fqeCVmRr0PQxk0o96v90PUvp9bIvBV7vCwWcFt
         6gXw==
X-Gm-Message-State: AOJu0YyE9PEhDVf6et3U5Vf3hDmFj1fnVtAawPmSqdFqawcdM0mOXUdb
	Ld8t5qFkwkja6yUtlf+nD+3aP7G2YjG6JU3kQVFBTKsiVj5JyiWioRgQb9mAO6qabWV+qbyyeYE
	uADAzpRY7LgI2tX+3CxDLQsu9U8jNn2YlRCJqOCvNb2jFatEhPBzl02ITLqD0nNM0lFFO
X-Gm-Gg: ASbGncs5Dhpy5VXgoe5w0b7U3dDkSyp0Z8wIYIkvjgEUz0attJhzkkyr6p5CaJkU/fL
	cXVq5ypv0bPvovrXd2P2au89xoJOzh8ihTkqXFpIHWBPwKy/dhhAJWnX7PPhUzCD5uy9av6guLj
	9qCwgg4Rupd6H2yIQhFyJ4qCus/CzD3kwEdL7Nw/A1ZLF5q+u41XYcWu3orXbDiYClQiBqrKY74
	kybiASgl2suEYWOzwD5iULE9woAjjNio7M8VDFjzNUlIf2MgTbGHr/IiCPsbMzLrL4fjmhbYMM8
	XVZDlhFRmbKUXhRfRghYNeLAgmCd6FA=
X-Received: by 2002:a05:600c:a315:b0:458:b4a9:b024 with SMTP id 5b1f17b1804b1-45b6870e72emr15133175e9.11.1756218848305;
        Tue, 26 Aug 2025 07:34:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF2US2Sob0r+3nZ9Eku15FgdTYFzqCNcxs3eNaUOtFT3y4qb+QuXZ+GEwFnu7000Fi86arEKQ==
X-Received: by 2002:a05:600c:a315:b0:458:b4a9:b024 with SMTP id 5b1f17b1804b1-45b6870e72emr15132935e9.11.1756218847921;
        Tue, 26 Aug 2025 07:34:07 -0700 (PDT)
Received: from thinky ([91.245.205.131])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b60ab957bsm80367895e9.12.2025.08.26.07.34.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Aug 2025 07:34:07 -0700 (PDT)
Date: Tue, 26 Aug 2025 16:34:06 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, contact@xavierclaude.be, djwong@kernel.org
Subject: Re: [ANNOUNCE] xfsprogs: for-next updated to 9ec44397ea2a
Message-ID: <p3a26gtzrro4csf2bxgwc5qc5d42askusfw6cy2xbcp7tttdva@33bhgcgguuhg>
References: <kmkoyhtz4mjuy5xlucr4noywsgons5n6pn5ti3fjs4uv34fzlx@zsopyugtig6f>
 <aK201Ikol4QsG8Yl@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aK201Ikol4QsG8Yl@infradead.org>

On 2025-08-26 06:21:24, Christoph Hellwig wrote:
> Btw, do you to pick up the support for populate from a directory from
> Luca?  I think this will be a really nice feature to have.

Oh thanks! I missed that last version. I will do 6.16, and then
include that in next for-next update

-- 
- Andrey

