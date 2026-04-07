Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E92293AA514
	for <linux-xfs@vger.kernel.org>; Tue,  7 Apr 2026 14:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775571763; cv=none; b=G3LDMJXn2VvizuA3ZSkV2so+o/mogzg0kRW4Lk0KHrQUXVq1CSr79OMwFLVEbQFAGxsnfwI3HBA9/fDdr9ENBDDSC1SWXLupwgIm6ca5VQTlH/+t/DOmhzCx1o8lvhvqAZ5seMSVGKd2SKqr5/ALx7Id5sYBhzCsfK07e7OEgrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775571763; c=relaxed/simple;
	bh=XoiDLUNNgyg2xEAnhOKD0CevZrrQ5TaDHiK2JbsgF0E=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=lEbioapnmVsuSRGQhi8r9B9mWnPONN4PP4Uq0N5mYcJsl4dm21y2qjdbWiJhqCkA8N9jecYyXdI+qsYiIP7u+07DUrK5KGEulMT7GqgZTyLOWQzH+9b/vKdRIkg+OXgchRRxR/U2udornChlnE8FwH3FqdbFBaglNmtSasAKim0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=JCs4ej3v; arc=none smtp.client-ip=209.85.160.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="JCs4ej3v"
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-4138136f02eso3359533fac.2
        for <linux-xfs@vger.kernel.org>; Tue, 07 Apr 2026 07:22:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1775571760; x=1776176560; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=u2+0a4Es20L8ZKKeR0LXCGBpUxoc39KcuZeJSpi5LyI=;
        b=JCs4ej3vq+AUdsXGXocKip8w8JpYzlb2dHYAbUEqRzbLiL4OKkutfcyyXTAFPRDhqU
         7KmwmQOLRvafQBISoFM3I3llfwvDRenAciPJadspsJB8Ot5SHI9euINRjBjOLlMn/kvS
         SpSHuVVJiwBcJm0VMSWJvoAimjSwNOyMCE1pw1cA/i9wlB7qiBr6cWqp2tJU6sbxehV4
         8NRn2lRxDZqr4xWAx3QXTpGf/ju195RjP+otJJ2mRnpY3fQS1jYHeev9rhAXLVSsuz0y
         hSHY/6GUAlRGVavLVaifmACVWU5UwWQAhJeIK0p3naniRMlfU5DzzOHF6obG81ZjzD4K
         +pUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775571760; x=1776176560;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=u2+0a4Es20L8ZKKeR0LXCGBpUxoc39KcuZeJSpi5LyI=;
        b=bhQoWY8Q62pq9lR/4zZequ6CQZlb2dGr6VcWHipDUXzIuI7XDX0TFgK17Fei9M2sdV
         RG5hMS7ROipJ7aZdDc/YPIjSSXRLFqLUzyDUXINElwX8Zd9bmiEM4y8PBeXzhAlkgqPs
         62kFSswhB1bv7mB+F2550G+XruArCG+qrs9kXBzYUCIFnnyGbSM1Q140GgHt8hg0OZI5
         aoZ3Az2xDn5xNIIgM8Ma7N52VZjFJSKJcFMyv3WXBQq4lMOKNgQouva0Vh4mSohqkBPP
         wtMWe401UbKyj1DqQ5H1e8jp9nGyvpL99QXDE3GAkvJt5B3KK1/KK1bgJVoHt/TZmgvN
         zrjg==
X-Forwarded-Encrypted: i=1; AJvYcCX474W00XZV04ez6u58RYRqy/JLxMpz+mBuvh6f/wZTjqlCnL+kzB4XmdJufGyGSBtlIV3bwrMb0Io=@vger.kernel.org
X-Gm-Message-State: AOJu0YxSANGZ6egNKC6kKgmLmvMwUSjQiy7LEvzZ8tYGN1IMqqhNvOmf
	9Qp2zH/khgJ9YkNDtpxbEtLmaiRFyZ+uggLbcVPd2+Jje56RY/d3u9yblLXJufeKQGZC4tVSg6f
	ZDbJB
X-Gm-Gg: AeBDiesq/bXgA74LHSs6pgdoUEsbpn8PL8ly4bVa8nopKNgmIeZBiz9nxYsjqAzrGwX
	jPXSghNGGfO/TEBDA6/+3xSVUWmzCASYV7hyucCs/UqS70mE94tOnPiBPAqtV0fGrxvcSsbufQE
	bMdrjpy/+59U5qaA9S6WoqPItKrweBaBcuqq2aKKWhBjKLA/iLFHBVtLuCxnUg/97RX/K1h2eCA
	Lp5bBOXfeV+7oom04OABrTfPXVYzHHSQ4BLQbNf0U9O4nQU88AieCjotTS73HGd3VbbvdTZ2xmQ
	V0MaQW6otlhAUXqSR1U2hxSwqDdtKgOzH6Dyqahq4lcjRwvFzr1T2P1fNAQbC1vxykdyaDkgejh
	6VoerUyY8ljcBxtvowSuyqTwGDQjzdRZ5KA8Ha+DiuwkuI1mujwXNe2CsfOAPrJ12AG862qKEj2
	F+7WDmxjZ3ci5xQ5/jrIb589zKp97BYI+zLzgj4LBFctqdgM3lRffC+GzorLsgPine+r0QEv+n8
	OAyi/wQxP4oxA==
X-Received: by 2002:a05:6870:71ce:b0:423:1d96:70fe with SMTP id 586e51a60fabf-4231d967d91mr8601881fac.21.1775571759601;
        Tue, 07 Apr 2026 07:22:39 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-42368e39eedsm3906866fac.9.2026.04.07.07.22.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2026 07:22:39 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: Christoph Hellwig <hch@lst.de>
Cc: Carlos Maiolino <cem@kernel.org>, Bart Van Assche <bvanassche@acm.org>, 
 Damien Le Moal <dlemoal@kernel.org>, linux-block@vger.kernel.org, 
 linux-xfs@vger.kernel.org
In-Reply-To: <20260407140538.633364-1-hch@lst.de>
References: <20260407140538.633364-1-hch@lst.de>
Subject: Re: refactor submit_bio_wait and bio await helpers v3
Message-Id: <177557175878.180843.3112896567038730737.b4-ty@b4>
Date: Tue, 07 Apr 2026 08:22:38 -0600
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15.1


On Tue, 07 Apr 2026 16:05:23 +0200, Christoph Hellwig wrote:
> this series factors common code between submit_bio_wait and
> bio_await_chain into a common helper, and then uses that in XFS
> as well instead of open coding such functionality.  It also
> cleans up the submit or kill logic in the ioctl handlers to
> share more code.
> 
> There is another places in btrfs that could be refactored to
> use this, although it is non-trivial, and I plan to add more
> users of this helper to XFS in the future.
> 
> [...]

Applied, thanks!

[1/5] xfs: fix number of GC bvecs
      commit: 452c8f6cbd0ef1408474a875c5c4149a02c7610f
[2/5] block: unify the synchronous bi_end_io callbacks
      commit: 65565ca5f99b42fe62b9a10117cca04f4311dc66
[3/5] block: factor out a bio_await helper
      commit: 6fa747550e35f0a74e649b19d97055988a25b2e4
[4/5] block: add a bio_submit_or_kill helper
      commit: 92c3737a2473ff5b83f90f5c1b353a27492a10f2
[5/5] xfs: use bio_await in xfs_zone_gc_reset_sync
      commit: 2d148a214b24b4a2525f649cced0c3e9e57281cd

Best regards,
-- 
Jens Axboe



