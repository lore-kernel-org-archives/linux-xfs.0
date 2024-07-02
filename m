Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A5312555B
	for <linux-xfs@vger.kernel.org>; Tue,  2 Jul 2024 05:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719897231; cv=none; b=OCb4PjlmH1XG/eotuvwEQhGCN5p9XRapXtQZNBNXFkYzY1ytgZsd/hZm4Yd6gir+gxcKN/HR+LmpaCsVJUViNREcRD9MgPO0rNRHncJ5EuTij8GA4W1vVVA39lMM8ef4Hz/TPJj6/o4psuMjPDbtaSzqhoUkzDZX4Dg9UvGr7IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719897231; c=relaxed/simple;
	bh=hzrkRus9ClYVgnNG80KkgEDb7rbHSl9k69H5zUGb9mI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ud/1rlUXkDrxj6m24Z4pfduzZ6X7uVuhZQXswOuHjwYvS8ZLIIm3pZAt+4pBozfK3hKDxcooySnE+TrpejIDlODvwgCxehNAxK3UOnBvhkXd+Y2+aSyye8NZYqkWbJ8RbY3DFpOj7gXZDoerj+h585521FGORxmBFNCFfZenudY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C99C268B05; Tue,  2 Jul 2024 07:13:46 +0200 (CEST)
Date: Tue, 2 Jul 2024 07:13:46 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 07/12] xfs_fsr: convert to bulkstat v5 ioctls
Message-ID: <20240702051346.GG22284@lst.de>
References: <171988116691.2006519.4962618271620440482.stgit@frogsfrogsfrogs> <171988116816.2006519.15287670811039475666.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <171988116816.2006519.15287670811039475666.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

> +			if (lseek(file_fd->fd, outmap[extent].bmv_length, SEEK_CUR) < 0) {
>  				fsrprintf(_("could not lseek in file: %s : %s\n"),

Maybe avoid the overly long lines here?

> -int	read_fd_bmap(int fd, struct xfs_bstat *sin, int *cur_nextents)
> +int	read_fd_bmap(int fd, struct xfs_bulkstat *sin, int *cur_nextents)

Maybe fix the weird formatting here while you're at it?

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
