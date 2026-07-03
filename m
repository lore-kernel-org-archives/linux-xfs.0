Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7869A3B27C5;
	Fri,  3 Jul 2026 12:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783082028; cv=none; b=sxwNi7SLvoHledf73Q8VsladLxTnd0srQ69Tbdi4DmCrSnIoel5NimAKDE9B6fowUiQKb5QP27nwGYzFCjS5iZM2LWYj0I9dh9gfgoUvbEaeyJXHh1ou64UG07IQ+r/OrqmHypc+sl1U4F+EyHV+NXJDQy3e9oUeSWqtV3x/5bY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783082028; c=relaxed/simple;
	bh=CLJdGH4Co00ExAveLH0+6vn6us3cXXNs/bGoDaaxJIY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PsWLLkkjIitGSWIS7AuVG8Ch9/YIwr7OepmqlIuMkdFg4aM3nCQyxdmE/LBlqLNmdQIQbr3dYz6kZM8ehowcjwjP9iDsdqV+M02VTW9/cErWb0OwOS6MR6vPBeJL+G9qaIrNdr2o4QFdaQoDK5USv3QcxWVjXxXU4ie3J+DIrck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 2A2AE68BFE; Fri,  3 Jul 2026 14:33:41 +0200 (CEST)
Date: Fri, 3 Jul 2026 14:33:40 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Joanne Koong <joannelkoong@gmail.com>,
	brauner@kernel.org, willy@infradead.org,
	hsiangkao@linux.alibaba.com, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org, Carlos Maiolino <cem@kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 02/18] xfs: convert iomap ops to ->iomap_next()
Message-ID: <20260703123340.GB25849@lst.de>
References: <20260701000949.1666714-1-joannelkoong@gmail.com> <20260701000949.1666714-3-joannelkoong@gmail.com> <20260702140301.GB21339@lst.de> <20260702164806.GJ9392@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260702164806.GJ9392@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jul 02, 2026 at 09:48:06AM -0700, Darrick J. Wong wrote:
> You /could/ use a bunch of fugly macros to simulate a default NULL
> iomap_end_fn parameter.
> 
> #define __default_iomap_end(a,b,...) b
> #define default_iomap_end(...) __default_iomap_end(,##__VA_ARGS,NULL)
> 
> #define iomap_process(iter, iomap, srcmap, iomap_begin, ...) \
> 	__iomap_process((iter), (iomap), (srcmap), (iomap_begin),
> 			default_iomap_end(__VA_ARGS__))

Don't go there.  These variable number or argument macros are a
complete pain to undestand and generate horrible compiler warnings
whenever someone messes up their first attempt at writing some
code (guess who never gets the first pass right? :))

