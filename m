Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23F292F7EF4
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jun 2026 05:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782450347; cv=none; b=U83OnVM/CWXdap/dKzZCXShTM5sz97L9z8OmCMWmMoPe4drefEX2ZAMXkQfaOYE+pbsI7Rgx8pkAs5AEcS8Cjm+EYMNQkoEjYkU5l2h8/7B1cMTTrvVl2jJDn32L+qO5KBP30fAwwIeQCKGEgUe9PHRx7lHgX/214ungLM7yA+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782450347; c=relaxed/simple;
	bh=DCnvlkW+c016LuMDcoW5H+cOA87aPp7PGaTKcuQhHUY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P+LHu96GDYRwwdVTkSHTax/w1Y22ulJeWlXjN55T/fx1XR+rljBZV10mGU/jrqfusWNDj+NHZ4Ttw0tGxOdsuFbyMzIZlXm3zmg0Rh2Hzt6aIE2h2a7iT/7GKw94k395O0IowiQGHUUvPzMDPTwHZQrywqLn1tFmOKFj4o3EdnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id A819C68B05; Fri, 26 Jun 2026 07:05:43 +0200 (CEST)
Date: Fri, 26 Jun 2026 07:05:43 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 8/8] xfs_scrub: always finish cleanup, even if
 reporting healthy state fails
Message-ID: <20260626050543.GH8786@lst.de>
References: <178242801268.1981574.8079691316092703702.stgit@frogsfrogsfrogs> <178242801452.1981574.2570766392535494985.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178242801452.1981574.2570766392535494985.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jun 25, 2026 at 03:56:17PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Codex points out here that we should always release resources used by
> the program, even if reporting healthy state to the kernel itself fails.
> We're exiting soon anyway so this probably doesn't make much of a
> difference.

Yeah, this seems a bit pointless.  But also easy enough to not care
if it makes checkers happy:

Reviewed-by: Christoph Hellwig <hch@lst.de>

