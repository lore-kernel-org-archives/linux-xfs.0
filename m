Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAD7C3A9014;
	Thu, 30 Jul 2026 08:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785399601; cv=none; b=cGlwOar9FQgfFVydgXuTeMA8ib8Dazo/mtfQA2oOpdyu7cY+AK/RPL9vr78CLkGjaUlE3eV9pu6vtUya+x1mC4HuSwyB+SXaefjG5+GHDHNvq+7KEg00YIoz7W6Lh7kt0jMX7aVzpZj5o93oAhRWUMIxAz7BD81O6oiLj+GJ7yE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785399601; c=relaxed/simple;
	bh=EmFzWInURBZlmB+U36a0JPbN+7Tg4ynI6ba6vNJHqe8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F1sRO++7dbunOg9hrQBAjsVt4VLXhRs3JVLbEi1M1hh7rUw4yUz//Y7YPgiFo6TRZLU7cJ6OPcTWyOe0IOv33n1Pah0OMpcJhQICOGvGwur1VpZRgDG0Msqep8s1yKnaMbzAzjtcwIQva9DTZAbMpYw0CO+R2W8SA3t+AuiiD9Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id CC88668BFE; Thu, 30 Jul 2026 10:19:48 +0200 (CEST)
Date: Thu, 30 Jul 2026 10:19:48 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, cem@kernel.org, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: fix name string recording in slowpath pptr
 tracepoints
Message-ID: <20260730081948.GC10558@lst.de>
References: <178538912844.4070956.17029198681620903700.stgit@frogsfrogsfrogs> <178538912944.4070956.3603642702710474972.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178538912944.4070956.3603642702710474972.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jul 29, 2026 at 10:26:49PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM observes that we memcpy from the xfs_name object, not the name
> string pointed to by the xfs_name.  Fix that.

Heh.  I guess no one really uses the tracepoints all that much? :)

Reviewed-by: Christoph Hellwig <hch@lst.de>

