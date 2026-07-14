Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE0E2364049;
	Tue, 14 Jul 2026 06:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784009499; cv=none; b=RxxM87mPIdv7zQbzkN7Xag5zDZHwdpBMg29jSspOKSVKmZeWGtX1r/omrOWBHjDH23yevDjTWTyGmrsWfHSEWqJfggPPSsYZePMoeobfJajNGaH4lve1AOUIIYMmLSjFLk9CqJdJtsJJRc29VIaQ0fiC1f85Q4tCedBVvun1EwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784009499; c=relaxed/simple;
	bh=dtgSLKyYkoKAyJpLmS28IjGLycUwytJoutkzgp5rZdc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MIbys6rbXsV87IHt79hbfX28ersv8eUHs326sROZMz7qk1YaXP67P0DJot1L7VvF2z7rJUXS95q4rZ7jpfYYaBmBG0LlaTkbD2FlaMfOn/In/n6BsILtfP1L0qdZoQ0NhEiPU4ysL7D4NscmQq52PdQW0mjoGpPhy09XBKcVyo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8991568BFE; Tue, 14 Jul 2026 08:11:34 +0200 (CEST)
Date: Tue, 14 Jul 2026 08:11:34 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, hch@lst.de, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: set xfarray killable sort correctly
Message-ID: <20260714061134.GB1072@lst.de>
References: <178400716782.268162.4846177784022689546.stgit@frogsfrogsfrogs> <178400716837.268162.4871292933498780753.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178400716837.268162.4871292933498780753.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Jul 13, 2026 at 11:06:12PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM noticed that we *disable* interruptible sorts when the KILLABLE
> flag is set.  This is backwards.  Fix the incorrect logic, and rename
> the variable to make the connection more obvious.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

Can we come up with a test that actually kills a sort somewhat reliably?

