Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B0211F19A
	for <linux-xfs@vger.kernel.org>; Thu, 17 Jul 2025 05:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752729310; cv=none; b=Z2lNkIE9I7Ih/rNl/YXoS0wIO5k/vyP7xt35pien2caDg6kOysb9tXyh9A9+LhNJT7l1etM2bnQaAhAivluj0lmMTR+7Z2hofGSI/8ldM/MjpAFG0K3muQw7kr/TXtDDXQm/Yx/OvO7lyusR+gMjBC5NsqB+hipSmfzfNjf7t9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752729310; c=relaxed/simple;
	bh=c8sQAuAHPG80IpuUMIVUiOVUwncVP10qQ9L5s8mde8o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mGt43zDs03eh62e4qWbYruP6GevuIk1y8gY5CCE+OeDWtb1ll09/nYQkzYj17bZrRjbxkI2tGOwACp4Fzji/psmw1GhvJ8B2+zuYlsUZ4AF5wZbGaQiVK6GyDV9qC8ARirjSHwIOLuGhjCGXnj5YI77UM/hTuEpbAej2vLAjqag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 91EA2227A87; Thu, 17 Jul 2025 07:15:03 +0200 (CEST)
Date: Thu, 17 Jul 2025 07:15:02 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, cem@kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: improve the xg_active_ref check in xfs_group_free
Message-ID: <20250717051502.GB27362@lst.de>
References: <20250716130322.2149165-1-hch@lst.de> <20250716160431.GO2672049@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250716160431.GO2672049@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jul 16, 2025 at 09:04:31AM -0700, Darrick J. Wong wrote:
> On Wed, Jul 16, 2025 at 03:03:19PM +0200, Christoph Hellwig wrote:
> > Split up the XFS_IS_CORRUPT statement so that it immediately shows
> > if the reference counter overflowed or underflowed.
> 
> Should we be using refcount_t for xg_active_ref to detect
> over/underflows, then?

In theory yes.  In practice refcount_t still has a lot of performance
overhead, so using it in something used a lot in the fast path might
not be a good idea.

