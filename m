Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E3E9339B3B
	for <linux-xfs@vger.kernel.org>; Thu,  5 Feb 2026 10:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770287973; cv=none; b=DVnh4OHXR5qhKZZ2PysuRznB93oXB9vnjKuwpNYjOzjWdNgfsZg1RfdQ/a+9BVyYcBpSd0dePcud3lXCl4OB4G+E2KjBjqP38oDSCCDYWFimKyRzmnKwiD84Q00F/lM0DUlCFWyCbHf96pBR5l6kbjJKUMF6n6rV6DhoW/KHOf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770287973; c=relaxed/simple;
	bh=RLYQJcko5ZmQH703o/t4xWix0JZGeYgc7SJKvzAq0Bs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fXKC05cc/1a8Qob54rRqiIbE2JZ/EbcXSN/sJ2tmY52lvjfl5rAyk5Pd++FBmF7WJ6oiMhB7pE9S+BdSSAbE+UH8TDZQ8jB3qDsxnqq/PlJTCuXHngpsHqzhX2f19xVkER/kwvfJxyBWUqAZs3DRg8thiOkLX9hWlLJFapKDIWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=R97kkFWh; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="R97kkFWh"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-c551edc745eso347376a12.2
        for <linux-xfs@vger.kernel.org>; Thu, 05 Feb 2026 02:39:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1770287972; x=1770892772; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QKjF0EYBO/32RgTr03cTBqJv+Iimk2exnK/nlokZoq8=;
        b=R97kkFWhjlni3P9bIbqjtc5Ei8RYfZNGhq7ORfkUbFnj1YID12LECkYg/anSrjh5l3
         OHuxGd8AMazasegBeFXSShaPnaajZgTG3Ji6wKWkejw6vRbxjD01bVwrXQnvE9TB/PKU
         JQyw6qVBLfCsSGY8ehPArosLk/s9r8UQXAPU4GkSQb9/yb2MqnWwOL+FngF9s0PCRgvQ
         wk+hq03kyPstN3ruuxz4uJxMBEcN1EDjHotcKeGCQbZ+ukKQnJtEAafqoQtN+OeBrTcz
         zc0Q91nmPRanj1T9SpMDRcxGaCE1XUpUfzjxnUaaSrgnRmofx+tkX55BxJWRfyn7EK3b
         pgow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770287972; x=1770892772;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QKjF0EYBO/32RgTr03cTBqJv+Iimk2exnK/nlokZoq8=;
        b=jU9FIXISazRt+bXm1uvtL4fxBOX2hQC2nyncHKF+TNigyVq3q/4eiPLnZbvYXZt6CR
         h5Wf/Kf3epi1Y1zznu8+EP+BV4rq+Wl25P2qiQwUTxjAE+I+Am7LKr+pS8KGQGTxs3nF
         JHyc4Rls7gIm1YrmLFOx6Y2IVlPiA/k1g35cmzy/T8BovsqZ9823HtYVP2vQvegEAC3l
         MXeIBmBabZls/FkDaEr+fpYmQsbhVkcWgn8nSshzgmPkhvrZMg3avHDouzD9H0M21Mit
         s24hEUQVriEUdKi3jWFRdtddwRVpeDdvexYFnhmbfxkGGpdkgV9M7IIONSzqkVqlSVyo
         tF7Q==
X-Forwarded-Encrypted: i=1; AJvYcCWVWgJ0u53xFH69YjIx4kAmvPaGM93FTjbUHI4ZxAct+l8P5MeopjWj3Gf6HPsGJr5JATTdBa72Hg8=@vger.kernel.org
X-Gm-Message-State: AOJu0YxU9RUkfgS9eirQEgjA3iRlgByE/3uki9B9CjMSyxjfjDPNJiPS
	Tj7lh8+clAfpdYgLnhzx+COlFyOj//aKAxojmrVl83zHFXyV34Gk+ghmtl18iiN0Ako=
X-Gm-Gg: AZuq6aLJgqoPx3DK09QNvXvYLJcwB5fD0BVF+G6UO77+AQfRs0Y1vz1MYHKW4vfno5B
	jtolz6PP5Z8wH09vCkHlcwSD02hs4BxFN38KaLSeRqjcNhQOY4ac5DFDWQWj4lfi3Rxo2ydle4A
	6+PryXn7DEGj21covbzAAvizuij2IfpM9OAqze/wg5IKmXe0j+RrOOHyTwTgDhsVWSVjZhW84yK
	P/NBYoAPuUqJqcRoZt9gdjCiSjjnaMr1wxlyngkAkaYmpCgbgpP9U5H+bG47M+JX0mQ8uTNaIoQ
	8U/zDo8JPduO14sP2mXolbsUbM2hnODHr2ja13AwtLx86cbp2RUTOlDNT+0nZsDsqpxs2RJ2Grr
	ArQDaMICnb0a+qNBUGX7TH0rWNvzM8UAg/o8GhiHUwMhK2msC2Ix8BcET4woZwT8ekArOtidXPi
	PGl91dtoU568QLpwDT2bmy93ZKNyas/Y9NMSuK6IW1VPd/Lw9dc41B8R+rko9+180=
X-Received: by 2002:a17:90b:5348:b0:340:ec8f:82d8 with SMTP id 98e67ed59e1d1-354870e9703mr5596350a91.12.1770287972502;
        Thu, 05 Feb 2026 02:39:32 -0800 (PST)
Received: from dread.disaster.area (pa49-180-164-75.pa.nsw.optusnet.com.au. [49.180.164.75])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-354890960a0sm2556503a91.4.2026.02.05.02.39.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Feb 2026 02:39:32 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.99.1)
	(envelope-from <david@fromorbit.com>)
	id 1vnwle-0000000DCmY-4AC3;
	Thu, 05 Feb 2026 21:39:23 +1100
Date: Thu, 5 Feb 2026 21:39:22 +1100
From: Dave Chinner <david@fromorbit.com>
To: alexjlzheng@gmail.com
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	Jinliang Zheng <alexjlzheng@tencent.com>
Subject: Re: [PATCH 0/2] Add cond_resched() in some place to avoid softlockup
Message-ID: <aYRzWiwIWtpSm_4z@dread.disaster.area>
References: <20260205082621.2259895-1-alexjlzheng@tencent.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260205082621.2259895-1-alexjlzheng@tencent.com>

On Thu, Feb 05, 2026 at 04:26:19PM +0800, alexjlzheng@gmail.com wrote:
> From: Jinliang Zheng <alexjlzheng@tencent.com>
> 
> We recently observed several XFS-related softlockups in non-preempt
> kernels during stability testing, and we believe adding a few
> cond_resched()calls would be beneficial.

I as under the impression that there was a general kernel-wide NAK
in place for adding new cond_resched() points to hack around
the CONFIG_PREEMPT_NONE problems once CONFIG_PREEMPT_LAZY was
introduced...

https://lore.kernel.org/lkml/87jzshhexi.ffs@tglx/

-Dave.
-- 
Dave Chinner
david@fromorbit.com
