Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27789249E5
	for <linux-xfs@vger.kernel.org>; Tue,  2 Sep 2025 22:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756852324; cv=none; b=jgmmOZUpgm/dC9Wiv+ja0Py1zTsPYJviJqNzkQsQF4RisZq9l9SO6fJeELoXk6m8iWk7HI/u2zCGg8jrwCVFXhsoyXLU3xw91MiPp1tD6Ro+1FjRScndYMt+t4hTDY5kgvs4MCX4uS9yNW2sNpx8X8kNmJUEd4TAgGRsc7rpW88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756852324; c=relaxed/simple;
	bh=tukf3Ui43RoQLryXBeLU2M8PpmEgu0VVKfXZbq9CKt0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zqk/4S9+ywXT2WO3G2HSj8AC8MomlSHyXQEadUkj2aAsl7kc04fz5BpbDGQIiCnkLzF4Jyoio8O7TaQR5z7auVtX3iX8oLy3klO/n9AAFkN9iGb1ebChN/9J9q9pLNber13EjaixqDdbOgbigVFimqh6cUCnE7imbdSRLblx+U4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pYwZry3H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pYwZry3H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99C90C4CEED;
	Tue,  2 Sep 2025 22:32:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756852323;
	bh=tukf3Ui43RoQLryXBeLU2M8PpmEgu0VVKfXZbq9CKt0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pYwZry3HRwMd+fReMaxBQaRddp7HDiEu8gU9q9INAXg2mfn+F43qEztevsF+Rpjuf
	 2DpJI5QRqO5o8S9iZZqZiB9GYqMipTiaGZGUspvwqtdzuufrXBI2OI7UfVrgdnllxi
	 ov9frlgcROMaGs5Qsa/jr/NVNX6zdWQWV3CESmqjEclQQx0DYy/gsL40adggZAe6LC
	 ufDtFYtMzvSqf+IQ3GlllBRD0dnrLPadkZoReO82uCjsCm3in6KjnS88hN3+NEij9u
	 A93gGMQaZKhwD3GoMev+m7LGViB7/Zgtgz0weNoMaHDSS47gnu+qTfhZyzRcZEzpwb
	 a9MyICqWIGrzA==
Date: Tue, 2 Sep 2025 15:32:03 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 8/9] xfs: remove static reap limits
Message-ID: <20250902223203.GJ8096@frogsfrogsfrogs>
References: <175639126389.761138.3915752172201973808.stgit@frogsfrogsfrogs>
 <175639126605.761138.1788578695179861070.stgit@frogsfrogsfrogs>
 <20250902062829.GG12229@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250902062829.GG12229@lst.de>

On Tue, Sep 02, 2025 at 08:28:29AM +0200, Christoph Hellwig wrote:
> On Thu, Aug 28, 2025 at 07:29:57AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Get rid of two of the static limits, and move the third to the one file
> > that uses it.
> 
> Removing the two now unused one is obvious, but could still be stated
> here to not puzzle the future git log reader.  But why move the third
> one?

It's only needed in newbt.c.  What if I change the commit message to:

"xfs: remove static reap limits from repair.h

"Delete XREAP_MAX_BINVAL and XREAP_MAX_DEFER_CHAIN because the reap code
now calculates those limits dynamically, so they're no longer needed.

"Move the third limit (XREP_MAX_ITRUNCATE_EFIS) to the one file that
uses it.  Note that the btree rebuilding code should reserve exactly the
number of blocks needed to rebuild a btree, so it is rare that the newbt
code will need to add any EFIs to the commit transaction.  That's why
that static limit remains."

Would that make it clearer?

--D
