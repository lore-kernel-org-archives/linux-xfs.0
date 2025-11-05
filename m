Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3EA427CB0A
	for <linux-xfs@vger.kernel.org>; Wed,  5 Nov 2025 13:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762349271; cv=none; b=FbdSYMI/SvoE2xY++JPjK/gRaVnm323m8M+TcldprUZrc6MJdNtQm2RR6lkPKQSrnOj2BWs3kZXv6U/ML93C5yhVE5w1hLpGCqkDY5N//f98BtpgvDrH2KWbOfEtxRVwVtlLam1q3SM1Rg5Ezs6s+yGcBWU28ckBosWZ6XBATLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762349271; c=relaxed/simple;
	bh=N6rPHBEYi43DOKTIrOP83pVHThov7aTW6PkyRdLbfZ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lhci1ZN+kHt3wv41AMfAWEo1oSKqFL5Zxrr87566U/L/Ndp05V4tmH1YESUvLvTDIlENIQYBzxLZRf2OC7hQQzgL+ifGRQ4HqyGY6H+05FFpWI8R7qGnYTvtXQmhdyeX+VgDr1TiCe7eY14XvmrIkNbfTRLEB5xDrb479mL4t/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 47F02227AAA; Wed,  5 Nov 2025 14:27:46 +0100 (CET)
Date: Wed, 5 Nov 2025 14:27:46 +0100
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/10] xfs: regularize iclog space accounting in
 xlog_write_partial
Message-ID: <20251105132746.GB20048@lst.de>
References: <20251030144946.1372887-1-hch@lst.de> <20251030144946.1372887-7-hch@lst.de> <20251104235309.GT196370@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251104235309.GT196370@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Nov 04, 2025 at 03:53:09PM -0800, Darrick J. Wong wrote:
> On Thu, Oct 30, 2025 at 03:49:16PM +0100, Christoph Hellwig wrote:
> > When xlog_write_partial splits a log region over multiple iclogs, it
> > has to include the continuation ophder in the length requested for the
> > new iclog.  Currently is simply adds that to the request, which makes
> > the accounting of the used space below look slightly different from the
> > other users of iclog space that decrement it.  To prepare for more code
> > sharing, adding the ophdr size to the len variable before the call to
> > xlog_write_get_more_iclog_space and then decrement it later.
> > 
> > This changes the contents of len when xlog_write_get_more_iclog_space
> > returns an error, but as nothing looks at len in that case the
> > difference doesn't matter.
> 
> Ooops, sorry I missed this patch. :(
> 
> It makes sense to me that we have to account for the continuation when
> asking for a fresh iclog, but now I have a question.  In "xfs: improve
> the calling convention for the xlog_write helpers", the len pointer
> becomes xlog_write_data::bytes_left.  In the context of this patch, I
> guess that means "len" is the amount of log data that we still have to
> write to the log, correct?

Yes.

