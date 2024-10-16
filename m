Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6283D107A0
	for <linux-xfs@vger.kernel.org>; Wed, 16 Oct 2024 00:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729038052; cv=none; b=Zw+1HvLhpGsDarp/VgayDJ3UUCwqWAFjoP2f2cvlMMrQgMUOXTxkXPgpREsQJYtTciK+AObVdEuJTg3brOF+9lCwGsj0tyQOvJR6mJHzvym7/2DGt0leIK/qhwQfn79BIkY6NPYp4W8Hsis8sVSOIUYYFJQK9B/KEzRVlaCqw/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729038052; c=relaxed/simple;
	bh=Zqpnwy20dI7dcgxaxfqT0zyez8yO4kcSeBT8/79bURo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DHv6G0Gxp4SUlfGLpjpuTr+cqaJ78eDdnJwCiCnyDk8uBMKhNDIJf8LTM0b6/Znnn+A7Zb1zC1lMtCdtRAuuv26ODEdtvkUxVWGiVg666nvY1ZI93ojGyWGQyTYGvLw+KbGCt+MTkSIxd3FvRj2ubQtqs9PNNOtZscqY16mdobs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jBaiX+nZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jBaiX+nZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBF85C4CECF;
	Wed, 16 Oct 2024 00:20:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729038052;
	bh=Zqpnwy20dI7dcgxaxfqT0zyez8yO4kcSeBT8/79bURo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jBaiX+nZ64H8Cqela3U9YH2+TYOF2illR1z8vYfc/yVnzoMA1646AApOZC+irBBYy
	 xHih/3C2uHrz5zIBMirD0twvjK+214nyya92XmEfcD4ExZeNvPm+GQOqOAXMywYrFo
	 blHRy+gLO+zfbxAuVf/BsWPGLYyiQ4X+B1xnFiQja3yr/XtmHqsQZ1hJDsJCtV+0ts
	 q/6stHDsnLQ/kkyhQezZcKulMvanF2QpjAYgNOTbjI7zQNGwZNUmTcK/VeulN8Ve9J
	 Hao76fbz55SFpSsArecO7JPsxlyTiKlO9TWophxsYdo6fgnZkLsUHfs8/dE7UPnMZj
	 xjXrXvykd4iBA==
Date: Tue, 15 Oct 2024 17:20:51 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 03/28] xfs: define the on-disk format for the metadir
 feature
Message-ID: <20241016002051.GK21877@frogsfrogsfrogs>
References: <172860641935.4176876.5699259080908526243.stgit@frogsfrogsfrogs>
 <172860642064.4176876.13567674130190367379.stgit@frogsfrogsfrogs>
 <Zw3rjkSklol5xOzE@dread.disaster.area>
 <20241015182541.GE21853@frogsfrogsfrogs>
 <Zw70vBF6adb0GAzA@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zw70vBF6adb0GAzA@dread.disaster.area>

On Wed, Oct 16, 2024 at 10:03:24AM +1100, Dave Chinner wrote:
> On Tue, Oct 15, 2024 at 11:25:41AM -0700, Darrick J. Wong wrote:
> > > > diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> > > > index be7d4b26aaea3f..4b36dc2c9bf48b 100644
> > > > --- a/fs/xfs/xfs_inode.h
> > > > +++ b/fs/xfs/xfs_inode.h
> > > > @@ -65,6 +65,7 @@ typedef struct xfs_inode {
> > > >  		uint16_t	i_flushiter;	/* incremented on flush */
> > > >  	};
> > > >  	uint8_t			i_forkoff;	/* attr fork offset >> 3 */
> > > > +	enum xfs_metafile_type	i_metatype;	/* XFS_METAFILE_* */
> > > >  	uint16_t		i_diflags;	/* XFS_DIFLAG_... */
> > > >  	uint64_t		i_diflags2;	/* XFS_DIFLAG2_... */
> > > >  	struct timespec64	i_crtime;	/* time created */
> > > > @@ -276,10 +277,23 @@ static inline bool xfs_is_reflink_inode(const struct xfs_inode *ip)
> > > >  	return ip->i_diflags2 & XFS_DIFLAG2_REFLINK;
> > > >  }
> > > >  
> > > > +static inline bool xfs_is_metadir_inode(const struct xfs_inode *ip)
> > > > +{
> > > > +	return ip->i_diflags2 & XFS_DIFLAG2_METADATA;
> > > > +}
> > > > +
> > > >  static inline bool xfs_is_metadata_inode(const struct xfs_inode *ip)
> > > 
> > > Oh, that's going to get confusing. "is_metadir" checks the inode
> > > METADATA flag, and is "is_metadata" checks the superblock METADIR
> > > flag....
> > > 
> > > Can we change this to higher level function to
> > > xfs_inode_is_internal() or something else that is not easily
> > > confused with checking an inode flag?
> > 
> > But there's already xfs_internal_inum, which only covers sb-rooted
> > metadata inodes.  I guess first we have to rename that to xfs_is_sb_inum
> > in a separate patch, and then this one can add xfs_inode_is_internal.
> 
> Fine by me.
> 
> > > > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > > > index 457c2d70968d9a..59953278964de9 100644
> > > > --- a/fs/xfs/xfs_super.c
> > > > +++ b/fs/xfs/xfs_super.c
> > > > @@ -1733,6 +1733,10 @@ xfs_fs_fill_super(
> > > >  		mp->m_features &= ~XFS_FEAT_DISCARD;
> > > >  	}
> > > >  
> > > > +	if (xfs_has_metadir(mp))
> > > > +		xfs_warn(mp,
> > > > +"EXPERIMENTAL metadata directory feature in use. Use at your own risk!");
> > > > +
> > > 
> > > We really need a 'xfs_mark_experimental(mp, "Metadata directory")'
> > > function to format all these experimental feature warnings the same
> > > way....
> > 
> > We already have xfs_warn_mount for functionality that isn't sb feature
> > bits.  Maybe xfs_warn_feat?
> 
> xfs_warn_mount() is only used for experimental warnings, so maybe we
> should simply rename that xfs_mark_experiental().  Then we can use
> it's inherent "warn once" behaviour for all the places where we
> issue an experimental warning regardless of how the experimental
> feature is enabled/detected. 
> 
> This means we'd have a single location that formats all experimental
> feature warnings the same way. Having a single function explicitly
> for this makes it trivial to audit and manage all the experimental
> features supported by a given kernel version because we are no
> longer reliant on grepping for custom format strings to find
> experimental features.
> 
> It also means that adding a kernel taint flag indicating that the
> kernel is running experimental code is trivial to do...

...and I guess this means you can discover which forbidden features are
turned on from crash dumps.  Ok, sounds good to me.

Do you want it to return an int so that you (as a distributor, not you
personally) can decide that nobody gets to use the experimental
features?

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
