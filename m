Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 007E11CE09B;
	Fri, 28 Jun 2024 17:01:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719594079; cv=none; b=PioCb2NzX5lWU0qSbewqncXUXesMUe6FefHzzaMSTULEIY6aQMDgsfrQAhVx6z+ChE6+9fAhSpjMr2VjmMBzCfJcpa4Lmd7m40xr5WR3G+Jflrq3jhVJSVnU2zf2Wi1JaCSO3N9FwSW5LS9hQcZycSBlEr/TBEbQS072rM7/QCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719594079; c=relaxed/simple;
	bh=p7XecSFWemJziWOM6nnkfXSrciddlpO1NrCyTpT36gk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mO6RIgQFJ9ldouXwbYcLan+I9WNbsq6R2hthNG89/LhU8ul4dB3zZtk0DDXFUwpnSnLDWcgoe9TXf1OfEE1vtSuDAIQrrvV243xxyq7guCEhCJxp2EqbC2jNWsFv3Q+YUlogtI+l4dL7YyqpqT4AqYrBWJug/sqw+/VzeHjIUJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cViiUIpm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cViiUIpm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3EDFC2BD10;
	Fri, 28 Jun 2024 17:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719594078;
	bh=p7XecSFWemJziWOM6nnkfXSrciddlpO1NrCyTpT36gk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cViiUIpm7GccXdL91WYZwBA6vfIz3FXP1EP+Z5hH2nFw0YIyF/aqMO7xHbPJGTpGs
	 Mvp8C6rIrzM/ip4FiZGH2egfAkMnibx/3yqfPf+QwvAkBqQ5KRGGTk5OCEq6TB0PYq
	 lfRlGspaupX89aewme8yAhS3qz64pAlp6mAEdHusddcsLXT0OBupGilhevgOn3JAId
	 7z/0oX9D06jXIjS11cpdtc7Zjb1LEpriCSz3lD05v2cAEvA7J9lv89rTmE5HYMYrN8
	 /JqB9Fxz6kBnCRr5YJOpWhsqQ6VNeFP1iyd5AQB/3KKK/qo6iE8/VVdBwM10Pp51h0
	 34rZPJiQMvi5g==
Date: Fri, 28 Jun 2024 10:01:18 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Jiwei Sun <sunjw10@outlook.com>, chandan.babu@oracle.com,
	linux-xfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	sunjw10@lenovo.com, ahuang12@lenovo.com, yi.zhang@redhat.com
Subject: Re: [PATCH] xfs: add __GFP_NOLOCKDEP when allocating memory in
 xfs_attr_shortform_list()
Message-ID: <20240628170118.GD612460@frogsfrogsfrogs>
References: <SEZPR01MB45270BCD2BC28813FCB39AEDA8D72@SEZPR01MB4527.apcprd01.prod.exchangelabs.com>
 <9b8357bf-a1bf-43d0-b617-030882540b34@sandeen.net>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9b8357bf-a1bf-43d0-b617-030882540b34@sandeen.net>

On Fri, Jun 28, 2024 at 11:25:10AM -0500, Eric Sandeen wrote:
> On 6/27/24 8:12 AM, Jiwei Sun wrote:
> > From: Jiwei Sun <sunjw10@lenovo.com>
> > 
> > If the following configuration is set
> > CONFIG_LOCKDEP=y
> > 
> > The following warning log appears,
> 
> Was just about to send this. :)
> 
> I had talked to dchinner about this and he also suggested that this was 
> missed in the series that removed GFP_NOFS, i.e.
> 
> [PATCH 00/12] xfs: remove remaining kmem interfaces and GFP_NOFS usage
> at https://lore.kernel.org/linux-mm/20240622094411.GA830005@ceph-admin/T/
> 
> So, I think this could also use one or both of:
> 
> Fixes: 204fae32d5f7 ("xfs: clean up remaining GFP_NOFS users")
> Fixes: 94a69db2367e ("xfs: use __GFP_NOLOCKDEP instead of GFP_NOFS")
> 
> ...
> 
> > This is a false positive. If a node is getting reclaimed, it cannot be
> > the target of a flistxattr operation. Commit 6dcde60efd94 ("xfs: more
> > lockdep whackamole with kmem_alloc*") has the similar root cause.
> > 
> > Fix the issue by adding __GFP_NOLOCKDEP in order to shut up lockdep.
> > 
> > Signed-off-by: Jiwei Sun <sunjw10@lenovo.com>
> > Suggested-by: Adrian Huang <ahuang12@lenovo.com>
> > ---
> >  fs/xfs/xfs_attr_list.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> > 
> > diff --git a/fs/xfs/xfs_attr_list.c b/fs/xfs/xfs_attr_list.c
> > index 5c947e5ce8b8..506ade0befa4 100644
> > --- a/fs/xfs/xfs_attr_list.c
> > +++ b/fs/xfs/xfs_attr_list.c
> > @@ -114,7 +114,8 @@ xfs_attr_shortform_list(
> >  	 * It didn't all fit, so we have to sort everything on hashval.
> >  	 */
> >  	sbsize = sf->count * sizeof(*sbuf);
> > -	sbp = sbuf = kmalloc(sbsize, GFP_KERNEL | __GFP_NOFAIL);
> > +	sbp = sbuf = kmalloc(sbsize, GFP_KERNEL | __GFP_NOFAIL |
> > +			     __GFP_NOLOCKDEP);
> 
> Minor nitpick, style-wise we seem to do:
> 
>         sbp = sbuf = kmalloc(sbsize,
>                         GFP_KERNEL | __GFP_NOLOCKDEP | __GFP_NOFAIL);
> 
> in most other places, and not split the flags onto 2 lines, since you need
> to add a line anyway.
> 
> Otherwise,
> 
> Acked-by: Eric Sandeen <sandeen@redhat.com>

Hey, could you all please read the list before sending duplicate
patches?

https://lore.kernel.org/linux-xfs/20240622082631.2661148-1-leo.lilong@huawei.com/

--D

> >  	/*
> >  	 * Scan the attribute list for the rest of the entries, storing
> 
> 
