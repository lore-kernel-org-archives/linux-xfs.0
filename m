Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7044381CD
	for <linux-xfs@vger.kernel.org>; Mon, 27 Nov 2023 21:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l6SNa8ut"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E749C433C8;
	Mon, 27 Nov 2023 21:55:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701122134;
	bh=Zi9NHuIQSzAvVjUEX8d2gd1WPIJbJ7eoLxtxwqIKSUw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l6SNa8utdPPie2dHg9nWYifBUROchi47nDiuwJUeOVDzgTRFVE09556vX8IL+v8iq
	 ahGuqB6Babonql12+PXWhK54qBllbuddB0jeyXJekEi24yY0nvii8J9mLzxWS+Ld+x
	 SDjDlxrBS5QVa4/PS0Jd+ym/W/CqNMnB69jzzQsLegi8GS8Q9GPGBfSSUyJxx/+IVv
	 eQ9Pd7OmIELCgjDdiGHn3Tibg47RLCKZN0bPgTcspmk4PbljuECshezw5AXMV1DsAd
	 +ikYOjQsSdvGv9rdVgkiuQfxEj0J5EWi15NayVfbhJD8FeA3JAQcD+CITGMp7QDeUc
	 c4SXX9q6NbOkQ==
Date: Mon, 27 Nov 2023 13:55:33 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/1] xfs: make xchk_iget safer in the presence of corrupt
 inode btrees
Message-ID: <20231127215533.GF2766956@frogsfrogsfrogs>
References: <170086925757.2768713.18061984370448871279.stgit@frogsfrogsfrogs>
 <170086925774.2768713.17299783083709212096.stgit@frogsfrogsfrogs>
 <ZWF+1Qz7p7SwdqWB@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZWF+1Qz7p7SwdqWB@infradead.org>

On Fri, Nov 24, 2023 at 08:57:57PM -0800, Christoph Hellwig wrote:
> On Fri, Nov 24, 2023 at 03:46:54PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > When scrub is trying to iget an inode, ensure that it won't end up
> > deadlocked on a cycle in the inode btree by using an empty transaction
> > to store all the buffers.
> 
> My only concern here is how I'm suppsed to know when to use the _safe
> version or not.

For xchk_iget_safe, I'll amend the comment to read:

/*
 * Safe version of (untrusted) xchk_iget that uses an empty transaction to
 * avoid deadlocking on loops in the inobt.  This should only be used in a
 * scrub or repair setup routine, and only prior to grabbing a transaction.
 */

and add a comment for xchk_iget that reads:

/*
 * Grab the inode at @inum.  The caller must have created a scrub transaction
 * so that we can confirm the inumber by walking the inobt and not deadlock on
 * a loop in the inobt.
 */

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
