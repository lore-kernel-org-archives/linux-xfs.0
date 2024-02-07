Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D56E31EB23
	for <linux-xfs@vger.kernel.org>; Wed,  7 Feb 2024 22:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707345546; cv=none; b=l6BIEAAe24PA9g7hd+cxNC3Kg7d3CTWFHnbDUetO4Kw7zb1eK/NOtkDHO8ETJjaflNeNejX2YpM1BF7pFAaIwInppbBTUYu6R7JUwTSI2nK+F3V3/NUWbeJWREByCu7ucSINYC3thpkYV+YFJIy16qG3mf2bTDrrYzyeThAyOXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707345546; c=relaxed/simple;
	bh=tjjD1i798u5ietaGRZCD1J6vQd1vhObMCyNbB997tJs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HIssvNsliUbvnubBxwHuzBN8joFVbqPJoUn08PQ4KDd8EtoeA22ekgXvLFIiMIuvvBS7Sbo2NwUawPD0BIGXG7/UIjtghVTcKOgFTOvuqIQg82GfVCVepd593EXHORXo/aEg9+fdKnG4mhAnJ0YsWf+2QrgQNwwJ2Ulwes3m0Cg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=F0rjd9V/; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="F0rjd9V/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=tjjD1i798u5ietaGRZCD1J6vQd1vhObMCyNbB997tJs=; b=F0rjd9V/jjIOd/VwvgY/a/8AWo
	kFpYnsbVEgc8Xitln9s65QkT437iy2R4IsXB7Ka5X08dKyNCJjhvUkzphhe4VQEf8vwMnCUBJ1EVl
	3wqlDFGgok3/DxwjGacce2DjiNfmpuGp6sbrbJdUJRO8PsoMrfks56US4x1sk8+SEkPCPLgBgfPJh
	mPdGo1G1/UzvYg/IMs/ZGgHOePnmKh0AA/KgQT8VfiypjxY6sLgnHnvo8rK+smSIxzsCDCI0PVzS5
	4FxBfa4vG0Ao/03mHebPu3RVUcNNar9kCYFpxj8R5YW44w/Qy27jNRO9bkrlORtK/1YB8qKY2noR3
	mTvZhBjw==;
Received: from willy by casper.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rXqZI-0000000GHCj-47OT;
	Wed, 07 Feb 2024 22:39:01 +0000
Date: Wed, 7 Feb 2024 22:39:00 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: linux-xfs@vger.kernel.org, ritesh.list@gmail.com,
	Pankaj Raghav <p.raghav@samsung.com>,
	Daniel Gomez <da.gomez@samsung.com>
Subject: Re: Max theoretical XFS filesystem size in review
Message-ID: <ZcQGhFszPb5TaqA4@casper.infradead.org>
References: <ZcQDrXwyKxfTYpfL@bombadil.infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZcQDrXwyKxfTYpfL@bombadil.infradead.org>

On Wed, Feb 07, 2024 at 02:26:53PM -0800, Luis Chamberlain wrote:
> I'd like to review the max theoretical XFS filesystem size and
> if block size used may affect this. At first I thought that the limit which
> seems to be documented on a few pages online of 16 EiB might reflect the
> current limitations [0], however I suspect its an artifact of both
> BLKGETSIZE64 limitation. There might be others so I welcome your feedback
> on other things as well.

Linux is limited to 8EiB as loff_t is signed ... I don't want to introduce
lllseek() to expand beyond 8EiB; I have reason to believe that we'll
have 128-bit registers in relevant CPUs before we can buy reasonably
priced arrays of drives that will reach 8EiB (and want to turn those
into a single block device).

See my Zettalinux presentation at Plumbers 2022 in Dublin (and that
reminds me, I really should do something with zettalinux.org)
