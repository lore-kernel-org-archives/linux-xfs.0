Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE3E7364D6;
	Fri,  7 Jun 2024 05:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717736805; cv=none; b=XgAcbc9IZ3n6M6W3TLoNioF5uqEMwmvMVVqdTDxXyXGF8AHtdVJiKjih1cojM6XqgluHWWeTzxqR5syv0Gw5uN3ITF1ShDF2UZB1s9/XFBl3GSp48B9M7SBCGWaxqSE4Nn5IZo2//e+bFjzpGef5xNgyNn1b/2SU2MMvEd8ngzM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717736805; c=relaxed/simple;
	bh=xgCIv2lNu6E4awznXLLv3uIm2OU74VkAN+UvFYeUpAo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OARq2540wc6cCuuy4evxKKEmkJBGQ8AbC/2ZLhmHyXVH+fZhH+lL5EDnvzMAS1BFHVNCpHIScLJ9HFAOcPuIJjbZijAvZ0LXluY5iXgSsNat3gKmk/ajSvtS7LpWvAqjbKAQNsPdKCuiekcnLMkBs/s4d1IQnE6XhGkL3x+QTv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Vdz7X5ZS; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Vdz7X5ZS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=fGdVACJqTMlDqJf/M7MUWEtrjp9vLZpoiOGZVL1AWNE=; b=Vdz7X5ZS/swp+IXTJdzOD0OyIL
	JavKDpV+Wa5t9v9d4+KUBig8tIqAhpsi8eSrFZEz9hO1gnPztz19MBf4rAvwrLyuoyL3SUDOGJCVR
	dkGzClDUsBfPOns0/M383aW4QGqf4geN74U+/JDyF7tSzQ0DSSlgZAkGM8As6K1GS/KxARA/3lKtC
	QnHwUnlpwetYzwc68U/+/rj+RcBBVj8LZjs9tdc1ARfcV5CORxO1buf7ZRp4WsjZcWFaZkh/2LcR8
	U4dji0UGhkxRodl6yN1Q4ZDeMLDfKN53C14V76xQoIFU9yZpS9hNAEcSLA2pOfKOSU0kR93YsumpR
	xuIaeyNw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sFRoI-0000000CRzN-2vYD;
	Fri, 07 Jun 2024 05:06:42 +0000
Date: Thu, 6 Jun 2024 22:06:42 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, zlang@redhat.com,
	fstests@vger.kernel.org, linux-xfs@vger.kernel.org, guan@eryu.me
Subject: Re: [PATCHSET 3/3] xfsprogs: scale shards on ssds
Message-ID: <ZmKVYsgIkh-h5PG5@infradead.org>
References: <171744525781.1532193.10780995744079593607.stgit@frogsfrogsfrogs>
 <Zl6hdo1ZXQwg2aM0@infradead.org>
 <20240605005636.GI52987@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240605005636.GI52987@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Jun 04, 2024 at 05:56:36PM -0700, Darrick J. Wong wrote:
> Not much other than the AG[IF] and log grant heads becoming less hot.
> That pushes the bottlenecks to the storage device, which indeed is about
> 8 per device.  More if you can raid0 them.
> 
> *Fortunately* for metadata workloads the logging code is decent about
> deduplicating repeated updates, so unless you're doing something truly
> nasty like synchronous direct writes to a directory tree with parent
> pointers that is being modified heavily, it takes some effort to
> overload the ssd.
> 
> (Or a crappy ssd, I guess.  Maybe I'll pull out the 860 QVO and see how
> it does.)

Ok.  I'm also a little worried about creating lots of AGs for tiny
file systems.  Then again I've not actually been able to find the code
yet which I should probably look at first.

