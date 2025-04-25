Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 986E9235C14
	for <linux-xfs@vger.kernel.org>; Fri, 25 Apr 2025 12:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745583838; cv=none; b=E0QfFhD4l8WFJPv3QblE8h+1QhIhQPYph8SHtF9Ub0RjbIT43l15x1ACIM1MtJhIx7Q7YMYm0K4bTYyhAgP2k15X5daLtfkCJPOywazgL7SnCP25jsqMwnUDAwZeX6QoU60YFy+1xa2Iq0emUqgHCKH32uetqEDJLsm04V40WDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745583838; c=relaxed/simple;
	bh=AmfNm3EqpM5vA01H4oh30BZdfvzhwq3JAWmQg7fiZsg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CNt7wn+jYmb0HPcOULYuNuYc4Fjq9vMxDiVVVFvhoB26n78GcZ2NOykJGR18Vn7jKgYmJft5L1/REgooNN51pjWCKrcXuj6k5WpDVPVQPNquRonPCsZ648698PZ1qWEhQ5PJNul4mvyuJR3+Nsg+svlvBsKyMdhJLjsa2aZFtgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RcxKqEUQ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RcxKqEUQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745583835;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=DFKsucXPFQxU0mSNuQp7U+saDrlyO3quNB4pj5Tcb0s=;
	b=RcxKqEUQaeJFUUplEbFXFvwwvkADUuBolYCeg8rvB/SZjKoCmEv+S6jmzkrHBl/F1Nbomo
	RzOAnEz1NsFHwu4NauycPDk7tGIagIUcAzbUvJBpKCgEyXKRuHeW6rFMJH+2utoazqiUnB
	SFrxM2ubN59hcUS9+4K01xl8L5Ma6Dk=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-68-XlUxxizsM8adv0JV3lB4nQ-1; Fri, 25 Apr 2025 08:23:54 -0400
X-MC-Unique: XlUxxizsM8adv0JV3lB4nQ-1
X-Mimecast-MFC-AGG-ID: XlUxxizsM8adv0JV3lB4nQ_1745583833
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43efa869b0aso13530415e9.3
        for <linux-xfs@vger.kernel.org>; Fri, 25 Apr 2025 05:23:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745583833; x=1746188633;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DFKsucXPFQxU0mSNuQp7U+saDrlyO3quNB4pj5Tcb0s=;
        b=iqC2jUmKh2u3VvRMB55mLemutTKzKg1Lq367mvjJ2FC29zoJ3e996KD6kK4pWnpHcI
         hLYnFRGldk1V4GEeXjovlP8n/gNRStxUpjlli/iq57AeLUKNVh530CvpShJb6Ct3HwMD
         WyeKTXG0312FiHHVvip0+/F/OViuZrxi2IqZQefMkfIVqv+OcXpm6/j6eZDMgdC6tBgx
         jPznwHT72AZuBJFxGpuS8UmPHGJeR9qDAYfjxE4qyQ0ilAbyqgSe3rVe7Xbu+RPVIw6l
         16ffW9YrocU16wEBwEwBho2lNl9zSeMRYi1voiS1VEa9BCM4jhi7+xRqyoFAtN0SAbfl
         bIBA==
X-Forwarded-Encrypted: i=1; AJvYcCWQoJMhLCQDvaf5LjtOh35dhWkbE4/UoAEFEe6EqDvekkk7Z9mk9G7dowZyZYsM67LPSEC6Iwzpuv4=@vger.kernel.org
X-Gm-Message-State: AOJu0Yx8uaVipsCNt9OA7HCVv3D8sHxcaZc+hHOxtfJhEANcZhhkuTIn
	6nJB2knU2cyrD+Fro6iPB6n8TQ3JviThl6ovcn4P1v5EI0Zqhr2CRLX85FtMtWty+lsOPH2gsv+
	Bu9JZpunE9uZiRi1AbKGO5x13WOzJwqOjXsvgmcqKeVwCgA/e8h3ud7ST
X-Gm-Gg: ASbGnctpzbHNgXCdj3mkauH0lulxN9cj3BIwmcVsOmHKxmIn0A/hJ3n0h1U9cnR7TuQ
	wXSXngC77349Ojpq4ZJhsToG1LRhZT4xUNbqfO1Ig2/gvt3tTOf1qlerbvu/eEDQ2n9Jf63T/rw
	v2GiQZ8QfN+iKj9ImFKu0izhSzXA6ImGKQm613M6VJdsvbqdtTLiirDuZ0UkZ2ahj/HlnqaKAnO
	EMphyd2w8cr48E98ES3fUg/LtMjM9bYBUaf8ocv+8/lVCMk1kbn6p0DDM3aaOM1Qgclei7QTDu3
	jbLhKURcTXcBgdd+rLxw4Ux2aqKKxlQ=
X-Received: by 2002:a05:600c:1e88:b0:43c:fee3:2bce with SMTP id 5b1f17b1804b1-440a66ab25amr17462225e9.26.1745583832839;
        Fri, 25 Apr 2025 05:23:52 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF0oHfn/eM28R858maXddnU+aiNrnrK734fYTgsoL9FEpylufK7d5k5zbuemVgCgNWDZ5pWMg==
X-Received: by 2002:a05:600c:1e88:b0:43c:fee3:2bce with SMTP id 5b1f17b1804b1-440a66ab25amr17462065e9.26.1745583832459;
        Fri, 25 Apr 2025 05:23:52 -0700 (PDT)
Received: from thinky (ip-217-030-074-039.aim-net.cz. [217.30.74.39])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-440a538f4aasm22876535e9.38.2025.04.25.05.23.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Apr 2025 05:23:52 -0700 (PDT)
Date: Fri, 25 Apr 2025 14:23:51 +0200
From: Andrey Albershteyn <aalbersh@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs_io: redefine what statx -m all does
Message-ID: <udawfebgohzoost4fkp4bn7t55du5uihrkgcbkvaerz5qekowh@mwm7gc55sb3a>
References: <174553149300.1175632.8668620970430396494.stgit@frogsfrogsfrogs>
 <174553149374.1175632.14342104810810203344.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <174553149374.1175632.14342104810810203344.stgit@frogsfrogsfrogs>

On 2025-04-24 14:53:23, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> As of kernel commit 581701b7efd60b ("uapi: deprecate STATX_ALL"),
> STATX_ALL is deprecated and has been withdrawn from the kernel codebase.
> The symbol still exists for userspace to avoid compilation breakage, but
> we're all suppose to stop using it.
> 
> Therefore, redefine statx -m all to set all the bits except for the
> reserved bit since it's pretty silly that "all" doesn't actually get you
> all the fields.
> 
> Update the STATX_ALL definition in io/statx.h so people stop using it.
> 
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

lgtm
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey

