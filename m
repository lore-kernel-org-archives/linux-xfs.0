Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16EF33ACEEA;
	Mon,  6 Jul 2026 03:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783310193; cv=none; b=RuRWLD6CHg3GoKv9+0eTjvric6thsTWuiE84cSebWgAUTrmd4SdxgXlvp/0RlchW6E6PCpYLbD9W6QD7EwMocHeoPfl/A1fw3x6r4hnBKJGPbwa5DLW08H3jEOIP5yBdXSPJaD/qZbbOD1YqjGrgWoRMuI5OJDglRzsTRGmM2iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783310193; c=relaxed/simple;
	bh=tzS/6ZVAUwzIcuvkYueb5+xqBXb7B3vjSx16vXjL2s8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=glGdcz+MR6cKR+GM89NXitW4bUArv3+/PZ4qT0rqMZU0arsUGbR24AJPaXxEPFWI5OtbDNkppEApBmuml7n0zJetYATcmMshSBoy/OOIdkdNVKQvyoKZDE8JTMvgoABnI6DHAHKsjnSHejqqNV8r87MNILYCOBYcv3VXYuOPrIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 069E068C4E; Mon,  6 Jul 2026 05:56:20 +0200 (CEST)
Date: Mon, 6 Jul 2026 05:56:19 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Joanne Koong <joannelkoong@gmail.com>,
	brauner@kernel.org, willy@infradead.org,
	hsiangkao@linux.alibaba.com, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	"open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 18/18] Documentation: iomap: update docs to reflect
 iomap_next model
Message-ID: <20260706035619.GB21998@lst.de>
References: <20260701000949.1666714-1-joannelkoong@gmail.com> <20260701000949.1666714-19-joannelkoong@gmail.com> <20260702192658.GN9392@frogsfrogsfrogs> <CAJnrk1YZQOQ0D6p6qYx1BPvKQaDgZsrKzLbGZzaH8tUkj_OoOQ@mail.gmail.com> <20260703020020.GS9392@frogsfrogsfrogs> <20260703124331.GA26440@lst.de> <20260703161147.GB9407@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260703161147.GB9407@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Fri, Jul 03, 2026 at 09:11:47AM -0700, Darrick J. Wong wrote:
> > That also reminds me that now that we actually still keep the low-level
> > begin/end ops we need to switch them to a calling convention that
> > passes the iter instead of the ugly container_of.  This is something
> > I wanted deferred until we get the iter conversion, but it turns out
> > that now leaves them untouched..
> 
> Oh, you mean changing the signature to:
> 
> typedef int (iomap_begin_fn)(struct iomap_iter *iter...);
> 
> instead of passing parts of the iter as separate arguments?
> Yeah, that would be nice.

Well, at least passing the iter in some form.  Either just the iter
in mutable form, or a const iter plus non-const iomap and srcmap
as suggested by Gao and currently implemented for the next/iter
callback.

> int fubar_iomap_next(const struct iomap_iter *iter)
> {
> 	struct iomap *i = (struct iomap *)&iter->iomap;
> 	struct iomap *s = (struct iomap *)&iter->srcmap;
> 	...
> }
> 
> to simplify the call sites.  The gross part of this is (1) having a
> const iomap_iter pointer to prevent filesystems from screwing around
> with the iter, and therefore (2) the need for explicit casting to remove
> the constness from the two iomappings.

Yeah, if we pass only the iter it'd better be non-const.

