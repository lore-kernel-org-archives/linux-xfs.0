Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99FA356A12
	for <linux-xfs@vger.kernel.org>; Thu, 10 Sep 2026 09:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789033464; cv=none; b=Z8UO7+XZHZ0hdEcIxWDK0eopuTj16Hp0/qjy8E4nlxpwtfFbBI63vYwebgYrE/xNQvlvgy2qbqjRVXsJ8mK0FrkT6NBsOmKF0D6o3G60F0bUP15cNBaDZ9LUwguSjjciI3N14YhMBjm2Bh8QITqglBOrGv75WVGTrSFfvVeOL40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789033464; c=relaxed/simple;
	bh=yGkh/XRF8VF2Q05611Ss7wejDxMIpLZm6fxX15JMK3I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FnBlvMrNwfrUyj5hlpWVjP5bQOHAwxINahaa9YgSewPMGQ85slYTWg8yXH3EY6PLtxhl4AdEJazWq7h0EZkJxqt+zoGriZLfXeezKdtIGiF2mGi9GcXdHUD8jv7szHPUOzh+rNivoqF0JV3cqC/rZF1wWNnoSLoDxC25e6t6FI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8786E68BEB; Thu, 10 Sep 2026 11:44:19 +0200 (CEST)
Date: Thu, 10 Sep 2026 11:44:19 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: guard against igrab failure in
 xrep_findparent_from_dcache
Message-ID: <20260910094419.GB5330@lst.de>
References: <178901989791.361651.4660674894120948649.stgit@frogsfrogsfrogs> <178901989849.361651.15853889388613447642.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178901989849.361651.15853889388613447642.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Sep 09, 2026 at 10:59:59PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM suggests that we need to handle igrab returning NULL here.  I
> don't think it's possible for the inode to enter I_FREEING or
> I_WILL_FREE while we have an active reference to the corresponding
> dentry, but we can code defensively anyway.

Yeah, I can't see how that would happen either, but handling the
NULL return looks sane as well, so:

Reviewed-by: Christoph Hellwig <hch@lst.de>

