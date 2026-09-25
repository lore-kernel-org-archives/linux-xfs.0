Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 642F643DEA1;
	Fri, 25 Sep 2026 05:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790315669; cv=none; b=tewVkgqo7A8Z72tRIkNdAwPX+gpNJTe2Q0wMyqG7qyFRzgFFYq4bJ8qh/LBMJknegGAZMItNXToPf5TAu00vjbRLQEsSL05FJY/FZe3cW6H2NLEMiuf2UpvxI2I588XhiD6LuVEUKMRiKYv9psQYCJENhddXSwMa9xbsaej9lVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790315669; c=relaxed/simple;
	bh=UGcjOsOz99qsOBPUSEF6SR3FT4EpW3vFMh3h9r8OR1Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D/NnmImfrdWXPP89ci2tGzFBZnSc7arUfkqZaG0ONCGdBadXVm9fupoh1Ra69ySWoZmR+8bfeWAlHsrnrJVsMm5vFGWLHFLs2YpzTwe65eUduXaKT1u7w9rjozdI8zjQZgtKgHBPIgVnbpV6e36Z3AIGIpLbrASKsnd7whSUUZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 91DE868BFE; Fri, 25 Sep 2026 07:54:20 +0200 (CEST)
Date: Fri, 25 Sep 2026 07:54:20 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 03/21] xfs: add a xfs_buf_read_async buffer cache API
Message-ID: <20260925055420.GB3193@lst.de>
References: <20260924100032.2733101-1-hch@lst.de> <20260924100032.2733101-4-hch@lst.de> <20260924214341.GE2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260924214341.GE2705364@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Sep 24, 2026 at 02:43:41PM -0700, Darrick J. Wong wrote:
> On Thu, Sep 24, 2026 at 11:59:35AM +0200, Christoph Hellwig wrote:
> > Add a new helper that reads a buffer asynchronously.  This is similar
> > to readahead, but doesn't become a no-op under memory or I/O congestion
> > and returns the buffer to be read.
> > 
> > The intended use is to kick off a read of data checksum buffers at
> > roughly the same time as the data read so that they are available
> > in the I/O completion handler.
> 
> Does there need to be a "wait until this async-read buffer reaches
> XBF_DONE" function too?  Or how do callers do that?

Using the new xfs_buf_read_async_wait function added in this patch.
I'll reword the commit log to make it more clear that it exists and needs
to be used.

