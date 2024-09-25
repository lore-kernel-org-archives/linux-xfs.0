Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7496715A858
	for <linux-xfs@vger.kernel.org>; Wed, 25 Sep 2024 13:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727269311; cv=none; b=YWJbdllvZWjxd2AykDQJNe+XyS0dU0KEKA44JIARgwqDuIyrsHn4DGunDbNT/75N/P3FQ779dLG5e+a5ykOBDKn5X7SO51y3w/Giammf3M4iwpn9lnp3ozEKdTsrnaaHl2Wmy2k7yjeWMfr73lLQutKMHoljao3C6gLLz0TKiAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727269311; c=relaxed/simple;
	bh=/I2QyuALtHqcZ4GKUEhdX0jON2I0ZTnTM6uixWW961A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p5zZSe0uzCl/5jaDVCH6Xt2iOO7/Glz7Ns1nf/piAuxcAyfYlOgbXD4HZlT6H4VFm970/AV7plydmGfp7IXipEQXh0skM/2fFS0lkvFsFIfX/wZn5LUUe8IDswDi9MIBWajjTl0p5pSHvQ4U9AYTpd8KAAJS8uuxSFFtzodgzac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=ZJHGiHAF; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="ZJHGiHAF"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7191f58054aso4989045b3a.0
        for <linux-xfs@vger.kernel.org>; Wed, 25 Sep 2024 06:01:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1727269310; x=1727874110; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+Hs7Rj+geVPl0+wE/2Riapln7P4i8+opp+f+HJRO79M=;
        b=ZJHGiHAFS2AgScucvvWX3NCYCxcshW9W19k3I9uqzfr2w399/a/heKllDE6r+cbK9Q
         qOnyEIEsCNxa6x2kjeAufWFV8+88lbP/ElRRRHj23uxgUmdPBdw1ETd1aOhvh5bkvyvB
         yqzaxM5Y3J9BxcYmTF5Fo4xducN9rUSoS8gOtzBAqX8B1KvWvumrFPOtnSxkfQGKpJNW
         f6iSuDRv5k+8jWlJtUyU2JtSEEwIq4PEUPGwHO0fPnxdMgNs9e13MXt9mRK9W27/h5RN
         VJCO4ZaZYB2YisTYoEdelYlbWoSoTvi0yQz8jLL0yRNL8u8nG0CF4tCasEPck2/kGeyu
         SA7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727269310; x=1727874110;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+Hs7Rj+geVPl0+wE/2Riapln7P4i8+opp+f+HJRO79M=;
        b=n5fGYBEtNKOEdzROwprKXT82VICXlQ/vF3RnUa8aXmupznju7W0iXRUHvNgcCyvXO8
         xKkzIkM2vQsoHvOqGhweFy3OtCUWSteVZwd8hOtPGabkPx/Bo5UzONg5iL76SBMvVyDE
         q0V8w2C+FMBQydYWYPxMQYAE4wGiwdiXoAmgf3npcVJqyWEtOkiVz5aw8cpiJPnCg+wZ
         jygxskSyTGfMNK4kHYk6BzKWpks2fx1QwkTfnHRuot1dR9UF6o18zzYNnE5y+8pd9GDM
         nsjYtmQMav8hxqEwOOerwIMOc7eB2YmzmFMfN7emel6yDipu4rYEtDAYsP+vj3tAjjja
         epYw==
X-Forwarded-Encrypted: i=1; AJvYcCWn7DdUFBESjMmqhiUdqnMZG1kUdIZWdKS8KVqFN90A8SkBH/6BcbCZ9A3WdTM2kr+RYr8peemIF8k=@vger.kernel.org
X-Gm-Message-State: AOJu0YxUpe3AqFL8n0ipqfS1W2KyLSacvJxjyW6HuM5EL9ZCgEa3ayyu
	pdm3RfsIPuQqMhGZAnpLmXEIHF5DM64gHEbokN3/87p/6O9W/LbHN/+0mtXtBlg=
X-Google-Smtp-Source: AGHT+IGhVDXpQmSdOuPcFz0YHbnVT7KRb9mz7wJNr05mOpzbhnXZwabgK4/OENvrYl39bd7adJnW7A==
X-Received: by 2002:a05:6a21:3997:b0:1cf:e5e5:263d with SMTP id adf61e73a8af0-1d4e0bf0da3mr4193230637.35.1727269309727;
        Wed, 25 Sep 2024 06:01:49 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-78-197.pa.nsw.optusnet.com.au. [49.179.78.197])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7e6b7c7326dsm2566998a12.66.2024.09.25.06.01.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Sep 2024 06:01:49 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1stReM-009sBT-2S;
	Wed, 25 Sep 2024 23:01:46 +1000
Date: Wed, 25 Sep 2024 23:01:46 +1000
From: Dave Chinner <david@fromorbit.com>
To: Sasha Levin <sashal@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	Pankaj Raghav <p.raghav@samsung.com>,
	Hannes Reinecke <hare@suse.de>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Daniel Gomez <da.gomez@samsung.com>,
	Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.11 237/244] iomap: fix iomap_dio_zero() for fs
 bs > system page size
Message-ID: <ZvQJuuGxixcPgTUG@dread.disaster.area>
References: <20240925113641.1297102-1-sashal@kernel.org>
 <20240925113641.1297102-237-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240925113641.1297102-237-sashal@kernel.org>

On Wed, Sep 25, 2024 at 07:27:38AM -0400, Sasha Levin wrote:
> From: Pankaj Raghav <p.raghav@samsung.com>
> 
> [ Upstream commit 10553a91652d995274da63fc317470f703765081 ]
> 
> iomap_dio_zero() will pad a fs block with zeroes if the direct IO size
> < fs block size. iomap_dio_zero() has an implicit assumption that fs block
> size < page_size. This is true for most filesystems at the moment.
> 
> If the block size > page size, this will send the contents of the page
> next to zero page(as len > PAGE_SIZE) to the underlying block device,
> causing FS corruption.
> 
> iomap is a generic infrastructure and it should not make any assumptions
> about the fs block size and the page size of the system.

Please drop this. It is for support of new functionality that was
just merged and has no relevance to older kernels. It is not a bug
fix.

And ....

> +
> +	set_memory_ro((unsigned long)page_address(zero_page),
> +		      1U << IOMAP_ZERO_PAGE_ORDER);

.... this will cause stable kernel regressions.

It was removed later in the merge because it is unnecessary and
causes boot failures on (at least) some Power architectures.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
