Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4612B47DFB9
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jun 2026 14:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780583311; cv=none; b=KVP+WqSLDnyCEcze773s8OMHumWtj3ty/qRjqrQGP8o/yqkGcg767iS1WWuhRDi9D4r/YgDeMVMFYUEdmVq6ElOBK1/MUrzKYzeRCuK3oL3EnkxGTVX/ZFDtNHcXy5mxw9IQTlsWuoWsv6ZEmgro6xITXATP1QErY4tzlMRX7pQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780583311; c=relaxed/simple;
	bh=+OGHoFdaAIf28xD/SwsHVS9zFNv/xBw1YyIKtTqMHJ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KlH5tdhKVYgEcYb4xZjWMw0VBTO3+5+8JjbyVvfubPF8P100mVoz1Sw3sHwA7uaUsEdPT5F5WNbQxlIO9b2f3S81m0FmptI9XHmLcDzVzhupJ23PlzUjjE2g6dai7aqKn42PnXsYPbKtwk/RhaFw91nyO5K9qy3gwcMPTrYqqqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gQBPCEo8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gQBPCEo8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00D2A1F00893;
	Thu,  4 Jun 2026 14:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780583310;
	bh=0MCQPmj47/pnNuHg+vK2A2q9MVlfAiGcqXpyPxxnL7o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gQBPCEo8EPz48cNy287r/2UibDQpIj7/yUD/LnsRleLMreXXPElp8i8O7tgQ7hspr
	 1rcOYyMd81Jk+xjkog2919Bz2zsQjC6rgUzPmLr+GDWD8wsNzh7XG92Idg4Y58uF55
	 shL2DKff7VxJAKCkJ0eeSwjT3plXJFW9qmgC1R8NaRWdLhRWspFLXw3BdZ+/gQ5ygo
	 xa21kpabChX4HbJWIsLBiox3wyC+CPeUrc0XpovPls+8LrN87lz+qPBZu8NuAOVxGY
	 LpVW+YPlgJPNxsw3ajnsYruiHyEGeUHxIr0R8sybD2JJ7/rCY5R/B5+P2ZkJE4ZeLc
	 ltDCqU9We+3Fw==
Date: Thu, 4 Jun 2026 16:28:26 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 18/21] xfs_scrub: fix inverted return value from ptvar_get
Message-ID: <aiGLePfjKCgrZqLH@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <178055303007.2608728.11678159907532979668.stgit@frogsfrogsfrogs>
 <178055303439.2608728.1431031580963210398.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178055303439.2608728.1431031580963210398.stgit@frogsfrogsfrogs>

On 2026-06-03 23:09:00, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Codex noticed that this callsite to ptvar_get got the sign of the error
> code backwards, unlike all the other callers.  Fix that.
> 
> Cc: <linux-xfs@vger.kernel.org> # v6.10.0
> Fixes: 4f4d99615d2377 ("xfs_scrub: improve thread scheduling repair items during phase 4")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey
