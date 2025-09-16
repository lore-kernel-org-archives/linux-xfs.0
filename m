Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C232B2D7DC2
	for <linux-xfs@vger.kernel.org>; Tue, 16 Sep 2025 14:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758031276; cv=none; b=FL+5yocQKQFGUCR4b8Zayso4JQM3E7FTHPd6e7ChcKCPu/vC2ZMBSMz3zimq0CDXLczGT/010Vw+GqS1BC3vJiZhsU720XbMUKyH84MnRaoAjJJJdz9lt5DLLoLusMRt/w87JN1Jp3Q8zdVf9sQtlXf8RHKcxQ+GBQr/tjoBBCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758031276; c=relaxed/simple;
	bh=Go1CGDqN9kjXkUlshjX0BpQYNb1tAtqN1iMZPh8NMWo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YRuLVKajBpCcNnKhA3S/o+EMCVHTkIaomyRdgsHgVRMLzKp4a6PRQzcjEWlgEt0cCQl9b5S5vGNFj82bn28/0M8bJ/NxJS2pwqr5HDcoDbZgbJtwZ2a7rEEEFiq/mIkCzCRujEdmcz7qZE6rpB0a1To6mbcSSyvI2qdyMKPCUrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B29B768B05; Tue, 16 Sep 2025 16:01:09 +0200 (CEST)
Date: Tue, 16 Sep 2025 16:01:09 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH] xfs: move the XLOG_REG_ constants out of
 xfs_log_format.h
Message-ID: <20250916140109.GA919@lst.de>
References: <20250915132413.159877-1-hch@lst.de> <20250915182732.GR8096@frogsfrogsfrogs> <20250915204835.GA5650@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250915204835.GA5650@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Sep 15, 2025 at 10:48:35PM +0200, Christoph Hellwig wrote:
> On Mon, Sep 15, 2025 at 11:27:32AM -0700, Darrick J. Wong wrote:
> > On Mon, Sep 15, 2025 at 06:24:13AM -0700, Christoph Hellwig wrote:
> > > These are purely in-memory values and not used at all in xfsprogs.
> > > 
> > > Signed-off-by: Christoph Hellwig <hch@lst.de>
> > 
> > Looks ok, but why not move struct xfs_log_iovec as well?  It's also not
> > part of the ondisk log format.
> 
> I have a separate series that includes the move, but I might as well
> send that now.

I just looked into that: with my log formatting clean series,
xfs_log_iovec can and should move to xfs_log_priv.h, while right now
we could only move it to xfs_log.h.  So I'd rather not move it twice
and wait a bit.
