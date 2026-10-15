Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89AA52C86D
	for <linux-xfs@vger.kernel.org>; Thu, 15 Oct 2026 14:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792075384; cv=none; b=FjA62p3Wiu0MLDBUF3B6JDRVORWdCYuVatp8O/CFX/34UDPGyfPDC7sAen+2eX8sK1MtvyF6VGPvuvOE7sAfDVwLQJ/zs3b5gN0d+dkKOVupp0IC493k+u6sPghCJDGTrLyHuxswTmdfp0Q5uFBstAXPt4ieuM77MXhmbLdIKIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792075384; c=relaxed/simple;
	bh=RAFAYPhQX97Wlsq0o4KhGbMwcj/EcxcDhlnGlQ1pWEA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Tc5AsgqHr2DRdU2P2PazFe9iq09xaoNMZPquaK349IS8LwyPBPmSwyHJl0xe7vqELCn8tDO8jF4XL3fQlMZassDf054bLNkoLEI1Jv/02bPBd5YStpyyr29eMhlrH87ckGy0QpYEpbhXuO00sjZuJgkCb04kuFAkywXeZzLGYJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sy61iJUO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sy61iJUO"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 24F521F000C4;
	Thu, 15 Oct 2026 14:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792075383;
	bh=bnmYHJK0MtXH3pRZ+aJTErRo+Ugrla6zWHhMeZAu2UM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Sy61iJUOy0JK75eezu5rO65xM4pdscZv0D6Nsnh17/bIy/LQxmd3KQ9wF/uiJjV9p
	 maZeY1vlW9DjDyH8pqTauX/2pIc0WVxjXHEMXGrsd1tUzvZA/PChW3hlN5ijE6S3LS
	 BQL9eU8ofXXfwzG8XEMeRXXKIDZpfpzBkLkh72v60UtOuww0uNSYpLsNdqJMdVNx4K
	 b6SaDcFA2M4gmf8a9wRCIYvbL3ulTqOEby8dd4Ngxx3afRlmIf1GMhsC5AmEUvSPeO
	 ASY2cJs5hiOWhjTN1qCD3ys7XqM35YtUU/W0InA95Ud+yUMHH6ceRQnl+mlfUZRswe
	 Y8vpnwbyE/2og==
Date: Thu, 15 Oct 2026 07:43:02 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andrey Albershteyn <aalbersh@kernel.org>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] libxfs: fix compilation errors
Message-ID: <20261015144302.GO2705364@frogsfrogsfrogs>
References: <20261014174442.GK2705364@frogsfrogsfrogs>
 <as_IydSHaWCYgnLJ@infradead.org>
 <20261014184212.GE1615495@frogsfrogsfrogs>
 <atBrJO9owC7yXsRb@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <atBrJO9owC7yXsRb@infradead.org>

On Wed, Oct 14, 2026 at 10:56:52PM -0700, Christoph Hellwig wrote:
> On Wed, Oct 14, 2026 at 11:42:12AM -0700, Darrick J. Wong wrote:
> > Add -Werror=missing-prototype (or -Werror) to WARNINGS in
> > include/builddefs.in:
> > 
> > WARNINGS += -Werror
> > 
> > Then rerun configure and make
> 
> Ah.  This is not "compiler apply the default function declaration",
> but the compiler warning about not having a prototype for a non-static
> definition.  Which is still somewhat useful, so I think we should
> enable it as a warning (but not as an error like above) for xfsprogs
> as well to stay in sync.

Well if you really want I'll share my old debug patch that tries to
enable as much of the kernel's W=3e as one can do sanely.

--D
