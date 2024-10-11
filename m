Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A600D19C56D;
	Fri, 11 Oct 2024 16:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728664857; cv=none; b=tqUvCv8dhSxUjS3ZgyIBX6pbYxFH18DE0hvfRSr0wr98jtlP4UV7wZN9gStHF0o10kNG/LDQHkqJlBKCu8ocf71xYMdw7sYFMeXAtB7C5fwSySKaDx9/qWy38R8evYduv6GZzC5428RCXCuNrAWPgYCWOSgbIR0WGH6uVNyN9wA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728664857; c=relaxed/simple;
	bh=Asz82BnMJfrhlWHmCMcADIty3kGuGQSL6snq/yAKpjY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P7bZpcsdFiZSTRMLgV0BXLjz4MVIF+/nbeoAkQavBEbDMklA8Pg6n85P4SzIRDQ6N0UW7IEyyNQ2M7E4w+sJp8fbh96Mp0h/ziqb1YQvHDwpDFfuq2nKsNk+bzYqb3MLyK6eDFBrzr5Euilh/ach/C9kHwoxg2LBRj/iAOyayi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GsUam5UA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GsUam5UA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BC18C4CEC3;
	Fri, 11 Oct 2024 16:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728664857;
	bh=Asz82BnMJfrhlWHmCMcADIty3kGuGQSL6snq/yAKpjY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GsUam5UAyPYEEu3qRNzeLCrWXL5UxedTCRGMgMdx9IKIQJyRUla6Wb+fiKoJN9cZY
	 EnYgrtlVyjod9ygnmLZ7R8N/nD8UtnrNegFc6WsU/04U9dHWVaYN2Zyd/1rgKV5arb
	 yB7Kn3O0KnGc65jjelTTa8FJTeI0o8vsEE3k1jwNW53pYvuZdrmdH1uj9zkBfWICw5
	 wFf/Ni0p/cJrBZRU3CpVufU1l5xAIxdRkI8g8GcNUySmhy/xKQ/XHGnLkNiSR6qDZJ
	 eDs7r3raNZjQ81AACGO/r3hao2ItqWYJywnOZ5LuhQ+mpg95DbJ7b85iw/rrB458mc
	 Vi6z823MCq9NQ==
Date: Fri, 11 Oct 2024 09:40:57 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: linux-xfs@vger.kernel.org, Ritesh Harjani <ritesh.list@gmail.com>,
	linux-kernel@vger.kernel.org, dchinner@redhat.com,
	Chandan Babu R <chandan.babu@oracle.com>,
	Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3] xfs: Check for delayed allocations before setting
 extsize
Message-ID: <20241011164057.GY21853@frogsfrogsfrogs>
References: <20241011145427.266614-1-ojaswin@linux.ibm.com>
 <20241011163830.GX21853@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241011163830.GX21853@frogsfrogsfrogs>

On Fri, Oct 11, 2024 at 09:38:30AM -0700, Darrick J. Wong wrote:
> On Fri, Oct 11, 2024 at 08:24:27PM +0530, Ojaswin Mujoo wrote:
> > Extsize is allowed to be set on files with no data in it. For this,
> > we were checking if the files have extents but missed to check if
> > delayed extents were present. This patch adds that check.
> > 
> > While we are at it, also refactor this check into a helper since
> > its used in some other places as well like xfs_inactive() or
> > xfs_ioctl_setattr_xflags()
> > 
> > **Without the patch (SUCCEEDS)**
> > 
> > $ xfs_io -c 'open -f testfile' -c 'pwrite 0 1024' -c 'extsize 65536'
> > 
> > wrote 1024/1024 bytes at offset 0
> > 1 KiB, 1 ops; 0.0002 sec (4.628 MiB/sec and 4739.3365 ops/sec)
> > 
> > **With the patch (FAILS as expected)**
> > 
> > $ xfs_io -c 'open -f testfile' -c 'pwrite 0 1024' -c 'extsize 65536'
> > 
> > wrote 1024/1024 bytes at offset 0
> > 1 KiB, 1 ops; 0.0002 sec (4.628 MiB/sec and 4739.3365 ops/sec)
> > xfs_io: FS_IOC_FSSETXATTR testfile: Invalid argument
> > 
> > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
> 
> Looks good now,
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

That said, could you add a fixes tag for the xfs_ioctl_setattr_*
changes, please?

--D

> --D
> 
> > ---
> >  fs/xfs/xfs_inode.c | 2 +-
> >  fs/xfs/xfs_inode.h | 5 +++++
> >  fs/xfs/xfs_ioctl.c | 4 ++--
> >  3 files changed, 8 insertions(+), 3 deletions(-)
> > 
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index bcc277fc0a83..19dcb569a3e7 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -1409,7 +1409,7 @@ xfs_inactive(
> >  
> >  	if (S_ISREG(VFS_I(ip)->i_mode) &&
> >  	    (ip->i_disk_size != 0 || XFS_ISIZE(ip) != 0 ||
> > -	     ip->i_df.if_nextents > 0 || ip->i_delayed_blks > 0))
> > +	     xfs_inode_has_filedata(ip)))
> >  		truncate = 1;
> >  
> >  	if (xfs_iflags_test(ip, XFS_IQUOTAUNCHECKED)) {
> > diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> > index 97ed912306fd..03944b6c5fba 100644
> > --- a/fs/xfs/xfs_inode.h
> > +++ b/fs/xfs/xfs_inode.h
> > @@ -292,6 +292,11 @@ static inline bool xfs_is_cow_inode(struct xfs_inode *ip)
> >  	return xfs_is_reflink_inode(ip) || xfs_is_always_cow_inode(ip);
> >  }
> >  
> > +static inline bool xfs_inode_has_filedata(const struct xfs_inode *ip)
> > +{
> > +	return ip->i_df.if_nextents > 0 || ip->i_delayed_blks > 0;
> > +}
> > +
> >  /*
> >   * Check if an inode has any data in the COW fork.  This might be often false
> >   * even for inodes with the reflink flag when there is no pending COW operation.
> > diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
> > index a20d426ef021..2567fd2a0994 100644
> > --- a/fs/xfs/xfs_ioctl.c
> > +++ b/fs/xfs/xfs_ioctl.c
> > @@ -481,7 +481,7 @@ xfs_ioctl_setattr_xflags(
> >  
> >  	if (rtflag != XFS_IS_REALTIME_INODE(ip)) {
> >  		/* Can't change realtime flag if any extents are allocated. */
> > -		if (ip->i_df.if_nextents || ip->i_delayed_blks)
> > +		if (xfs_inode_has_filedata(ip))
> >  			return -EINVAL;
> >  
> >  		/*
> > @@ -602,7 +602,7 @@ xfs_ioctl_setattr_check_extsize(
> >  	if (!fa->fsx_valid)
> >  		return 0;
> >  
> > -	if (S_ISREG(VFS_I(ip)->i_mode) && ip->i_df.if_nextents &&
> > +	if (S_ISREG(VFS_I(ip)->i_mode) && xfs_inode_has_filedata(ip) &&
> >  	    XFS_FSB_TO_B(mp, ip->i_extsize) != fa->fsx_extsize)
> >  		return -EINVAL;
> >  
> > -- 
> > 2.43.5
> > 
> > 
> 
