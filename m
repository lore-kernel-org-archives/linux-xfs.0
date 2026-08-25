Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1961F3C1D70;
	Tue, 25 Aug 2026 06:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787639302; cv=none; b=PyEZJP0DV9JbS82mqjG+/NA4fMdoZDurnZsaC2Jz7XgOe8sxCCle7BrpKnU93yQOyuIFL5JqNoVbXaA3HRgSyD1ouyXIK21nTSN5Ij2CX/uoXtcQ/VQ8ZIIwDbyGofh81iUKIfZJ4QnpDNdk6k/+DnqNt36YxUc34qOwKdGCZC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787639302; c=relaxed/simple;
	bh=wOmpnGpj3tGWcgMuH28rPN3VuvC3IuDSa40dIGFdm88=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TZJFZTc7tnt+WZseJE46+wJ+2U/8xrFla8+3CSvk518OV6/LDSb9VLQgJJGnMQ3HmLFml5zcqoQEDaNvlOvmO0zo6hZoiEl4LELGIIwu67Pna0H9oHq2QyKA8ytcMetW6bNLjNabfgwbHQniacw5HKt903pGua+yzekSdLhdWrw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id BC09668BFE; Tue, 25 Aug 2026 08:28:16 +0200 (CEST)
Date: Tue, 25 Aug 2026 08:28:16 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, hch@lst.de, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: log the tempip after we convert it to extents
 format
Message-ID: <20260825062816.GC24324@lst.de>
References: <178760940641.944084.17475223769703836830.stgit@frogsfrogsfrogs> <178760940742.944084.4404098260047036388.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178760940742.944084.4404098260047036388.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Aug 24, 2026 at 10:35:10PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM points out that xrep_symlink_swap_prep converts sc->tempip to an
> extents format file prior to the atomic swap, but incorrectly logs
> sc->ip immediately afterwards.  Fix that, and the other problem that
> we're supposed to tell xfs_trans_log_inode what to log and don't.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

