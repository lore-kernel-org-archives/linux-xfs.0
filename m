Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1FE83DFC6D
	for <linux-xfs@vger.kernel.org>; Wed,  2 Sep 2026 18:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788373506; cv=none; b=rMDUMHJl2rus2+QiehnAzUNgmpFoxLYz0IvLN8D9am7QPTkbpRi4hHWK2zb+yJPvNf6L7VbOIR9NauYC3d5hHnzmIh3n8HZRl0HUeWJh/r7bikuinfjmeU+3WNayGa7h3HBRFSYA0Sf8I01OapMLho779p7zhT9dkZ7dQtNlZQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788373506; c=relaxed/simple;
	bh=j5z05H9my0ZEtJmvedrVdfeQ7u1S/6Jb1g3UIaBPI1Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JMPjkK2xwXroSb7t7926HrjA98EuVPgNonfShd7EUAGFisxPJC4A1kzpftdVpUhTvXIl1g7RIosCw2gAPsKsjkzkA+XXfgqWNaeeuDw+peRh8bis9AWU1zN2KooiHWgDlmmzzFMhFk8Jl5yb48hhRTjZgOII5GtQ9SzzB6Q8inw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bg7Ghj2Z; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bg7Ghj2Z"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-38dfe910e9dso1660053a91.3
        for <linux-xfs@vger.kernel.org>; Wed, 02 Sep 2026 11:25:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788373505; x=1788978305; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6AXQi4howHroN7DuyCWjjvFV0b8XeXdQweCPbXwE3Wk=;
        b=bg7Ghj2Zg9gHrAQAB507FCOukWRib8exoNHTU0g+SZiZ0dy+W9CV/Jl35z69LOeTwX
         AtLZx8i6dsAI0rcf+Bungk/qWi9XdEftQzLaZ3FLhNGh8ptAi7ymsZ9aiDf7w0IKzbRu
         B4yd37q10dldPR5FT4ZruigM5dp4eJA6iNYEOuj7ksw70dvHbmDobQWYWq43N8Y97EyT
         QW9nFg/mXTbkHoEXKXDiA4U8vDgmZdb5Tg7QOqd/cQahNUmgg/lUeSEbGYjkLL5ZYdhB
         Qvv8y0fUMj8vvYDBZK2SM9llX7yZQbDofyRET/MfDUU1cjK1dFbHw0A5Jx0vOQj1y4yD
         8/9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788373505; x=1788978305;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6AXQi4howHroN7DuyCWjjvFV0b8XeXdQweCPbXwE3Wk=;
        b=KXbDtYK5uEH8RAqQRUmW0PJv822jrju3X5oyVL8B0kh3ZSjm90sIdq0qqpSuTqJNqE
         WgmyjZlpo2/p0xVhB+8vnth3H2qNCkgcIZFjt4K97RbGaoIpTgewxt4JPi3Iv43QierO
         AdL/cjSRAO08EwQhHiFX/3oe0Dc1BGTZr5VqgEA/yCMc4pgYFbtu+hgjkiScFfJLbrTP
         SWYWKI22gsvNu/j68CNBFC4r07KXFXk48+2sgT5qyFRBzIRYwoG5Pzpt/uLikFcyj5fy
         4d/SkAPQpbyHcHk/HRlJ9gaDnCS19yBs2m+8muEPSrgFiri/lno257l3P9syDuQsRX0G
         AIVQ==
X-Forwarded-Encrypted: i=1; AKwUvBxZs55RL8Fd57My1acQPRar3qyKtlI6Ojig9qowXjw1yZ5TmhY3L/4LUhietFo1Bx7cvFe/UihLIRU=@vger.kernel.org
X-Gm-Message-State: AFuF++lcYmVo06oI+fuPOC93XtSxTPJjMTVkUoNN9J3hA+ngFojIaYuf
	q7+XPKnUf9B9jlquaFvXHMYIQlZe5FehPyaeuJ4wgKTz4MiWnlYG0jo=
X-Gm-Gg: AYBFou2UDezwiRLNDOb4/UXagWl3L5FHxefJMAOFTX9KUc36uAD8w6fPOUOF3AOM88N
	JaTBir7+EbPwKwVmJYhr6HKLaaX41uHSqHLqqHj2tMRzjXZB0r+A9uQqALinIXkvlfuLOuIgDK6
	sCQXA8uFxQCTLZOcWPDrFVlZL38Y/wij/0NTg6WZNSVeXUUpROEb7k8z8+OgPxWEQzR94d51mSu
	hIyHykSkpO8+q1cHqisVJZROxx2k6tbWqz2U0R1NIt4E16odS9hg/rS5buYQScDICu/pjdFD6/w
	ZlXNVIjVesDIC+n/II70u0MiEZ4OydcrA+jyxjmXjE0d+2Ig6O84XASQ3rxl+nglpW/ZH6NyowB
	G38yAjk4yBaqq8Gxd7zZEO26uz6TiAMAMxVSk9gLK5JSNbS3eVD52KfzRPllbzdkdchoX9FS8G2
	gQouaV50ttBkHz/WqUE2zlHXsCryYPYWQ6iJ1olWcp9TG3iml/kiyN1TbwKUwTIkx77k3kE07cF
	bbzTIs+hLHurOmJy29JXFIEBxwO
X-Received: by 2002:a17:90b:17c2:b0:396:b918:c2a with SMTP id 98e67ed59e1d1-39aee13cbb6mr8049325a91.12.1788373504937;
        Wed, 02 Sep 2026 11:25:04 -0700 (PDT)
Received: from anuj-MacBookPro ([2406:7400:63:f76b:3efb:3463:cad7:ba39])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-32f079bd68asm8704512eec.2.2026.09.02.11.25.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 11:25:04 -0700 (PDT)
Date: Wed, 2 Sep 2026 23:54:56 +0530
From: Anuj Gupta <anuj1072538@gmail.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Christian Brauner <brauner@kernel.org>, 
	"Darrick J. Wong" <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, 
	Tal Zussman <tz2294@columbia.edu>, Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org, 
	linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 14/17] xfs: add support for lazy direct read bounce
 buffering
Message-ID: <k7ugcithodfdkswsbzshcnwaqwiubmhf2zq5jp2usck6finbhk@xt4pbaimvl6d>
References: <20260831064010.2574896-1-hch@lst.de>
 <20260831064010.2574896-15-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831064010.2574896-15-hch@lst.de>

> +	/*
> +	 * Free the bio integrity data for the original bio, as we'll allocate
> +	 * ons for each sub-I/O, which could deadlock if we keep the original

s/ons/ones

> +	 * one around.
> +	 */
> +	if (bio_integrity(bio))
> +		fs_bio_integrity_free(bio);
> +
> +	/*
> +	 * Reset the bio to submit the bio to the block layer again.  Switch to
> +	 * an end_io handler that simply complets the ioend, as all verification

s/complets/completes

 
