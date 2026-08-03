Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F9503B4417
	for <linux-xfs@vger.kernel.org>; Mon,  3 Aug 2026 13:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785763388; cv=none; b=U1l4O61IKOpCu3zNKDMDftAs4OZOIpfRPQJRuzLj/XI7aWIQjRrQ0FB666aNlhcHYQm1Y2DhdYSpaLWs5NIJU+VSDGllyDxbnawxmU/XttVst71kQoQg1WPeE0U9P6rPQfgBWE86R1QF/qpPKGsmMbKvIob2b0OLJ502cMSoY8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785763388; c=relaxed/simple;
	bh=d3z2+P7tF2EyMv9FR7b6NmrPz88prkPo5ne/fhl6EN0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=hkokPOO2mcIxmFg1sXkLKdTWyomwl6yPkHgreZZe6C8nKAuQFrFg/GC3zmcT91noPG0EhUEqDs4yydvFnG+qoj0MHR8urrLVnxllC76D661hYbUpx/GgT9C9TjCvPR6V3HPghYDXoiCIQgwLQxbhCSgZbOGPZHATxylpKvRdnl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VA8rD67K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VA8rD67K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0CCD1F00A3A;
	Mon,  3 Aug 2026 13:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785763380;
	bh=gktkl34C2tydwsF/RcHMABcCH+dSNdCX7ivQbgvFBu4=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=VA8rD67Kcy9kShcS2AKnYGIBywXEiDvMK2stsWp8kZ2blDXhP9+9RtbQrJNlocGWX
	 CsVNWC51Vu8Vllj88qFr9auaHbDugELR7mdU0G1g/Sf9Nqlw0e4Lm8HEZbNKNnugGk
	 aapeOptNJ7vlUAmFzc1xxWTfGVmpxJUKfJN3JgnG2SPUfFrFYs2+QD0TWrqjJjM7+b
	 IhJwjwFsWXM9VLVZus3XJiNirX3xf/D+7hxC6BJ38Onw6qcJPQCbpMcu0hZi/1Puop
	 gflXdHa6Uh7LK2+YfpGlq2lBjBfot9uWFUNA2kvL7nBzVG1B4mXQQtjC23VcgQwGoU
	 +OQOeHAwwAlbw==
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: darrick.wong@oracle.com, linux-xfs@vger.kernel.org
In-Reply-To: <20260729130121.2281910-1-hch@lst.de>
References: <20260729130121.2281910-1-hch@lst.de>
Subject: Re: [PATCH v2] xfs: check v5 superblock features early
Message-Id: <178576337952.315832.6286350785253803875.b4-ty@kernel.org>
Date: Mon, 03 Aug 2026 15:22:59 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Wed, 29 Jul 2026 15:00:58 +0200, Christoph Hellwig wrote:
> When working on a new features that reuses the existing pad in the
> superblock, I noticed that mounting such a file system on an old kernel
> logs a rather confusing warning:
> 
>     XFS (vdc): Metadir superblock padding fields must be zero.
> 
> This is because we only validate the various feature fields in v5
> superblocks after the common superblock validation helper is called.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: check v5 superblock features early
      commit: eb6b2cc1fc8ad566d746d128a559989ff0bba5cc

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

