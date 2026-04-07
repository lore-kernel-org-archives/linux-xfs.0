Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B698175A9F;
	Tue,  7 Apr 2026 13:38:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775569098; cv=none; b=uRbqi9C9DKgbfdvCaDgm25riaAh7BegUwwa1mCK3F5aJAOrMHCgdRZL1d2w9vUUfHa153wBMqfuQdAnfePH4NW7a8ryv6YxTJw/0GK2eBcRYLvrLrzYxoe0q02SfGpM3bJ3SI0bTlTIebD9/PmM/86N/OqcIkh7ElFbsu8HOjCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775569098; c=relaxed/simple;
	bh=Hbjga5qwoquqvi9hkET1frOTSMfaMJD9dcHEZZ0EWQA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=Xi9EU1Ilhvz4AL0jORldY6CZ5hGhV8oONuuTxhBChoL/yu2+dH9WZlthXfknkMYNCyYTHLdwmNfC12UOFHOx4pM4S+YmJ46RW2H8K9XzS8Xv6FBlCDyJMzub/pJq2QMXDcdEuwLfOYv9x6UPs3mlCW0Zs6QBdEBC8BVKbNQewkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h9+2txS2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h9+2txS2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C41AC116C6;
	Tue,  7 Apr 2026 13:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775569097;
	bh=Hbjga5qwoquqvi9hkET1frOTSMfaMJD9dcHEZZ0EWQA=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
	b=h9+2txS2FBbJ38Qax8nNs4A5Lc19gBPKPmuCeQBfdrp0APSMM48fQzBSkfghalD9I
	 /SFTUZUAXQCwPNKHdILg4CYbeQuKoX150rcvqlEIiZwtykf/SQGU3mz5wD1N0SCatU
	 5yPKyVH8t7gCH3VjJtdrauTXvxwdUGME3k0PBG6GK1ecsv2oZlSsyfj/0z8fJkjdDG
	 Qbt0oo5KzEh796AbOHrqBiE050mcT9iISz9L1/nvGgaJo9M3IHmGMZVwDBSJDH1NbA
	 3oEiXqE393valZPHNBV4umPX1pP940GFCUuCYfbIR74UrJiOMk8yJc55gXRgzW63q1
	 foKDunheqC0dg==
From: Carlos Maiolino <cem@kernel.org>
To: Yuto Ohnuki <ytohnuki@amazon.com>
Cc: Dave Chinner <dchinner@redhat.com>, 
 "Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <20260328173407.43057-4-ytohnuki@amazon.com>
References: <20260328173407.43057-4-ytohnuki@amazon.com>
Subject: Re: [PATCH 0/2] xfs: fix potential integer overflow in sort
 comparators
Message-Id: <177556909626.105112.6776553570990598931.b4-ty@kernel.org>
Date: Tue, 07 Apr 2026 15:38:16 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2

On Sat, 28 Mar 2026 17:34:08 +0000, Yuto Ohnuki wrote:
> Several sort comparators in XFS subtract two uint32_t values and
> return the result as int, which can overflow when the difference
> exceeds INT_MAX.
> 
> Use cmp_int() instead, as was done in commit 362c49098086
> ("xfs: fix integer overflow in bmap intent sort comparator").
> 
> [...]

Applied to for-next, thanks!

[1/2] xfs: fix integer overflow in deferred intent sort comparators
      commit: 59e586d7dc7813910abe20a8281bbc3f1360e08e
[2/2] xfs: fix integer overflow in busy extent sort comparator
      commit: 553a13e2076d64774910d597977a17022625763d

Best regards,
-- 
Carlos Maiolino <cem@kernel.org>

