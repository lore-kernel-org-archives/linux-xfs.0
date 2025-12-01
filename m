Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 859DB28504F
	for <linux-xfs@vger.kernel.org>; Mon,  1 Dec 2025 09:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764579660; cv=none; b=aMrxVz3RdWGLdi8CaIeGrbLNwcCGWHLWGUvu0hj5dV8pqwS7MqVmAqV4C5G6ww6+u0tBSEG2Yk7YV7YbYtlAm8tzoGEDW9r8oD5aADytW1nUDrC5u/4NuCM/w/coY4idWiDWRO91QmoaRcXUJkSXkwHX1+dtObvY8mJt1AblQ7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764579660; c=relaxed/simple;
	bh=T4bON2XsX2OGpzrAH3gTRbbebWu3F7cpL+ATPshxjoU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jEAzsET7ZQmSMj82BHb4yggf3vs71HCc1G5GyC7YYd+4SI/qLSb0VyV+3kcsUMJSh+2VvbmTjDWqRyJ/+Tv6sPffExuHQHNHaGzx/f5zwQTNU6RkrDaOucsEDNyzPHsug5JrqnUw2PjZ/Ni4EKq9tkfXTJWxowdgzpNRSlA5QLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VGGi4JSC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VGGi4JSC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3B4CC113D0;
	Mon,  1 Dec 2025 09:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764579660;
	bh=T4bON2XsX2OGpzrAH3gTRbbebWu3F7cpL+ATPshxjoU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VGGi4JSCrEemljFEdynpw/DfaJ72OZ1hxaGUy1VcaCYkLv9Ya1iOY9IZu/WnTsrbn
	 uLf0M5MltTz3akFSrhMIaYzW1ODHXnt7O6COtr8Wa1q2PLmwFAt8FcFwASzbYbGAnA
	 RPJsk8nsXWMRcde8D6arkrzF3XkOb0JLnRyf2cyx5U4OejugJjiECAbB4eNAXFgW7f
	 GQdig0mSzbhnI/L2b1eKcrdjjEUF1MWxseKGFSUjzF40wdWzaat3SMWZrjaPB5nlYB
	 lMoJNmWiD37mV+yW/xIs7o/IeY1K1TVkoaZn5i+GH9a2zSNaxBo1z6MjBaJ+CUTkzF
	 jbHSHYepqCP+g==
Date: Mon, 1 Dec 2025 10:00:55 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, 
	"Darrick J . Wong" <djwong@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/4] repair: add a enum for the XR_INO_* values
Message-ID: <txngz5bzrffhoavi5ybwtcptmgypljosi5wtgyqiuq7o3qgwhe@acb2ashnm6ml>
References: <20251128063719.1495736-1-hch@lst.de>
 <z-56E7SJXYuGLyhwMv_kupA6P2PsSlno3ZFbm0ZBF9Txb-n4NCMjzm45G45l18LisGhRfSQjDFf3YyOKUNVgPw==@protonmail.internalid>
 <20251128063719.1495736-2-hch@lst.de>
 <gsry5zrjmrda6m6yj7o2wifqgf5gg4hpbcaej7ehon3aqdbswt@lewg6qgjizhx>
 <sIpjVVPgFrJB_EYQ-4f1Y8i6qGYh1qcqLJgCagHsWzYHVXQTUM5isxe7N0EvT84tAEQPhAqUnUGZN_QRxZJamA==@protonmail.internalid>
 <20251201062241.GA19310@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251201062241.GA19310@lst.de>

On Mon, Dec 01, 2025 at 07:22:41AM +0100, Christoph Hellwig wrote:
> On Fri, Nov 28, 2025 at 08:53:16AM +0100, Carlos Maiolino wrote:
> > I think those comments are redundant as the enums are mostly
> > self-descriptive, but independent of that the patch looks good.
> 
> Most seem on their own, but given that this is mixing file type, data vs
> rt device, and magic metafiles into a single enum I think it's worth
> keeping.

Reasonable enough.
