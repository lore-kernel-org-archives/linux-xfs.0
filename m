Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B72C04A3D5B
	for <linux-xfs@vger.kernel.org>; Thu,  8 Oct 2026 13:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791466361; cv=none; b=OeNJjP6j4cZMTQAQgwETX3AGTszDVZxLtmbgwEaML9+np8R9lBlFzdf4bSbgxzkP0f4JHdSWHB1ucLjJRG9BpqC0V0fpmv3YS+k7TnYeqMJHYfodHt6gVfBuvgC7Bb7DtSqwPHiaPfAuIaxCVXjk/LttqWzP1MZO3l25mWTzayg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791466361; c=relaxed/simple;
	bh=HqViE7+JG2PT/pMwsNSGYy1fs/SXCsKx64ihCObO/Ww=;
	h=From:To:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=D2xSMezHp0+PD4jWVgSai/WNPQWEN3q6eWXjhoI1htzFu6B/DgA1980QkmaDPCIQ6jFpD47N3/RxZmuogQ8689ISQN3f2fIqLz0PUQAwcr4aBLnzlknpK00BAhSH4mOJCDieGVwPwX6tQadREfTupFYcOr/Qw1Gqvf7ku8tZT2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xow2ueBz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xow2ueBz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D92221F000FF;
	Thu,  8 Oct 2026 13:32:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791466360;
	bh=945x1kSJsS8XIkl2ZiAge1ou0pal5IkDK7Tqct9SFjI=;
	h=From:To:In-Reply-To:References:Subject:Date;
	b=Xow2ueBz22mMQe5uazwtJyQycfETA/AHdM8iFOVOZs6eN0apqAxUNaNVlkFV7s+Ob
	 ws+78Kz+YCJvDqmkzarVaoAwO3h8PJ2iMBFR6+tgBwxIDa1t/q2az8cvD7CPtGqC+Z
	 tTnPwKjIFLrmFdBuzHI36Ia9KF3xKklPp3x3Cp+k18BaB9pRHja1IdudeO674hfd5D
	 puzbgmwtZVMA+b/LlVwgm96fiJkUO45fGNtgERmthENEh4E6WqHAYZA5DMbqKU9WML
	 KgeUF5AqErshKesTb3F9S0lzYrvlmAWsf3xq4EghTJKHqdjBB4pJvw60vDVxhSRjL3
	 hpkpft8IzQpAQ==
From: Carlos Maiolino <cem@kernel.org>
To: linux-xfs@vger.kernel.org, Brian Foster <bfoster@redhat.com>
In-Reply-To: <20261005120118.229086-1-bfoster@redhat.com>
References: <20261005120118.229086-1-bfoster@redhat.com>
Subject: Re: [PATCH v5 0/4] xfs: fix a couple sparse chunk alloc problems
Message-Id: <179146635956.378461.13766780792954483651.b4-ty@kernel.org>
Date: Thu, 08 Oct 2026 15:32:39 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.3

On Mon, 05 Oct 2026 08:01:14 -0400, Brian Foster wrote:
> Here's v5 of the series to fix the sparse chunk alloc shutdown. The
> original report is available here[1].
> 
> This is mostly a convenience repost of v4 with a variable rename in
> patch 4.
> 
> As a brief overview, the idea here is to rework the freelist calculation
> helper to calculate a min and a max. The min is the historical min AGFL
> requirement for the current allocation. The max is an optional value for
> minleft allocations that perform at least one more allocation in the
> same transaction and thus are susceptible to seeing the min AGFL
> requirement increase due to level increases in the first allocation. The
> specific fix is to carry the delta between the max and min into minleft
> for such allocations so they are either guaranteed for a given AG or
> fail gracefully before dirtying the transaction.
> 
> [...]

Applied to for-next, thanks!

[1/4] xfs: set minleft correctly for sparse chunk errortag allocation
      commit: a9a984a1e6ea1314a3285402fec9cf8e9ef0e355
[2/4] xfs: support additional levels in the agfl minimum calculation
      commit: ad4c2c4630b743c6a3bc1198faaadffd35c94268
[3/4] xfs: calculate AGFL max to support multiple-alloc transactions
      commit: 831f4c28b5dca287422613fe1c1bf4ff1ad13cd1
[4/4] xfs: incorporate increased AGFL min requirement for minleft allocs
      commit: a644af916cf14daba9a4fd6413565c7bd34b5bdc

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

