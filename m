Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7DA634D384;
	Thu,  3 Sep 2026 05:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788414213; cv=none; b=AumMvKfENIqsSH43Tx6NfkIkl++sirm4vTg5IOCCRuaiAZFoHUZXKB5G8VkCSA0tn3/alOJr7ntfyKmjxexxvYL2K8a0OA7kmMZRj3ywJqmWRaekayDZcBcx9udbT9pcVfMGFQPM70yDqXl/4t3VBqGudgtOUpPZCZlvWsJCLQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788414213; c=relaxed/simple;
	bh=g2PDjSegKx5T/xDiqarJ9JwBQIGrXylvcofgoYKR/Eg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U2miZGhb3jL1yBJRfSGh405Vx7KJCo3XqUaSDHllOUluA9J5uFymaVyys8Nm5sgcrFab/VY50pIyqN1mVy/IldDhP8j2Y8+Ldw2ZM8MPjIZhvSlzTB23oUcAE+RKKQCPI1lzTNTQ7swTvM2F8usdhCTkaPRCYFpL21mVxAGppLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NluFXz/w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NluFXz/w"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9E9CE1F000E9;
	Thu,  3 Sep 2026 05:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788414210;
	bh=YQ2oSKOGpZ56PZr7U+GT6KlG+zk+3THE8RBOtiHlXNw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=NluFXz/wt0LQWpdWMWHSzjHrzp2M5F1Gt37np9uUJPCgoekjJOm/ehv2PyGTiXNPR
	 HDvcz36NjjVsnpXNr6VaKSFsXFGSu3eMw2CN2WKvq8yb5yWrknxZwSHe2nrH4RyyfK
	 rbMT4aJT13L/BHT56LNM5y+SQk7E/ELgxR54LeJpOqodboR+3MaQOhn3TFPNRqxe6l
	 oSVNUR8ZX8A3Y7Ic/pLZwLhCi9AEt8ggS48FlpbSESicO0eAUshSx1c8J4K/jfL1fg
	 dyzUm9Yqv+Vdvjdmq1wsUtXAQMB2Q65pSf2Qvi4VNwvfWKX7JYMIeU7nJAwSdBvKvD
	 WzJojr1Q9RXPg==
Date: Wed, 2 Sep 2026 22:43:30 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: compute dquot checksum after resetting dd_lsn
 in repair
Message-ID: <20260903054330.GA127607@frogsfrogsfrogs>
References: <178832750681.3508131.6009513367948627110.stgit@frogsfrogsfrogs>
 <178832750773.3508131.8667220003399042973.stgit@frogsfrogsfrogs>
 <20260902072341.GC26173@lst.de>
 <20260902153703.GN1933798@frogsfrogsfrogs>
 <20260903053517.GC16469@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903053517.GC16469@lst.de>

On Thu, Sep 03, 2026 at 07:35:17AM +0200, Christoph Hellwig wrote:
> On Wed, Sep 02, 2026 at 08:37:03AM -0700, Darrick J. Wong wrote:
> > On Wed, Sep 02, 2026 at 09:23:41AM +0200, Christoph Hellwig wrote:
> > > On Tue, Sep 01, 2026 at 10:49:16PM -0700, Darrick J. Wong wrote:
> > > > From: Darrick J. Wong <djwong@kernel.org>
> > > > 
> > > > LOLLM complains that xrep_quota_block updates dd_lsn after calculating
> > > > the crc of the ondisk dquot.  That's clearly broken, so fix that.
> > > 
> > > Yeah:
> > > 
> > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > > 
> > > Also why do we set the lsn to 0, shouldn't that contain a valid value
> > > (probably the current LSN, but I'd have to look deeper at what this
> > > does in detail)
> > 
> > Hmm.  When I wrote this dquot repair code I was mirroring what
> > xfs_qm_init_dquot_blk does (memsets the new dquot buffer to zeroes,
> > doesn't explicitly touch dd_lsn).
> > 
> > It probably ought to be set to the current LSN but we don't really have
> > a dquot log item for determining that, and assigning 0 here means that
> > any subsequent logged dquot item will always be recovered into the
> > ondisk dquot that xrep_quota_block writes.
> 
> Can we capture this for the future in comments somewhere?

Will add that and repost.

--D
