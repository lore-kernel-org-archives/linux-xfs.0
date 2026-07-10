Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3362630567C;
	Fri, 10 Jul 2026 21:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783720412; cv=none; b=bUx5t9PoJwxzJa77zaPrOv1jB78VPsgdlMSNrmDT2e1COjuZadWep+BFeuc5/tXV6qFIqz1wutQ/nu7usZlcPpivO15sPDiHm+N9Uyobb/2QfRIfrX5/zQ9XH1gKKsQgjuNK+HWYGJALLw6xfV+Yyu9nTpN1s4FZRd+fufYkip0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783720412; c=relaxed/simple;
	bh=N7LJiaCHFsUsGXKi+IsqyL1nF7fcEbn8+AazIiPJzCk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=r5X0ww8+6pTT5yDIIAfFPY/eayjnjyrylXdMtR2Mo7a+aSIygIoBQxNziBEI/G1jF39FhZ/dre78Frnt5nNDsdziPGF5VQBvHosz9tRzHsSRqssrj8IFCWHkb/3FiLzn648Citx2YYWrR12QJlq7cXdJfzIaL/L+sAjPcGymUJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ortp2wtX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ortp2wtX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDE381F00ACA;
	Fri, 10 Jul 2026 21:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783720410;
	bh=bacwDZsOZFP+i+Bl8YQK08roVp2/1oQDKcRl9Y/BMBg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ortp2wtX2bNnnSzSOao5Jx2OTEF/Tk5MQuajBlAyNVNLoJRfnhIv0TUdBRCZmc6gE
	 p/RnFzOhdxUubLz1o0YPqF8KL6o0kNnl6SG0X6306GtlCKcQ98dOce8LOBJ2xSzDAC
	 vFf3+DbYtoeliLAb3vMsUgVTxvP3ngPahCkKGi8rro3SEhjjFPu19pS9Uw1YWKouCZ
	 pkCXlLQQr+LbKlelipVh1MOzN7wOf0lpJ0Fp3Uqmzd0v6BU0cbQ9T3CevbEsn616B3
	 zguA0fKb8ZrXrzWNUGQqScryx4RGO7hHhrHIuy5RQV3+RuXP+zhUz/tEJWmUMT1a+2
	 L/zf83kawyWzA==
Date: Fri, 10 Jul 2026 17:53:28 -0400
From: Eric Biggers <ebiggers@kernel.org>
To: Keith Busch <kbusch@meta.com>
Cc: linux-block@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	axboe@kernel.dk, brauner@kernel.org, aalbersh@kernel.org,
	jack@suse.cz, tytso@mit.edu, Keith Busch <kbusch@kernel.org>,
	jaegeuk@kernel.org, cem@kernel.org
Subject: Re: [f2fs-dev] [PATCHv2 0/5] direct-io file extended attributes
Message-ID: <20260710215328.GE1911@quark>
References: <20260710210646.3576365-1-kbusch@meta.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710210646.3576365-1-kbusch@meta.com>

On Fri, Jul 10, 2026 at 02:06:41PM -0700, Keith Busch via Linux-f2fs-devel wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> The attributes reported through statx are incomplete for applications to
> fully know exactly how IO construction is valid or not. The statx call
> can report minimum memory alignment and total granularity, but it
> doesn't show the underlying gap boundary requirements or max segments
> per granule.
> 
> This series adds the minimum to the extended file attributes through
> file_getattr. I hear this is the preferred interface for reporting such
> things over adding more fields to statx. In order to get everything
> under a single syscall, some of the attributes are duplicated from
> statx.

Okay, in v2 we at least now know that the existing statx UAPI was
considered.  Could you give a specific real-world example (with the
actual values of each parameter) where it's not sufficient?  Without
that there isn't really any way to evaluate this proposal.

- Eric
