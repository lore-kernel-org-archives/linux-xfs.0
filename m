Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0124F182AF
	for <linux-xfs@vger.kernel.org>; Wed, 24 Jan 2024 09:42:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706089373; cv=none; b=g0+NWWGTP3ownMyw5q4cKaBxou+v8KTTrLSonHTXmIXteTr7QFCzl4ZZbjui1e42L+XbywvBrSIcRnPmtpXwl9F+WmnKkYan4i5mJHIVsoOlD6SXYJ2wLgJS3nzeZ0xa6whf6HZxE5+WQNiBAIA2Dwh7X8NyimXAkj4L2/adlGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706089373; c=relaxed/simple;
	bh=Zp8W1ceQYXwhHso8iRVY3NeZQC+dFhEyZasAaiqmdYk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YN69O+IMjftLZP1vVkXTyIAZ76hn5a8KpvkJNlHio0vsKakny635ioRHoXBj0aXsftTJ4rZJZpCQj26fr9DMOLqWn8vmbmttkstcX8nSjoROAL+jEhx8QmzNFvI4kI+yUVIQhZJiW4KylL6s6amOclc7KArmXqLib7ip6vBaJdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PzpGn9Rw; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PzpGn9Rw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=yFdb3bMcs0BfTRNniR0KI8FmwWfCiyfyy1EEGh8mCc8=; b=PzpGn9RwxzNE3A8XnsjyVp2cIy
	p5AxjDwlwd8GUBuv6nsPlQCQZ6LP5aQJgD0TTqauTRHBlOG+gBsgXYvn8tLf78hpWnnNo7L5c85Zw
	xCfTNL0M174tOArdI7a6bNtQkEKmJk6gA4jlLIjCPSG7Hhealwj5m7/PdoebYxloBPNqA4UiLmxTN
	hYcZMCHYVUjcIdUKVp7Fh/KZYLlDFgvQob5nUbzlF841hkqM8pikQR4YRGvoftQJv4YAFI1RrF/bP
	4MlH9PhXX+4O/IkVEngTJY4TQsDqQRcydn8BQkwMs3jZgeem1RaVxVLyu/WW6RX1WHMudW6PC4VmT
	H1R2ivgg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rSZmV-002J6S-1u;
	Wed, 24 Jan 2024 09:42:51 +0000
Date: Wed, 24 Jan 2024 01:42:51 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-xfs@vger.kernel.org, djwong@kernel.org, chandan.babu@oracle.com
Subject: Re: [RESEND] xfs: reset XFS_ATTR_INCOMPLETE filter on node removal
Message-ID: <ZbDbm6ZvNL3oBzPf@infradead.org>
References: <20240124094032.1150014-1-aalbersh@redhat.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240124094032.1150014-1-aalbersh@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Jan 24, 2024 at 10:40:33AM +0100, Andrey Albershteyn wrote:
> In XFS_DAS_NODE_REMOVE_ATTR case, xfs_attr_mode_remove_attr() sets
> filter to XFS_ATTR_INCOMPLETE. The filter is then reset in
> xfs_attr_complete_op() if XFS_DA_OP_REPLACE operation is performed.
> 
> The filter is not reset though if XFS just removes the attribute
> (args->value == NULL) with xfs_attr_defer_remove(). attr code goes
> to XFS_DAS_DONE state.
> 
> Fix this by always resetting XFS_ATTR_INCOMPLETE filter. The replace
> operation already resets this filter in anyway and others are
> completed at this step hence don't need it.
> 
> Signed-off-by: Andrey Albershteyn <aalbersh@redhat.com>

Shuld this have a Fixes: tag?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

