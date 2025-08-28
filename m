Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com [209.85.219.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 679AF285CA4
	for <linux-xfs@vger.kernel.org>; Thu, 28 Aug 2025 21:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756416130; cv=none; b=D+CDqcLnsxkWIWdOTBoFn5HNfh7LIPvORK7eLnb46aW3aGaPtGy9PO84+HPsyy4wRF3Lki4oyg8xLLrrl9uZrnzqJvd7hcVATrY5DSd7nAuaysfl0XA1C7bG3FYMb9lV3JpaF4rvJMIQS6zF7/Q0z5wc7Yrfm0oPFwj00jHhOMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756416130; c=relaxed/simple;
	bh=aJVTJp1Yl8+vhV4hPswj4DUIjr7rT/uJiOu13fSpVZo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VSt6sCT4Ab0F1DW2T7voLUw12d+Q+63Bb/shEL1wzOsn1ZqoXp0EtZpdNoalNGFE/oYN2WGaZt8d4vJr99ExlNlCw0SU7vBjjF1fwamsT30rOWYdZmmNaSlE1Nhwc2cF7gqhY5GIisZjBReB9h0uOlbPLx0p4G6Zps+bKH4FN2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com; spf=pass smtp.mailfrom=toxicpanda.com; dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.b=R2xnPuDW; arc=none smtp.client-ip=209.85.219.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toxicpanda.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.b="R2xnPuDW"
Received: by mail-yb1-f180.google.com with SMTP id 3f1490d57ef6-e96e5535fcdso2473378276.1
        for <linux-xfs@vger.kernel.org>; Thu, 28 Aug 2025 14:22:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1756416127; x=1757020927; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=t3LkVCQ8kVOnnmDS8grT1/qlSRphyhJmLNB0qej4dbA=;
        b=R2xnPuDWF/75jFkeuckMdZk6lBdTcyoplNsE7ZX05OI7npgHio71mlIiN3ggzglFPc
         ftA4kHUXniRGnDg4TvSPwDTCnOrNVQQsbH4JsTeB06gSYkSQaBTLgQo6TX8nRWlFsh0q
         GjKaUA5lBMhN2reL5l1TGXJ8WDTdIUz+0ofIYtrQfByHwygXGidvbEjeQe0Xn+bODbTJ
         Cedj7Ky8LWwF9h3bB18TgeVDdoQecI3zxqE0AI/4vmZm/OcuemprOUAbADdg7EspEt6o
         3VhicqvvSg+4GuV8IoqhVYfPUwnnW64MIuPMCvfLFmCMIdNKIdsdycBWIEAw3opqSi1r
         PdpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756416127; x=1757020927;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t3LkVCQ8kVOnnmDS8grT1/qlSRphyhJmLNB0qej4dbA=;
        b=buI+3vC8LuDQI18lu2owNk6zryyAblQdAqxdGZhy4Qvad++RXYkQd0b0Fpo+qFu3y3
         d1VGQjvRb1vL8V0KONFRJ9nXPch+ASMjvlY0Y7wxrdQNCKijTO9u3H9e7NrDUmRv8fv5
         dAe68NIzwrhL313dZSUAwULb5XQrVL2jYYvJtoGi1rNEwYAhn2uLHH3+3x51RMaO4jkq
         KUldU4UAkQCTWkuONc9qcNov1af7zOQO0Rqi7l7nWl6xISHOKKFQhHieoo74RIxZ+4tM
         nva/oB9ro1/CBEhPg4KxYdO+z/pZ3nlaZEWXPSPudIHvURcIsMmHHfi/LM5kF+ebrwa6
         /Acg==
X-Forwarded-Encrypted: i=1; AJvYcCUAnUdmmFiDhOvIJ4G/+WJh/Z64mBMi55MwoNvQFep5KaxYnhD0zAyHxfw/KcLzknrwG+KbEDfxSJE=@vger.kernel.org
X-Gm-Message-State: AOJu0YxuLee/zaktCbMZcG099B9r8YpbaktMd8k+E6yyJDVaoj+v5A9E
	oFyhY5+vC6f1wsJIIeWyahY5Ja7mrDmWXEY044UBqs6VhvxHrzNQj6cz3Hb7wH+FzYI=
X-Gm-Gg: ASbGncu07IJG31k7EJw+M2LJgbonE5c2XAefokwBf6rvqodCcDFSih6E51H7ET6ta8F
	HwiZYj3jN+BLulQSyR69oONRctQlX3NkrArsnuTsXMrQOnCSBgztj7xDnuEg7JuqgUZV/LSYuq4
	uVIiwR5c/5Cj8M317UXL8XXWlVmNEab50+r/yKJwJETKFTSukPluY40Hab3R3QNDcKLkVhQB/S2
	7H6DJI65KE9EZKyOck3/Wj+A/X+BurjukRGD2OhH0Iq0CJpvpjTjJwDQ2DenzOnQo/LMx+DgGi/
	YFvM7rsoo+G308tAs00MuNyLxxgGWdVq+tzkWhSgvIQlwnmY5O2TLpGYsqKJGIqdtpwDx5shCNV
	h/nNE5Mwr7O63uqPeRR78zOaB0G7vMw7Or7oQVDuxZmfQTsq1mgEEZtnRVAY=
X-Google-Smtp-Source: AGHT+IFOrMBYSYojc1UQ/EpVD1LfbmNEfeG8jgLFeXE187SLAD9S1Hu+9phZyJ9UxwGExOFza3VkQQ==
X-Received: by 2002:a05:690c:64c2:b0:71f:9a36:d332 with SMTP id 00721157ae682-72132cd7798mr125819147b3.27.1756416127280;
        Thu, 28 Aug 2025 14:22:07 -0700 (PDT)
Received: from localhost (syn-076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-721c630b9c5sm2339097b3.9.2025.08.28.14.22.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Aug 2025 14:22:06 -0700 (PDT)
Date: Thu, 28 Aug 2025 17:22:05 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	kernel-team@fb.com, linux-ext4@vger.kernel.org,
	linux-xfs@vger.kernel.org, viro@zeniv.linux.org.uk,
	amir73il@gmail.com
Subject: Re: [PATCH v2 00/54] fs: rework inode reference counting
Message-ID: <20250828212205.GA2851550@perftesting>
References: <cover.1756222464.git.josef@toxicpanda.com>
 <20250828-hygiene-erfinden-81433fd05596@brauner>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250828-hygiene-erfinden-81433fd05596@brauner>

On Thu, Aug 28, 2025 at 02:51:23PM +0200, Christian Brauner wrote:
> On Tue, Aug 26, 2025 at 11:39:00AM -0400, Josef Bacik wrote:
> > v1: https://lore.kernel.org/linux-fsdevel/cover.1755806649.git.josef@toxicpanda.com/
> > 
> > v1->v2:
> 
> I've been through the series apart from the Documentation so far (I'll
> read that later to see how it matches my own understanding.). To me this
> all looks pretty great. The death of all these flags is amazing and if
> we can experiment with the icache removal next that would be very nice.
> 
> So I wait for some more comments and maybe a final resend but I'm quite
> happy. I'm sure I've missed subtleties but testing will hopefully also
> shake out a few additional bugs.

Perfect, I've been fixing things as I've gone along. I'm going to wait to see if
Dave has any other thoughts while I'm asleep, and then I'll resend tomorrow.
Thanks,

Josef
