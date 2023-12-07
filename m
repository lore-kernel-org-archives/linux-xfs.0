Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="l0k5d0Y4"
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDACF110
	for <linux-xfs@vger.kernel.org>; Wed,  6 Dec 2023 21:58:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=q1DcKXpOgDhyF4YidLrF63gY6fVEJqr1rwVk+RMLBwY=; b=l0k5d0Y4hrH2oFJgAXJ45ezt55
	giZsXAwI74Qpt6IroMhGNB/EM+MZqvCAwyccP9smeVUxu9yDuKdH2JFr3qQfwjbTYA76pPVZ2AGDs
	WM+f4x2jzL32Zdlh2nFR+DnM63BpDzWmZPsucNAtU6NLLovNtWZope/kGwsI82jsRagLgdfFDknxj
	msaUUUH0vTAM2cEMmTDiuMz4cAMsNN9t70IIcK46TGJxYD+iQkmtTBvSKLxt1bPtdscNA02Tz6q3J
	gXO2iZOFoLzaGe3cRt4QfI0OteIhBQ83H08tjOEsAeYHlcTRytF6jPI/mzomnptknotiBII5bntrr
	DEOx3iqA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1rB7PW-00BwXf-2d;
	Thu, 07 Dec 2023 05:58:58 +0000
Date: Wed, 6 Dec 2023 21:58:58 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 6/9] xfs: set inode sick state flags when we zap either
 ondisk fork
Message-ID: <ZXFfIl3yFsACbjf0@infradead.org>
References: <170191666087.1182270.4104947285831369542.stgit@frogsfrogsfrogs>
 <170191666205.1182270.10061610128319408467.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170191666205.1182270.10061610128319408467.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Dec 06, 2023 at 06:43:16PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Christoph asked for stronger protections against online repair zapping a
> fork to get the inode to load vs. other threads trying to access the
> partially repaired file.  Do this by adding a special "[DA]FORK_ZAPPED"
> inode health flag whenever repair zaps a fork, and sprinkling checks for
> that flag into the various file operations for things that don't like
> handling an unexpected zero-extents fork.
> 
> In practice xfs_scrub will scrub and fix the forks almost immediately
> after zapping them, so the window is very small.

This probably should be before the previous two patches, and the
reordering seems easy enough.

We should also have a blurb in the commit log and code that this flag
right now is in-memory only and thus the zapped forks can leak through
an unmount or crash.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

