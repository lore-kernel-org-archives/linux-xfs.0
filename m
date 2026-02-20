Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 643E934DCE4;
	Fri, 20 Feb 2026 16:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771605779; cv=none; b=dttZnE0zQVE7AKp4OwAtC9G1ynoEgm4Pyd1Do5u4CP0J+MMUQncODIfN07vQqvde0+dhJ5NYFfLECkjkiPTkdRAX0SS+YgYr4FWP8DPhiqBIvVBc1aCcCQ4U/naTVgcCFKl0L9/OY++8o0UuejWPw+oGOXSbiXIhGFyevxnSJlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771605779; c=relaxed/simple;
	bh=G/ShcUtWenoizu0ggf3gy/Kmn+L8arABOtvZeoHmP9U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UNtgBjZRwIXG7od7+6IzXeIitnwDsmNmxTHi63JYTmd1UPZMDvIfAN5Ro8LbDnUpMs1RE3krCdq886NXZk1aS7J0JAlDtJDbZ/xA8vyB8AZEH7s4VqvpXlCUDpNZzUTx2rHAaNAQzoijuYrWuRzjlXZy7eayD+C0Vx7a16zFaes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Fw6+HNWg; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Fw6+HNWg"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=G/ShcUtWenoizu0ggf3gy/Kmn+L8arABOtvZeoHmP9U=; b=Fw6+HNWgtJ4WhDUTGt/0H3Wh6D
	nL6DLKdA5A6+mJwlwtW8OzuCyl4WzUPdQSynchxOLWYKN1aCzqbktRTL+t7VqvvT1Zp3STRSU5JeU
	fLgd4H7MMTzZcJuu/v9tEsT7er5AoQy/ZKDJtnaLD2A6edEDqtaybZG986ao+CJFAjid04Z49bakm
	+rVE+kO6+cKdLGPMcgCRPnmBiySovPYj3Iay3I7Wv9l5UBQs9y9qwGkefL5Gh31LZjNjVePCxFnMG
	rGO6UoYydYCiPxZGmiqV6lrjPXcA/CCvoaJ/kTVVdGDtQpqIWmB+PmV665O8KGKgWxtJuwjBAyV6t
	iecqSJeQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vtTaf-00000009pGZ-3jnu;
	Fri, 20 Feb 2026 16:42:53 +0000
Date: Fri, 20 Feb 2026 16:42:53 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Andrey Albershteyn <aalbersh@kernel.org>
Cc: linux-xfs@vger.kernel.org, fsverity@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
	djwong@kernel.org
Subject: Re: [PATCH v3 08/35] iomap: don't limit fsverity metadata by EOF in
 writeback
Message-ID: <aZiPDWBn9-1AIQAi@casper.infradead.org>
References: <20260217231937.1183679-1-aalbersh@kernel.org>
 <20260217231937.1183679-9-aalbersh@kernel.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260217231937.1183679-9-aalbersh@kernel.org>

On Wed, Feb 18, 2026 at 12:19:08AM +0100, Andrey Albershteyn wrote:
> fsverity metadata is stored at the next folio after largest folio
> containing EOF.

I don't get it.

Here's how I understand how all this works:

Userspace writes data to the file.
Userspace calculates the fsverity metadata.
The entire file is fsync'ed to storage
The fsverity flag is set and i_size is reduced to before the metadata
starts

At no point during this process do we need to do writeback past EOF.

What am I missing?

