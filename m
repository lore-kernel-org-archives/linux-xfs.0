Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5986E43AA5
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 16:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713284892; cv=none; b=VYKVl1t2tI6M7CbpACzN21A0Q9Sipc3scdstP3SYaL6dzlMyJY7QBfUqVD+FYHs37Z33EwWvpC6U9OJj6DmMUYlEn3cQvMv3zWUNEKdCg4Al5Mqq9Fg8w400FUADPJi8sBKMjE0IO55ZP89vYY4rywrTf+oZhwD/6rnPOzFZo6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713284892; c=relaxed/simple;
	bh=LN35RBXBzv5j+IflOBzzeMv4pA4HDyQuIcQvcu5Cm/g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mCYrNdDg4FJpCtoBiReZ7C1HoVYE/sLtow0LWRewO0NCAjuGPYGrzu0sqjNluRPpq+YuJzzxxzfP6OzJoS86/GzEwFEXfYegsoWsdsEzAO21CAQEVOKVe+cwgmJghOnFG1Nxv/qTbQEbCLXW3Uhia8Sle8264oGbm+wh2uWrnrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=DHhBFuVi; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DHhBFuVi"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=LN35RBXBzv5j+IflOBzzeMv4pA4HDyQuIcQvcu5Cm/g=; b=DHhBFuVilBR89QrYGbN6tR9djn
	xlU5IvahAgkgUvoLpKQuWi3mjDvjG4jLHILqOIVyTA5m4zucfptXE1Mr1eEA8jRuiVfDqUY5FB3jo
	heXnDVvvBb3psqZxV7AWPqW6WAJhhzFxRjhx1C6UHRn81DY3dkrWbxhR7dHFsnLYlU4yCTSCv3DC0
	A6DDjjcu5EaH4Z/UpfzXlTyBvAJX+l6IaB1VF2Sp1C/KcaPeYdidLRvq2i2KAmLtOg5noEML/16L7
	fXIj0/eCG3fZFjirN8ath5JR4ZqtuECjrDSuprfdwVXHNMIBvOf23nB9fcUTESV2ELrgmnNqW2JU+
	cABuEnxA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rwlfF-0000000D14I-0oCZ;
	Tue, 16 Apr 2024 16:28:09 +0000
Date: Tue, 16 Apr 2024 09:28:09 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, allison.henderson@oracle.com,
	linux-xfs@vger.kernel.org, catherine.hoang@oracle.com, hch@lst.de
Subject: Re: [PATCH 03/17] xfs: use xfs_attr_defer_parent for calling
 xfs_attr_set on pptrs
Message-ID: <Zh6nGaPvk3tKf3gg@infradead.org>
References: <171323029141.253068.12138115574003345390.stgit@frogsfrogsfrogs>
 <171323029234.253068.15430807629732077593.stgit@frogsfrogsfrogs>
 <Zh4MtaGpyL0qf5Pa@infradead.org>
 <20240416160555.GI11948@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240416160555.GI11948@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Apr 16, 2024 at 09:05:55AM -0700, Darrick J. Wong wrote:
> I prefer to keep the pptr version separate so that we can assert that
> the args contents for parent pointers is really correct.

We could do that with a merged version just as easily.

> Looking at
> xfs_attr_defer_parent again, it also ought to be checking that
> args->valuelen == sizeof(xfs_getparents_rec);

Yes.

