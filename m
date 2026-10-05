Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9832A47F2FA;
	Mon,  5 Oct 2026 13:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791206181; cv=none; b=OtdpcGw7AlficSXdJGX/WiLoIVPnW+0CNUgCzw1RLRKNDh/ag+Mx0xLo/vKwQpYp5P6E+zyjBY1gEiYhEK7Lzqdioizkkf1Wuwc2z1nH4YI4cJF5I4XCtHWbbyZBpGAurU3blLR1HU580ke44xwH+ucioyfJ/CL6GrPwfN78GjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791206181; c=relaxed/simple;
	bh=Cz24RSeIYnIWe1CX68kbv2pThBUCLp49BRwFlWIRYr4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dIuSKiGjzbxZBh4p7cLp0o3RH7Vq+zfFhRGspdmcOsnZOu+98hmZ+Ma0Esw99FDqILLtkjI453FFtMXilakVM5DCcxEuXDu/UatBlOjevdbTSN7rOnF3Vdp6xtPvZo2CzEXlNeJAPisUDSOX2umYh8LPDHaFzj6FfJQCo5VguIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id ED6C768AFE; Mon,  5 Oct 2026 15:16:14 +0200 (CEST)
Date: Mon, 5 Oct 2026 15:16:14 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christian Brauner <brauner@kernel.org>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 21/21] xfs: enable RT data checksums
Message-ID: <20261005131614.GG26805@lst.de>
References: <20260924100032.2733101-1-hch@lst.de> <20260924100032.2733101-22-hch@lst.de> <20260929012755.GC2705364@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260929012755.GC2705364@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Sep 28, 2026 at 06:27:55PM -0700, Darrick J. Wong wrote:
> On Thu, Sep 24, 2026 at 11:59:53AM +0200, Christoph Hellwig wrote:
> > All mandatory pieces are in place now, allow mounting.
> > 
> > Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> Looks good.  I'll try to cough up an amendment to the ondisk metadata
> documentation to go with this.

I was going to do that myself, but if you can afford the time that's
even better as that now means at least two people understand the format,
which always is a good thing.

