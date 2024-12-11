Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B051A86326
	for <linux-xfs@vger.kernel.org>; Wed, 11 Dec 2024 21:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733951838; cv=none; b=l5UXgzQbjY2IsWtIQbY/Q3y7GMUzuyUXwLYIEM9uH4EEkZBPJ5UmAOpFmKCxkCtW00yrr66xovpwoTYKJ+aamF2GRq8FUZ3vswI+661saO1TwGnDf8ASWu2HClYV5f8xZ48W07xProZfK1jaq5lqu3F/jfq7Dak3OK9LF6xuuI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733951838; c=relaxed/simple;
	bh=49+GzHuGjrOzqnKq5Y2FAoFnOy9l1mxP5vXMaSlah8Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B9pegg6FkUB1B6L8sA15u9j0YpIZbVL6HoF9HKF3LwxwXEQMYbo8HwhWVPOO+HAdHvlg2TEr4ePeZL/rmExeULGNE9mF+H3uyOabw2WZqpBtOifvnxUDWHvIQsLOemQWMlLVDLiL2NaEf4O8ECtxdIjrfPQldPgbzcmAlQCl0Xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N9iXFiB0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N9iXFiB0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A109C4CED2;
	Wed, 11 Dec 2024 21:17:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733951838;
	bh=49+GzHuGjrOzqnKq5Y2FAoFnOy9l1mxP5vXMaSlah8Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=N9iXFiB0MKJ66uh71CXBHvJT49OM1/wXquy74WkZipFYwTjmPHH7wWgNrCe3/34Zq
	 sQa3ktIbzuFs0bIB+fDxvnLvuR7ep5/YOkPEVRFNrimsQWZMaGPdzKojBUQ9SUMbCs
	 bIW+Go8zaoRZK0T2Hp6q4j8e33T4/B3dFJkDLrwCo8UJATMgfWnqajU1q6CFn3RI9P
	 +Nw5oKma6lGEyUIZIeqMlf8spa3VjaIqPqZu955gLyYdecZb9HTCEtO8mK8MKcvQEe
	 atyUoiSI3ulFaA41TSxP83E+eR773oDRrW+BI8dRLdJk1BdmjIzXiHYfsrdiSdOjr0
	 c5lM67f4Yy8PA==
Date: Wed, 11 Dec 2024 13:17:17 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: aalbersh@kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 24/41] xfs_repair: refactor marking of metadata inodes
Message-ID: <20241211211717.GN6678@frogsfrogsfrogs>
References: <173352748177.122992.6670592331667391166.stgit@frogsfrogsfrogs>
 <173352748603.122992.7502270004875178872.stgit@frogsfrogsfrogs>
 <Z1fMeIC3XEMK2sgh@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z1fMeIC3XEMK2sgh@infradead.org>

On Mon, Dec 09, 2024 at 09:07:04PM -0800, Christoph Hellwig wrote:
> > +mark_inode(
> > +	struct xfs_mount	*mp,
> > +	xfs_ino_t		ino)
> > +{
> > +	struct ino_tree_node	*irec;
> > +	int			offset;
> > +
> > +	irec = find_inode_rec(mp, XFS_INO_TO_AGNO(mp, ino),
> > +			XFS_INO_TO_AGINO(mp, ino));
> > +
> > +	offset = XFS_INO_TO_AGINO(mp, ino) - irec->ino_startnum;
> > +
> > +	add_inode_reached(irec, offset);
> 
> Nit: I'd just skip the local offset variable.

Yeah, that does look cleaner:

static void
mark_inode(
	struct xfs_mount	*mp,
	xfs_ino_t		ino)
{
	struct ino_tree_node	*irec =
		find_inode_rec(mp, XFS_INO_TO_AGNO(mp, ino),
				   XFS_INO_TO_AGINO(mp, ino));

	add_inode_reached(irec, XFS_INO_TO_AGINO(mp, ino) - irec->ino_startnum);
}

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
