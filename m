Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E80848B380
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jun 2026 14:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780582744; cv=none; b=AH5VSSa5Mj71aIeqLW/5L8VyBGICS4oE30oqRtx+ybUEtzN179BkpEyZTLfNZM7dZaQ9WDqKfkOViVZJ8QVkufkWi+SXa1Dyghj2YyeSiSnLRLxCEeFpAMkVI/YSuIFbVMPnkTJ48fFzVlAzkQ+TZiuK7t/FA09w09tLb1vGgEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780582744; c=relaxed/simple;
	bh=XHzatx+BEX3ATyqVWccfdHYDE5QE4RgMiQ/9Ud653O4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SDbrj7JEGIl/PnXdhBGrRh4p/1ZSTCbr0Fz1QmVF45QMltmTk5jFldcC5mFgyWUgu2JuC6mj0gk2NXpl/crN0M41cSRaforPJDfVKfUfxJMG8yxxvIVtL4j1Vo89AX1IFKuYhjYzsMQsnKL4M4Z7TJKfL7HPS91RdJL+x7LwEh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f9+GU9pD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f9+GU9pD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 204D91F00893;
	Thu,  4 Jun 2026 14:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780582743;
	bh=J5sBclCxpRD+D7qP3Bt13+77z5a/bxwy4s+9YEytF1w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=f9+GU9pDbQWVTWUJSEChUjU1Y6eomC+AANMsk5vVA0PclrFO/AyZphEAysQvvAyRy
	 2lKF0Gn178xqFgd5ne9hYOF1qlBGWjwKjAQM4NhnHmFl6dW9NDpRaExZoAhGr3Tehv
	 eTgeesA/coYW1/3K2KHLF7Ver/LZOgPRUUlDNxELas5Dwz/jY9LzXAzPooXrtkICTQ
	 djYp+6OQbAUjy9gY6x4JWUq5JRNDUxXsVgyqmnZ53xLlC7rEM/nEfbJdI3nq6Olpq0
	 k8z5D8N5BA8rv3Mav5K27ic+itePBIzjvEn+sV+KDxe+xGvOCBc/VvQH6qfV2QzzW/
	 ZmCETs+jhPG6w==
Date: Thu, 4 Jun 2026 16:19:00 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 16/21] xfs_scrub: don't continue with phase1 if
 autofsck=none
Message-ID: <aiGJPketuxngz7zi@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <178055303007.2608728.11678159907532979668.stgit@frogsfrogsfrogs>
 <178055303402.2608728.10846299600136218647.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178055303402.2608728.10846299600136218647.stgit@frogsfrogsfrogs>

On 2026-06-03 23:08:29, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If xfs_scrub was started with -o autofsck and the filesystem's autofsck
> property says not to run xfs_scrub, we should exit phase 1 early so that
> the rest of the validation checks don't need to run.  Codex points out
> that the current code can fail pointlessly in this manner.
> 
> Cc: <linux-xfs@vger.kernel.org> # v6.10.0
> Fixes: 9451b5ee0d0d2d ("xfs_scrub: allow sysadmin to control background scrubs")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>

Looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey
