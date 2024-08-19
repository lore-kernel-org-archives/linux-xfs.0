Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D91F16BE1A
	for <linux-xfs@vger.kernel.org>; Mon, 19 Aug 2024 15:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724079632; cv=none; b=Phk7Ek2a3TP0E621SJt3FGm1vKxFP1/G48oULVLIpptfxTPD8nZ0yYypcBI1IMwS0F+1aKa7KuF7MwMWMK9qCqM5+e2oftYu1J2eBkXY+2CMhT8vjs7WrUnyRJIHlF19TYjzv3j+OJOQ0b8lzxlSINL113YS2DWPrl9eA0EqUhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724079632; c=relaxed/simple;
	bh=JPGlJYlD8GR54UP1s6GxN4xwSDeXjGj/aFiXZiEGlQk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yq48ksIKM8fLp8pBD/3X4MErcROKmkXQ0+V3I9Ph/XJANFUpax8n7JvU+lGr7PrppPJGYCgymmbY9GkmII3sNBxULxUGS186AgBXbCvBKmG6qeswK9JqjigFlYZKItbMZaBtfn+IMXY3L6DQc3h4uNBw6qjVepatYwirqQJCqQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qQ7pDJM2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qQ7pDJM2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01042C32782;
	Mon, 19 Aug 2024 15:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724079631;
	bh=JPGlJYlD8GR54UP1s6GxN4xwSDeXjGj/aFiXZiEGlQk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qQ7pDJM2MZ1jCRZJYmDA0KrWvex9+LJR9Kw1B1yUrjdN8hV7WGxKAdwsZ2h8f+h45
	 A/nxcCKGsX1uhlgApwiArAkQtspVXFNJbQbdszce94kjaU6kDKPz6mRCa661BdcsjW
	 lF5eBFuFiLCyBg/4XJlXSEuxAgPrQFZecyA9lRcfBERKeOIvlFdWgdGWOXmrDiz++3
	 6ch0yuSghookC3aFxtp4tWvKovhD4Hcv/ZXTlhEj7b0mvzDjpFFd6IdzmTqwOcxX6E
	 d0fcn6tu7R2uGbFqmzBnU+a0Zda7H75OK8vvxhnbuh8FhTSl+2C7c+O5fFogDL4Pmb
	 eqoTg4iQ7TG1w==
Date: Mon, 19 Aug 2024 08:00:30 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 2/2] xfs: don't extend the FITRIM range if the rt device
 does not support discard
Message-ID: <20240819150030.GO865349@frogsfrogsfrogs>
References: <20240816081908.467810-1-hch@lst.de>
 <20240816081908.467810-3-hch@lst.de>
 <20240816215017.GK865349@frogsfrogsfrogs>
 <20240819124407.GA6610@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240819124407.GA6610@lst.de>

On Mon, Aug 19, 2024 at 02:44:07PM +0200, Christoph Hellwig wrote:
> On Fri, Aug 16, 2024 at 02:50:17PM -0700, Darrick J. Wong wrote:
> > Is there more to this than generic/260 failing?
> 
> The only other users of the detection is generic/251, which doesn't
> seem to care about the exact value.
> 
> > And if not, does the
> > following patch things up for you?
> 
> This works.  OTOH it will break again with the zoned RT subvolume
> which can't support FITRIM even on devices that claim it.  And for
> actual users that care (and not just xfstests) these kinds of hacks
> don't seem very palatable..

What does discard do on a zoned device?  Is that how you reset the write
pointer?  And does that mean that either you tell the device to discard
everything it's written in a zone, or it will do nothing?

I see that this test really just puts a lower bound on how much FITRIM
can report that it discarded from an empty fs.  That number is already
rather meaningless on XFS because the amount "discarded" is roughly
(free space - (amount of pending gc work + discard work already in
progress)) and the user has no visibility into the amount of pending gc
work.  And you can repeatedly FITRIM and it reports the same number
since we have no idea if the device actually *did* anything.

Hmm.  No manpage for FITRIM.  Why don't we return the number of bytes
in the space map that we iterated as range.len?  Or perhaps leave it
unchanged?

--D
