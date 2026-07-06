Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC3FE381AF;
	Mon,  6 Jul 2026 04:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783313993; cv=none; b=q6S3r4umgZQrIrAx7pdjhysih46iQbh1ls2BPd2KwfkAhzomV0abQ2rpHHBcNH1vcJbKGgs7W/V+rP01jpI33j710PSc576wG99iRkokVWEEXlS/9PA2CaoRy5VpQxexVZmLUdEkIUywjBzfbgkKq4C+yvdk3VS323OGJSLDEE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783313993; c=relaxed/simple;
	bh=H9Ht06aw6tySuor7rCKdBxu1z4VulN8iC2a2eWpaHNw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KmclO3iuCHLqccI8VJ9xnYd3xdy+IXIjqTApdenHM9Z+i1K4H4rATsiPqfKYsXEnvz8+mkHTwmq5Z01icCdQgqgWsNUo9XaP7DPoNHQ2ohhVunjTYCG/271ckPsYakuuvB95yV1+PIygiywRvEHt8QXcUypACWkOJIEVH43erPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 64ADF68B05; Mon,  6 Jul 2026 06:59:48 +0200 (CEST)
Date: Mon, 6 Jul 2026 06:59:48 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Joanne Koong <joannelkoong@gmail.com>, Christoph Hellwig <hch@lst.de>,
	brauner@kernel.org, willy@infradead.org,
	hsiangkao@linux.alibaba.com, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	"open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 18/18] Documentation: iomap: update docs to reflect
 iomap_next model
Message-ID: <20260706045948.GC23106@lst.de>
References: <20260701000949.1666714-1-joannelkoong@gmail.com> <20260701000949.1666714-19-joannelkoong@gmail.com> <20260702192658.GN9392@frogsfrogsfrogs> <CAJnrk1YZQOQ0D6p6qYx1BPvKQaDgZsrKzLbGZzaH8tUkj_OoOQ@mail.gmail.com> <20260703020020.GS9392@frogsfrogsfrogs> <20260703124331.GA26440@lst.de> <20260703161147.GB9407@frogsfrogsfrogs> <CAJnrk1Zv8FEAD+T=1+ZLi6q8ztHVY1zray019QNdeLpYjTNQAQ@mail.gmail.com> <20260704043808.GC9407@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260704043808.GC9407@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jul 03, 2026 at 09:38:08PM -0700, Darrick J. Wong wrote:
> Oh right, iomap_iter::private is a private pointer that the filesystem
> can sometimes set to pass per-file-operation data to ->iomap_{begin,end}
> ... that is tortuously extracted from the iomap_iter via the iomap
> pointer.
> 
> iomap::private is a private pointer that the filesystem can set to pass
> per-mapping data from ->iomap_begin to ->iomap_end.
> 
> IOWS, never mind, I'm babbling nonsense.

As did I, so you're in good company :)
