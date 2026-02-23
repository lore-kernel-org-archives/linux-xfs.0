Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B7A1A9FA8
	for <linux-xfs@vger.kernel.org>; Mon, 23 Feb 2026 13:24:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771853069; cv=none; b=C6uUqmeRfyIZNrjB5LPtR+0EMyDeUYfkF4mBe//0RfU/ykCm53HH5YeLY2cm31kicOXVoj6BfgDscyiFe3bJ/9K/X/Y8tJlI4nM4K8hqxEZiSP73N7IUQna/Mcgr30B9ts5hF+jvUi+ZkFwcetLQPsXEx8uTCZY5vjAX9RXsOGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771853069; c=relaxed/simple;
	bh=poGA6bo1jLXsV/w23+mdRU7Cm6PVshK+XcjhPgUMDlM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UEdLg5sXpM8f620/abHNazbS+Y0fW5R9aJCBc8wQxY5rsOOD4LtXSkoNnhz7ARmp8Tj2slTFDeo7CaATJ0JHIevWBeN5i2Xvi3+pM4kccUjn0UHUW3bXfZmO70amtMvXZKS+dMAGKjau3mQAsT81NRCkOIbsMLaVEEaSnh9jpFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aXOU9MHK; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=lCvKj4WC; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aXOU9MHK";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="lCvKj4WC"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771853067;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ksBMn2vFs5bfQS6gxZSFoOu9S+2Bm4FmVN3N5GLrC7g=;
	b=aXOU9MHKx20ObuU/DXBzJEmbu8TqQER3fG7Wk3c4ks4kVSTlmATAJgiKxaYZEKPaGbuQQ4
	IxztSN22xapLoWzQ04wYGFIDSlTiHHUXWOp5VpB/8qpJhmRTK4ATSjzj4hkGLauJnPUWFo
	GfuIXoQFGFsabuQfWE7cJkWyktLhGsI=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-624-skgBj-VBMP6mBHPYuXZq9w-1; Mon, 23 Feb 2026 08:24:24 -0500
X-MC-Unique: skgBj-VBMP6mBHPYuXZq9w-1
X-Mimecast-MFC-AGG-ID: skgBj-VBMP6mBHPYuXZq9w_1771853063
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-48378c4a79fso33723995e9.0
        for <linux-xfs@vger.kernel.org>; Mon, 23 Feb 2026 05:24:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771853063; x=1772457863; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ksBMn2vFs5bfQS6gxZSFoOu9S+2Bm4FmVN3N5GLrC7g=;
        b=lCvKj4WCveD433Dsw/xYiiqEEbiLFVim2z+wFeOXmAZca+PMmW8Cejks/z6sEFy/dt
         ylcB+MDifsnt+f3t/D23sT+HL8wwxmU5979aOSm9rGauTirS4Btgme6Gr+40yqp+kd4g
         /WJAHLSVkpqsLVkxqJc/L5ZHldrbB9D4djT3iaSZ/cGWkm3T/EGyLHSQ5NSSgiq98uCj
         eAIHIdCgV/XhYMTwrFADsNixwDuvxIWMapAe0QNv6FqiUNzxRI8GIGI9a3vBQagYdGe9
         Z70Hm3lkb4ko/RxBEHA2hj64Snhs330/O9Cfn6ogJsCuf5R/riMRoHtEwF2hXuM3xdzH
         gWWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771853063; x=1772457863;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ksBMn2vFs5bfQS6gxZSFoOu9S+2Bm4FmVN3N5GLrC7g=;
        b=MOudiHxoJb8ZNdqyBE3ax8rUxMGVPSHzHV2/ltLOLSSAvr5IH+SWzmkIgbOpjUoh1e
         Ok4Ppe+j6sbF9ncSUB7rbKM/rQnrlh0XQuETD3ryI1qhwsYTUmG4F8CLVFM6ZkD2Qdzm
         EkJ5/9A+eXTMaPPfY8XLTwL3XQSgCvazPUswXYmWJLXKXwib9NbhabSIqzPl8RTy4lUN
         4XUPLnVheQI/w1wJaERe/5QZXeOU5/+zxoMogSx3LfoXBOWrjhK45yH8/TAmuIFP730S
         2eFEz+i0OseJ/kIJw4ZVI1apc195z7yDg1Uj2EYlRtgbK5VGouT7VoafqQhOFYleS81q
         fOeA==
X-Forwarded-Encrypted: i=1; AJvYcCXiFAbWzurOWeA8PVN7Jtc/HHz6SnEt5tARDy8PraBjL/xrx4CHgsTPN8lctBovaO7y0K8ay6mlrCI=@vger.kernel.org
X-Gm-Message-State: AOJu0Yxlma9klZlxN5V/fSzbm2FS/gaSscBn1KJFfDyL7/8MqsVMKA5d
	MV2bmEmQFgP43v2uAe+cvacIkKTcM3+GMPiN7KQdxMKnzRAQrqwnrozCZlrZmnTDfZFbnaFZjbB
	sqUD1HrFp7WBFdgR6uJWcZnmGV6x3xnTR9psCxC62loEMyoAYVuQ9DTwZSgL6
X-Gm-Gg: AZuq6aK5h5q+a6X2usytuUnPJdiXC4GMdjrvAX+KLXu4Vjb4YCsaofnLBJxI1jkQrd4
	IIDjPMcF0+YMx38tyV3ZMsD3ob64wkXNCotIbosJ/+UxbmzoJM6F2cNvmUIroiHvz9aiZZSclHI
	YCElTWXUUcKaCjuEwk5ZEtJOgbVOFze7VzamJIojNB9li00GLsQSItD05S+ny20tTRrSdVkQmX0
	5q2pm7EpgVZcswaH2I7tRnX5QC4yGw+/5aQgvYN0nHyvw1sG3Y/D60pe84jDYHIS5N/QQU33u/N
	OYvT9UWfLVdkYgILcFWEyVja30Xsged59y9Z+pfdQPDlBrGP//KYLYttH/ynZBKkJD5EwMgdH/G
	2qwzesQQ5pOw=
X-Received: by 2002:a05:600c:1f8f:b0:480:4a4f:c363 with SMTP id 5b1f17b1804b1-483a95fb25dmr151444915e9.9.1771853062832;
        Mon, 23 Feb 2026 05:24:22 -0800 (PST)
X-Received: by 2002:a05:600c:1f8f:b0:480:4a4f:c363 with SMTP id 5b1f17b1804b1-483a95fb25dmr151444465e9.9.1771853062370;
        Mon, 23 Feb 2026 05:24:22 -0800 (PST)
Received: from thinky ([217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483a42cd49fsm122198985e9.5.2026.02.23.05.24.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Feb 2026 05:24:21 -0800 (PST)
Date: Mon, 23 Feb 2026 14:23:51 +0100
From: Andrey Albershteyn <aalbersh@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, 
	Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org, fsverity@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, djwong@kernel.org
Subject: Re: [PATCH v3 06/35] fsverity: pass digest size and hash of the
 empty block to ->write
Message-ID: <gjehtg6itdgjysiksqmccrelsqev7so7366zmfer62tgse7u6d@2kucmtmrfq2t>
References: <20260217231937.1183679-1-aalbersh@kernel.org>
 <20260217231937.1183679-7-aalbersh@kernel.org>
 <20260218061834.GB8416@lst.de>
 <wl5dkpyqtmbdyc7w7v4kqiydpuemaccmivi37ebbzohn4bvcwo@iny5xh3qaqsq>
 <20260219055857.GA3739@lst.de>
 <20260219063059.GA13306@sol>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260219063059.GA13306@sol>

On 2026-02-18 22:30:59, Eric Biggers wrote:
> The hash could be stored in that same allocation for salted files, or as
> a fixed value in struct fsverity_hash_alg for unsalted files.  Then at
> least unsalted files wouldn't use any additional memory per-file.
> 
> - Eric

Hmm, but fsverity_hash_alg is global const, and anyway we will
always have merkle_tree_params::hash_alg::zero_digest as fixed space
for salted/unsalted.

-- 
- Andrey

