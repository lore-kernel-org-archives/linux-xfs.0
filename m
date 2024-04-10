Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F6C6181BBF
	for <linux-xfs@vger.kernel.org>; Wed, 10 Apr 2024 21:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712783059; cv=none; b=V7QFLoV0NZJHiQ6TbFEiko768BDApdPWiyu7uxgIAdqubPSHC+rqYALDnFTD5PZs3DUI8EmjgURwWgwfoM58NJcLjcj4iGm6ZZjLrrD+cfnBiqU+3pqSvXOKfE8mt/Uq2ws+nbkIHeiqenoNaHXkV/LqOLHoEukIAHkarrET//M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712783059; c=relaxed/simple;
	bh=6l7NiH8xyCC3iCTzhiELMpqxluN5NNqzIgCyJO88CQg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XxFZMB7UjSrWT9dgJoISxaGdfHR7g3dfU2LkG2dLW0Phpp8niVen+QW8c+xJwLBNJ7TZJzYURYGhEdRFx9CXpDEN2ihn6wqj7mEtXQJLpNXpr8GVX4XuIJiLuELQ71h4QCAtXhF7mvBByCUw+TjTB+d/ormNvYZ4AOEkYN0TwiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FddH1X0t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FddH1X0t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50845C433C7;
	Wed, 10 Apr 2024 21:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712783059;
	bh=6l7NiH8xyCC3iCTzhiELMpqxluN5NNqzIgCyJO88CQg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FddH1X0t3Eb1c0gZeAl2H0S8njRX9k2Y1pTqSilljCs8kzbEXaXbzky8dBMhWokvH
	 jDLRuX+LGCvalHcdI8GBmcM8ujrqBLnZK05LIhKo+Cap1oVQ2SRTbiAA0aaw6qeCIC
	 1/GZFEZAdX3P7wIjm2vOzFyDhzfqMKk4cGCIJl2Fgm+rtfnS5DiXT6Cs6qGzvbzRf6
	 Ys1mD5yWgLZpWfNArNscv/ybbxTYJ4eDEYPc9nU0GfTGW8Q5vSbjB632F9BHZWSwVF
	 Zi387ww4y6tDiN/PR01aKIc7nLZFaRdVquaTEnv65hzZqDwbmhhS/f8NTGf6QE0czo
	 hNmWJim/TQiOg==
Date: Wed, 10 Apr 2024 14:04:18 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 05/12] xfs: fix missing check for invalid attr flags
Message-ID: <20240410210418.GC6390@frogsfrogsfrogs>
References: <171270968824.3631545.9037354951123114569.stgit@frogsfrogsfrogs>
 <171270968933.3631545.17328111564626328171.stgit@frogsfrogsfrogs>
 <ZhYefgcsDhixG9AG@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZhYefgcsDhixG9AG@infradead.org>

On Tue, Apr 09, 2024 at 10:07:10PM -0700, Christoph Hellwig wrote:
> On Tue, Apr 09, 2024 at 05:51:41PM -0700, Darrick J. Wong wrote:
> > +#define XFS_ATTR_ONDISK_MASK	(XFS_ATTR_NSP_ONDISK_MASK | \
> > +				 XFS_ATTR_LOCAL | \
> > +				 XFS_ATTR_INCOMPLETE)
> 
> Note that XFS_ATTR_LOCAL and XFS_ATTR_INCOMPLETE are not valid for
> short form directories.  Should we check for that somewhere as well?

Good point, xchk_xattr_check_sf should be flagging those too:

	/*
	 * Shortform entries do not set LOCAL or INCOMPLETE, so the only
	 * valid flag bits here are for namespaces.
	 */
	if (sfe->flags & ~XFS_ATTR_NSP_ONDISK_MASK) {
		xchk_fblock_set_corrupt(sc, XFS_ATTR_FORK, 0);
		break;
	}

I'll tack that on the end.

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
