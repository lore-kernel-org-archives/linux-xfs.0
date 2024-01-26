Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34ED81DDDA
	for <linux-xfs@vger.kernel.org>; Fri, 26 Jan 2024 16:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706286118; cv=none; b=g1tpAZc1DNmoqLqytvyUzMiAOpJtlkT26qzL7OfEoEeXXv/Wy1GBG/AYn9GVxqXbDMVto8D8nikBCabIPb3rmWa7ahmZ2N+gUlSYl193Z8n36vX+LFIuGCYyvP+c5EKhqYw8+RwjegMpzk78agLfKJZFCwdLhO7eB5Ng1tdpFO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706286118; c=relaxed/simple;
	bh=vhJpAolHpiTF5WRtSWb5/spCGmF5yTEX3VPAXWhZklo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LM0lwR2eHlncolevwoVRxNgISS5evUJSObqfylOBGGXcmub1jwsnI7e/qMendpUBcoPSVbapRLSqa9c8mwoSmJ57c4tRntjWMftyh+E7Enx+QGl4yuev7mp9uIHkX08TbxotiMeF27rwLCOKpesplr5RRyJMwxUVtIKVawhimZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=L8Zuw8D+; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="L8Zuw8D+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6Eq5PV0JObRglyH9Vv+nr1C+9HbTQJe9ICOwY4GJBso=; b=L8Zuw8D+uOFKLKPcyh484x55+K
	c9IpxJJcx99wyvGmy0INiMJlC8QUlzZpTxH3hZfkf/K9FqvwUt6O0avTqf31U8TttnkvGJNLOGH8d
	C8mgSP+HZRn5xhApuA+xeK0/RaIvj0G1BNDH6sKwpseXhIhpPXEwl4/z5KqYeaMoQ9zcVL7iItJkg
	5yAxl5FklBJwxE6f49vLYAhCk8y5xg+/CsEc79yOoJqaJMqZ4y1YkyyKd89JhOQQWOtY71ta1QfvR
	TxXJV777sXZPQ15QYTLf2//FxhOmacptfJZc7QAyIMIPed8YKkWQ0PjmDtFpvp2hq41Z2dhhwXfzk
	QBHtrHsQ==;
Received: from willy by casper.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rTOxk-0000000E9Uw-2H7S;
	Fri, 26 Jan 2024 16:21:52 +0000
Date: Fri, 26 Jan 2024 16:21:52 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 09/21] xfs: remove the xfile_pread/pwrite APIs
Message-ID: <ZbPcIPTFX_XpKIhw@casper.infradead.org>
References: <20240126132903.2700077-1-hch@lst.de>
 <20240126132903.2700077-10-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240126132903.2700077-10-hch@lst.de>

On Fri, Jan 26, 2024 at 02:28:51PM +0100, Christoph Hellwig wrote:
> +++ b/Documentation/filesystems/xfs/xfs-online-fsck-design.rst
> @@ -1915,19 +1915,13 @@ four of those five higher level data structures.
>  The fifth use case is discussed in the :ref:`realtime summary <rtsummary>` case
>  study.
>  
> -The most general storage interface supported by the xfile enables the reading
> -and writing of arbitrary quantities of data at arbitrary offsets in the xfile.
> -This capability is provided by ``xfile_pread`` and ``xfile_pwrite`` functions,
> -which behave similarly to their userspace counterparts.
>  XFS is very record-based, which suggests that the ability to load and store
>  complete records is important.
>  To support these cases, a pair of ``xfile_obj_load`` and ``xfile_obj_store``
> -functions are provided to read and persist objects into an xfile.
> -They are internally the same as pread and pwrite, except that they treat any
> -error as an out of memory error.
> +functions are provided to read and persist objects into an xfile that unlike
> +the pread and pwrite system calls treat any error as an out of memory error.

It's a bit weird to refer to the pread and pwrite system calls now.
I'd just say:

+functions are provided to read and persist objects into an xfile that
+treat any error as an out of memory error.

I wonder if we shouldn't also change:

-Programmatic access (e.g. pread and pwrite) uses this mechanism.
+Object load and store use this mechanism.
