Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46C0D19925F
	for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2024 17:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724695038; cv=none; b=NGFZaSoJAmBVcnG06QdSR3LEVPHVy8DB/BLBNOm7dJhvn3hspVQHDwcrSP0LLi88czBKZ0jTw5raKrj9DXpCUTKzjmVLyypUvCCWWp9twpJsGv65fHGIx/aG44YLJzUncM9/B7DzUMq1oGjp93aSvdPbc3H+Jx4xgr/+luNh0RQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724695038; c=relaxed/simple;
	bh=fXAhBE87VbVUppqK+xYlHUGAgS2a4OdUmN364NHWgWw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=imRHhOn7C2PwaLOnBUSEy7W6Jn57t1jCXcuqmgtbeXtFVAEuDXwMllWY1/pn3MFE+ZQHmUFccfT7W41TLIPYzWeuJtiX9CC+9EVvw2McyDzw+3Fwhg5tmt0+oFQd7UpBasTgJaKX+ZBz2unX+Dihq85NIIQjM+7At7TV/vTuCnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F8S9W0+R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F8S9W0+R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB499C8B7A0;
	Mon, 26 Aug 2024 17:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724695037;
	bh=fXAhBE87VbVUppqK+xYlHUGAgS2a4OdUmN364NHWgWw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=F8S9W0+RGrP+NR+LL+1hXhX8PqTGQ3YIKLpP7wUwQYO09bmVXackuvfHmcTv/0cNx
	 QLi4xxzFYWY01SAZ2OP1eY6SrjXKHl/Njlmz2bbnRJvN1JllVE4J43RxK7JXEscVSJ
	 5vsYOrUCt5rx6kL8XoZbDx3VA6guqIjztzbSMVUzSJ812InjYqir9Ci5Hb0/ppMcz7
	 tMduNOpa10RcL+tlGlN9cr/mCbKy/w5CuUhItf1HFG8nsB4zHCnLZaUIONnFKOf9WD
	 HQs3TL03/KDTZQvJDHfU0ej0VWaZEFqqUZATfPeQKenjPf8P2W7SHkdF9DDsTidXZD
	 SN67Q8IidTB0w==
Date: Mon, 26 Aug 2024 10:57:17 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 11/26] xfs: don't count metadata directory files to quota
Message-ID: <20240826175717.GX865349@frogsfrogsfrogs>
References: <172437085093.57482.7844640009051679935.stgit@frogsfrogsfrogs>
 <172437085364.57482.4719664018853105804.stgit@frogsfrogsfrogs>
 <ZsvQrb4o0vUAL/lP@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZsvQrb4o0vUAL/lP@dread.disaster.area>

On Mon, Aug 26, 2024 at 10:47:41AM +1000, Dave Chinner wrote:
> On Thu, Aug 22, 2024 at 05:05:01PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Files in the metadata directory tree are internal to the filesystem.
> > Don't count the inodes or the blocks they use in the root dquot because
> > users do not need to know about their resource usage.  This will also
> > quiet down complaints about dquot usage not matching du output.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/xfs_dquot.c       |    1 +
> >  fs/xfs/xfs_qm.c          |   11 +++++++++++
> >  fs/xfs/xfs_quota.h       |    5 +++++
> >  fs/xfs/xfs_trans_dquot.c |    6 ++++++
> >  4 files changed, 23 insertions(+)
> > 
> > 
> > diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
> > index c1b211c260a9d..3bf47458c517a 100644
> > --- a/fs/xfs/xfs_dquot.c
> > +++ b/fs/xfs/xfs_dquot.c
> > @@ -983,6 +983,7 @@ xfs_qm_dqget_inode(
> >  
> >  	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
> >  	ASSERT(xfs_inode_dquot(ip, type) == NULL);
> > +	ASSERT(!xfs_is_metadir_inode(ip));
> >  
> >  	id = xfs_qm_id_for_quotatype(ip, type);
> >  
> > diff --git a/fs/xfs/xfs_qm.c b/fs/xfs/xfs_qm.c
> > index d0674d84af3ec..ec983cca9adae 100644
> > --- a/fs/xfs/xfs_qm.c
> > +++ b/fs/xfs/xfs_qm.c
> > @@ -304,6 +304,8 @@ xfs_qm_need_dqattach(
> >  		return false;
> >  	if (xfs_is_quota_inode(&mp->m_sb, ip->i_ino))
> >  		return false;
> > +	if (xfs_is_metadir_inode(ip))
> > +		return false;
> >  	return true;
> >  }
> >  
> > @@ -326,6 +328,7 @@ xfs_qm_dqattach_locked(
> >  		return 0;
> >  
> >  	xfs_assert_ilocked(ip, XFS_ILOCK_EXCL);
> > +	ASSERT(!xfs_is_metadir_inode(ip));
> >  
> >  	if (XFS_IS_UQUOTA_ON(mp) && !ip->i_udquot) {
> >  		error = xfs_qm_dqattach_one(ip, XFS_DQTYPE_USER,
> > @@ -1204,6 +1207,10 @@ xfs_qm_dqusage_adjust(
> >  		}
> >  	}
> >  
> > +	/* Metadata directory files are not accounted to user-visible quotas. */
> > +	if (xfs_is_metadir_inode(ip))
> > +		goto error0;
> > +
> 
> Hmmmm. I'm starting to think that xfs_iget() should not return
> metadata inodes unless a new XFS_IGET_METAINODE flag is set.
> 
> That would replace all these post xfs_iget() checks with a single
> check in xfs_iget(), and then xfs_trans_metafile_iget() is the only
> place that sets this specific flag.
> 
> That means stuff like VFS lookups, bulkstat, quotacheck, and
> filehandle lookups will never return metadata inodes and we don't
> need to add special checks all over for them...

I think doing so is likely an overall improvement for the codebase, but
it will complicate life for the directory and parent pointer scrubbers
because they can be called with the ino/gen of files in metadata
directory tree, and there's a special bulkstat mode for xfs_scrub
wherein one can get the ino/gen of metadata directory tree files.
Anyway I'll think further about this as a separate cleanup.

Note that the checks in this particular patch exist so that we don't
have to sprinkle them all over the bmap code so that the rtbitmap and
summary files can be excluded from quota accounting.

--D

> 
> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
