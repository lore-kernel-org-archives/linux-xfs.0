Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68DFE17BD3
	for <linux-xfs@vger.kernel.org>; Tue, 15 Oct 2024 01:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728955996; cv=none; b=kYFkWfP7hi9lShHEW0BzNolhm2SAKZf6KClrRh+Q5HsD1GM0Cg8LAib/inyY7cwl7+tJmFbt8n7XnvBtkdac7MhebZvZECvcvT6DPu6m4i7E/X5hLDawKSNScKF3IyWQa0EURGCQ10xqfKK47QVfQtx6reEYQT4+4LeXVW8u42s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728955996; c=relaxed/simple;
	bh=WEIejzWjDY0bcgBsJSIDj7GJfUcg4STTso7FNsKrBGY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=abyhgzSziy7Q6KfUaiChBusIUuE/b1IcNBb7uBOPGDdPmJC3JaxDWP1sIWNfh28sAorAaquMksGl0vfgWrazaJfmzyLmqXlSx5MQkuXKUU+8cmt2+Rao6eLg9eSIaSiv2H54a4DzmEqp8Kx+Jo5y4DgR+/ZcFikgNckl4TG8FGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oB24t4zs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oB24t4zs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F804C4CEC3;
	Tue, 15 Oct 2024 01:33:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728955996;
	bh=WEIejzWjDY0bcgBsJSIDj7GJfUcg4STTso7FNsKrBGY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oB24t4zskqAPnjkF2P9qpv0ZoKFKUOcOPqMmvlDK/dWLvgBO1LmMP8uxGPtwLYmlJ
	 JYulSkE/GsDUZFNZHWFTnqlhtSUE4/NqHoMtU1BgywllZsRYVxHFwG5bCCkcnBEP/P
	 cL8q024ljQhxod1rs5YQn9Rg0ANQJM+mx677x2sLlWMYWBt4RfPNyssCqeatwq3rLq
	 ABCObTpv2PY57DFQof/VknDH34xj5FhFJQIgbFq4z/mecyID0+m/jHn8A1TG9wUAMR
	 mcqs1ID2gOBG84p1M95MiCUF15vVwQFSpnsISqG4yp1YD3LkWO8OZXAfYykHKjfiJm
	 +1mpWAPPado3A==
Date: Mon, 14 Oct 2024 18:33:15 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 30/36] xfs: move the group geometry into struct xfs_groups
Message-ID: <20241015013315.GS21853@frogsfrogsfrogs>
References: <172860644112.4178701.15760945842194801432.stgit@frogsfrogsfrogs>
 <172860644760.4178701.13593967456112695233.stgit@frogsfrogsfrogs>
 <ZwzRn1fEt0xHdel-@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZwzRn1fEt0xHdel-@infradead.org>

On Mon, Oct 14, 2024 at 01:09:03AM -0700, Christoph Hellwig wrote:
> On Thu, Oct 10, 2024 at 06:09:29PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Add/move the blocks, blklog and blkmask fields to the generic groups
> > structure so that code can work with AGs and RTGs by just using the
> > right index into the array.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> I think this lost my From above during a git-rebase that likes to
> strip authorship.

Grrrrr crap tools.  Sorry about that.  I probably force-imported this
patch at some point and it tripped over all the free form text in a
patch that looks like headers.

> But this should probably go all the way to the beginning into the
> generic group series, maybe even folded into the patch adding the
> generic group and thus also xfs_groups structure.

Agreed, will do this tomorrow.

--D
