Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3D493BB107;
	Thu, 10 Sep 2026 05:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789016437; cv=none; b=XqDMYDPo+/csTsSANlJLywhulL9u7PS2pqkdTrksKHJPJtdWRiedOefdnHcEiiDO0lxD3G8oKZvd6Bl9Ee9ItsdX23rX30OjXVrVGglLCI6AYBL7L/yTqEgf+DJi6YJJebzN2QZu5bR/YTgtJXo0C+QrxeizpXsQfmMqVNZy3nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789016437; c=relaxed/simple;
	bh=h94JUXtozQPZr5bhi9rFOSPTsnqmkp3FNqZM+hsy07g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fvZ15j1tkbxknwldQ4dkG4U8VevzeDg5ctUI9fUPd8vspDy8tPKnupSii7peE6UwJKsa2I25/F45ek/Zd0OxahuHxusZlqph02RVDsiw4nuw7QBY/o9v6f6vhjO54lJXLFnSu1BEQeFHTLfCGHQaa+l8JrYDzazdvL1y6+uuGWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 7258268BFE; Thu, 10 Sep 2026 07:00:31 +0200 (CEST)
Date: Thu, 10 Sep 2026 07:00:31 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, dgc@kernel.org, floss@jetm.me, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/7] xfs: fix under-reservation of blocks when
 repairing sf directories
Message-ID: <20260910050031.GB26687@lst.de>
References: <178892936573.4057962.16225191041041958394.stgit@frogsfrogsfrogs> <178892936640.4057962.1916451282677820756.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178892936640.4057962.1916451282677820756.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Sep 08, 2026 at 11:04:35PM -0700, Darrick J. Wong wrote:
> +static inline unsigned int
> +xrep_tempexch_estimate_sf_resblks(
> +	struct xfs_scrub	*sc,
> +	int			whichfork)
> +{
> +	if (whichfork == XFS_ATTR_FORK)
> +		return sc->mp->m_attr_geo->fsbcount;
> +	if (S_ISDIR(VFS_I(sc->ip)->i_mode))
> +		return sc->mp->m_dir_geo->fsbcount;
> +	return 1;

geo->fsbcount for attrs is a always 1 and a lot of code relies on that,
so this feels a bit overcomplicated and misleading (but still correct).

What about the more usual:

	if (S_ISDIR(VFS_I(sc->ip)->i_mode) && whichfork == XFS_DATA_FORK)
		return sc->mp->m_dir_geo->fsbcount;
	return 1;

?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
