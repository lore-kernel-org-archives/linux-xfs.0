Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F02B713CFA6
	for <linux-xfs@vger.kernel.org>; Fri,  7 Feb 2025 05:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738906512; cv=none; b=PgQ/xJyFKh0WLeN+pMcPQ8Y0yAGF9gul4RvsUYE80aTnP372r8F1o3wwpqjyg7uPd5PSCf5JNmcedHqpswxRKQUzsjDCIN5J5rM6F4q0tTjqQauSekX0OlCdNQiemKJO1IL1AlfzIdHn5uqEWC5UEdcdmDt6NSoD2uZOuIuqjf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738906512; c=relaxed/simple;
	bh=A7EetiKAf5uwBqOsgpNy+wf0CiRg4lcvryJ/B5161kM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CNqLXN5HhN1Z5DO/vlvZF8Z0NbywBuN/bcdy5GXkyLfGfutR69gygHI7JqBYIXske35wa/kicvAHsolHNIYHZoxk4hNxNNtDVCZvOKKie2RugaWZa1gsTp4zaebWqHdi11SUb4YlWfiAQMr3lhXG2JPJbfsugxStnk3rQbTJQnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fOjvlJi9; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fOjvlJi9"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=iuXhwTMSR9QKp54GPP5pefAydEkwu6xoccyoJ87o+3U=; b=fOjvlJi90A5IQHywU/9hgRLR+Q
	8KEJCw6apcSTkxmeR88hhRSwnmgzabkIE8DUo+wbD5Rq1ClzPsdq+/UYjqovbJ5yp073UrZ2LLxW5
	s/28pmADza63v04/1taZdMhl9M++sU7yL2tE2qsB9EVbHtaSj6n80EhqvzXeEwbpKmA7E0y4b0bRP
	OLf3CEy+bjG+b5mzhY37NRg3GGVReot8//bD3hBG6lb8f/iJ7YE6kjBIjhxRwYBorRpmXEaZux+qs
	zbHsjWRO/UtdJImssPHzi2C5Uhtr1XehWtSBJVLZrks3ivoUdA8NJ3uu6kGWNh24UxZhehjZf8GSn
	2Izy0h8Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tgH1C-00000008NdY-1zTr;
	Fri, 07 Feb 2025 05:35:10 +0000
Date: Thu, 6 Feb 2025 21:35:10 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 19/27] xfs_repair: check existing realtime rmapbt entries
 against observed rmaps
Message-ID: <Z6Wbjl75Ujt-FoG8@infradead.org>
References: <173888088056.2741033.17433872323468891160.stgit@frogsfrogsfrogs>
 <173888088387.2741033.18417535290564732679.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173888088387.2741033.18417535290564732679.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Thu, Feb 06, 2025 at 02:54:41PM -0800, Darrick J. Wong wrote:
> +	struct xfs_rmap_irec	rmap = {
> +		.rm_startblock	= 0,
> +		.rm_blockcount	= mp->m_sb.sb_rextsize,
> +		.rm_owner	= XFS_RMAP_OWN_FS,
> +		.rm_offset	= 0,
> +		.rm_flags	= 0,
> +	};

No real need for the zero initializations.

> +
> +	if (!rmap_needs_work(mp))
> +		return;
> +
> +	if (xfs_has_rtsb(mp) && rgno == 0)
> +		rmap_add_mem_rec(mp, true, rgno, &rmap);

And it might be a tad cleaner to move the variable into the branch
scope here.

Nitpicks aside, this looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
