Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5246535B62C
	for <linux-xfs@vger.kernel.org>; Tue, 30 Jun 2026 05:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782796882; cv=none; b=OQ3UZratV4rNgVT1LSu3105heMhgCcKF4KB3gy3naA8+D3yACbAQfReT74eLKvjKtDN4s+1uPJCAqtqtS/nAT9iMRtrPDBLltaZwZPUY4qzqiinREilvuNpB3cYc8yZUOvQMRsYUQMjXPXx0SLdE+doUqGqkM8wLWwrGfiUjcuA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782796882; c=relaxed/simple;
	bh=AfyJgN/BePgW6EbZvpa/o+D+2d1OUUubFcf/UfW4qsw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UuRgdSQhWZyZzp1YdnK9sQf8q0GrV1HBP8dANFwn9LD/oL6d/T9neT6gY0il0vpIpSYyaUFfjDbIYG+BXrzbVQFJw8y84zzdyqiHPKe1L6wxdDDXG85TI4NED4Mkrtqi5hl9zftoRVE/QMmz42P/z7gruZcOrgi/1L7d1AjHR/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DDF6868C4E; Tue, 30 Jun 2026 07:21:18 +0200 (CEST)
Date: Tue, 30 Jun 2026 07:21:18 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 2/2] xfs_db: dump zoned filesystem superblock fields
Message-ID: <20260630052118.GE20888@lst.de>
References: <178278130113.858605.5206441223016436305.stgit@frogsfrogsfrogs> <178278130156.858605.18364793006080520519.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178278130156.858605.18364793006080520519.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jun 29, 2026 at 06:04:44PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Display the rtstart and rtreserved superblock fields if the filesystem
> has zoned storage support.

Ah, yes:

Reviewed-by: Christoph Hellwig <hch@lst.de>

