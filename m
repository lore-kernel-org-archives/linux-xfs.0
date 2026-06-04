Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4091514B977
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jun 2026 12:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780575693; cv=none; b=JvONEiN/Q4EJTAuZgiDgcAh1jPV2qf2aBe3YDVMlLPpFUAAlMlzvJxNUoUUWKO0ac/XpOucSw0KWxY2wTSkF5LJc1RzZH5WACo+Yed7xOc52UC8KlM7++0OEJJ6fQdTbxmGXUfIP/2c615DguZLKzl4elgiMNnfqsTu78ES7oYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780575693; c=relaxed/simple;
	bh=OEiPhDgmD5I2mcdEk2EhgS1UWye5OriylsX4+czZz/A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d9BNLQQNqCe+FItIZyD0XyTK0WCWNO6XA0MxBoYK51N5JNfUf8YgfUTD6FJGvogwOkDntee6NQPhE6VS3Vy9aFNPhMd42cpx0pygfpGu2beJbcDp3xMdDuj1I8JC2ioqzW9sGIhqd52UMnoKhIHERpeWEmcWUo4LxmueEsg/JPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e+jDx8CR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e+jDx8CR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 091071F00893;
	Thu,  4 Jun 2026 12:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780575692;
	bh=z6BSMea3UmHEMQibcFX/v5OPCP8W124h7aZ105X2Rh8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=e+jDx8CReV5+7Q8bEKIj5q1HtZW/WaZsLbJK+7pTlE9sTMU5Qk/7GEfB1kygj7hfR
	 AqJcs0DbqaWnGHkSPbWFt29UG2vEFv+rihegF8BWNLyei+oMed2p8C1U0Hb7askqUk
	 0r3dclPM5kOHB85EWZs7r4vL5IMK8dkXJXRASuMZp6OSScC1YqCyW/b/FCVGMxyox0
	 EDWU+PAXpjN0LoICz7QrROh5MPACUvqfnBcHT1jpQJryNpdkgEr9gGKiHKxxM3O8Z3
	 wGZ9xnGvEu2XPPNtLIpNOIncCSS9QXfZiauKTOjFNWICVGmn1+pGkVJ4xZlK+4XUPq
	 D9MQ0F3cBMQGw==
Date: Thu, 4 Jun 2026 14:21:28 +0200
From: Andrey Albershteyn <aalbersh@kernel.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 03/21] xfs_scrub_all_fail: reduce security lockdowns to
 avoid postfix problems
Message-ID: <aiFtguYms2vPe5Wi@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
References: <178055303007.2608728.11678159907532979668.stgit@frogsfrogsfrogs>
 <178055303164.2608728.5936112369383781102.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178055303164.2608728.5936112369383781102.stgit@frogsfrogsfrogs>

On 2026-06-03 23:05:07, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> The same lockdown logic of commit 9042fcc08eed6a ("xfs_scrub_fail:
> tighten up the security on the background systemd service") was applied
> to the media scan failure reporting service.  Therefore, it's also
> broken on systems that have setgid mailer programs (e.g. postfix).  Fix
> this by applying the same change from commit 15fd6fc686d5ce here too.
> 
> While we're at it, put this service in the background scrub slice for
> resource control.
> 
> Cc: <linux-xfs@vger.kernel.org> # v6.17.0
> Fixes: 15fd6fc686d5ce ("xfs_scrub_fail: reduce security lockdowns to avoid postfix problems")

Fixes: e040916f649f ("xfs_scrub_all: failure reporting for the xfs_scrub_all job")
?

Otherwise, looks good to me
Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

-- 
- Andrey
