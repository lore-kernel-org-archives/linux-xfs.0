Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B978A21E3C3
	for <linux-xfs@vger.kernel.org>; Tue, 15 Oct 2024 23:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729033410; cv=none; b=Mz/QLhJi08BDC05UaE4utx8/hXcdzCTTWMd9Mr+w73TIBH/CUbYggyDZhroRQoQLN959iB2787k/TDew+xX1UqQoWIb97btgpvQiJt3a1AYmVRv6NKcUBqA5GQiQCjUenN7n3Jk+jJjgnrxFmyoT7hqOxvp+5RY7D2lNcya5upA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729033410; c=relaxed/simple;
	bh=kgGUPUBwlaDhssoOabuYNUrWdwuGB4T5fjqPgW1qnUs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BjQmiyJKNLcCdB0q4VGKBz7vrWeciZK4xdUnL4m1o1bTW0OQ6I7QuKi0icU0GUuwW0IfJ/KQfzhI+kMnpFNGkSX1vectXXVlzNncDf9rUA1rHDFI2X+VcNqbuIXV3bh6kkioB1oqFhTqjy0mkVeoQjjaJn9udU5R8dJffh/ETcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=2WyIC6xH; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="2WyIC6xH"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-7e6cbf6cd1dso4135398a12.3
        for <linux-xfs@vger.kernel.org>; Tue, 15 Oct 2024 16:03:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1729033408; x=1729638208; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jKI9OXxu5+KlhQJILaa2ZGHxrhPWA5HiYUOUggphIOg=;
        b=2WyIC6xHUy23Ujr6E7RzAhA9IemA/IvXor8S6OhwB4diN/eYyW3LvQ4pfCRN2MZYVv
         bwNJ9Ks2QavA1hQwHcrk622cMg5Fl3D9wL9hU7a/CKBnx+yitMSwaP76hJKvUgU+xwzd
         E3bdffuYv/ttLwqQSWw1JXH+P5gfmJNgb0JB9WmivX17bAzee500UIgbfv0M9q75rZz5
         9IvhLcNAi8P146frN8+wXpP/Fs+PztltHx9BuFCvWLD0KBZT822EZIExS1eJCl9SDNLd
         KsZeb0IqupNixMbNGqcb4xxRYI/pE424uwpJCzdLaz/bmDTyrMmlN8nQ5WX67LpCwCkP
         42QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729033408; x=1729638208;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jKI9OXxu5+KlhQJILaa2ZGHxrhPWA5HiYUOUggphIOg=;
        b=HSqmZmKC+axRM5G1iboUUMPOeFsB0xbimBGqzlXM0jP99QVtJsINcjo4ZfyErwW8Q1
         LmFKS6vU6pX09vvsy9ClCRcqVECtFeLHyu/yyve9kb8tJ8jLnf+lJl4tIsxjhXRxh4e9
         K1Ku08TURvNSMkbJybgOw5UXeInc2Z9/4HJSpsrOa7ICpm4Ta4+y+qhi+a/DVjCv4TC3
         q9uyakSjh0z+0uS9hCWW+/HlN/Ag8yub6aoYAE70YWCAc20zWpwRMXXw4KvO5DTl4Umi
         PE4V2yEj990QcX0sXudR67bpQVtVYRQPKo77UyDLkxTNcX04NEQ7GZdJemHDJa61j413
         svFA==
X-Gm-Message-State: AOJu0YzFkVfA64LHnYeX6z5TL+C9aaS5W5dVQSdafjxXaI2FpixchglH
	jQapMMN61FAju8Jzt0v6J1Kfcg1pzyMtPFbWdH0wEXQrfL8XPWV7zS6zYSy/cwcF8hfnpbEz6j4
	2
X-Google-Smtp-Source: AGHT+IHuTI94SEwfUtJOyXEWfcP5X1amr6pc8fi2qG4SCXwFqiYX9m7cmX/6T4JkPTCU2qMDJr6UfQ==
X-Received: by 2002:a05:6a21:6b0b:b0:1d2:e78d:214a with SMTP id adf61e73a8af0-1d8bcfbae38mr25424072637.44.1729033407942;
        Tue, 15 Oct 2024 16:03:27 -0700 (PDT)
Received: from dread.disaster.area (pa49-186-209-182.pa.vic.optusnet.com.au. [49.186.209.182])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71e77394ca3sm1869143b3a.49.2024.10.15.16.03.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Oct 2024 16:03:27 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1t0qZY-001KUM-34;
	Wed, 16 Oct 2024 10:03:24 +1100
Date: Wed, 16 Oct 2024 10:03:24 +1100
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: linux-xfs@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 03/28] xfs: define the on-disk format for the metadir
 feature
Message-ID: <Zw70vBF6adb0GAzA@dread.disaster.area>
References: <172860641935.4176876.5699259080908526243.stgit@frogsfrogsfrogs>
 <172860642064.4176876.13567674130190367379.stgit@frogsfrogsfrogs>
 <Zw3rjkSklol5xOzE@dread.disaster.area>
 <20241015182541.GE21853@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241015182541.GE21853@frogsfrogsfrogs>

On Tue, Oct 15, 2024 at 11:25:41AM -0700, Darrick J. Wong wrote:
> > > diff --git a/fs/xfs/xfs_inode.h b/fs/xfs/xfs_inode.h
> > > index be7d4b26aaea3f..4b36dc2c9bf48b 100644
> > > --- a/fs/xfs/xfs_inode.h
> > > +++ b/fs/xfs/xfs_inode.h
> > > @@ -65,6 +65,7 @@ typedef struct xfs_inode {
> > >  		uint16_t	i_flushiter;	/* incremented on flush */
> > >  	};
> > >  	uint8_t			i_forkoff;	/* attr fork offset >> 3 */
> > > +	enum xfs_metafile_type	i_metatype;	/* XFS_METAFILE_* */
> > >  	uint16_t		i_diflags;	/* XFS_DIFLAG_... */
> > >  	uint64_t		i_diflags2;	/* XFS_DIFLAG2_... */
> > >  	struct timespec64	i_crtime;	/* time created */
> > > @@ -276,10 +277,23 @@ static inline bool xfs_is_reflink_inode(const struct xfs_inode *ip)
> > >  	return ip->i_diflags2 & XFS_DIFLAG2_REFLINK;
> > >  }
> > >  
> > > +static inline bool xfs_is_metadir_inode(const struct xfs_inode *ip)
> > > +{
> > > +	return ip->i_diflags2 & XFS_DIFLAG2_METADATA;
> > > +}
> > > +
> > >  static inline bool xfs_is_metadata_inode(const struct xfs_inode *ip)
> > 
> > Oh, that's going to get confusing. "is_metadir" checks the inode
> > METADATA flag, and is "is_metadata" checks the superblock METADIR
> > flag....
> > 
> > Can we change this to higher level function to
> > xfs_inode_is_internal() or something else that is not easily
> > confused with checking an inode flag?
> 
> But there's already xfs_internal_inum, which only covers sb-rooted
> metadata inodes.  I guess first we have to rename that to xfs_is_sb_inum
> in a separate patch, and then this one can add xfs_inode_is_internal.

Fine by me.

> > > diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
> > > index 457c2d70968d9a..59953278964de9 100644
> > > --- a/fs/xfs/xfs_super.c
> > > +++ b/fs/xfs/xfs_super.c
> > > @@ -1733,6 +1733,10 @@ xfs_fs_fill_super(
> > >  		mp->m_features &= ~XFS_FEAT_DISCARD;
> > >  	}
> > >  
> > > +	if (xfs_has_metadir(mp))
> > > +		xfs_warn(mp,
> > > +"EXPERIMENTAL metadata directory feature in use. Use at your own risk!");
> > > +
> > 
> > We really need a 'xfs_mark_experimental(mp, "Metadata directory")'
> > function to format all these experimental feature warnings the same
> > way....
> 
> We already have xfs_warn_mount for functionality that isn't sb feature
> bits.  Maybe xfs_warn_feat?

xfs_warn_mount() is only used for experimental warnings, so maybe we
should simply rename that xfs_mark_experiental().  Then we can use
it's inherent "warn once" behaviour for all the places where we
issue an experimental warning regardless of how the experimental
feature is enabled/detected. 

This means we'd have a single location that formats all experimental
feature warnings the same way. Having a single function explicitly
for this makes it trivial to audit and manage all the experimental
features supported by a given kernel version because we are no
longer reliant on grepping for custom format strings to find
experimental features.

It also means that adding a kernel taint flag indicating that the
kernel is running experimental code is trivial to do...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
