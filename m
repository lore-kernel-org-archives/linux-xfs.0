Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBBA1364AB
	for <linux-xfs@vger.kernel.org>; Fri, 21 Jun 2024 16:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718986735; cv=none; b=UUJq8fh0eePYl/E6YTrfckvvi+hzLX7YNsixeLVroaQQbGLm+DWflFrYxXi0lgE7OtnNkvQMvozrrunGTTGDkEryHeVbUDFvJ7O4jo6T5S2H3RemY445kUFoPRv1dgLPRk4Uh3ZyRXTlePEUcC0X/yPR9zEDwyMw9BGZRYatkpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718986735; c=relaxed/simple;
	bh=eQzFSfeBSDpJCGWwi/b/qbgIfAtyDrkuXZs2YgdLqrw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k1cBoyIJV4JDsT4+pUZNcO0K580MAWWaEzevWRLTSATGZgOypkDAZQo7j/Jcp2BS4DyqvsMB7nckAUzJT3w60mogyBGTTnpiMMA0F3yD8xDvcSMbF7MrFiyqrHBD07yoK/ckCZpycH81oEZS6ISSDGS2noIXDmXaUG26ciOqacQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gXfln9Jz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gXfln9Jz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38C61C2BBFC;
	Fri, 21 Jun 2024 16:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718986735;
	bh=eQzFSfeBSDpJCGWwi/b/qbgIfAtyDrkuXZs2YgdLqrw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gXfln9JzXXfrwpCMUOLmjBaAayGiW1qM5TvShp2tWpC31stZig8yuXTSpc08ebZWI
	 qrG0szOKCDAvi4ERNVN7rinLjrX3N/8S7/x1U9BPj57BWLRsLtrcfb5XwY4inAeSEF
	 eOXyQ5rLTDeUoz71r9tp5brkB3Qwa2j4OCYV/JZB2CbML9iKrmvdh2L0eCJOEU9jLf
	 UMQKnjiI0EXRwcW3hxmSWQbNKSfKOCakxoDKwCAZ50fqKJOPs3RFgrIMNEgduFE9NA
	 lwfstCNvvbfYflYUlVl7MUqmPvD+TRipxsvj95U3Vu2tNbam/QwuXLGf03wCZg5o9s
	 7VEzDlSxpfrOA==
Date: Fri, 21 Jun 2024 09:18:54 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>,
	Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
	Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH 04/11] xfs: background AIL push should target physical
 space
Message-ID: <20240621161854.GB3058325@frogsfrogsfrogs>
References: <20240620072146.530267-1-hch@lst.de>
 <20240620072146.530267-5-hch@lst.de>
 <20240620194226.GF103034@frogsfrogsfrogs>
 <20240621053726.GA15738@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240621053726.GA15738@lst.de>

On Fri, Jun 21, 2024 at 07:37:26AM +0200, Christoph Hellwig wrote:
> On Thu, Jun 20, 2024 at 12:42:26PM -0700, Darrick J. Wong wrote:
> > > transaction need to be pushed or re-logged to simply sample the
> > > current target - they don't need to calculate the current target
> > > themselves. This avoids the need for any locking when doing such
> > > checks.
> > 
> > Ok, so I guess now the AIL kthread maintains the push target in
> > ailp->ail_target all of the time?
> 
> Yes.
> 
> > I think this makes sense to me, but I'm wondering that I've never seen
> > it on the list before.  This is a later revision to the earlier posting,
> > right?
> 
> I started dusting off the last posted version and then Dave gave me
> his latests working copy which hadn't been posted so far.

Ah, ok then.  Thanks for answering my question; let's move this along
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

