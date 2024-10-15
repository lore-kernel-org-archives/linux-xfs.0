Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 169CF1F584A
	for <linux-xfs@vger.kernel.org>; Tue, 15 Oct 2024 18:32:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729017149; cv=none; b=tqm0W3ckSX1s6lq49mEDdhN4Zt0DnstjN0OOurJIOrm2Z+7g8+/JWnrwCNjiJj2SXWluK2A3dCS4bj90pK/B7dp2+T5rhptq3K60J/c0UImGnsfs66yk14VGh59XZLezxyK009i6whX80z2tRjUrp4tCorAON4GG/xNYsfGdmN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729017149; c=relaxed/simple;
	bh=CgIDUCRvj8pRXz8uC8WNyuRzxpoKZGjTqMjsbLAJHwU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H+moH41n8H6njWPKUX3h91l/7gfwIh5cKODyaFwPUXL0iDUUkE15G/W9Tnsx2xejPgqJHWUI+LQ5Z7QE9vu1ltK6Db5ASzjsJX7deqkCjwXVe5pKJ9bJDtsZh4JzssYaMSLYzORCR0uNpTy+UbeQlVaKVo6D69cOaaakYBMWbQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=paKGY+pk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="paKGY+pk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C759C4CEC6;
	Tue, 15 Oct 2024 18:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729017146;
	bh=CgIDUCRvj8pRXz8uC8WNyuRzxpoKZGjTqMjsbLAJHwU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=paKGY+pk+rtW9k6sevvrizYC7yMXNB4Lq97zFLdBfYi0DK3e5XrWDdptWToLvYTRs
	 AGoLfzyIsim+5SHkYBnwdjk3ro952c184BMTJMZSFk6oMDJ7LFryfqePCYWvLTftD7
	 mGxvZdzJeG9ZKYLlUxtrnUL1qhc8TFGbcVfiO5nUp3em8iwPUCMROL0kRiU8FY2DEr
	 gOjp5xPfKaJ4FGt2n8f5MDRv856NRwJUY8j+vpni7tI17V10liYF/Pqgwo8zpuHL27
	 /rGmnnVNbbMULt1tmimRmFzCjo6xsR7WcMBLiCznGykrdeFNcNldZZnibs9paREqD/
	 UhoAbChNDPzVA==
Date: Tue, 15 Oct 2024 11:32:25 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 04/28] xfs: undefine the sb_bad_features2 when metadir is
 enabled
Message-ID: <20241015183225.GG21853@frogsfrogsfrogs>
References: <172860641935.4176876.5699259080908526243.stgit@frogsfrogsfrogs>
 <172860642083.4176876.2034736773059229041.stgit@frogsfrogsfrogs>
 <Zw3vHOiOBG28/vgv@dread.disaster.area>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zw3vHOiOBG28/vgv@dread.disaster.area>

On Tue, Oct 15, 2024 at 03:27:08PM +1100, Dave Chinner wrote:
> On Thu, Oct 10, 2024 at 05:49:25PM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > The metadir feature is a good opportunity to break from the past where
> > we had to do this strange dance with sb_bad_features2 due to a past bug
> > where the superblock was not kept aligned to a multiple of 8 bytes.
> > 
> > Therefore, stop this pretense when metadir is enabled.  We'll just set
> > the incore and ondisk fields to zero, thereby freeing up 4 bytes of
> > space in the superblock.  We'll reuse those 4 bytes later.
> > 
> > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > ---
> >  fs/xfs/libxfs/xfs_format.h |   73 ++++++++++++++++++++++++++++----------------
> >  fs/xfs/libxfs/xfs_sb.c     |   27 +++++++++++++---
> >  fs/xfs/scrub/agheader.c    |    9 ++++-
> >  3 files changed, 75 insertions(+), 34 deletions(-)
> 
> This is all pretty nasty. We are not short on space in the
> superblock, so I'm not sure why we want to add all this complexity
> just to save 4 bytes of space in the sueprblock.
> 
> In reality, the V5 superblock version has never had the
> bad-features2 problem at all - it was something that happened and
> was fixed long before V5 came along. Hence, IMO .....
> 
> > @@ -437,6 +446,18 @@ static inline bool xfs_sb_version_hasmetadir(const struct xfs_sb *sbp)
> >  	       (sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_METADIR);
> >  }
> >  
> > +/*
> > + * Detect a mismatched features2 field.  Older kernels read/wrote
> > + * this into the wrong slot, so to be safe we keep them in sync.
> > + * Newer metadir filesystems have never had this bug, so the field is always
> > + * zero.
> > + */
> > +static inline bool xfs_sb_has_mismatched_features2(const struct xfs_sb *sbp)
> > +{
> > +	return !xfs_sb_version_hasmetadir(sbp) &&
> > +		sbp->sb_bad_features2 != sbp->sb_features2;
> > +}
> 
> This could be:
> 
> static inline bool xfs_sb_has_mismatched_features2(const struct xfs_sb *sbp)
> {
> 	return !xfs_sb_is_v5(sbp) &&
> 		sbp->sb_bad_features2 != sbp->sb_features2;
> }
> 
> and nobody should notice anything changes. If we then check that
> sbp->sb_bad_features2 == sbp->sb_features2 in the v5 section of
> xfs_validate_sb_common(), all we'll catch is syzbot trying to do
> stupid things to the feature fields on v5 filesystems....

No.  TOT kernel/xfs_repair/xfs_scrub enforce sb_bad_features2 ==
sb_features2 for V5 filesystems.  If a new xfs_db omits a
sb_bad_features2 rewrite on an pre-metadir V5 fs because
xfs_sb_has_mismatched_features2 returns false, then an old repair will
complain "superblock has a features2 mismatch, correcting".

> Then we can add whatever new fields metadir needs at the end of
> the superblock. That seems much cleaer than adding this
> conditional handling of the field in when reading, writing and
> verifying the superblock and when mounting the filesystem....

<shrug> I don't see the point in undefining sb_bad_features2 for metadir
and not reusing the space, but since you and hch both favor extending
the sb instead, I'll just do that and drop this patch.

--D

> -Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
> 
