Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2397D2253EF
	for <linux-xfs@vger.kernel.org>; Sun, 18 Jan 2026 19:19:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768763953; cv=none; b=ChI7NPcfl0uD+CxTcfzsORlkMQZ6MIf5Q5VKWv6ayKkc0yJIlUmpBIqPLdi76WqLnvkLNglftJHImC4Rz7ZYg7OEGCcTDn+37emtMID0qiRcjoqYY1TERhh8xzu9/onTMU+wxu/V02FMGw1HbBS2Suoy3u8WzOTZFhW3/K/DpFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768763953; c=relaxed/simple;
	bh=82Mf2NJeAvt2o3n0VPrMIXZfLa8qYg+zAv5mNLENzcA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sog1Da1UJm3HUW4gemIvCsYaB8ggreTdCfUKM9E1y7KIkiXwYU5F9TQdXMBpuQer2cOe73eoLBVecxvOrQPweVKlj8NI5CUc6l1Nkj/GtcCmhNcOEerUX8Od6U3cKfvlHh202DWqPV9P21mugyi6dxPiAnExk5etScWkALxtXoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NXUFoe2l; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NXUFoe2l"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-47ee974e230so29602345e9.2
        for <linux-xfs@vger.kernel.org>; Sun, 18 Jan 2026 11:19:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768763950; x=1769368750; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UFArAHFNDsmlr0nPHwPIpxNTvQE9baTRoexdP9gjAwk=;
        b=NXUFoe2l/q48oIfFkHDTgsGf5X0bpBIIibEIhW6Mu6S4SiU2qkEqqrRnZEgiYtYbNy
         I5dcDGNFQYMqX7Jc3COF3LCUZYP3vX4G4ZEnPpK+1KR9hWnG+b7I4gZM6fvXkgpstrgC
         kMaXIF5h4444GkXuaOxtIHUwh2LLVQlGxrTv3JAsV7qn0cPDAlQdsAbv41/6E5IAf9Nv
         t6TppIg05qGauklRMl2Tx5IhVXe3d6WedpykRvskiaOMfq/s8tVsTJkNbvxAFrk1c+cG
         +9E35LB3BIjxxxugfc5bj588OzrsYtKX7Jr3k/Y/hjOkqYgbJ1NWSKMtEkzYal8Z69m6
         0JFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768763950; x=1769368750;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UFArAHFNDsmlr0nPHwPIpxNTvQE9baTRoexdP9gjAwk=;
        b=l6WLFxBvI10iEPQt2Ae0lVfOblWDKWkKj+anKaKWj/En8gtOgsc33x1rTyKvMa/wIY
         8WNiJaleIrDVR63l90de2xWggddNTU3sQLFHBQPflviTvJJQzDuE2iyObTeUby/fJEBH
         eREBvwmTC3Ldz2ZjQBlimoQopOLHaBfX2wiCS2bFmD/DGg9BgQVyOebHlEpKLoU7/tft
         WmwkNHp77hveVf38zIkiADFBAwhL/b0nYjpVE22nsX54g+jBOqTCMzv69WiwVOCPZ5qE
         4v+rXA+mDhJplMHPfXaPQmMdO177p4sZViMoMQR9c53ZUMSL1KutOhh1LqIY4swV3Yy1
         So5Q==
X-Gm-Message-State: AOJu0YzKVldr/DQ3/Pzw/dQWvO7SlDmcTHEeGj1mOhZ8kaUCQ+C2dYZO
	1moM7HoFQr373n46qxrnYMXZyVRbxj3qB/nE39fNXqN1KvMmLJtN67Mb8cP8qA==
X-Gm-Gg: AY/fxX5RKfMgFYDCjRB5vhc5SIDDtyk1ZrUOeXGIcT7inCzNG5en6bmN5GkCm0fjBTg
	S+Q2+xoYIKFkbsd4FFqjdDCXDMnfrmjkAYIhtbMW6x4wzQAJNx8RODjPWUcHmzxTjfoYO4q+93K
	bDeL+XLeBLVVxcnHCmdtAnbELFqtC1Y261Wdc7krKFGwMGeuxiuuZ6AaWWgERVrZps/1srUE4bR
	aeXZb7yKzqg20jbdrO4kZLRUJ99GndeONcsNgKiSydtVdlCLGYpNjuiY/n2qGfsxBjfJOzRXmk5
	b6LeXZAQWqnbU1lTPVZl+C4C4VKVT036VXHom2PLHCH+wV0NEHebujeIKBaS6QS+okA9+5scfYV
	3HgdOnd5A+ZqbFf2wO605vx+QHL96rRHKNQkvIqhphiuZodLMtw/yziv5zOzecCsTeSJTym6BMO
	D44rg=
X-Received: by 2002:a05:600c:19d3:b0:479:2651:3f9c with SMTP id 5b1f17b1804b1-480215e207cmr100616015e9.14.1768763950359;
        Sun, 18 Jan 2026 11:19:10 -0800 (PST)
Received: from f13 ([2a01:e11:3:1ff0:f108:9c47:a37e:e4a4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4801e8caceesm152849235e9.13.2026.01.18.11.19.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Jan 2026 11:19:10 -0800 (PST)
Date: Sun, 18 Jan 2026 20:19:08 +0100
From: Luca Di Maio <luca.dimaio1@gmail.com>
To: Zorro Lang <zlang@redhat.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, djwong@kernel.org, 
	hch@infradead.org, david@fromorbit.com
Subject: Re: [PATCH v6] xfs: test reproducible builds
Message-ID: <aW0x4lXOhO0g1_wm@f13>
References: <20260108142222.37304-1-luca.dimaio1@gmail.com>
 <20260118175327.hdevfpau7uifdsb7@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260118175327.hdevfpau7uifdsb7@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>

On Mon, Jan 19, 2026 at 01:53:27AM +0800, Zorro Lang wrote:
> On Thu, Jan 08, 2026 at 03:22:22PM +0100, Luca Di Maio wrote:
> I think it's not good to be commit log, better to move this part ->
> 
> > 
> > Signed-off-by: Luca Di Maio <luca.dimaio1@gmail.com>
> > ---
> 
>   -> here
> 

Thanks Zorro, sent a v7 with the correction

L.
