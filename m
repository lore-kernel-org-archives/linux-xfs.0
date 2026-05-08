Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D2E522759C
	for <linux-xfs@vger.kernel.org>; Fri,  8 May 2026 08:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778227861; cv=none; b=QOGVOOHHBPvjVeUSmXtJbAHHOpactDyI8Beus11RgfumqccHS6htGXgCr9V+EBQ1ji9OI485BE9/rLz32MEBglzDcHSX6MWUWzmmJ4uyUlXtijwSGu3+hRSDGWE/uDeFeZSV856AzNYDm22DiJXDqbwXmurCf+BtKMTTONc+e2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778227861; c=relaxed/simple;
	bh=i9rGIztp2GHSuF3aEaa5c8pM8y1W/aQ6fVmvelvkIyw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IV3CUHMOfXyb7CIQUPz/C8UdB5p0R68PQGxmJnVY9xAgPU5jVhPN5Yn+4N+ngEzLmvibv2YZn6JFrX5DWtRc53eaNy6LN6E71luCzjnYwY6MZpGl+XRmwruun35D3ZHp93aIC2YwrVpk2TlBUl27oK1sDZEozhDd2FgH2ui5fv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id B960968C4E; Fri,  8 May 2026 10:10:47 +0200 (CEST)
Date: Fri, 8 May 2026 10:10:47 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Pankaj Raghav (Samsung)" <pankaj.raghav@linux.dev>
Cc: Andres Freund <andres@anarazel.de>, linux-xfs@vger.kernel.org,
	Carlos Maiolino <cem@kernel.org>, Christoph Hellwig <hch@lst.de>,
	Christian Brauner <brauner@kernel.org>, gost.dev@samsung.com,
	p.raghav@samsung.com
Subject: Re: Increase in XFS journal flushes with (direct_write;fdatasync)+
Message-ID: <20260508081047.GA19748@lst.de>
References: <7ys6erh3nnyeerv2nybyfvp7dmaknuxrlxv74wx56ocdothkc6@ekfiadtkfn2r> <paibiwpjxhdmfrjq3tn7gbdvgtarm4yvtid7qu5zchhyptdlhx@w7lwvjhevsj6>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <paibiwpjxhdmfrjq3tn7gbdvgtarm4yvtid7qu5zchhyptdlhx@w7lwvjhevsj6>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, May 07, 2026 at 10:34:43PM +0200, Pankaj Raghav (Samsung) wrote:
> This fix seems to reduce the number flush calls and fix the regression.
> @carlos and @hch let me know if this is the correct fix or I am just
> suppressing the symptom and not fixing the root cause.

This looks good from a very quick look.  It'll need testing, a line
length fix and preferably a comment as a reminder and should be good
to go.

