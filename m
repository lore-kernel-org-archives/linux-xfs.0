Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 335A04501A
	for <linux-xfs@vger.kernel.org>; Sun, 23 Mar 2025 06:33:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742711624; cv=none; b=CxGUO6EIokewu8/KOLT2VALUGYiNFWnB1sWwKfdca6KFRatsFIITlPn9zUx4cwdLBG8JvRJGR/riAdv9TXB6F/nSkDoRSMy500w164JbF4b8n9kNUvw0LuJPkqLvfeErhvyMrNAAlSl9aGrLIgdP7ezx3LOl7zgSXkK2QToyods=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742711624; c=relaxed/simple;
	bh=EXByMub0y6k09ymvsDyY0OQWp3Pxopx3QkIWHMi7Al4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BlNvsgiGmooRgeXu1Of1jWj8DsEQIU1OL6dHf8erWHhNNw+PwDi3stPGVVqDp3Tx935r34/Yx6vqsa4A1vrC77OLtdyxP4G6z+q1DThLQS0GMWQ8+6wjnEwRvRdNcV3Q3upbCWmy3ReT3cZsFYOPnG3YRBvq2ZVQlhTcVIzmoBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=2K0cscWE; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="2K0cscWE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=goO/d9kbGyhmAAEX89m2xwHyZ3M82kqmjXudGdvZdvg=; b=2K0cscWEpaTPq0lGbdhOPQHz5G
	nHhw8MyFxxn06gsp99foENLPZKb4AkzrEWCb49ZJdA1wu8HTW2viJggTNwQu2VKerMU+SC4t8MX/d
	6Fd2eHaf99Oe/v+FOMf97is2qeO8S4+CPfXvivD8dHTWanSOrbACO/5Vu385dMpCajOXYkNl9YWtr
	lY25jrvLZevUOeHkIXgoGIzYtzxzuDlhwyRvVWdpcOH63z1s//WttWxRmh2iwcqbdyeqzp75eLyQM
	4lML4jPohQYlfzLLUbwQjtWPS4g4fgKVzluj/AOgtxCIq7tGxYCgI8AqWsQYJ/89tw560m/pYr73F
	gVdEH3BQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1twEty-00000000lh5-2isD;
	Sun, 23 Mar 2025 06:33:42 +0000
Date: Sat, 22 Mar 2025 23:33:42 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 1/4] xfs_repair: don't recreate /quota metadir if there
 are no quota inodes
Message-ID: <Z9-rRv7jZrcHCBcX@infradead.org>
References: <174257453579.474645.8898419892158892144.stgit@frogsfrogsfrogs>
 <174257453614.474645.7529877430708333135.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <174257453614.474645.7529877430708333135.stgit@frogsfrogsfrogs>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Fri, Mar 21, 2025 at 09:31:31AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If repair does not discover even a single quota file, then don't have it
> try to create a /quota metadir to hold them.  This avoids pointless
> repair failures on quota-less filesystems that are nearly full.
> 
> Found via generic/558 on a zoned=1 filesystem.

Interesting, I never saw that fail.  Any interesting options you had
to inject for that?

The patch itself looks fine, though:

Reviewed-by: Christoph Hellwig <hch@lst.de>

