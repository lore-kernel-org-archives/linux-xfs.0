Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5B093C1D70;
	Tue, 25 Aug 2026 06:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787639217; cv=none; b=R78QDr+hI6m4ugVHKyU3LBBedXy+Wu1OtIhq/umSH8LIxqA+/Ek5lwClTH1taPQTiMbCaVz0FVzyakbjfc5fmy8LJFWN6VRqwM7uYkgOnKLfZSqVHjIDrEDTcJoG2U+n0LrnO6etLdvbSSOjbhHgWT3qWt6vAG7ZDJ7l5REtwCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787639217; c=relaxed/simple;
	bh=5giOOw1nhzZoumV3SeK3DyKqsmlDSLPgRJeIDmtt29Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tUZVpJBezG2XWy5F4dSIIiGf4x2sGycKJvJk23K9FV5wv/UGrDHuGXtuDy4APqMlKHo/rti+fnHUQL5/7DCV7ft20Nr1WWpv80YzEaSX7B/uixAW8VB3rU10jRm5CT8BuUYvOhWHnMJObz8TNRUIq8cCvWjUcwu4RLSJHPyvbYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C5F7768BFE; Tue, 25 Aug 2026 08:26:44 +0200 (CEST)
Date: Tue, 25 Aug 2026 08:26:44 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, hch@lst.de, stable@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/6] xfs: don't spin forever on zero-length dirents
 when salvaging them
Message-ID: <20260825062644.GA24324@lst.de>
References: <178760940641.944084.17475223769703836830.stgit@frogsfrogsfrogs> <178760940700.944084.17154290942223549187.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178760940700.944084.17154290942223549187.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Aug 24, 2026 at 10:34:39PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM noticed that xrep_dir_recover_data can spin forever if it
> encounters an unused dirent that claims to have length zero.  Fix that,
> and prevent the same thing from happening with a zero-length entry.

xfstests for this?

The fix itself looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
