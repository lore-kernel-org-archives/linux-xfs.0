Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C20794A5EBD
	for <linux-xfs@vger.kernel.org>; Wed,  2 Sep 2026 18:26:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788373594; cv=none; b=KPx7SryWJhXKesQec5t8JdOgtPCBNV+2gjY9hNelgCv8pPBA5zh53412If/c1ZLF9eybC5PENEm4TlJ8RB3Lk1K7xbQkyTQp+Cl6LlEGlxN5YflrdJUF0h/UBcrdC3BbYCY5CQjiJrMA+d6EA3iQwQDGbeYnZb9ICiCJ1L/5zyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788373594; c=relaxed/simple;
	bh=70OW5ShH/kqO2yK+u932q94LT0CG487EPQmNfC7PiGs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qONoFmOZ3DixlLl0R2UOrtgNM74Ehl0otOCTX3Y7Yijw3aCU1HcjkjJhMGNCKqk/3s/ij4SC4do8bSh7DSmLRoMScvhAwZCcsOzpb5Ga8pE4Jcolosn9zxXUB4m5wBuoWhjONZZ6suc2AuAxTzOY4pM+BIUmxen53ZbuKffg0WY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QI3g4JYq; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QI3g4JYq"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-398b3d66515so1847416a91.0
        for <linux-xfs@vger.kernel.org>; Wed, 02 Sep 2026 11:26:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788373587; x=1788978387; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=x8T9r1V4Fm4dLLkn3wT9Y3iOMgRpVRxafH+zo6DqTKc=;
        b=QI3g4JYqdukT6t5dp7WrJfdLnVcAMQofmXy9zdQE5Bl2YA+zbQHHNVnjyTlZ/wczzh
         F3F91+s9Ab42Q18P7xXNYtcBTBgovSEPlWa7alaOxNSD9umHNIMW/SbygIkTXRko88FH
         ltO1Kew7Ni/8l4gJ6vc8uzWLA6oSA0Nsu8tDiKIuEI6CSi+6HcD22mfOr/Efa9HJCxr6
         O+eS+y0yEvLlQrMJ8TvZymXwae9aOoZCBbL2AvE7/FGPBNil2lrWLPpMIdiU47iTggRv
         PU/2klL+m3W8dDTqks3h4JT8ujmYFyRGZCN+8M7qNQ6rhgwvow04f9henXV8KNoS4oPm
         E37g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788373587; x=1788978387;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=x8T9r1V4Fm4dLLkn3wT9Y3iOMgRpVRxafH+zo6DqTKc=;
        b=K3/TY3zRAOy68Q7Ys8CuUv0MVyZIdPps09XS2qSNMzzI/m9xzcpyyZ6ChnNfCYrB9C
         T1QDcMjWpwxxmbi20J75Mb/SVKOGvgx0rXyFVC0qjek1r4A0ySdwjASBUZf6HHibL09P
         S4h5n8K7Z9u/9RSK6L8jfJAb8JCiyd1EJv7oQSQtN4JUiUNCUhS6ouZbIuJ7/DiN6JVU
         vCyP4q62yIkdbqtjPzfQdEsYy+FAnZ8gXH3rmiThi9tsxrGPOcGDI19fWwYADpEh+A2x
         PRq05YZjY/ahaGKYLrJE1uESfPyJx6oX/DIdeqtot5K+wT1h6smaogkTKkkcWssHRPjp
         CunA==
X-Forwarded-Encrypted: i=1; AKwUvBxW29GDO3NQkoQIozax2QyIMWvpeqv7rnWr0DKDHUvTW5h0BMPOY+GMfcYJm1cLpq5c3W3ONXyMXSs=@vger.kernel.org
X-Gm-Message-State: AFuF++lNY+6IQAKSXqkjO49/PZbUv0EWJJdDSMBud0hPVA+vuxZVRguv
	jZSFIgVKy875lEO86CMVOglRpC9O2qQQhwt1EvoRBYgFIoK3WDCw7HY=
X-Gm-Gg: AYBFou08p8n2yGQZBj9LDGOztEIN8oAzKE45LGAjgeEyCECWotOpVpJwQfNPSFPEHSI
	3UKKM9csyx8hxGqnin+MBC77wde1dkA2Y6YppuHKgK1ZoPlCWz/p6k99ABGfsdfW81t3I8C6pap
	PKzD2N00NrM6TnimXk1HWw+zkJ7VZBPXWg9DRP6mIWn7SpRwtKlL671mAmbKtjwTh3wZYt37f4d
	HEJdfWCWEBf5RPPgIqdRJNTjkTwueakzK5vUhlDhCoONXXDO+PlGGJdxVk4bjNWV24VsW/89C36
	1agCS7Fzxy7ztsJMHc1qv0DeLdYCHdMkQtbHBMgDNao45bOmGgrkMh0kMyctDNu3YQpQiCnGwUU
	Kcgfx8KmdEPL9K00idy+W4AhrP2TzjVHfBfsZXLOpVssrhzSTQZyoLkdUvutOK3hRmfj65WVZ+M
	7JxrxCeg5YPlyWSsFK6Od/7lOGCFYAMjpPcZLwL2twkQGu6oLgHA+Ia9kPXPWxDfBKGkTHQ4neJ
	Mb4itmhHq/ytqs7DX+9btv5bm8=
X-Received: by 2002:a17:90b:5288:b0:37f:eafd:3505 with SMTP id 98e67ed59e1d1-39aedfbb2b9mr10243473a91.6.1788373587474;
        Wed, 02 Sep 2026 11:26:27 -0700 (PDT)
Received: from anuj-MacBookPro ([2406:7400:63:f76b:3efb:3463:cad7:ba39])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1430ea2d3e7sm15195061c88.6.2026.09.02.11.26.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 11:26:26 -0700 (PDT)
Date: Wed, 2 Sep 2026 23:56:19 +0530
From: Anuj Gupta <anuj1072538@gmail.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, 
	Tal Zussman <tz2294@columbia.edu>, Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 15/17] xfs: add error injection for lazy bounce buffering
Message-ID: <hvosc4jkifetywtlktfn6wepezuckp4hb3qlctq6xqoq5glh3b@ri7b6u4r5eod>
References: <20260831064010.2574896-1-hch@lst.de>
 <20260831064010.2574896-16-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831064010.2574896-16-hch@lst.de>

On Mon, Aug 31, 2026 at 09:40:03AM +0300, Christoph Hellwig wrote:
> Add an error injection know to exercise the lazy bounce buffering

s/know/knob
 
