Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA4A33FE05
	for <linux-xfs@vger.kernel.org>; Thu, 26 Mar 2026 14:52:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774536776; cv=none; b=TrZuJ5p8M8elEirvc55EhHVygGqXck8zdbQbcHrHLagfsREb4lR/rWcBL4m9hJnzrBJjd9AISf7DRxvkXfMLhFIvPuOrXaEf6gp3C6FkUiRVhOT4qHaz1/rpulWz29K+neJeBtd1pOedZPc0FZ+tcAUJUwJFA4Tt9DTa0PJCoxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774536776; c=relaxed/simple;
	bh=0ByWtK4Dq+BdrxURvLLJwZlKH1YDOxF20O0HrPjAIfM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WkmX6Bje1vhoWct/wmNlupkho8/4eNXQ0w0OmR81BhDRTORo1kdQpnW+lv5VC5yrV7JZWYgAkYlh3Mx035i8uLONCi6sAFJMz9ESucCY0bTrcoYkugkQql8G1a7t8VifJI/VlJF/2fQoXv+Ar1QQyRkVct6G1W2CiovqfSk/41Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TzPln0C9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TzPln0C9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B62A0C116C6;
	Thu, 26 Mar 2026 14:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774536775;
	bh=0ByWtK4Dq+BdrxURvLLJwZlKH1YDOxF20O0HrPjAIfM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TzPln0C9frMu57Dd53mHeJERcsg9MYyGKAVbNTDuo8o82PLLkJeM/CPffw4yWS33C
	 2aGIDgDJJmbzaBk3o4SSACF67K45ThawiRzPXZ/Rb2TvpSbP/vRBc4uWYjje1s2yYD
	 FjX9zuc15iWrpknruVxa9Ro8JIpBpwgO44iroqUG22XnT7Db3jnfZGHtfO39Gfah9+
	 +DBYu9XyM+uiVWFIe2LeH2R0IcEMui7c0mTzY44L77Ocgsn+CTD6qLv4eYWp/tMwwW
	 ndJOMaQ3sja4Ro2ZY4QvVlb6YP5LwdbvNbgtD/EtsYjY6xu4u+o2naRlMMj/z6ntXe
	 owfGQObwGNELg==
Date: Thu, 26 Mar 2026 07:52:55 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Carlos Maiolino <cem@kernel.org>
Cc: Long Li <leo.lilong@huawei.com>, linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 1/3] xfs: don't irele after failing to iget in
 xfs_attri_recover_work
Message-ID: <20260326145255.GZ6223@frogsfrogsfrogs>
References: <20260323210157.GM6223@frogsfrogsfrogs>
 <acUmASyA2rZQG7K_@nidhogg.toxiclabs.cc>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acUmASyA2rZQG7K_@nidhogg.toxiclabs.cc>

On Thu, Mar 26, 2026 at 01:28:20PM +0100, Carlos Maiolino wrote:
> On Mon, Mar 23, 2026 at 02:01:57PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > xlog_recovery_iget* never set @ip to a valid pointer if they return
> > zero,
> 
> * if they return an error * ?
> It will always return zero when setting @ip.
> 
> I can update it at commit time if you're ok with it.

Er, yes, "...if they return an error" is correct.

--D

> >so this irele will walk off a dangling pointer.  Fix that.
> > 
> > Cc: <stable@vger.kernel.org> # v6.10
> > Fixes: ae673f534a3097 ("xfs: record inode generation in xattr update log intent items")
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > Reviewed-by: Long Li <leo.lilong@huawei.com>
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > ---
> >  fs/xfs/xfs_attr_item.c |    1 -
> >  1 file changed, 1 deletion(-)
> > 
> > diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
> > index 354472bf45f145..fe909bc44c3a79 100644
> > --- a/fs/xfs/xfs_attr_item.c
> > +++ b/fs/xfs/xfs_attr_item.c
> > @@ -653,7 +653,6 @@ xfs_attri_recover_work(
> >  		break;
> >  	}
> >  	if (error) {
> > -		xfs_irele(ip);
> >  		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp, attrp,
> >  				sizeof(*attrp));
> >  		return ERR_PTR(-EFSCORRUPTED);
> > 
> 
