Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F1B274670
	for <linux-xfs@vger.kernel.org>; Fri, 20 Mar 2026 07:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773990977; cv=none; b=rK6dTo3R8K+CsBXwPfSt9GEgi65NjOyLr9GghYIrYLR9cs+MCmkroTjQ7VCiJtk2y3X5+bb6gkZBw5VG4S9oWxe8zX0zzsQ8diF1C0LQyTl2h+eDw9SXDW6ifArgZiyAFekzWLrCuiA8MF8naXakHwpoNPetY6JXzWd5G5JMRFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773990977; c=relaxed/simple;
	bh=KNZeDZK1zlrm2oaYr+TYi783Y3nH0XbT8/Ak6B1gDq8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P09V+EU8udX3K5NIuvYj4UMVN2Td76Q0mTunwim7A084HVBOyHn6zMXxwD0vI2mv6K7bkEnh5109LgD3MytrsphZfTsEoYdTm650MQWTy7m800IW3fe1EfBDTRxBSqB9RPqhpOfWmmHG2z3i9WD6tNN5v1//saGuMuwblMKcsoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fDqJNEax; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fDqJNEax"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Uypa5ddlYMFv47o7dLj1YnNgxH9nvhsKkahAfWvHnPk=; b=fDqJNEax8Nus3ZCuxCyv3LcHrT
	yXw2Bbp3XfeSnjlydPvpGaKD23U7hyrfmgJ2zLcaekmrFDQB0Z1jW4IE62Pxs3LMGDT8o9PhQGVzB
	w7pH9KCE6bTFLOlFrZLyHceS1x503I9OJuasFtJ68Ma0lxsKQYE0EX6Uo92gXu6hMSKZt4A/5GIIi
	QO62fp3TYFdRpnlZBBHOQk0QlrBTtOMX5aBf2G7pbZiESa8jnkfwp2N4uqxpUb2bS3LdgQhIovK8p
	KumMfu4hwiq8nbrYgwMuPsbVZnKxTXfLeKpvDLirFrRIRFG9eXMES6xB7fqn6wVpmVQlMTWHDsPSh
	aKmxLv5Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1w3U5g-0000000CDm7-3H0e;
	Fri, 20 Mar 2026 07:16:16 +0000
Date: Fri, 20 Mar 2026 00:16:16 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 20/22] xfs_scrub: drop SCSI_VERIFY code from disk.
Message-ID: <abz0QKb4HrF6Ycif@infradead.org>
References: <177389506832.3681140.14985419190965827651.stgit@frogsfrogsfrogs>
 <177389507307.3681140.7579091494209455124.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <177389507307.3681140.7579091494209455124.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Mar 18, 2026 at 09:50:44PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Now that we have a media verification ioctl in the kernel, drop the
> SCSI_VERIFY code, which enables us to drop the dependency on sg and
> obviates the need to fix some unit-handling bugs in the HDIO_GETGEO
> code.
> 
> A subsequent patch will enable larger verification IO sizes, which this
> old code cannot handle.

Good riddance!

Reviewed-by: Christoph Hellwig <hch@lst.de>
