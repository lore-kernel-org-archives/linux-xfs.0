Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 044F6F4E7
	for <linux-xfs@vger.kernel.org>; Tue, 16 Apr 2024 17:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713288689; cv=none; b=SyAYaT1cQQg7psloPIomdCQh2F91W1YyVwztLF2azKKSD1pIXJY6nLe/LKPrnUr5usxzuB6HiVyCKNC+ZAYAcFSSKU+ath/oI8+277zV3Zxpisq0U2oj9kuFSoSA6sD8TmWneInDETsqTYNAceeGng+h++H3r2Q56IEmkscNEIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713288689; c=relaxed/simple;
	bh=qpmDIrl2oTKDoRQhNB8qJpaOKSWnAMpC4iUrOy8m990=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MNR2k8mg9kuUBlf0iySThere4U+YC1Kt4in9KIBHrExt2mctodr3BQHobYJ0HeOu0GEAl+hBV2V3UASiz6kvSLehfOe4EQqeluQECfeJUt9TlMpXT5imNRK4q0FsgYZdYrE/iY4fR53RmY8kmfTTKF1OCFnzR1KZXaoZP/cJDoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UpUtZWf2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UpUtZWf2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 889E4C113CE;
	Tue, 16 Apr 2024 17:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713288688;
	bh=qpmDIrl2oTKDoRQhNB8qJpaOKSWnAMpC4iUrOy8m990=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UpUtZWf2nvqMZmd1bRzBd8xfNLPI807HUKpMiLa1a+aV4tH4xYSejmkzz4I0xQ8Q4
	 rakpsAo/UQYDeXdNRAiNvAPYARRRDw61nsxt2bLTB8ukxXzbaZPiMkRBbmgfedkQzu
	 KQ6qbmSHI3CIQruaehBrG0ko8o91pHIuCIHCl4xRRQl5bZP8qwFiPEtlAMnDT25MzL
	 8JTv7qGuKJMbXW3naD0USUVqBbru9sSoO/Tf+1YzQbF5IEveDdPcm6Y3bNiaksGFfW
	 xJTejdAtEUoa8c3SDsvoq6wqHNL1PD/bgOty0jU6mezW5p9SPyD/2M65HhRXYP9zXC
	 wzWcsxFhXCWSA==
Date: Tue, 16 Apr 2024 10:31:28 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 4/5] xfs: make attr removal an explicit operation
Message-ID: <20240416173128.GS11948@frogsfrogsfrogs>
References: <171323026574.250975.15677672233833244634.stgit@frogsfrogsfrogs>
 <171323026654.250975.17998254398908556664.stgit@frogsfrogsfrogs>
 <Zh4IrLX10rprLUiV@infradead.org>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zh4IrLX10rprLUiV@infradead.org>

On Mon, Apr 15, 2024 at 10:12:12PM -0700, Christoph Hellwig wrote:
> > +	if (op != XFS_ATTRUPDATE_REMOVE || xfs_inode_hasattr(dp)) {
> >  		error = xfs_iext_count_may_overflow(dp, XFS_ATTR_FORK,
> >  				XFS_IEXT_ATTR_MANIP_CNT(rmt_blks));
> >  		if (error == -EFBIG)
> 
> No need to change this in the current patch, but checking for a remove
> on an inodes without attrs just to skip the extent count upgrade
> and not fail the whole operation is a little silly :)

Yeah, I don't think there's a point to checking @op here.  The only
code we need here is skipping the overflow checks if !xfs_inode_hasattr.
Separate patch.

> > @@ -203,7 +203,8 @@ __xfs_set_acl(struct inode *inode, struct posix_acl *acl, int type)
> >  		xfs_acl_to_disk(args.value, acl);
> >  	}
> >  
> > -	error = xfs_attr_change(&args, XFS_ATTRUPDATE_UPSERT);
> > +	error = xfs_attr_change(&args, args.value ? XFS_ATTRUPDATE_UPSERT :
> > +						    XFS_ATTRUPDATE_REMOVE);
> 
> Given that we have a conditional for removing vs setting right above
> i'd clean this up a bit:
> 
> 		xfs_acl_to_disk(args.value, acl);
> 		error = xfs_attr_change(&args, XFS_ATTRUPDATE_UPSERT)
> 		kvfree(args.value);
> 	} else {
> 		error = xfs_attr_change(&args, XFS_ATTRUPDATE_REMOVE)
> 		/*
> 		 * If the attribute didn't exist to start with that's fine.
> 		 */
> 		if (error == -ENOATTR)
> 			error = 0;
>   	}

Done.

> Otherwise looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Thanks!

--D
