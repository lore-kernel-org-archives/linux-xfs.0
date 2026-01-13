Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4878356A31;
	Tue, 13 Jan 2026 07:04:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768287876; cv=none; b=K0QW5Zw7/JHJP3msAu4cbPPu0Th6LS03XfD2wcu7xVmYEvdWz+wmclsKc03RMkZVil72mFH1A2uR0pZq8cLmY7YbOGg2qYHr8FK/J9DZNXKqreNzU63foI7DepWEwavCCH9QR+RzJJ8WDkBQ/t+PGa5vlLwHJw6ax2cA1vEOuAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768287876; c=relaxed/simple;
	bh=TmSPwKh9kjcYsPEkv8ujZcdTlN0xnIUxg/eNvW9T9DQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jc4O92JI1DAINMW44t/S8EDoODGA7Y+f0pXr77S3Bxuv0ysYH+kd6y5kItRHBhPEvFcRyzkGSocgVg2HejpFvJ/Ad0jCTiBAPJNF+Ab4Vt3AiSMB4IG1UsZQxMlJKqYsdMiZ0f3CEueOMeAYfOX1xDrFSU3oX8d5YInBINcKDfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C8825227AA8; Tue, 13 Jan 2026 08:04:25 +0100 (CET)
Date: Tue, 13 Jan 2026 08:04:24 +0100
From: Christoph Hellwig <hch@lst.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: David Chinner <david@fromorbit.com>, Carlos Maiolino <cem@kernel.org>,
	Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build warning after merge of the xfs tree
Message-ID: <20260113070424.GA25939@lst.de>
References: <20260113155825.1ae96221@canb.auug.org.au>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260113155825.1ae96221@canb.auug.org.au>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jan 13, 2026 at 03:58:25PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the xfs tree, today's linux-next build (htmldocs) produced
> this warning:
> 
> block/bio.c:329 function parameter 'bio' not described in 'bio_reuse'

Sorry for messing this up, but I promised a resend for an updated
kerneldoc anyway :)

