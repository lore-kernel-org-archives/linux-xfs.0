Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8845D472762
	for <linux-xfs@vger.kernel.org>; Mon, 31 Aug 2026 13:50:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184236; cv=none; b=HLvlUqHcekh+JYQRLUKxDR0wlq2zYkmWnfwKaZU0m/V4YaOzf+IqSWpr9VRu5HgVmxyAWIJ5J2z67QGFZur4RV8CU0LYy8A5QD79nPGF8oxu+qgCEVSACBQ6ZYw9oN8UUf2GosnVM+FZTTjBa/KHZPbl0+4Er7Pej2Xy7q3GNyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184236; c=relaxed/simple;
	bh=DyWmfRRWeT9fO3hZ+q6o1fjBvR4WThWfm06SfgNT3kg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nUf59C120otUwjrwX6kMjw14yZOfpt0eA42vkAinrkLw2mOlLimY/mMewh5WkuB3r+lIdG25YOTG+zHc5dz74WA4Mzz1UxdcG01Xj/r4CfDYNcwEsAlrHfSabO/cuSU8nmj12G1qaVRUj6T6aJVSPp5BILJAZDEYAdfzICgVDw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=48YwwLw3; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="48YwwLw3"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0NCzUlG78EIiIsg0XyjcI1Qu5gotoROB/TWEWel59qM=; b=48YwwLw3Ujg4DQZbOvaOOQVB2z
	o9kLkEGOLAcFTFlPur7x2yp8Jo8l0uVgPfn+U4LPZcJF3WwWM5AuOndo9hbo2vgAjEK3lFEJ31EPQ
	YohLpApZy385WyN6n0/56Qci6NzjeHqwjXFvJwuLxDxvmlj4JLQYvOQTOjrtTrHx3i5UlVb3T2iIn
	XxQ0YhYJ5wDzMqw9kao6Yt3enFl3FWcxgdL8ss5dQWRrivd0i+JTJ2WSEK3XhEug3BTTk0cLlKfct
	9+RAgNoNjIRUYeRwZADeXJBL7vsPQ0E4F8phukConF00Rpkotf3g1gCz1zKD5So9Ef62P3rwZ8/mf
	qx2lqDVQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x12PB-00000009XxO-3D91;
	Mon, 31 Aug 2026 13:50:33 +0000
Date: Mon, 31 Aug 2026 06:50:33 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Chris Wedgwood <cw@f00f.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 9/9] xfs_repair: finish deletions the crash interrupted
Message-ID: <apWGqUWLAPNdX0GK@infradead.org>
References: <cover.1788110147.git.cw@f00f.org>
 <f779978814dd39ccf58cadbf176418dbc638d473.1788110147.git.cw@f00f.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f779978814dd39ccf58cadbf176418dbc638d473.1788110147.git.cw@f00f.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Wed, Aug 26, 2026 at 10:48:03PM -0700, Chris Wedgwood wrote:
> Do the work.

Not a really useful sentence.  Really.  Just to emualte the kind of AI
bot speach used a bit too much in these commit logs, however they ended
up here.

> The kernel drives it through xfs_irele() and the inodegc
> workers, ending in xfs_inactive() in fs/xfs/xfs_inode.c, which is

As is mentioned file names.  Please write your own commit log,
instead of generating this kind of rambling.  And this also makes
me a bit worried how the code came to life.

> Before this patch that filesystem reported ifree 9 and moved twelve
> inodes to lost+found.

Please create test cases for unlinked inode recovery.

