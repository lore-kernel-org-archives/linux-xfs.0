Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35B3927B4F7;
	Mon, 12 Oct 2026 13:06:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791810403; cv=none; b=q6TdYSEX7nDUiso5zS++ss/7W/6R/nW0K+OBOgBSqC3RPJgd/laoZ6Owg2oPuht844abQjuvceFqKYMRWtwOKi25LJlSH55nHySMGWpbRD3T1C5KVmTjZ0H+coovaWnIBwVDq45557fhkdNFk8bo7pM0hv97cvP9rBqv0c7UniA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791810403; c=relaxed/simple;
	bh=qKgS0UeeyGKssHgiIBBGNCrMjOJsl9f6AGxPis4ao1s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OKM0nJKnY/qxK4HhGPe+qlflSKClXAO+rPA2l4qZLN1+Hrv6PMj4sxwAQ3yBnxmyRpmfqujhrtpMl72qEA3P0twwdh0wHvNLjhw543EabL1+2Rra6kGQuviZe/SlwWZ5m+v4Cdn9zrjyFBv/qHxXp6MxYyNBWvEhnCJsA3pThwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lC9YiPvE; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lC9YiPvE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=wPqZLQ++L9TmT/EPslzPQu8/um2VizLlJJKjshC0Hjg=; b=lC9YiPvE7BR6mjs0ybQ/PMxO5n
	kiTEav+VMFyYFvntwU3M0wtaJGIux862eKGNhy+LqUxtmowr6oJDyxijnKq0e31HlzWo8XfnlL26n
	IPkV4ARHGRuiB2s7ikBeEfKF6a0PT7NHK0HvQqvtgCgxKcE5kSRbE7M9lGVWd1Yh6MNswJnFSzVAx
	r1aOS9+nfFJr2E4HarETtUS40SMqpj9UA/0feC0zFnK3l1hABmCvtyQd/VR+g4PHpqrdLdDvFR32b
	PKVGq4qoSvXxkhjHOULIlU1w7gSYQqin/+TOCzfCx1WeSAh8B+JFi3srfDEFlsxfEfp5YWnIG6OrH
	KcfXpU7Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1xGFjl-0000000AWw5-2xNv;
	Mon, 12 Oct 2026 13:06:41 +0000
Date: Mon, 12 Oct 2026 06:06:41 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 02/12] xfs: fix data fork block count check in
 xrep_inode_blockcounts
Message-ID: <aszbYYtRhP2uVU7R@infradead.org>
References: <179178065114.1058326.9639488899319330972.stgit@frogsfrogsfrogs>
 <179178065237.1058326.4317771576749891941.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <179178065237.1058326.4317771576749891941.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Oct 11, 2026 at 10:56:15PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> LOLLM notices that for non-reflink realtime files, the @count output of
> xchk_inode_count_blocks includes both the file blocks on the realtime
> volume and the bmap btree blocks on the data volume.  Therefore, we must
> compare this value to rblocks + dblocks to avoid unnecessary failure.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

