Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40A891EC017
	for <linux-xfs@vger.kernel.org>; Tue, 17 Dec 2024 20:44:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734468295; cv=none; b=Y5ShhNPTIHD5Mx7ITTQbyuZYfusQjn3RW4CX0VglgdMWgF0rp2WjRwvbPIyHifeVpRgxis2gq/B7DedcWmkXWbH+a9FO5P+Vb3oQAaqgcBUlgYanEKDtP4go8O0AB1i3pCVOxmHUiugBN6yOIABMPWYu4y2U37UePdmJ4QWVK2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734468295; c=relaxed/simple;
	bh=mK8tqeHKwYsnnhD3VaaIW2aRJgXgUoJxElNhuZ5R9jM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VyUdE5KP38YXMdqSqs3jVPX2D7tcjw1hSZApbQiFAH+pYt2o9jLg7TGfWjc/V0NGAD4CQZORwBXBsoMTtcoEDGOIyYYlZDneJ7wcBTr3Xg3tOA69lSF5lHGLdH/OpkO6qI0yw4UcBlWSTVWx4HdzzpIAzJDO0YaBrwPA6muzIeA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PA/35xcr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PA/35xcr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C78F4C4CED3;
	Tue, 17 Dec 2024 20:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734468294;
	bh=mK8tqeHKwYsnnhD3VaaIW2aRJgXgUoJxElNhuZ5R9jM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PA/35xcrX7KyOJTROE5hwKcGwrcKrKIg6YEnYVp+7XhpKX/p1i62uOk1iky5rTJMl
	 0MXjyMBu7nj3UGiG+8jAUtdc5wEq2i8WHTPMlTNCdy4V3bgQYPFOYrs2kYu3OIgvli
	 cprsK9y7ULLvZXr+XrDZR98J5qQcmQlIaXAQqjT5k1G0wkFes492jEFs5WzW24bPRR
	 t9TAUwH0mxmA+YzY1tIBsNaCr7KUsqpp3nwtT83qJPBYFx7/trME9uUOse1RonrVK2
	 Nj3Udto+PFtmBhiAJ7raXmyFwATzO+S5TBgg6JR2R0d6ITcOr0JDsOHdoyM6eCrB2C
	 wfLVsEbmzrDAw==
Date: Tue, 17 Dec 2024 12:44:54 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org
Subject: Re: [PATCH 03/43] xfs: introduce realtime refcount btree ondisk
 definitions
Message-ID: <20241217204454.GU6174@frogsfrogsfrogs>
References: <173405124452.1182620.15290140717848202826.stgit@frogsfrogsfrogs>
 <173405124618.1182620.6370020995613116382.stgit@frogsfrogsfrogs>
 <Z1v5jJFM4COV9cKY@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1v5jJFM4COV9cKY@infradead.org>

On Fri, Dec 13, 2024 at 01:08:28AM -0800, Christoph Hellwig wrote:
> >  xfs_rtbtree_compute_maxlevels(
> >  	struct xfs_mount	*mp)
> >  {
> > -	mp->m_rtbtree_maxlevels = mp->m_rtrmap_maxlevels;
> > +	unsigned int		levels;
> > +
> > +	levels = max(mp->m_rtrmap_maxlevels, mp->m_rtrefc_maxlevels);
> > +	mp->m_rtbtree_maxlevels = levels;
> >  }
> 
> I'd drop the extra local variable here.

Done.

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
