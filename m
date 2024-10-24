Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC16A17D340;
	Thu, 24 Oct 2024 06:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729751133; cv=none; b=mo+bwtunRa+K8nTfozTh5hV8HhkF88eWIYbEqC+IM5iGcvjj8Ba+ZVfhszPyQZpt3VxcGOwjyjV5NFiTANsV2cWoZPwYkDJGQP/ikVbPE/Yemsa3Udkb+NMD2ywXHdZ8hvTgEpnTIiJnPrs6OUGw7uOW7Jym8Cy9a/DkhkOXHMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729751133; c=relaxed/simple;
	bh=pSCM5zoKE7tVQ+Ng60vnDnwxGnWK0sregmN2qPhTQLU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kBtc5v/NHGaeBYryT+CxuIwPv2JP1X5gqkZifFQNqaCJvLeNuVX2DfJoOeiZFmZqqeNmUngzg0wndAhsFy32C4rto2J6Gp/r135XsVGXAp0Ek9hy+AQWP3QjaLwj3Gr8oszwOtFWOD2+C9sd7saR4DdpiFjxBzJugPlet565bYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3BFD7227A87; Thu, 24 Oct 2024 08:25:28 +0200 (CEST)
Date: Thu, 24 Oct 2024 08:25:27 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, zlang@kernel.org, dchinner@redhat.com,
	linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH] xfs: remove the post-EOF prealloc tests from the auto
 and quick groups
Message-ID: <20241024062527.GB32468@lst.de>
References: <20241023103930.432190-1-hch@lst.de> <20241023172351.GG21853@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241023172351.GG21853@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Oct 23, 2024 at 10:23:51AM -0700, Darrick J. Wong wrote:
> On Wed, Oct 23, 2024 at 12:39:30PM +0200, Christoph Hellwig wrote:
> > These fail for various non-default configs like DAX, alwayscow and
> > small block sizes.
> 
> Shouldn't we selectively _notrun these tests for configurations where
> speculative/delayed allocations don't work?
> 
> I had started on a helper to try to detect the situations where the
> tests cannot ever pass, but never quite finished it:

If you get that to fully work it seems like a good idea, yes.

