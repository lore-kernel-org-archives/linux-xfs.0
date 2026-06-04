Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E43C02D0625
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jun 2026 16:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780591684; cv=none; b=ONjwEu73oqbAmtc4BYoCEOKaXtgas/m0sX3VVPSeS2+JSUplbYRW42ivIw349LlVH0RfWkFA4zgFnT6csFa4LrfmbpdvRTcfKOTa92uv+rBhSI1Fg0vrZGkE3n+63HGxui/G4RZjouBtaTL3sr/grxgupWpZ2ER801KQTR4yzjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780591684; c=relaxed/simple;
	bh=xj+INhQ8uwlf7RGolCOhnGEMLAGa32xyb+evEusySLw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tBMvi+0ydsu6dsgDT/11dcA7m/OV51xsgTHhkST0KS9IIEjSjX0lRpo1hnWktEzY3WzJLcaomtTzQQmaM+9n9ep/8jsjAA1iZzc0gAM5wn4e0SF4rjG5ZCqUeWqS+yLheMbsBRizGqGM8heHs4Nfmjv+ecc79OvtRHg1WiyXgsU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DdzVfMdy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DdzVfMdy"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 759881F00893;
	Thu,  4 Jun 2026 16:48:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780591683;
	bh=We8GWYeacINb6k7Hb0g4/O/miEcOh6WH95+IqZ1IB5A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=DdzVfMdy1A4SY6FXtr3D+OoeHBAK4WLA7SzMRtlvzo1a1AQxmozkpJ0eKpXeBBVJq
	 +dX/tVe9WA16NvILPqlhThdpVWCXMRDOktghU+sDWDP7ourGBB9ofmYXQ0o5iIunoE
	 fIZ907cJOwQOLJuSx9ZOY0zLEpNvLsaf4/ahV16BeVvtzQVi89aZWFjcpPNqXMsTm3
	 VTaG+svNRZjiwf8Rn5JCz9YlYqcOLWQrr5qLZU4RYIkLqEZHEcIysBGjPiwsNXPthi
	 FDnoYYKXT4EwNdQppnIVyURY3faJLj6tiNI9e9uoV5pD+wp1Gvubj+dO9VNPcSVw8Y
	 endPZO8Xb1FNw==
Date: Thu, 4 Jun 2026 09:48:02 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 01/21] xfs_scrub_media_fail: reduce security lockdowns to
 avoid postfix problems
Message-ID: <20260604164802.GW6078@frogsfrogsfrogs>
References: <178055303007.2608728.11678159907532979668.stgit@frogsfrogsfrogs>
 <178055303127.2608728.13759559996989386020.stgit@frogsfrogsfrogs>
 <aiFj_pIHg7SsGPqV@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiFj_pIHg7SsGPqV@aalbersh-thinkpadx1carbongen13.rmtcz.csb>

On Thu, Jun 04, 2026 at 02:16:24PM +0200, Andrey Albershteyn wrote:
> On 2026-06-03 23:04:36, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > The same lockdown logic of commit 9042fcc08eed6a ("xfs_scrub_fail:
> > tighten up the security on the background systemd service") was applied
> > to the media scan failure reporting service.  Therefore, it's also
> > broken on systems that have setgid mailer programs (e.g. postfix).
> > Fix this by applying the same change from commit 15fd6fc686d5ce here
> > too.
> > 
> > Cc: <linux-xfs@vger.kernel.org> # v6.17.0
> > Fixes: 15fd6fc686d5ce ("xfs_scrub_fail: reduce security lockdowns to avoid postfix problems")
> 
> Fixes: 45ec29cfba02 ("xfs_scrub_all: support metadata+media scans of all filesystems")
> This one, no?

Hrm.  45ec is indeed the commit that introduced the overly strict
security posture, but 15fd came after that, and failed to fix the other
two _fail services.  I'm not particularly fussed about which commit the
Fixes trailer points to, but 15fd is a more recent commit.

<shrug>

> Otherwise looks good to me
> Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

Thanks!

--D

> 
> -- 
> - Andrey
> 
