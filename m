Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5FD037D03
	for <linux-xfs@vger.kernel.org>; Tue, 19 Dec 2023 17:45:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OL+XPYnV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 684E4C433C7;
	Tue, 19 Dec 2023 17:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1703007906;
	bh=L9xEPFdkB+sxbHCm+rl91gSV01hZVofBxUvrcSKkOIU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OL+XPYnVO2lQG/apol429JFr/4grzqE1YsdiMc1vVtEgBv6yCrW7e4KT0xeT65XRF
	 w2MqHSYeAeiikNqzROAwvAnKFUVG4Ldm21EGXQJ85ZVz+rVBOBuoo6XsIxbgJWKfP+
	 1YD2IMhwc8+9OvkodmFZ5ATKn0bU3ToLpt7jv9kY93F5SizQz/QLUvkQmJ6QbJoSuc
	 omIFuLqLlbKj8BaWXIIDglTxeOsUJQ3o41VKOCKrwGg+G9LqVE8+Y39yfzYBEoxwYk
	 PRPDdyh39lXi1F+UDB+XZbwrblLmTIOIjj5iYyl9Moi8IYUxgMrqFEb5z28Dh8FUbO
	 TPp4oP8mP/psg==
Date: Tue, 19 Dec 2023 09:45:05 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Chandan Babu R <chandan.babu@oracle.com>, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 5/8] xfs: remove xfs_attr_shortform_lookup
Message-ID: <20231219174505.GM361584@frogsfrogsfrogs>
References: <20231219120817.923421-1-hch@lst.de>
 <20231219120817.923421-6-hch@lst.de>
 <20231219144627.GA1477@lst.de>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231219144627.GA1477@lst.de>

On Tue, Dec 19, 2023 at 03:46:27PM +0100, Christoph Hellwig wrote:
> So, the buildbot rightly complained that this can return an
> uninitialized error variable in xfs_attr_shortform_addname now
> (why are we disabling the goddam use of uninitialized variable
> warnings in Linux again, sigh..).
> 
> I then not only created the trivial fix, but also wrote a simple wrapper
> for the setxattr syscall as the existing setfattr and attr tools don't
> allow to control the flag, which I assumed means xfstests didn't really
> test this as much as it should.  But that little test showed we're still
> getting the right errno values even with the unininitialized variable
> returns, which seemed odd.
> 
> It turns out we're not even exercising this code any more, as
> xfs_attr_set already does a xfs_attr_lookup lookup first and has a
> copy of this logic executed much earlier (and I should have really though
> about that because I got very close to that code for the defer ops
> cleanup).

Eh, there's lots of, uh, cleanup opportunities in the xattr code. ;)

The changes below look reasonable, but I wonder -- the leaf and node add
functions do a similar thing; can they go too?

I'm assuming those can't go away because they actually set @args->index
and @args->rmt* and we might've blown that away after the initial lookup
in xfs_attr_set?  But maybe they can?  Insofar as figuring all that out
is probably an entire campaign on its own.

> So..  I'm tempted to just turn these checks into asserts with something
> like the below on top of this patch, I'll just need to see if it survives
> testing:

I'll await your return then. :)

--D

> diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
> index d6173888ed0d56..abdc58f286154a 100644
> --- a/fs/xfs/libxfs/xfs_attr.c
> +++ b/fs/xfs/libxfs/xfs_attr.c
> @@ -1066,13 +1066,13 @@ xfs_attr_shortform_addname(
>  	struct xfs_da_args	*args)
>  {
>  	int			newsize, forkoff;
> -	int			error;
>  
>  	trace_xfs_attr_sf_addname(args);
>  
>  	if (xfs_attr_sf_findname(args)) {
> -		if (!(args->op_flags & XFS_DA_OP_REPLACE))
> -			return error;
> +		int		error;
> +
> +		ASSERT(args->op_flags & XFS_DA_OP_REPLACE);
>  
>  		error = xfs_attr_sf_removename(args);
>  		if (error)
> @@ -1086,8 +1086,7 @@ xfs_attr_shortform_addname(
>  		 */
>  		args->op_flags &= ~XFS_DA_OP_REPLACE;
>  	} else {
> -		if (args->op_flags & XFS_DA_OP_REPLACE)
> -			return error;
> +		ASSERT(!(args->op_flags & XFS_DA_OP_REPLACE));
>  	}
>  
>  	if (args->namelen >= XFS_ATTR_SF_ENTSIZE_MAX ||
> 
> 
