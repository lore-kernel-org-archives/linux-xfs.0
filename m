Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9E2122094
	for <linux-xfs@vger.kernel.org>; Wed, 19 Mar 2025 07:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742368626; cv=none; b=RQXosWXOw5brQbQ3pf0WFAFTnkEr3r7+BigcUEP6EbtROHsod2ljW7CuYyKqUOf69ebVqaRRMO4lifQNzqmm1UDgnhy6PFHUCqH9/gxEWaNi6/RSBrCgnwfoUbuzRjqjQw3ZllnnMBxxfGzC2txo/8W6Ste6ub6n5W1F5XEaoYc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742368626; c=relaxed/simple;
	bh=MG7t37RDhUuQgvNXz3+Ln/eBp225CH/2CaJ9joxQoio=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=R7gbhQRsWeBwGdCpQq6kff+1xAlxbLCsxuQZZyOc5pW+Nqo/VPMzEXWIIgHeWTEwsX4b5WeBgywrZiwaab/coMqKaBnWKn4rZ/7CztPAKBbQxWhRlAqa3o5zY6xa88vp8aH/c4z8PE5VRzO69Z3rCaCaFX6qJd5e/+lRtpmj2ok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=xq5NLzV8; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xq5NLzV8"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4393dc02b78so27549715e9.3
        for <linux-xfs@vger.kernel.org>; Wed, 19 Mar 2025 00:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742368623; x=1742973423; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MTzWpabUT9+XbmtN14r4T7Omt7j6L7c99WjDe+SPMdM=;
        b=xq5NLzV8NJ8n3ke9hiZ+L/YqqHxK3sPH8Zyb3PEvxInQPkq3XqMseAVOCRmAZ+f95b
         Dq0ceTKOBKQi3OoUAg50lINjIyoY8Izt+zKyutLMU/RliJv+gDA+52c87O2coXyxzS84
         5jeq4REUjxYewKp+V21PDu89uf+QtFdnHXoIy+nUwbKhfrCigvEtxyPdbB7XC32ljEus
         jCEe4Oms/jC9jNylftJGe6IBmCyWCXOLL7dB9lK/Pboh2029Q9oTUdYQr/gf8GpeV9fM
         EvcufOsQoddN4gNsvLLBK9YrMIPybHyHkgHv9/Y/LQg/jP2aRDfDMaiUvRBUsGH8u5Av
         6z0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742368623; x=1742973423;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MTzWpabUT9+XbmtN14r4T7Omt7j6L7c99WjDe+SPMdM=;
        b=KzdJDWocJaqZAFrpD8K1EaaARCDL9FBbC0GoTwb8YdynKzxXKTiIMbAeZvsc4z2srq
         f03JMF6Y4cGeqvBb8Kh+Qm7NEpDy7iLnYaejyQxg87ATGczMh8sXnaA7Ij5NvE5MC73n
         R+V2jJGgs/mltEdYAU8sbPZLyq32HfedwWNkn94lGpWahW1iaft9whyY8QQzxCWf3wbA
         9MN5y//Zg9E94ERKr/oJVn8VnS7aeb3imcJyngyvYCK1u6sdgCm94om2W6kATPxEzBgd
         tuH8nGkbq8PV24DqQI4Gclp1xSJfLkkrV3XMlVJypzuW/u7eAXGfPlwYgEtxfNqMTQ/d
         +cZQ==
X-Gm-Message-State: AOJu0Yxxif3nxb2EdMy6mEQEG8qVYJDjFNSA2isduWJ9Jw9PC+DmCro7
	g46faWQX1FOLBcOIMLGE228tHXYuhG4Z34rK0x5wPsqKVDYW+lOmZNL+NUU3R7D+pqRA9ZwJR83
	d
X-Gm-Gg: ASbGncuhB1tIiYS6f3MD+MyikpD04rU93yZefxTRDIoE4nOLQZaMpbRKasPKDFBmEcA
	F2UpOVSXQnoWyioQOCk965fvXfyqL4dgRxrPKdYQmqnOA47uG+AVpgI5EzKn+zTCdI5JMPKLdMN
	FWEn76xi25Va8lMaPKgJswCTdPV4zuwS78FYjDM7Q0Cw31YP45J0mDCpv3bx26rVWbfWaZ5KnF3
	XJltdIwEe9RFgM7cMKf7weNMN1s8B4IJnAqEVX4BzdB4xurESr7hyiTUR46X8ipDOtBMNiWUyPy
	rCH3pHSA+kK8tustadqYSF8FCV0krNeQwfeEs3zwA9x8QiWEig==
X-Google-Smtp-Source: AGHT+IHE3CjNeq/pL3h/Otz8kuPv45/pOpt7y7WAOIGdwj7yyFNMb3DzzscWh2RpqZ6M4dneQY3nHQ==
X-Received: by 2002:a05:600c:4ec6:b0:43c:e9f7:d6a3 with SMTP id 5b1f17b1804b1-43d4379301bmr9440225e9.13.1742368622979;
        Wed, 19 Mar 2025 00:17:02 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-395c8975febsm20654809f8f.59.2025.03.19.00.17.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Mar 2025 00:17:02 -0700 (PDT)
Date: Wed, 19 Mar 2025 10:16:58 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [bug report] xfs: use vmalloc instead of vm_map_area for buffer
 backing memory
Message-ID: <58572c66-2ee5-4119-9570-b359d77c6a3d@stanley.mountain>
References: <91be50b2-1c02-4952-8603-6803dd64f42d@stanley.mountain>
 <20250319063113.GA23743@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250319063113.GA23743@lst.de>

On Wed, Mar 19, 2025 at 07:31:13AM +0100, Christoph Hellwig wrote:
> On Tue, Mar 18, 2025 at 11:40:47AM +0300, Dan Carpenter wrote:
> > Hello Christoph Hellwig,
> > 
> > Commit e2874632a621 ("xfs: use vmalloc instead of vm_map_area for
> > buffer backing memory") from Mar 10, 2025 (linux-next), leads to the
> > following Smatch static checker warning:
> 
> Just a question to reconfirm how smatch works:  the vm_unmap_ram
> replaced by vfree in this patch also had a might_sleep(), so I think
> this bug is older and the check should have also triggeted before.
> Or am I missing something?

Oh, yeah, sorry.  It did trigger before but I never reported it.
It only showed up as a new bug because the warning moved from
xfs_buf_free_pages() to xfs_buf_free().

Sorry!

regards,
dan carpenter
