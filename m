Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1F6B22FF2B;
	Wed, 16 Apr 2025 08:45:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744793123; cv=none; b=Cgec3eE+XMtuyUmbNiK6AD33DeJ6jLXqv9gp24D0aV9q+RL/kpUBTRqzkQi7SGbw4Z1zg17glsBoMMY8jJb0lJxaHXGmbB7y/KMslHVe8LZfsGNUuwkaS/+DxvQNA1ssJ0jZZ3+LD5Wf6rZlMQheiWDi8oTQObDHbCHbQ3r0k0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744793123; c=relaxed/simple;
	bh=DOjBHuLbp0F/GopqrJRq4K3bsCmFQZ83Y/V+5o2ppjw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=nPk7VCMpWwKI5nOh8M3Pe26HBB+y1WH2jzA6mAkEcsTx3XkWBDoQz5dn3h1Ns3piFBX0ajVAiz+eo7zZtLRQfd4ScHuLBa4jTdISFK2edo197jgymTfQcFYh2hGjERKnJjZeWnE5bBnln5d/LEAUg7X3bOl0TPbwk4aimiOsOw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mMGCfZHZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mMGCfZHZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8286C4CEED;
	Wed, 16 Apr 2025 08:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744793122;
	bh=DOjBHuLbp0F/GopqrJRq4K3bsCmFQZ83Y/V+5o2ppjw=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=mMGCfZHZBJMxbmz5JP24nA3fputIO+c0eNwQbvFdAxAKnSW2GepNByiNtopKYqBaH
	 AV9POLQTkJbOZYAow3iC1v+rt7k14E9atM12JkF8qta2+Ur6iRltvZxRWAREfZHXY3
	 7OZAPdArHN5LF6AGb+dCwAFf3vO/9h1qCN+c8YRffy+nBQY++/7ylNR/VK9/raPqd8
	 UhN0v/OKefZcJ+zkj2AC9iC8zbqHy2Sht4mqjFxjpOrZ4UixD+2t4S0qO79Paho0T7
	 4dcQrp34h9onrKa4rFC6qjc+tyKRNHS2MTFZY/LK3JKipsClGo2gvy7aXFB8wEglg3
	 guztBDvv2FuNQ==
From: Carlos Maiolino <cem@kernel.org>
To: Dave Chinner <david@fromorbit.com>, 
 "Darrick J . Wong" <djwong@kernel.org>, 
 Hans Holmberg <Hans.Holmberg@wdc.com>
Cc: hch <hch@lst.de>, linux-xfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20250325091007.24070-1-hans.holmberg@wdc.com>
References: <20250325091007.24070-1-hans.holmberg@wdc.com>
Subject: Re: [PATCH] xfs: add tunable threshold parameter for triggering
 zone GC
Message-Id: <174479312058.188145.11238177508667153075.b4-ty@kernel.org>
Date: Wed, 16 Apr 2025 10:45:20 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Tue, 25 Mar 2025 09:10:49 +0000, Hans Holmberg wrote:
> Presently we start garbage collection late - when we start running
> out of free zones to backfill max_open_zones. This is a reasonable
> default as it minimizes write amplification. The longer we wait,
> the more blocks are invalidated and reclaim cost less in terms
> of blocks to relocate.
> 
> Starting this late however introduces a risk of GC being outcompeted
> by user writes. If GC can't keep up, user writes will be forced to
> wait for free zones with high tail latencies as a result.
> 
> [...]

Applied to for-next, thanks!

[1/1] xfs: add tunable threshold parameter for triggering zone GC
      commit: 845abeb1f06a8a44e21314460eeb14cddfca52cc

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

