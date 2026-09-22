Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF6C247291;
	Tue, 22 Sep 2026 05:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790054235; cv=none; b=krDea1+xOEiA0K4k3rY6tZ+QBzKXzLQ7aNejNTFBu+zLxhmZf+kAhiA3I67+uCK+/mV4L3LMDHk+SbmXIEJ0B7+AvR5E1GcKwy8UXdSQsjT6LgrVmOqJhskaiHFRfJCoo4xsFAenzO16DSEJ3T+/3PpmwYqc/yOhQaZGox/dsq0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790054235; c=relaxed/simple;
	bh=ee/jdJCF4YkG5H50vE0B6vJ/8YOesu+YFBDtTA06v4Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UCHP6v+75bfOvaFQ58dKPaNKCbn/fqN0KOdfjaHwz8jqN9o1jyo+ME6yJnYUKFty6y4ZNKBGAxT7CpY54qS9bvJLZIMZm5gqKh5JEGJtqabDJFLFUgr9Q2EB9qUVg1n26BIcApKt3bQulbpnJq3C3uUgdqjq/PE0KQ2rptQBYpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Gx8QgeyU; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Gx8QgeyU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=XQC20JC54+fehdzydqxXz7j7xDef2UWpqHdZPnhk3zc=; b=Gx8QgeyUKsNtVmsKM655eENqfy
	LucrK0NRoVXfO3VTMQyqcJTnqJzNDTXwOgzzjLs82jXVXI83MOsjMqrny3UFbvLwvYdm6hFk9MVKw
	osyGz3tgZQjbWIwbfJTTs+m2UwswmrpI/WnXaZ8RDsrCaDUn4YOqD/uYtFrMTX02UlSUbGNbXup81
	883nKytUt4ZKqEOdW4cjJfPZmOSlhkQtFuqwWNK3mYoA3HEsMo2egr1XHU7/4mDXkO9eb7bUbBnUD
	3nSQ7AT9l1lvBNKmT4ibc5b+3/2cKK0XHO7P7fb5siyJGZk6k5nHHLIe6owRmDOFeYbaMWkL+5svp
	6ZqecNHg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x8ssR-00000004EYh-3pj5;
	Tue, 22 Sep 2026 05:17:11 +0000
Date: Mon, 21 Sep 2026 22:17:11 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: cem@kernel.org, stable@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 04/14] xfs: clean up after failed metafile relinking
Message-ID: <arIPV0aMk6MlHe3v@infradead.org>
References: <178996120463.181988.9152653965555322220.stgit@frogsfrogsfrogs>
 <178996120636.181988.3123812677951717201.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <178996120636.181988.3123812677951717201.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Sun, Sep 20, 2026 at 11:16:01PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Once we start a metadir update to link in a file, we have to commit or
> cancel it, just like any other operation.  LOLLM pointed out that I
> forgot that, so fix it.  This fixes a bug in xfs_repair.
> 
> However, in commit e80fbe1ad8eff7, we made xfs_metadir_cancel a static
> function within xfs_metadir.c, so we can't just add a xfs_metadir_cancel
> call to xfs_dqinode_metadir_link.
> 
> Instead, create a new xfs_metadir_link_file helper in xfs_metadir.c that
> takes only the xfs_metadir_update object, and handles everything from
> start to finish.  This enables us to make xfs_metadir_commit a static
> function too.
> 
> Cc: <stable@vger.kernel.org> # v6.13
> Fixes: e80fbe1ad8eff7 ("xfs: use metadir for quota inodes

AFAIK all this isn not used at all in the kernel, so a stable tag
feels a bit odd.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

