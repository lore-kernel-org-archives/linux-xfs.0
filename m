Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D5944EB45
	for <linux-xfs@vger.kernel.org>; Thu,  3 Oct 2024 05:59:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727935190; cv=none; b=WTBUQNFxPKvHeXz1WyPWTTvhm7AuQHFdAQP2sNQioRFeP1noBxitzDEBOSv0qDT7VGdS7sCqcq1lIJzEK/R9hu3kGOamNgWkQdC0Ql77A8BpGIVy2/3lZvF4N4mp7q+z3+r5v//Lp02Ns5rwZhzNmg7LDEUjA1CJ+JKGQwXDZa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727935190; c=relaxed/simple;
	bh=OWOsm7ZxtLM/gvpBAV1VPiDsfc0QEqjnnA4NgVabO3A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iXcgBhR4y8EJ1I0W9Lk6dXJmidXecENtc9AN9/nCKAET2WpSrrAoIjaYOVgY9QcJi/t9e8VhupRlhNbM6pBVhkSAvRrYyiXTKhnBHM1bXjfsxJTztpjVMWK0zk1Q6GFoYe1/oe0iaNDf9VikDcxNz6lrIpMe3yiTkS5+t10ujGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wwOV8QwM; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wwOV8QwM"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-37cc84c12c2so296125f8f.3
        for <linux-xfs@vger.kernel.org>; Wed, 02 Oct 2024 22:59:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1727935187; x=1728539987; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QaLuPXFwFEMXzwdJuRm9nCMZ+olqm02WUGH6BxqckLE=;
        b=wwOV8QwMYJIe29CHF6Jm7wNuItOkmA2jflTOnILTFIs6zJ7+8vAo3nXsXvxczh7czE
         AdJ3/Am4M3b6/uPejys37Ps5eqUyeMCkuxfiPz3z4xf/5NMa3qn6SfYmSqVQKA8cZt5T
         JrtOSMuPc+kaBwzwVbTw77jxWnRgWpQLMXgT+JJbHqs5TYr3cfA7QMGKHqCKr+Laq9Oe
         dAHJvf6L7i56wgQVnjafAwsCSM1DuGd5MHsQ8HJCzUXJhTm53j0gx7JSnsA+lzKu061V
         XPsW384+4brQG8whDWcFaWmgmAg4ziudNwcC6x6mcDwsM9svR/ROcRnxg1K+7CtQCOnf
         EiGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727935187; x=1728539987;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QaLuPXFwFEMXzwdJuRm9nCMZ+olqm02WUGH6BxqckLE=;
        b=gTaliviG/tqZE+Ej1TOsmK66QmBhTnqerAy662HyVx0N8gzNVXtj1RvbqwlQWA/K1p
         XkoayrSU2/HyHv8zUhxXSbvBvW8yHq7/m+UA2CK/0cXBU2L1lwrzhlsZqDyIgn7ApS8l
         0dnJTDQA3QXhI31pG0I76Ktb9dJws+H1N0tRqSgf5TtPpG0qyCj6BhBrHNJPilDSt6H5
         Vt0u3BDUhgU5xqXklsq7K4xhLRkNRiNvlKDDUzzRutfwo7ZtKqf5Zfy6Q+r6Ngc7e4M7
         C7VJ0fjYobBWbZJRj6fmKIhHTWEAG0JYxerbLivgzONHL0NVamyvWS6XwVDzRBx7z3tz
         aQXw==
X-Forwarded-Encrypted: i=1; AJvYcCWWh7wRLGPPX4J4Y+0KLbzS8p38+QbazS4wazeRg4sJl1bdB4iPzswkwvrf8f0Z6/d22ouvptLUFh8=@vger.kernel.org
X-Gm-Message-State: AOJu0YyXALJjbr1Quz4l6bR8/epNAfSHWUQf+hHnWvTonSjjyja6rfA2
	4WDJ43si+nTEuF0O7XXL+qhaUkMtnMCQuIlj92F+lcvxPYSgWddShFzjJOWmRM0=
X-Google-Smtp-Source: AGHT+IFhfzemxSCvKHPyI9lyhE5X9vj54jqzCvp5GjX9CuBFrvGGQSyGFB2LBZXOwoC5OjFWE4N+sQ==
X-Received: by 2002:a05:6000:bd0:b0:365:f52f:cd44 with SMTP id ffacd0b85a97d-37cfba0aa23mr2849115f8f.57.1727935186868;
        Wed, 02 Oct 2024 22:59:46 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37d082d22b0sm464564f8f.102.2024.10.02.22.59.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2024 22:59:46 -0700 (PDT)
Date: Thu, 3 Oct 2024 08:59:42 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Andrew Kreimer <algonell@gmail.com>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] xfs: fix a typo
Message-ID: <1fe2c97a-fbb3-42bd-941a-c2538eefab0a@stanley.mountain>
References: <20241002211948.10919-1-algonell@gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241002211948.10919-1-algonell@gmail.com>

On Thu, Oct 03, 2024 at 12:19:48AM +0300, Andrew Kreimer wrote:
> Fix a typo in comments.
> 

Could you explain what the typos are in the commit message so that we can spot
it more easily?  It saves a little review time.

regards,
dan carpenter

