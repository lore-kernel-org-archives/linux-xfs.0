Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B34131E89A
	for <linux-xfs@vger.kernel.org>; Tue, 16 Sep 2025 16:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758040864; cv=none; b=KH+ck4GZRb7YyBiqv3KO8CxyuYdVA5CcaN1a+ZU060p1bQXdnRBCP/gjj5QzvOFrvVpAIXhUFaR+QEPuf7XgOnIClpz/CBjOCk+1CdX+ONe/yEJiY8uw8XwbZ8qfZsbhXOLtMvjgGMzrVt3Y8Zi2CtPGEWZ88vERtu5aZBDoK/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758040864; c=relaxed/simple;
	bh=JG3YhjYFjG9cCusqkFfJxPreLG98Ett02BTq8L8sG3I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RqUNq8ATWMwCfcAkCJ/kskIml+BhlVB6ZdahXdxzkdEfB/2GwZUlwiXiHaehdNrX8hnsFe82OCVVWqakL+FzhM1/xd9orSQKQ+M/nN5Og84VHju8/xICILpqfWaw+FdTthd6djTKPE4kJiKH8gmQoydlBs4cOnuRrOVlS1zfYbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6097A68AFE; Tue, 16 Sep 2025 18:40:58 +0200 (CEST)
Date: Tue, 16 Sep 2025 18:40:57 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Carlos Maiolino <cem@kernel.org>,
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/6] xfs: centralize error tag definitions
Message-ID: <20250916164057.GA4208@lst.de>
References: <20250916162843.258959-1-hch@lst.de> <20250916162843.258959-6-hch@lst.de> <20250916163831.GG8096@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250916163831.GG8096@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Sep 16, 2025 at 09:38:31AM -0700, Darrick J. Wong wrote:
> > + * an XFS_ERRTAGS macro that expands to the XFS_ERRTAG macro supplied by the
> > + * source files that includes this header use for each defined error
> > + * injection knob.
> 
> Hmm, that last sentence could be more concise, and describe what is
> passed to the XFS_ERRTAG macro:
> 
> "...will define an XFS_ERRTAGS macro that expands to invoke that
> XFS_ERRTAG macro for each defined error injection knob.  The parameters
> to the XFS_ERRTAG macro are:
> 
> 1. The XFS_ERRTAG_ flag but without the prefix;
> 2. The name of the sysfs knob; and
> 3. The default value for the knob."

That feels a bit too verbose for my taste, but if it helps I can change
it.

> I wonder if XFS_ERRTAG() should be supplied with the full XFS_ERRTAG_FOO
> name, not just FOO?

I did this initially, but it means very long lines that make the table
rather hard to read.  So while I'm not a huge fan of magic symbol
shortening I think it's fine here because the places that need to know
about it are very confined.
