Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58B13A7F47
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jun 2026 06:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780381961; cv=none; b=g0jaZIcnXkevkkHfn3ocf4unSm0I/O9BAgVuisar1taiItmlQxOgU9ZMnUBpoYkkMCo/MLH9o8Y/k0x+IJksYfQMOdw425jiDQGaF8IZHWutH1qufj3EZb4FHTQQRACcEPI6WroLrhbOC3ElwCxsBLIUe27DtZ/55QTtYwtq8Js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780381961; c=relaxed/simple;
	bh=sknXZcBCK3xT3L93j5Owgg4tNwgO3SbPY5i5JmvIF7o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ptk4a5KR8teEDDuHF4gp7e7u+1GocU+00CIOC2xUGGkOG0OYRj0umP39Rn70h1tcoF0UFkATzhy/SgCAZXbECgjL6xcCeaFcdl6R6Fgz3H5PCWwjxp2/wR3V901RVqMGCqKC0/AGFijAEt/9I6JbMHo6dIKLbkGPV4QT2AmKLgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 4924068B05; Tue,  2 Jun 2026 08:32:38 +0200 (CEST)
Date: Tue, 2 Jun 2026 08:32:37 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 4/7] xfs_healer: run a full xfs_scrub repair if we
 don't know how to do a spot repair
Message-ID: <20260602063237.GD2185@lst.de>
References: <178037627011.588879.6129023788062831734.stgit@frogsfrogsfrogs> <178037627117.588879.2171281965197455730.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178037627117.588879.2171281965197455730.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jun 01, 2026 at 09:59:06PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Codex noticed that there are a few sickness event flags that we don't
> explicitly handle in fsrepair.c.  These three codes
> (XFS_FSOP_GEOM_SICK_METADIR, XFS_FSOP_GEOM_SICK_METAPATH, and
> XFS_AG_GEOM_SICK_INODES) can't be handled from within xfs_healer, so we
> should trigger a full xfs_scrub run to try to fix those problems.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

