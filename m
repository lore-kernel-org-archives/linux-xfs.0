Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF738522698
	for <linux-xfs@vger.kernel.org>; Tue, 22 Sep 2026 23:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790119574; cv=none; b=YI+TERRZ1HytBAdpC9Pkhg9ph2L2iseXQLmuzjC/0KB2AQREShmIC1+bj1l4crRfTnrX42iFnjWI2TZYE2EYE44WDWsUdHhm5L7OdmUB710F4DhnNENEeP+aNx/4SnkuFXpZCP+Y85gEHpf90Ksz5VcOR+8SppCriOIlfoRtOhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790119574; c=relaxed/simple;
	bh=yI+lYpZFV+xB5dipDfH01djzO5zjFRUXbiS4Y2WbQsw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bHDhfuZri3DPgGOALYBzWN9wNfaJYS1/eMaQGF06wVG7fz0u1lAbu/BrMij6X/9O5WnC7+whR3XG8sy//pFZG3QywZJ66As/ljoVGbFS+DYYgrPcvWlAx5Z2w95rhIW/G4GF7FrBvYtnA3ljhLMG8RDDxyuq4f5liyaglee9Wiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W8ZkR55s; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W8ZkR55s"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 478B91F000FF;
	Tue, 22 Sep 2026 23:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790119567;
	bh=Pv7azh8K3cg6p+lBRnZfGjAbaatxIrORLs5K6YR54vc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=W8ZkR55s8fmeUK0QlqC5CEEd4Fr9hv2Ces1nXTUHCzgXTmb6ef0+09YEKTCUilvBW
	 EGR9Nbyb/kZ1YOv7Q47/DJoidO/S3CQr4y+MxTDu5R5saLbRsUCnHcYhCEbgdo4M9D
	 nCC99gJHWoVw9B4RebONZwmbv8moO/xeRwNklCkhi5zgo1zsb7D+NCQSp63srPxfBX
	 hfW4e/G1irkS9b+gTqpaJTzEbwbeacXXpxPSJtMUolkQDRu55eU0u+tNC5oo6oxdje
	 ybH6BuOtC2Ks2uhSgKCkCz5Kpug+QVAKufo1uCavHlaxb2lRQzXnmSmBg5TbAF63N5
	 h1fzApvMQr7Ug==
Date: Tue, 22 Sep 2026 16:26:06 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs@vger.kernel.org, cem@kernel.org, hch@infradead.org
Subject: Re: [PATCH 0/2] xfs: share rmap & refcount btree ops
Message-ID: <20260922232606.GB2705364@frogsfrogsfrogs>
References: <20260922231845.3266784-1-sandeen@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260922231845.3266784-1-sandeen@redhat.com>

On Tue, Sep 22, 2026 at 06:17:07PM -0500, Eric Sandeen wrote:
> The first patch should be what I sent before, just combinediff'd.
> 
> The second patch does the same for the refcount btrees as suggested.
> 
> I didn't keep prior RVBs since it's not the same patch any more...
> 
> This elimiates almost 250 LOC.

Offhand that looks fine to me!
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D

