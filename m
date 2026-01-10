Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF55D13D8B1;
	Sat, 10 Jan 2026 00:50:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768006211; cv=none; b=lVkipxwC4A+774kI6PskYqXrOBTIYc67iqW6g70fW0d6GisIpizALFh3Xe3AQiEzBpLlnZCI31YtXEh0k7DzS1WB5V7cmVpmA5IARtqRM2F/bdiRjkQUVhGYlcdLpPrJdqJOqC1MtCa09Qapk+uwYHe5Wf1A4TLbfZYOrpofIS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768006211; c=relaxed/simple;
	bh=hLSd+dpHYdWrhoz5btWTKrnm8lBv2niFb9un0TBXSvY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JdfQdkPobIkkHHxGqe25Y3cNyMIzUZTUf/FFL4Q81Uf+AHlPkejO4bXBMGE9bgQ7fdbEtciimECzM4K5cVoMZ7z1xI71ckvVOrVvIJrts6aDpXmuKANLNhec3efxg44I/egvzjLuqlaoLEQh42srg5sB+fXaOPmyOg2bwz55LqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XCSgDR+y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XCSgDR+y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77A67C4CEF1;
	Sat, 10 Jan 2026 00:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768006210;
	bh=hLSd+dpHYdWrhoz5btWTKrnm8lBv2niFb9un0TBXSvY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XCSgDR+yU69AnFGByLtnjMMYAeoSoAWY2kFbj2eYg2xl6ZcSDbOTlowH4UfSB0DLe
	 cxAoUZ3OsIOL6jA3LxFkqXCmED3pQ29WoTvLQYaCeQrs5PFLnVtuEh6fA/LcYe1aaO
	 CdM7FM9aH4NkG4y3yhHXUVrV6srx5YsV5eOmENmKKDjropjIvbv8pqc3KrkfaUPJDL
	 mNW5HawTnhY3b8oPg14pmizSPjLKyMqTRncPNO5WhFoT/3VJmxw3FoY51jXxfliweX
	 lnxDcMdycQPDFyKtYIYUE6ExO/E6lQEYkCz4eE7f9T2AIEsLoVgZo9LRTJEI67XtXi
	 9RAKRTs3Np1mQ==
Date: Fri, 9 Jan 2026 16:50:09 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Carlos Maiolino <cem@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Hans Holmberg <hans.holmberg@wdc.com>, linux-block@vger.kernel.org,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 1/3] block: add a bio_reuse helper
Message-ID: <20260110005009.GU15551@frogsfrogsfrogs>
References: <20260106075914.1614368-1-hch@lst.de>
 <20260106075914.1614368-2-hch@lst.de>
 <20260109161906.GN15551@frogsfrogsfrogs>
 <20260109162506.GA16090@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260109162506.GA16090@lst.de>

On Fri, Jan 09, 2026 at 05:25:06PM +0100, Christoph Hellwig wrote:
> On Fri, Jan 09, 2026 at 08:19:06AM -0800, Darrick J. Wong wrote:
> > General question about bio_reset -- it calls bio_uninit, which strips
> > off the integrity and crypt metadata.  I /think/ that will all get
> > re-added if necessary during the subsequent bio submission, right?
> 
> Yes.
> 
> > For your zonegc case, I wonder if it's actually a good idea to keep that
> > metadata attached as long as the bdev doesn't change across reuse?
> 
> We need to generate different metadata for a different block location.
> Reusing the allocation might be useful, but it would really complicate
> this API, especially as the currently most common way to use integrity
> metadata is through the block layer auto PI, which allocates it below
> submit_bio and frees it before calling back into the submitter on I/O
> completion.
> 
> But it might be worth writing up another sentence on this in the comment.

Yes, please. :)

With that brief mention that PI/crypt data get regenerated, I think I
understand what this (fairly brief refactoring) does, so
Reviewed-by: "Darrick J. Wong" <djwong@kernel.org>

--D
