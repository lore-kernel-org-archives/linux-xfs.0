Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71381311C35;
	Fri,  9 Jan 2026 15:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767971032; cv=none; b=LL2WS/G6tMr1Y1YnBCZQybw0CWhiw+BsOK216Sv7u9mTGefS5/PuQW86dKsQZK3mDvaoIvBuKnRw3P7RWcTjPOXGa88QdteEf/ivyP1ju8BxY/8q18jOXpN11oqo+XCfWdh7B1opbEOKZHeh6AktUQDhLghcrqohY43uBaIX8W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767971032; c=relaxed/simple;
	bh=pbLPYpzdk8kWolx7kwYDUbVMxRo563GXMNxZLBos7v8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=dJcnz73uOMAXy4zvkpHdrR7Rhwjr3ClNbEp4OyboWrM33Dz02frwuwNfnJO+3iM3ZHs1O7mb0R3RRO79LYBoLMuyPoZjE3PCE59xnKJ/mDCVhEuQDshVo1MVyM2WDl0/UAJfuHrssfiPAT6S3lDHOU++6QyRbbHnm+93fJHVZPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bGStLacL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bGStLacL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC1F9C19423;
	Fri,  9 Jan 2026 15:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767971030;
	bh=pbLPYpzdk8kWolx7kwYDUbVMxRo563GXMNxZLBos7v8=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=bGStLacL2eAXuy5dfayU8ActyXU5RGx7zxaxPlVpNFg5V8fvyWjC+kylkp04ftClo
	 aODHLSIF6V2N933W1wEUxN2S0ONnAW8psGtJQOG2CU+DA1Vlk4V9VuKtvB92J4d1t5
	 GY5ASkuWtlIeCDV6LleDF6C/77hoW7t0RO6VHxlxUkMCUUUoG040/qkHb0smp8eRXt
	 SHwevsTN8MP2Y+aLzTBP40iSsCAxl93vGVEk8YpeZrvJYKeuDdHW5rOB4hAR8s792A
	 OOOQRiMsNpxDrJnhkP+aEGHyThsFGhnXqHm0/JvGEWLLNVIs6dVz/qPnl0+HoWdtR1
	 xm1ux6tMLBEqQ==
From: Carlos Maiolino <cem@kernel.org>
To: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>
Cc: Damien Le Moal <dlemoal@kernel.org>, 
 Hans Holmberg <hans.holmberg@wdc.com>, linux-block@vger.kernel.org, 
 linux-xfs@vger.kernel.org
In-Reply-To: <20260106075914.1614368-1-hch@lst.de>
References: <20260106075914.1614368-1-hch@lst.de>
Subject: Re: improve zoned XFS GC buffer management v2
Message-Id: <176797102841.430235.1465892466150330026.b4-ty@kernel.org>
Date: Fri, 09 Jan 2026 16:03:48 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Tue, 06 Jan 2026 08:58:51 +0100, Christoph Hellwig wrote:
> the zoned XFS GC code currently uses a weird bank switching strategy to
> manage the scratch buffer.  The reason for that was that I/O could be
> proceed out of order in the early days, but that actually changed before
> the code was upstreamed to avoid fragmentation.  This replaced the logic
> with a simple ring buffer, which makes the buffer space utilization much
> more efficient.
> 
> [...]

Applied to for-next, thanks!

[1/3] block: add a bio_reuse helper
      commit: 8b7b3fa4c5dffef6cef56fad42d0d4bc525200a8
[2/3] xfs: use bio_reuse in the zone GC code
      commit: ac6d78b0277ba32b8b60c4cf02dd4d7b77fdfe94
[3/3] xfs: rework zone GC buffer management
      commit: 07e59f94f4d2a01e1858ef5e872f16c75665568c

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

