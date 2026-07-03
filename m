Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE1B633C192;
	Fri,  3 Jul 2026 12:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783082617; cv=none; b=VYFQZPRVeJP1/EuSWuoTv+MyMVHrrPVdRTl9aO1/w0cxkFnsshpz5ts8QgnKlz0zxFVRAG+Hahvpoo/qPuLXRXATobx7DnN3US+snCi42hXe3slQeZCRp5fjGzSw0VTGr5nOd40CEJthsu4i6MP+iXH5KFaQgHuvd6pxp/+B+Zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783082617; c=relaxed/simple;
	bh=krMCldtrNIYbQHPzZ0QwSuHzg/lM1DrQFu6P9QC+DBg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nmy0e2CDD7F7oGB8/KUqNdFSnDIR0OGBxje8dLkoTJp9N1/2mbCpw7hHtwKvMVcJ2ZobVyL+Qamd7HF+t12u7381gu7dh3Z5W2olvKi++Bev04LM5F63aZUY6FG4Ep6UFxDkp+PngdFfvz4MdyLbCLuwXKPN9oozS+V4uxBjo3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id C058368BFE; Fri,  3 Jul 2026 14:43:31 +0200 (CEST)
Date: Fri, 3 Jul 2026 14:43:31 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Joanne Koong <joannelkoong@gmail.com>, brauner@kernel.org, hch@lst.de,
	willy@infradead.org, hsiangkao@linux.alibaba.com,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	"open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 18/18] Documentation: iomap: update docs to reflect
 iomap_next model
Message-ID: <20260703124331.GA26440@lst.de>
References: <20260701000949.1666714-1-joannelkoong@gmail.com> <20260701000949.1666714-19-joannelkoong@gmail.com> <20260702192658.GN9392@frogsfrogsfrogs> <CAJnrk1YZQOQ0D6p6qYx1BPvKQaDgZsrKzLbGZzaH8tUkj_OoOQ@mail.gmail.com> <20260703020020.GS9392@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260703020020.GS9392@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Jul 02, 2026 at 07:00:20PM -0700, Darrick J. Wong wrote:
> The ->begin method can still set iomap::private and the ->end method can
> dispose of it, right?  Oh, wait, no, that doesn't work because you're
> talking about ->begin/->end passing something to the next ->begin.

Should we move ->private from struct iomap to struct iomap_iter?
That'll deal with the constness and the fact that private data
really is a per-operation thing.

That also reminds me that now that we actually still keep the low-level
begin/end ops we need to switch them to a calling convention that
passes the iter instead of the ugly container_of.  This is something
I wanted deferred until we get the iter conversion, but it turns out
that now leaves them untouched..

> Hm.  I was thinking that the signature for iomap_process could be
> cleaner if you didn't have to pass iomap/srcmap explicitly.
> iomap_process could do the (dangerous) casting from the (const struct
> iomap_iter *) to the (struct iomap *) pointers before calling ->begin
> and ->end.

I don't quite understand those part.

