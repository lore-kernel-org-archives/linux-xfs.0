Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C65D53815CF;
	Thu, 30 Jul 2026 08:22:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785399730; cv=none; b=jJeOw0OeBaZpY82zxysNxYtPNvrnNSXwRwIk8eaWLLDpoAlMkX31E2IU8pumuOUeVsNZf/EBooXtXaYWSIyiD76+Vu9x4vksD//wghKcwrM6M6XUltuoLyamEdT6li2suI2Pk3bTvarJk+rrdRDMXfAl7qCckgKrVnbQxp1b9hU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785399730; c=relaxed/simple;
	bh=GICFqNCvwoTUmSLDYaSt5dTiq5t+S1uUwqAcHTnsPwo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nCU9WyeIf+PHR+61LnEK7a+xwgdpCaipyVoRR1tu86UgRFqwETG43+7LuCkNjulZIVYYNPwn17c34D4q3uQRn1aWy6TAo5OnhZH1zpuYFiUQ0OmVlmgILq7UsiA50lpdaZ1ScyncLzWG4JXdRvS7Go8lO+I0tZD7TmtxCgjdDz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id DC63768BFE; Thu, 30 Jul 2026 10:22:04 +0200 (CEST)
Date: Thu, 30 Jul 2026 10:22:04 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, cem@kernel.org, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: adjust datadev sector count to reflect
 internal rt volumes
Message-ID: <20260730082204.GE10558@lst.de>
References: <178538912844.4070956.17029198681620903700.stgit@frogsfrogsfrogs> <178538912986.4070956.14205556423461124701.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178538912986.4070956.14205556423461124701.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Jul 29, 2026 at 10:27:20PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> A media scan of a filesystem containing an internal rt volume produced
> an error in xfs_scrub phase 6 complaining about a truncated realtime
> device.  The rt device wasn't truncated, but the media scan code thought
> we were trying to start a scan past the end of m_rtdev_targp.  That in
> turn is an alias for m_ddev_targp, but in xfs_configure_buftarg we set
> nr_sectors to the size of the data section.  Oops.
> 
> On these filesystems, the internal rt section comes immediately after
> the data section.  We need to set the sector count for the data device
> buftarg to the size of both sections.  Without this, media scans don't
> work and media failure notifications from the kernel will be discarded
> silently.
> 
> We also need to fix the superblock buffer recovery code to do the same.

This feels wrong.  Nothing should acess the internal rtdev through
the data device buftarg.

Is this an LLM report bug, or did you actually run it using scrub?  If
so can you help with the reproducer?
