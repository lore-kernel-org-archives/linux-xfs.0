Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 957CD1991AB
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 10:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724752811; cv=none; b=Vgzk8kXUW2srja1bS/t7ufD3LLbVLJgx+P9Za8CdGxRQdO+RxVNwf2p8h9rpioD1XUjauzKETm/jjSqDjQxBM4RVUZ7hYIeTHDFwmf9XDtvWKQxoyATFHLSf33UErwjldJl/2mDX8x4xgHgoXMYc8AoPBnXzj6vOnGvKMoMGyvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724752811; c=relaxed/simple;
	bh=N0PzZDt0PzJPjSER3FZj4PELLF7A1Vcr8t5O2XBdm2U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BCBKXP3sFCBIqEkWYgJlkWAG7wZiwlXRiyw4mksGfkuPKTf2LnEXWuIDcUpBPQpboXrqPYGjbr3XTXw40PNpx4P9KMd939zAKUSiVhIhawnbDEg3Ze4sGiNerDfCHh5VSPsI2bG5suWzHBmHUe1vfnLj9fuCsqZp7c5WEiXLWuU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=gXJ/Trce; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="gXJ/Trce"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-7c6aee8e8daso3759516a12.0
        for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 03:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1724752809; x=1725357609; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LItg0RW/oD/L3YKzfGrhnwe+I1ecw+wcxdiz2DlOt1A=;
        b=gXJ/Trces7755n6U41E9bLjoxB2B2KEQHfjE/CGLDvcjdgBwlkG+GpcKyQpsXvw6Ca
         8cwsa6diBEe7o0JWd/jad2IjL7oufNi9z1e/ahT7bqeiCWUDTA3j+98jarrr8OsLI3tV
         QRr2rHcxwLruaUPQlUhG9psp4yb2H0nR4VIWqVDkZri/hZcV0SC0zajnCBkc7sZ3Mde7
         gB8DqBFAsnXlIIh4jn9mcyVBT4/vF9sRbCPtPuCyVz37/Ftq5kRVIFRrHwSSj5K0cRUt
         4WqmkZxEaMdskUr2Y2GU08rnUpVWzOkgohKf88JXxqyO2rc0BtAMojCFPq1HlpIfIw5k
         7J3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724752809; x=1725357609;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LItg0RW/oD/L3YKzfGrhnwe+I1ecw+wcxdiz2DlOt1A=;
        b=B/qqvTF9RfCzdAVOx/PtWOQUYRpbmPBh1ldiLOB9DwuJD7v114IvMFCGtt1m3gl89/
         AcEM9b6/jc1NtH6q4n6GxHtUmb3nqFI+LhdHepsO3c7cJj0+pULBWXFCle9kQgEOrfY8
         mZuLD0cCRF85wmZELBIv48Bb71GPTsonKaCPYNjO4l4gj4yzl4bI5sCwl/SLsqaK20DF
         fxYc95OR3aSxMEIlj35Xz/II9TrIvYoBcolWASyQ3LxEPpibluTQH2om8kziUaYlmgKo
         sLwHB4EErZoCb0TGI8BpdSH0Jnac1IS5E38mb8O9iV4XQqSf/gtz79Eed8HXXhZEt4K6
         oFFA==
X-Forwarded-Encrypted: i=1; AJvYcCVDnEZxoWh5F9x5T+gEKd5gTeeNWyPBvvzbYAIV9XyW4IYcpYlpZL4d2E3qsX5YQet/kfLW2WFzJ8Y=@vger.kernel.org
X-Gm-Message-State: AOJu0YxyfJ/sZVdk9SdUHOObZaUnRkisJJGj2orrN2qBGLbH+fMiAS5e
	tf8P4MgC38cFqqqnCB2nLKcKovRUJk6N3i4sWV7w7ZALp5KfAx6U6mNaFegmjHA=
X-Google-Smtp-Source: AGHT+IHptT87g/WsLrq0RQjHqrafESub5eBdp7QEFbfncW7gkNW8FxjckCVK8lwNpC5/Bgj8612QGw==
X-Received: by 2002:a05:6a20:b598:b0:1c4:b931:e2c4 with SMTP id adf61e73a8af0-1cc8b4bd8bamr14912132637.26.1724752808767;
        Tue, 27 Aug 2024 03:00:08 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-0-65.pa.nsw.optusnet.com.au. [49.179.0.65])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-203855dd2e8sm80165895ad.121.2024.08.27.03.00.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Aug 2024 03:00:08 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1siszd-00EQEa-20;
	Tue, 27 Aug 2024 20:00:05 +1000
Date: Tue, 27 Aug 2024 20:00:05 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Long Li <leo.lilong@huawei.com>, djwong@kernel.org,
	chandanbabu@kernel.org, linux-xfs@vger.kernel.org,
	yi.zhang@huawei.com, houtao1@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH 3/5] xfs: add XFS_ITEM_UNSAFE for log item push return
 result
Message-ID: <Zs2jpYJHBtYqSMmD@dread.disaster.area>
References: <20240823110439.1585041-1-leo.lilong@huawei.com>
 <20240823110439.1585041-4-leo.lilong@huawei.com>
 <ZslU0yvCX9pbJq8C@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZslU0yvCX9pbJq8C@infradead.org>

On Fri, Aug 23, 2024 at 08:34:43PM -0700, Christoph Hellwig wrote:
> On Fri, Aug 23, 2024 at 07:04:37PM +0800, Long Li wrote:
> > After pushing log items, the log item may have been freed, making it
> > unsafe to access in tracepoints. This commit introduces XFS_ITEM_UNSAFE
> > to indicate when an item might be freed during the item push operation.
> 
> So instead of this magic unsafe operation I think declaring a rule that
> the lip must never be accessed after the return is the much saner
> choice.

That may well be the case, but in the normal case the only way to
remove the item from the AIL is to run IO completion. We don't
actually submit IO for anything we've pushed until after we've
dropped out of the item push loop, so IO completion and potential
item AIL removal and freeing can't occur for anything we need to do
IO on.

Hence the only cases where the item might have been already removed
from the AIL by the ->iop_push() are those where the push itself
removes the item from the AIL. This only occurs in shutdown
situations, so it's not the common case.

In which case, returning XFS_ITEM_FREED to tell the push code that
it was freed and should not reference it at all is fine. We don't
really even need tracing for this case because if the items can't be
removed from the AIL, they will leave some other AIL trace when
pushe (i.e.  they will be stuck locked, pinned or flushing and those
will leave traces...)

-Dave.
-- 
Dave Chinner
david@fromorbit.com
