Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48D2348BD45
	for <linux-xfs@vger.kernel.org>; Thu,  4 Jun 2026 16:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780591791; cv=none; b=JkpVB7/RDytQpxzmMujplWb4cOPYv7gVaDIBUpcAsB3FhKysd2BO1gyuhKwNUuTlIue19anBf6O0m0IQU5JQvB8kz46mbw1jCHRJrhj4irKSCmd3ANxyvCUBaMCIH+RgT1HU5qnK3D1KmYd/BzK8S/Dj8RdpM1yzpOds9j5R0Vg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780591791; c=relaxed/simple;
	bh=9DlGJgbJHZ2hmCMnHgbkJPtKHxeY9HFNThxy/LQOW6U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mY4MxF+SzW8oKho5IHMKczPiDI+di9gjFlPj5nbKCwKBcdzyW2e6fagNBx/xdF8v7Wdhs0ac8gDhPMgCFzcnmcCSVNNvk5+9ApX4Kvo4PTyMx6p4eZeQSDb3WSMdmqauWMep9fgxLw17UXOiA0aPmXSYzflzyM4UZjvYuW+hgf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O5ClxAAg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O5ClxAAg"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id DBE691F0089B;
	Thu,  4 Jun 2026 16:49:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780591790;
	bh=dxS/Vyw+/knV/yVkCdNODJcXFLXdMch6Wo/oVa9i0eQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=O5ClxAAg/jfEuiRbAR0J81uF02vIJ0jvxACl/wOltCj2xPLXZGoqu5elhQw1DT7Vb
	 BsNm+nVhQ4mRVLLsj69zG3dtjfn/nVRJ5SVQGYWIkHfuH/DFp1dzx+AIUeIFwdQBjv
	 2appSB2iOeYD8XyvXdjb+oWRFZkiueqbaTlUvhrsBqfTcY9rP/pNq/9ZadXY0bBjld
	 EK2bUtzIGp12JbTCdW+nyfI+uK/YALZGpKN//WUiCW1wyds2UgXaPwQoCo3ZP+YlFr
	 3TBMfvut4Wpr6PPtusn3zaDgWoIV9jUr/Dkxdpb0XbEtvUuKGJLhwEa5pGbANozQnP
	 b8rEKCjP8HUsg==
Date: Thu, 4 Jun 2026 09:49:49 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 03/21] xfs_scrub_all_fail: reduce security lockdowns to
 avoid postfix problems
Message-ID: <20260604164949.GX6078@frogsfrogsfrogs>
References: <178055303007.2608728.11678159907532979668.stgit@frogsfrogsfrogs>
 <178055303164.2608728.5936112369383781102.stgit@frogsfrogsfrogs>
 <aiFtguYms2vPe5Wi@aalbersh-thinkpadx1carbongen13.rmtcz.csb>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiFtguYms2vPe5Wi@aalbersh-thinkpadx1carbongen13.rmtcz.csb>

On Thu, Jun 04, 2026 at 02:21:28PM +0200, Andrey Albershteyn wrote:
> On 2026-06-03 23:05:07, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > The same lockdown logic of commit 9042fcc08eed6a ("xfs_scrub_fail:
> > tighten up the security on the background systemd service") was applied
> > to the media scan failure reporting service.  Therefore, it's also
> > broken on systems that have setgid mailer programs (e.g. postfix).  Fix
> > this by applying the same change from commit 15fd6fc686d5ce here too.
> > 
> > While we're at it, put this service in the background scrub slice for
> > resource control.
> > 
> > Cc: <linux-xfs@vger.kernel.org> # v6.17.0
> > Fixes: 15fd6fc686d5ce ("xfs_scrub_fail: reduce security lockdowns to avoid postfix problems")
> 
> Fixes: e040916f649f ("xfs_scrub_all: failure reporting for the xfs_scrub_all job")
> ?

Same general comment as before -- 15fd should have fixed up e0409, but
I overlooked that.

> Otherwise, looks good to me
> Reviewed-by: Andrey Albershteyn <aalbersh@kernel.org>

Thanks for the review!

--D

> -- 
> - Andrey
> 
