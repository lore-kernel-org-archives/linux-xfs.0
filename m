Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E974218EB0
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jun 2026 12:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780575789; cv=none; b=pNIc2WZ0VLu74HnwelIhG+Uf6mhA+vwWQ95B83mAeL/A+SwN5yPHQRNFHeBD7EA5g9ttK3vey1ayvM1QqX4aEke9PaRGrDx1cSgtFDWw6q2TBaiDVz9C6Yrx7doy385z3RtzNSuP6KDxA7N0JksaHWBmamSySu2c4+jpW6qi4+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780575789; c=relaxed/simple;
	bh=ccdUv0jKhaHjiXxdUELEdb15W2JJZMZdwseJH/IPOsQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MgU//VKTtFvIya8RcxWFjid2zSob415Wcw01lmtkgTvJxMdrasdhBQBTifFvbUT7Jbyx76IaR7xkTG8/tPe1eNTHtosdARpKa5MvV/t10k7WeJw0R/GpnRrwozskq875eSi/VVsoTHD53WLbCNQ3UICbjA9l5HCT0qYegDYYrZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Za6QNk4b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Za6QNk4b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 973F01F00893;
	Thu,  4 Jun 2026 12:23:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780575788;
	bh=91edjxA78Zqe+hxtMmgh2eteeUIssRaAi+EQObEoGLI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Za6QNk4b0D1Y4SbdB4+OjvHMdhNaHNMvvS3zjSpy+sBe62a12pWb+nSjN/U45Yq66
	 8CSDQqaCHUam6lEeXjHHjsisFZEC8UvxIlLVH5NL0XbJXBC67htkxv95snhvVsN/83
	 9iYxNPt3SzpqrwdORB/T5JumbQnj7f9zNvv+c6ufily0YPSSwfRRohyGtLuSyZeLmH
	 innRoWYmZxGDxwSx0pfxFDCyrTOhwUTs27/OqiPq/kZBPoBSoBtz4k1i7wayufsB1k
	 QG+XRu6MKBZy9WtJ6B7i8upcW+q/IwKJIjSZjzWPirvxtYKor1By22pMWMN0LLqrG/
	 J+AVr03+prkeg==
Date: Thu, 4 Jun 2026 14:23:05 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 04/21] xfs_scrub_fail: send content headers for
 xfs_scrub_all failures
Message-ID: <aiFuDVlGdsT6TJUQ@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <178055303007.2608728.11678159907532979668.stgit@frogsfrogsfrogs>
 <178055303183.2608728.11213800137735900500.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178055303183.2608728.11213800137735900500.stgit@frogsfrogsfrogs>

On 2026-06-03 23:05:23, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Codex noted that fail_mail() doesn't include the same content headers
> that fail_mail_mntpoint() does.  As a result, utf8 encoded content for
> xfs_scrub_all failures might not be interpreted correctly by mailers,
> whereas they will for xfs_scrub@ failures.  Fix this by emitting C-T-E
> and C-T headers so that mailers will see this as 8-bit encoded utf8.
> 
> One could argue that the choice of utf8 is actually system-dependent and
> ought to added by the MTA, etc. but I suspect that 99.9% of Linux
> systems out there are using utf8 and not some other legacy encoding.
> 
> Cc: <linux-xfs@vger.kernel.org> # v6.10.0
> Fixes: e040916f649f71 ("xfs_scrub_all: failure reporting for the xfs_scrub_all job")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey
