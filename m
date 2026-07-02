Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F8613A874C
	for <linux-xfs@vger.kernel.org>; Thu,  2 Jul 2026 10:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782988083; cv=none; b=s1k4L7Fk27si2QHWxekaCnHTKK/ISHUPeRZYPaihNc5/coeUcdOg8e9tgE78l946NrfcMaYn0BhS6+NBbFyFrQfTPylrJesNTBekwhh2EB8M2YPSPGnMzsXJh3EH5WvnhsZNrBk5WruWK89vXEDzocIifMDIl4NGwg31SZXxpNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782988083; c=relaxed/simple;
	bh=zgnq9cOCovxi5gzGAI2jxhLzecdk061JDdbgypVOoSQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BVNq07aMAZjrJ0xhOsGOshIwUuTE9ckk60p1kKSUvEfBd8nrzQ73laGNqRrSnxVIt47HXZBxAcv+6Eg4jyZpVAHE5sK273tab0BY2ZMji45XiYFhnrBSThPOw/z4BaOJy75Uhqz3fMLRAk3WjGPizQ31w7ThP6K5iO7OE3GIJK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 92D7968BEB; Thu,  2 Jul 2026 12:27:59 +0200 (CEST)
Date: Thu, 2 Jul 2026 12:27:59 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH] xfs_scrub: fix spacemap scan for internal rt devices
Message-ID: <20260702102759.GC6252@lst.de>
References: <20260701145124.GE6526@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260701145124.GE6526@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good and thanks!

Reviewed-by: Christoph Hellwig <hch@lst.de>

