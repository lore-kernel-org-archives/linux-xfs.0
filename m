Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F1F211704
	for <linux-xfs@vger.kernel.org>; Wed, 16 Apr 2025 16:27:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744820831; cv=none; b=HIaEBiprnPUUvX9F22rYePlPbhp6ZvJyiEBKY5lh33n2JEVDEXE5sAuOSLhyvvsWHYQ/jtMU6L5ng+6MUg+8dZ5uDj8yZDHlRXujXsi+Rhmz4MSCBY9Qub7oosAsDT3YFTavCIKz2XW9lmbndLn+NfkGd/CiJF5y1M0+Tn+xkPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744820831; c=relaxed/simple;
	bh=pG8T3rB8EFhQI6VzqdQJuwKrllt9Wp04UgOu1lak1Vw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=E4d6k59OBiRb5541R8k/E610/rzhhY6w/XLRHfx6YtAK12bakIiPANlFBQLdZyabIWGXH2wkXG0up1NnXbcJfA2mZ2ypksJV4HuNFxO5SapZVmt1ghNA/R7QTjJ/Y1KDdpSDX0PgPyQoMSb/xQi9tM3c7xxHUeEescRAYb/khBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=css8Ezya; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="css8Ezya"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86C1EC4CEE2;
	Wed, 16 Apr 2025 16:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744820829;
	bh=pG8T3rB8EFhQI6VzqdQJuwKrllt9Wp04UgOu1lak1Vw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=css8EzyaA6HuFbDRyEIk3miduXfkZt5eKad6E1btn6EGwOxx2S57uaaQtMYex9ioJ
	 pvlRwBN7+6ig4VBmwZDyxRiaBTg5uQF7wf2crr3kgw38o+xTR3ZpLmN973E0aq5RPX
	 cKPtyHmsh+FPYnHwkcsZRHWxvcO6ij6TALZcZmbbWTg5PkEMc5YjMoYzczlT8NESZz
	 bArCqyCZRm54QyghRs36k2UCzZrboWKNX7yA90oNuoSX4OgZcDCUSI1gqljnnHtfvT
	 2Q8pZGeQ1mEIxQRRGVVgCjeR7UuUqQOL9QJYK/i44ohT7JO1lFrhgioyNGVltJCvmP
	 IUMkIme6BOLKA==
Date: Wed, 16 Apr 2025 09:27:09 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, xfs <linux-xfs@vger.kernel.org>
Subject: Re: [PATCH] xfs: fix fsmap for internal zoned devices
Message-ID: <20250416162709.GK25675@frogsfrogsfrogs>
References: <20250415003345.GF25675@frogsfrogsfrogs>
 <Z_8zvnmHAYewIP_l@infradead.org>
 <f0m37ft7elImOolijMp0OvKgJ6Xh-5QafcNweho4vs9gaFtKbw4lNH4pPJx6N1gd-z8Dorq4iIshP1CQ5JcNBg==@protonmail.internalid>
 <20250416161057.GI25675@frogsfrogsfrogs>
 <2jqrlf3kiyuzsu37ih7hbenxbhiboz4h4jfq2xyibtufkmw6ua@zytdh6nt33tq>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2jqrlf3kiyuzsu37ih7hbenxbhiboz4h4jfq2xyibtufkmw6ua@zytdh6nt33tq>

On Wed, Apr 16, 2025 at 06:26:03PM +0200, Carlos Maiolino wrote:
> On Wed, Apr 16, 2025 at 09:10:57AM -0700, Darrick J. Wong wrote:
> > On Tue, Apr 15, 2025 at 09:36:14PM -0700, Christoph Hellwig wrote:
> > > Looks good:
> > >
> > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > 
> > Hey Carlos,
> > 
> > Can you pick up this bugfix for 6.15-fixes, please?
> 
> Already picked, it's in my queue, I'm pushing it tomorrow morning.

Ah, ok.  Thanks!

--D

> 
> > 
> > --D
> 
