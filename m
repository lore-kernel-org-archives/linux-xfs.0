Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4E3AD51
	for <linux-xfs@vger.kernel.org>; Thu, 21 Dec 2023 05:49:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RNzY51Ro"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=foY59+PEXmGFlElstCYkjy/vFlAgGHbWNE9Pr6bi3Qw=; b=RNzY51Ro+dv8RRzdEl5COMs2bV
	0YUZ2m0RAARtx0GBna9FEh19sAl09L178Mh59tZk7MnQuUbOfOwcmXdqcjULvLqFmo4B8Yf08nXkN
	IYDXAk81tHRSojAB5Z+Xut7dUEoN8U9dYN7NmVknuqTY7yjJkhRPFku3h/nbf9ltu1cqW4Vml3AWF
	JxLWLFVDa348EWyEPl4BHNmsEbIdVhOECMxdAj0kR0mdP8ZZ60K7zMDkuG+vP1UCXLtrO4veM+UfO
	GbY9XcKiGsb3y6yNuIp0VCjbICFvWXr4eEdcidiMdcqKjNTdps4X0QtLYarW90Q4z3IoDJ9vP+GIT
	2PWR4/dw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rGBw0-001lwJ-2f;
	Thu, 21 Dec 2023 05:49:28 +0000
Date: Wed, 20 Dec 2023 21:49:28 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/4] xfs_io: extract contorl number parsing routines
Message-ID: <ZYPR6LYTefX5ILfs@infradead.org>
References: <170309219080.1608142.737701463093437769.stgit@frogsfrogsfrogs>
 <170309219120.1608142.14150492359425333052.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170309219120.1608142.14150492359425333052.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Dec 20, 2023 at 09:15:04AM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Break out the parts of parse_args that extract control numbers from the
> CLI arguments, so that the function isn't as long.  This isn't all that
> exciting now, but the scrub vectorization speedups will introduce a new
> ioctl.  For the new command that comes with that, we'll want the control
> number parsing helpers.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
