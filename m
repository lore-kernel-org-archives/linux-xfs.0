Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4F8A156861;
	Fri,  4 Oct 2024 12:15:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728044112; cv=none; b=bQd7o1SsFHjRCAHu7YzabMZY8ODV9JKT4380nnbC0kLuI6GG++DzsKRXSzmP69tMge1p83T1nnuE7tbvS4YZtWZffr6ix3ZZEyVw6A32ZMVDWblowF9lC2ciU9ewUWiBSQr1TZxc0asTzA4GO+qHPUqwkhvi7oo/mDsf8BTqeWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728044112; c=relaxed/simple;
	bh=IHG2rcO6niAgj79p0iS4MJY2rxo4OZlyjNpg5GwV7YI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dMaxM6i6CsR0gw2jz11MgMyv3Gvi3n80AIIou1G+bBOuvdEFqCcEXX09Ug1eSdmEvCFtdGJHt6Q8NEuX8ZnrplyXqGTG3rsgB+o0tbFMb05iSuPmpFo355IPTiSByb8MNsXEXMcPyT4zrciarrw2FVjayySYbPiBoKyk/nrX4v4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=r+llvOsv; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="r+llvOsv"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=nw5UII9YlPkj6j45/pAA7ubQBhrRGKthR1EkfAJseas=; b=r+llvOsvNVnIiYKbA8xEsley8V
	mCvR8043OQuDf6ORA0/apbv7pTNDXEn+G6VIrah18lPf03JW+4Nz+xrYigfutje7LkaY00+7Tk/+L
	xHutqPwWTDO5xW4hVVgi1Re5osh2CCuSphV3ws/kag49PImn9bJeyRCjZfCQ1+mxL6oPsNJXH3Oy3
	k4Ndi73CLTE9aRh3V0JvFuKNCfl8Vqct9otdbd7rJhhSyPDR/NEbYn5eM9XtogbgW3NPwAT8xhHH1
	2IlVWPqrT9j6ZSwi+vtYkEbqthBRkI8z5jqa+VyeZJNYbDfuYcJ2PG9lv4al0SA6/+hw2BIcnq4Jy
	+BkswE2A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1swhDB-0000000CGZY-406v;
	Fri, 04 Oct 2024 12:15:09 +0000
Date: Fri, 4 Oct 2024 05:15:09 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org,
	Ritesh Harjani <ritesh.list@gmail.com>,
	linux-kernel@vger.kernel.org,
	"Darrick J . Wong" <djwong@kernel.org>, dchinner@redhat.com,
	Chandan Babu R <chandan.babu@oracle.com>
Subject: Re: [PATCH] xfs: Check for deallayed allocations before setting
 extsize
Message-ID: <Zv_cTc6cgxszKGy3@infradead.org>
References: <20241003101207.205083-1-ojaswin@linux.ibm.com>
 <Zv6sU5eF4OCPTzNH@infradead.org>
 <Zv+tfQhBdxuownfv@li-bb2b2a4c-3307-11b2-a85c-8fa5c3a69313.ibm.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zv+tfQhBdxuownfv@li-bb2b2a4c-3307-11b2-a85c-8fa5c3a69313.ibm.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Oct 04, 2024 at 02:26:07PM +0530, Ojaswin Mujoo wrote:
> Hi Christoph, actually now that we are also planning to use this for
> atomic writes, we are thinking to add a generic extsize ioctl 
> test to check for:
> 
> 1. Setting hint on empty file should pass
> 2. Setting hint on a file with delayed allocation data should fail
> 3. Setting hint on a file with allocated data should fail
> 4. Setting hint on a file which is truncated to size 0 after write should pass
> 
> So that should cover this for ext4 and xfs as well.

Sounds good.

