Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B82420ADF8
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jun 2026 12:25:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780575960; cv=none; b=PkdT+DeoOROou8kzEYRsksUrWOOAncF2OnB8fHwWpor4gK9f4gnV+K52qpKJ+i4dbk4mVXGZOhzQBwbwLbGdCGMUlFuSXz9ZGcoFCnRiO2hYc1UEIlaO4wELb+Wk06xFBlJ7U1rkEnsWO14yPBTrcvObSTv1+7S/fqa4K4P/4VU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780575960; c=relaxed/simple;
	bh=u2zJcFOfnen44VdPlX8jaHR2xzH/R9vAhcPPoYg2FUM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bvX5XEe0RfHrw2eKZQXvo8RWtD3j4sxA34oABCoe/tMnm+m8FFXZOnxA+0VweLYwALbm+wQtYmILLaXQruv4AAzPTSUioOa9yJJV0xcRNpjV3LAfIRdWaRaKZT3zpuUUsbyWSrU9rls1FSAK7HMiiM0MP37RNh2SxKg5hNtgXPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W+0Tg7Be; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W+0Tg7Be"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 608AD1F00893;
	Thu,  4 Jun 2026 12:25:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780575959;
	bh=6kYjDhdYKYQGn638T2RliIuWnLg+rWnSf5Y35NT1jUM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=W+0Tg7BemQKnfP9LdM7iDXAiZ1hJaOuIlIZt775UidS2Um3Q9/APhoE88SGu3OECz
	 Gvz/Jfgykm1OUrv0SV1XEl8Cvq+o0v4bL7NiG1RfoucSFdqxiZLR/VrMyB6lb5de8z
	 mqaZc0YQZmfmiU7yVAw0KmK/gxm8u9+pv02/6En0spRDF02vXrFgGbLYqiFXHYKC98
	 mjvUkXEdKEp+DBtAmejBHrm+JS4kQn8f1fD5jeV3Nxwirptv0ba7tBsWf6zUsca+tX
	 cRLRcZnfezJcxrD6e/Ay0lnfJ2yaWg/mkegQA7MRoUyezMrGQ47MtgjrHYTaM6WCo/
	 m2zxqqjiHKv5w==
Date: Thu, 4 Jun 2026 14:25:56 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 06/21] xfs_scrub: fix integer overflows
Message-ID: <aiFuvhASAf69xGC8@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <178055303007.2608728.11678159907532979668.stgit@frogsfrogsfrogs>
 <178055303219.2608728.7060540682362288655.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178055303219.2608728.7060540682362288655.stgit@frogsfrogsfrogs>

On 2026-06-03 23:05:54, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> agblocks is a 32-bit variable, which means that on a filesystem with a
> large AG block count (e.g. 2^31 blocks on a 1k fsblock fs) the
> multiplication with 95 could cause an integer overflow.  Let's just do
> 64-bit arithmetic here.  Codex found this.
> 
> Cc: <linux-xfs@vger.kernel.org> # v6.10.0
> Fixes: 34bed605490f93 ("xfs_scrub: tune fstrim minlen parameter based on free space histograms")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey
