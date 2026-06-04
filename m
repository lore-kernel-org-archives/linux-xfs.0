Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF79F42315B
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jun 2026 14:24:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780583097; cv=none; b=WwhEMUXfzoKqI3k90qBLnjsmTrALqrga5omZMFDa4Wy0r9/LJBCWG3OvkuDcoUE/dc1yHGSGosTlbeGJFc8rloERl/CjjmOY6qlisXQ/cl9PbGB95uO8JRhCiVCdEm4/28cXCACP9SYbfBIMc9ubSeH8O6slBAosUFB9OeQNAU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780583097; c=relaxed/simple;
	bh=NLNM4l2Xz9An63VVNQ4xqaxJrJC3rdHMWNYPlGjERkU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T5hdLs0ynyp9CDwXXRuZbi4hGdl0QE1FK4zxRLBn8ESLOvGfs/bkoXkvME3OOsnOWHOPG+AFNXU7t7LAAGlpfxT+1WqpY6I9vvapwOgmMbJBtamq8y8lgHbPsCwspRhdqSiAO9VDUHKijEh0P2lyDrOVquZdsJl5nX1epvGo/Qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SV6ZmJ7z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SV6ZmJ7z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 637021F00893;
	Thu,  4 Jun 2026 14:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780583096;
	bh=Ts6JWqG/iqZZF12vquHvGWZy63umA+gOwvM7VdyAZ20=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=SV6ZmJ7zg9y+vheFa5xmqsov+oPj6zGbOx/HfxDMR7ByKaJLjj+RsFfbZ7q6zcmuP
	 njpkXTVcLjimKFz9DNo/GiwPdg50QhgsC4NZky7Tr1kYLnIdukbnHx7WytyV2jJyKz
	 MUT3S4VyTQc3hDxivuvyT6zHHizslCtiMq9H1H9bAb4q/KKB/alh34obPABIcWTdtj
	 GtsUX/N1S26H8Jkqjf5rTp/MwxkEqWhXsYWnIwRih+cXVuqNJC7MAHDE1JQUGvgZT1
	 yq9mHXJO3cgZTfj2EBEwzr1yTEg5Rc4KelwOPOU/cf57Ttwke8b0kyJrcPcdB7+64T
	 Le7ea6Y/B9v2w==
Date: Thu, 4 Jun 2026 16:24:53 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 17/21] xfs_scrub: don't crash trying to complain about
 clean health
Message-ID: <aiGKpj0jmCvbks2S@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <178055303007.2608728.11678159907532979668.stgit@frogsfrogsfrogs>
 <178055303420.2608728.4807386578991249703.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178055303420.2608728.4807386578991249703.stgit@frogsfrogsfrogs>

On 2026-06-03 23:08:45, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Codex points out that the str_info call in report_to_kernel can crash
> because of the null argument.  This whole callsite is fubar because
> the third argument is supposed to be a format string, and it's supposed
> to print the mountpoint too.  Fix all this.
> 
> Cc: <linux-xfs@vger.kernel.org> # v6.9.0
> Fixes: 2025aa7a29e60c ("xfs_scrub: upload clean bills of health")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey
