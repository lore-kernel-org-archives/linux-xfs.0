Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A25BE2848B2
	for <linux-xfs@vger.kernel.org>; Wed, 24 Sep 2025 09:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758704645; cv=none; b=Ph+yFl6N/xw5nQbdLW9GPSTbBfBuuxdquDagmw8Qot6yIP9RPRCmKWzy/N9cIwkYsNeeivsgq7PdssqHsZ5eMAvcY4Iw6UEVecTfEtr2fEQbVk74So9nWZRrsH2BOJn1QxWzkHCGr8ptZoE481QaijdXzwtg8MQPGc+XYpYwZZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758704645; c=relaxed/simple;
	bh=mnN8gXhjgxvoijuGOQ9B9tZi8LXOAyJu5Ni+HzLpAoo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZavMw92SStNLjWGAt+FNtYCxnvjPTzL9k6QNF3Qf0uVpXrOHp9o9saafugT4e7NaUBxtRlsbw1oxlUOrU4fC+TFN4L6E3Z6G2zDz8Zo14fRq6KGegX+xhW9Q/z54UqhAFR7U8+HIbDqfHcoUnCqYnEMtZrjoqq+odOUhSMZMKGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W4PhQ5Rq; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W4PhQ5Rq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758704642;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0pp3iJDBP0Ik0M/jpTm28KpP1qXGJABlURXTEDHCCS8=;
	b=W4PhQ5Rq07A+u0+jk5tttnmGxESVj1ygzTJItRR5EcZVwNXVftCjI68FbPE/ct6Yf6O2sz
	nxLQSbmM1Pt+DiSEImAaCSaVo1j7xrHTVMyJVcBL5oBB8LN+6vnHDZ2ms3nyfe0DBiB1Zt
	P+hlMlSsKU0g8GJebwBNlZOCuRgfaQY=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-253-8WgURr1jO8O-ywC8As5LeA-1; Wed, 24 Sep 2025 05:04:00 -0400
X-MC-Unique: 8WgURr1jO8O-ywC8As5LeA-1
X-Mimecast-MFC-AGG-ID: 8WgURr1jO8O-ywC8As5LeA_1758704640
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3ee888281c3so3580357f8f.3
        for <linux-xfs@vger.kernel.org>; Wed, 24 Sep 2025 02:04:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758704639; x=1759309439;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0pp3iJDBP0Ik0M/jpTm28KpP1qXGJABlURXTEDHCCS8=;
        b=SozGWlpPavplVklSVJz+jrSPQQRQ47G1Zswlg5vVHjgsmJtmVGDVb5XX6WrqLvzhWU
         je5MQjdU1ErEO6Aye+mPBUtysiiT2q+SaC9iDjD2DOgnFGiGK7y89LkYKuOE9yEE4qF0
         rAMO8tzmj0Zc5weOOSNu30It/BRKmBe35f5eiIegx8gaZuEau3yOPlcoMLtxJJN3nxGQ
         WyAFcKL9RaFUProPXBRqeoGx8jEIC0iyjOhyyXAAhFmkoEUQ7js78xH2M+T/tVgxANIy
         +4SJJYToYK59vW6lCVQFPjV/tC89yh+NjpMGdI6Smp4DCtLrnxOhgJiq2XItF48WjaWb
         PWDg==
X-Gm-Message-State: AOJu0Yw2Grzkqz9OEAnou16Wixry8GYYa8iA90+5eyN/gpPPTkLVNbYH
	oH5gnciOmdUp+CqqkIIn9SLtHbfMdS6cmYdmHI9KYNMZQZ3A0QPRoJ8+0r4cOyE0Z1HaI7qO9r2
	dtGDaiIuN99oo23fRkH98+PBgiLyLKPxiwAZwgOtK3XtfP5Cg/HZGWEsIfIlfmyrHTP0fFKE=
X-Gm-Gg: ASbGncug32HXf1Iyg2vTZGyhHqzWgW6wIYkpBouJl0CMVVMAbiU/igHh32+bDxAUKOh
	iEbU539+X/zv7yz1c80K1rqful/xDzrc+4rl0Vyni4z2OJiJy+X7LWIRjB4MXR76OUrooyWDzWN
	6u1gjuzO5rK6CYyZ8dH237YV4YcnRzq5R8QeLJVmDKBjDX0k1q7Y/W4ZcZklEdGx+Vx4+SVjdCm
	voFwy4A5TlbXeNf9xlilLZTsnesGMa7XaXYc+C7LoGVbF2BfxIhEyZaSpKAFZnKiKGAudZzbFfL
	nvoLNoE9GJ6Mr0PCooMkGhZc5Y78XCKx
X-Received: by 2002:a5d:5d0b:0:b0:3ee:1125:fb61 with SMTP id ffacd0b85a97d-405c551a33amr4113991f8f.7.1758704639268;
        Wed, 24 Sep 2025 02:03:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEyVxvi9ntpVJOXLi9Dwp9K/deIWukD7g9+mFv7lhN0yp8r7dPeepHBEAnGyLGOxJhHJNvUlw==
X-Received: by 2002:a5d:5d0b:0:b0:3ee:1125:fb61 with SMTP id ffacd0b85a97d-405c551a33amr4113965f8f.7.1758704638769;
        Wed, 24 Sep 2025 02:03:58 -0700 (PDT)
Received: from thinky ([91.245.205.131])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee0fbefd5csm29240500f8f.51.2025.09.24.02.03.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Sep 2025 02:03:58 -0700 (PDT)
Date: Wed, 24 Sep 2025 11:03:57 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] mkfs: fix libxfs_iget return value sign inversion
Message-ID: <bmg2hatfktqltu4cx5tblg6m2l2ktn7qunlfalmifpdivzx5o7@flygswvzbxro>
References: <20250923170857.GS8096@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250923170857.GS8096@frogsfrogsfrogs>

On 2025-09-23 10:08:57, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> libxfs functions return negative errno, so utilities must invert the
> return values from such functions.  Caught by xfs/437.
> 
> Fixes: 8a4ea72724930c ("proto: add ability to populate a filesystem from a directory")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

lgtm
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

> ---
>  mkfs/proto.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mkfs/proto.c b/mkfs/proto.c
> index bfeeb5ac638185..2b29240db95f74 100644
> --- a/mkfs/proto.c
> +++ b/mkfs/proto.c
> @@ -1425,7 +1425,7 @@ handle_hardlink(
>  	if (dst_ino == 0)
>  		return false;
>  
> -	error = libxfs_iget(mp, NULL, dst_ino, 0, &ip);
> +	error = -libxfs_iget(mp, NULL, dst_ino, 0, &ip);
>  	if (error)
>  		fail(_("failed to get inode"), error);
>  
> 

-- 
- Andrey

