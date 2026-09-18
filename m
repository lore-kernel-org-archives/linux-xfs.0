Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E89A4E4302;
	Fri, 18 Sep 2026 11:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789730209; cv=none; b=EMLJ5W/vVzWewmPpDCJ1zvDSCbZxBx1Qbube4BDeV5FXBu56gKOHB8V8/Ta6tRld2T4WsHNR8pvk2kVoPXTu8BKwTXbhEf8sLcRJJEKKLJ0WDJdc+ikbh6IkbVsdr5qNZbh7HJ0Nrx2qDdOtdu9AT0tpWGVW+R2T/QXNPA7BtYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789730209; c=relaxed/simple;
	bh=+QPM9RAzDnrAzUPQMgUBgpfhbSWglRjQvNnPQ++gRBc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uNFsuYZzEJOkRMgS5HsK7KBBe7C2LH06yo7RM+Ts0b6b7Q4xHnhJ17WliVqM9cey51ZQCilFVqAtan+sWmN/Xl/cW+ovJ+XsjzFGO61Kazxw9vWU23pqzBCZKF5w6dFdYoKeKciK9Qk7Agxs8xZyvCvOEwn5iHOl/iC1v5abuUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=PjkcvBhx; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="PjkcvBhx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=x77G3CVaJyxKp4fAHlS9sAQa88nysPfN50+PoRK8Zvk=; b=PjkcvBhx5loAG0ay8nQTiq7R1/
	WP14xLTb+wHZbnww6bMJoLSeWn8M68JXLZ9X59VsRDO9EKWzw7nMY6Rlvq41+Co3IoLHKP/PQTYAd
	eoGJByFaIoNJ6fshTMdFlqDyPncP8bbj6k/oH7D6cpxfls8wW2q9EkE41OzwR53wzzERTCdSnZrgi
	WCtLBfbrgzCRoBYRj0TiiMs/JSMT5g1x2YLthiigZcsDt51OWwnqS2e+bGJY+KDNBZPpHVHdJRrCo
	sFpbv/RanOdlxHi5DbxSHGtNwxY9xQD4tOU0NS894qoKHD51no1A6CHHqjPZ8aJyeiQlOvuaiRqPA
	tm41zjKQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x7WaE-0000000ECn4-2dga;
	Fri, 18 Sep 2026 11:16:46 +0000
Date: Fri, 18 Sep 2026 04:16:46 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: Lalit Shankar Chowdhury <lalitshankarch@gmail.com>,
	"open list:XFS FILESYSTEM" <linux-xfs@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xfs: replace kvmalloc_array with kvzalloc_objs
Message-ID: <aq0dnoWhkq9JZkiu@infradead.org>
References: <20260917200835.31027-1-lalitshankarch@gmail.com>
 <aqzHPqgh-rKqHRo-@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aqzHPqgh-rKqHRo-@nidhogg.toxiclabs.cc>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Sep 18, 2026 at 07:16:32AM +0200, Carlos Maiolino wrote:
> On Thu, Sep 17, 2026 at 08:08:35PM +0000, Lalit Shankar Chowdhury wrote:
> > Replace kvmalloc_array() with the more concise kvzalloc_objs()
> > implementation.
> > 
> > Signed-off-by: Lalit Shankar Chowdhury <lalitshankarch@gmail.com>
> 
> NAK...
> 
> This is used to allocate composite objects managed through a
> slab cache. This is not for fundamental basic data types....

I don't think so.  While the naming of the helper is a bit
unfortunate, it is intended for allocating arrays.

But this function really should not exist, instead bitmap_alloc/free
should be switched to th kvmalloc family so that it will just work
for large allocations and we can kill the wrappers in XFS.

