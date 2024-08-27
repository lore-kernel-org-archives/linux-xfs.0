Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D86D10E9
	for <linux-xfs@vger.kernel.org>; Tue, 27 Aug 2024 01:05:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724720758; cv=none; b=Bz1AkpO/4/Pf6ZPuZ7LhcxKG649O4DWHBTlvbbeeiIp2Sn+8CnZOZXOiCnt9H98YWjEjOZ8+BNbXl2SRof0OHjdHOxmdIVDlnlOGnQSDoQiO/PYo6ca5XlhPazi42RRHKJPvs+gEf3ytSI5OXWh+9ZJyL/YcNzjUAYNGFe5WBgA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724720758; c=relaxed/simple;
	bh=cSA6c+t3vEyJansKpgvDf6mOtPHUeic0l+SqG4N3/Ag=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NoSUXPbRAn1egtCRUGETetTQze6mgyGH8pRW8P0INN8xaL4sMNhjNAer1LRI0gfhLreBYGw+rAn494A+hgQ/igKiFklipzqITLEzlYmtvosmxDi7BJMur9CDLV51hwBFZFXksqtnTAvzRRWEUCSJxOVQPZcrUQQnt3su2IjAgcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=FHP+YC2Z; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="FHP+YC2Z"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-20219a0fe4dso48163925ad.2
        for <linux-xfs@vger.kernel.org>; Mon, 26 Aug 2024 18:05:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1724720756; x=1725325556; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IVv8uPXc7iWgcAQg+pryTYezVU8twIApiWvn5w3q5kk=;
        b=FHP+YC2ZN+ghzBtIYWPPnvE54l5L3WpCR+/5Kq/Ns/Ur2XfwFyS+GgwNF+XflA6nW1
         upICfyhW4SnSZxX3jieKMX9KCIU7FmHEwBiaIT6UmDbe616AkjYru3nj3eHtyI6QFjYi
         acdsNAo2kEU7YFh0ac+OtNYPOEFk2Nfy/4WUy37CbvBUaRJKccpA7fnwDqAi7TwCse/8
         mhVjXCiX7dFYbJWaIuBuoowSncDI1PcVmm49iW0k/zOQgfOi4Sd0kWyQRKjJp73CtUIO
         NopU333973wKKlRBygtLgWrlzqZlgeCo89AYxT5lpmuJR1kgswJUpQR0TCyDfizm/hop
         62+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724720756; x=1725325556;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IVv8uPXc7iWgcAQg+pryTYezVU8twIApiWvn5w3q5kk=;
        b=EczajboNaZSNsfIlxv7F4l9EcuH8zdESo1CosUwU33afuc6fACh8FDKj+6N2fl4Lh5
         qXPlTiJOVOPcB83Xd5wgIve8xrjwXY73kbhI5OZY9Yij8akx8aUBtJskBPuHVqR9pI96
         8KPpcNWAP2/CRx2szWk87P6uuAjKTmIXCGDKbQwkrI3EPSZsgxYY/zDjxKezwhdVtbEu
         uo9QDUxnu1qeJ5aCKqTohiXgP3I/i3sY+qCFTdriY2JaqSzZH1WwZ6S6/YJcq/Dy87yS
         9Ni0mFzoAEMl/rt21hEp+oT0YLoJX5PrlLOTUX7gNG1NInskpVFrgs9mCxWZh5BnKHwJ
         stLA==
X-Forwarded-Encrypted: i=1; AJvYcCXIPqLD+2JLFMSGrYrm56gSZ3IDlQbTReg6QgOSzqJdQOcmVDD6inmTftIrj5JFIE3xX3Qev1PTw14=@vger.kernel.org
X-Gm-Message-State: AOJu0YwPK7ZgR3C2/PnDX04RHOm5nOOqG27RYmoj1FCvlX3VPqgFHl7I
	tluiqjLrgk9EY3Rg9xXpIpNH94Px2KIUp6WIGCWX4/tEZkEyev3k5rKbBKwsknk=
X-Google-Smtp-Source: AGHT+IEv/TLnjdnFSKvoQZ8iZH2SRkYlg41ocmhIsWdKlng9bw7pDh8xzAATbLSE5N90RgTw72R9vQ==
X-Received: by 2002:a17:903:2449:b0:1fa:128c:4315 with SMTP id d9443c01a7336-2039e4ef297mr141361475ad.44.1724720755790;
        Mon, 26 Aug 2024 18:05:55 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-47-239.pa.nsw.optusnet.com.au. [49.181.47.239])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20385608eb5sm72969845ad.188.2024.08.26.18.05.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Aug 2024 18:05:55 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1sikef-00DywU-0C;
	Tue, 27 Aug 2024 11:05:53 +1000
Date: Tue, 27 Aug 2024 11:05:53 +1000
From: Dave Chinner <david@fromorbit.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: hch@lst.de, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 14/24] xfs: support caching rtgroup metadata inodes
Message-ID: <Zs0mcWjsEzTeAysF@dread.disaster.area>
References: <172437087178.59588.10818863865198159576.stgit@frogsfrogsfrogs>
 <172437087487.59588.6672080001636292983.stgit@frogsfrogsfrogs>
 <ZsvdP4IaRNpJcavt@dread.disaster.area>
 <20240826183734.GB865349@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240826183734.GB865349@frogsfrogsfrogs>

On Mon, Aug 26, 2024 at 11:37:34AM -0700, Darrick J. Wong wrote:
> On Mon, Aug 26, 2024 at 11:41:19AM +1000, Dave Chinner wrote:
> > On Thu, Aug 22, 2024 at 05:18:18PM -0700, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Create the necessary per-rtgroup infrastructure that we need to load
> > > metadata inodes into memory.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  fs/xfs/libxfs/xfs_rtgroup.c |  182 +++++++++++++++++++++++++++++++++++++++++++
> > >  fs/xfs/libxfs/xfs_rtgroup.h |   28 +++++++
> > >  fs/xfs/xfs_mount.h          |    1 
> > >  fs/xfs/xfs_rtalloc.c        |   48 +++++++++++
> > >  4 files changed, 258 insertions(+), 1 deletion(-)
> > > 
> > > 
> > > diff --git a/fs/xfs/libxfs/xfs_rtgroup.c b/fs/xfs/libxfs/xfs_rtgroup.c
> > > index ae6d67c673b1a..50e4a56d749f0 100644
> > > --- a/fs/xfs/libxfs/xfs_rtgroup.c
> > > +++ b/fs/xfs/libxfs/xfs_rtgroup.c
> > > @@ -30,6 +30,8 @@
> > >  #include "xfs_icache.h"
> > >  #include "xfs_rtgroup.h"
> > >  #include "xfs_rtbitmap.h"
> > > +#include "xfs_metafile.h"
> > > +#include "xfs_metadir.h"
> > >  
> > >  /*
> > >   * Passive reference counting access wrappers to the rtgroup structures.  If
> > > @@ -295,3 +297,183 @@ xfs_rtginode_lockdep_setup(
> > >  #else
> > >  #define xfs_rtginode_lockdep_setup(ip, rgno, type)	do { } while (0)
> > >  #endif /* CONFIG_PROVE_LOCKING */
> > > +
> > > +struct xfs_rtginode_ops {
> > > +	const char		*name;	/* short name */
> > > +
> > > +	enum xfs_metafile_type	metafile_type;
> > > +
> > > +	/* Does the fs have this feature? */
> > > +	bool			(*enabled)(struct xfs_mount *mp);
> > > +
> > > +	/* Create this rtgroup metadata inode and initialize it. */
> > > +	int			(*create)(struct xfs_rtgroup *rtg,
> > > +					  struct xfs_inode *ip,
> > > +					  struct xfs_trans *tp,
> > > +					  bool init);
> > > +};
> > 
> > What's all this for?
> > 
> > AFAICT, loading the inodes into the rtgs requires a call to
> > xfs_metadir_load() when initialising the rtg (either at mount or
> > lazily on the first access to the rtg). Hence I'm not really sure
> > what this complexity is needed for, and the commit message is not
> > very informative....
> 
> Yes, the creation and mkdir code in here is really to support growfs,
> mkfs, and repair.  How about I change the commit message to:
> 
> "Create the necessary per-rtgroup infrastructure that we need to load
> metadata inodes into memory and to create directory trees on the fly.
> Loading is needed by the mounting process.  Creation is needed by
> growfs, mkfs, and repair."

IMO it would have been nicer to add this with the patch that
adds growfs support for rtgs. That way the initial inode loading
would be much easier to understand and review, and the rest of it
would have enough context to be able to review it sanely. There
isn't enough context in this patch to determine if the creation code
is sane or works correctly....


> > > +	path = xfs_rtginode_path(rtg->rtg_rgno, type);
> > > +	if (!path)
> > > +		return -ENOMEM;
> > > +	error = xfs_metadir_load(tp, mp->m_rtdirip, path, ops->metafile_type,
> > > +			&ip);
> > > +	kfree(path);
> > > +
> > > +	if (error)
> > > +		return error;
> > > +
> > > +	if (XFS_IS_CORRUPT(mp, ip->i_df.if_format != XFS_DINODE_FMT_EXTENTS &&
> > > +			       ip->i_df.if_format != XFS_DINODE_FMT_BTREE)) {
> > > +		xfs_irele(ip);
> > > +		return -EFSCORRUPTED;
> > > +	}
> > 
> > We don't support LOCAL format for any type of regular file inodes,
> > so I'm a little confiused as to why this wouldn't be caught by the
> > verifier on inode read? i.e.  What problem is this trying to catch,
> > and why doesn't the inode verifier catch it for us?
> 
> This is really more of a placeholder for more refactorings coming down
> the line for the rtrmap patchset, which will create a new
> XFS_DINODE_FMT_RMAP.  At that time we'll need to check that an inode
> that we are loading to be the rmap btree actually has that set.

Ok, can you leave a comment to indicate this so I don't have to
remember why this code exists?

-Dave.
-- 
Dave Chinner
david@fromorbit.com
