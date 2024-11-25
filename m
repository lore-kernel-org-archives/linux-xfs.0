Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0449186E59
	for <linux-xfs@vger.kernel.org>; Mon, 25 Nov 2024 11:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732535861; cv=none; b=uMHb1WwJe4Kp8EW4opgBV6/fQfocOfCZtq3jlZRUrcndTZJS6evi3sFXFR3O2mzf+2wid2yexA1JoCk6KCQuZEbwe4rlykU8XZoLn0ReFyCkNBpphuQ3/olj9zCsTNaZaJbFJukm6CjqnXP4PBza0IYy5eGk7bOvxQvcags5ED8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732535861; c=relaxed/simple;
	bh=MGp1l142g+CXPR/e50e7mS9BI7MbxqdXSOHtRHPjpf8=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=XwLB3FXhMilVdw/yFztZyi6yiDvxCQBQUzei8EGzNt5fonLR+Ng0RIQQVIZkkYhjGB7emm+kAYYpSlrm8WEDhNyB9mRt8AcAOB2nt6I/d8WNehRbe5q5Mr1UY7DleZamXnTSmWOrCwT4ihFs0p7rjeqMRgi+kIpOThaFcEoiIh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RPXB+D2h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RPXB+D2h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 065C1C4CECE;
	Mon, 25 Nov 2024 11:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732535861;
	bh=MGp1l142g+CXPR/e50e7mS9BI7MbxqdXSOHtRHPjpf8=;
	h=From:To:In-Reply-To:References:Subject:Date:From;
	b=RPXB+D2hctC75m39QqVdEe9G65eMHJTSI/8H89aj2s0FDZ95Uwi0xI2miZduskA6S
	 fcB2h6AHiAug257Kkcnl8ksKKZNWtVF66pb9WSy+D/eYl8tHJQXYwzAG8lStVLehhB
	 W+PwAuXJJFAweyHb9lNoq9rO1nvaMuXnPu72Sdhdhg7zoLxAMUKFoDzwLkE4bbr+5D
	 GFMb8IdXpD98Ne2KPvJH52NyFmcLM877OH9fGrBz1/hwuERyiAsicTVNQWK1ugodsd
	 q67iHsehtBp6j8QcM6HTpC20nSVwbjTXstXcxjotUpXig4oiVEiE4dKqVYVn/ksLr/
	 RPqaOwOemr7uQ==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, Dave Chinner <david@fromorbit.com>
In-Reply-To: <20241112221920.1105007-1-david@fromorbit.com>
References: <20241112221920.1105007-1-david@fromorbit.com>
Subject: Re: [PATCH 0/3] xfs: miscellaneous bug fixes
Message-Id: <173253585964.514512.8381852317349250817.b4-ty@kernel.org>
Date: Mon, 25 Nov 2024 12:57:39 +0100
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Wed, 13 Nov 2024 09:05:13 +1100, Dave Chinner wrote:
> These are three bug fixes for recent issues.
> 
> The first is a repost of the original patch to prevent allocation of
> sparse inode clusters at the end of an unaligned runt AG. There
> was plenty of discussion over that fix here:
> 
> https://lore.kernel.org/linux-xfs/20241024025142.4082218-1-david@fromorbit.com/
> 
> [...]

Applied to for-next, thanks!

[1/3] xfs: fix sparse inode limits on runt AG
      commit: 13325333582d4820d39b9e8f63d6a54e745585d9
[2/3] xfs: delalloc and quota softlimit timers are incoherent
      commit: c9c293240e4351aa2678186cd88a08141fc6ce9e
[3/3] xfs: prevent mount and log shutdown race
      commit: a8581099604dfa609a34a3fac8ef5af0d300d2c1

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

