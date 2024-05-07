Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F81177F12;
	Tue,  7 May 2024 06:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715064028; cv=none; b=ZEKtLsosgu8seq4BkXIvYAPUl6T+R/l1ON6PKfiIc/tDitKt2Mip1xe1yccgpiXA8yRoYTG6SbiFKAXkh+WfdwEMdbB1WQ0Z12tymxIVUNH+0BTmDRvI8wYkR50I+gNhbMP+ieXDico/YxVyxRzQePZ7ekSJ7biwfJt0IGShOjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715064028; c=relaxed/simple;
	bh=C2mqlbjChb+Zb4jizOt6/qiS5xaLrNfrCbMuByqaQFM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=usPp0xT/8AtVdnGtKnhSu6qaBCYazOxHlsKmBmfO99j2DFr6VcuysP8P4L49G2CGKgOpiPO/36G8ayVJ6REErSP4285Od8hL/y0wH1BwCvpgCS2EdZxrEiYFexuEWbLWFOseeHct4Hs1Lqic90Jm7EgpKd58YLQ6cfPnxwCmZGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=m/KDuJpq; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="m/KDuJpq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=WuIN6nq3/l8uVmPgn8xJBtIN3q6SKM4SUD2H711BSy8=; b=m/KDuJpqz7ZZkloXUJ4oV1/tMg
	e9CfJZ6n0M8BcvcddzDeJ/7/YSmZaMH3FzXBFQEa5U5pPtyQkWiXw8YHjzBZHLiUp9TVmyyTcjS1l
	GCR44wkemCeDjQ70sMYUnQbt8ckhIsnoRvy/1Q8ZonIiXgpO+dGckhZiytPSTyiS3s/gElCf+rKPv
	p44Q+xLijOz3bl/Gt1+/BWYL88cKmRgKSt5fqhysBgtFM1YNicOfNnnksovgse0pbphft3yzCDM3N
	oVQDSAp6KXtgPjq32cQz21jcWC2bftzoc8IvueuyHuKarH6JWHrHbz+hFyshNL5zbFeOi4Cfclamp
	EVkLXtEA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1s4EUz-00000009s5C-2ZTA;
	Tue, 07 May 2024 06:40:25 +0000
Date: Mon, 6 May 2024 23:40:25 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	"Darrick J. Wong" <djwong@kernel.org>,
	Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] xfs: check for negatives in xfs_exchange_range_checks()
Message-ID: <ZjnM2QBtL68KJtio@infradead.org>
References: <0e7def98-1479-4f3a-a69a-5f4d09e12fa8@moroto.mountain>
 <ZjnE2SjU7lGD0x5A@infradead.org>
 <d953392c-44d1-4c9f-a671-b25803181b97@moroto.mountain>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d953392c-44d1-4c9f-a671-b25803181b97@moroto.mountain>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, May 07, 2024 at 09:33:40AM +0300, Dan Carpenter wrote:
> On Mon, May 06, 2024 at 11:06:17PM -0700, Christoph Hellwig wrote:
> > On Sat, May 04, 2024 at 02:27:36PM +0300, Dan Carpenter wrote:
> > > The fxr->file1_offset and fxr->file2_offset variables come from the user
> > > in xfs_ioc_exchange_range().  They are size loff_t which is an s64.
> > > Check the they aren't negative.
> > > 
> > > Fixes: 9a64d9b3109d ("xfs: introduce new file range exchange ioctl")
> > 
> > In this commit file1_offset and file2_offset are u64.  They used to
> > be u64 in the initial submission, but we changed that as part of the
> > review process.
> 
> I've just checked again, and I think it was loff_t in that commit.
> There are two related structs, the one that's userspace API and the
> one that's internal.  The userspace API is u64 but internally it's
> loff_t.

Ah, yes.  The in-kernel ones probably just needs to move to use u64
as well.

