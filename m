Return-Path: <SRS0=Wnnb=7W=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 649CEC433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Jun 2020 14:24:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 35A942078D
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Jun 2020 14:24:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lkHa7Byv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730561AbgFIOYf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Jun 2020 10:24:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728601AbgFIOY3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 9 Jun 2020 10:24:29 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE726C05BD1E
        for <linux-xfs@vger.kernel.org>; Tue,  9 Jun 2020 07:24:28 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id q24so1485675pjd.1
        for <linux-xfs@vger.kernel.org>; Tue, 09 Jun 2020 07:24:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Y7qSCXXFdmIfw1KzT4Uytl55I+cr6LBcxYgBrjTJfIE=;
        b=lkHa7Byv5PxGG3JSATtDhXj0edhdFUMFcGIA5eT9oohBnF0dBTXWrWzVemz1H7WP1U
         G17B/snTJI2nXLXSZ7JsmhuxlXMjhpMAEn/Qp4PH1lFcsuI3PUKsJtTaKgJcQsUJ4CWE
         Lc53dDur0tVHh6nn/pyejlFYZrTguB0Ww2TmOCx71YHh14sCNKpggWef4X4ZStsV7X0f
         bjs5Yl1U9Yv2dFd6XrtpX8WyWnuo6WeqT5tvLGR6EBT9g9m9rzf/NZL4Sx2MxkbHKJQC
         0HUb7nlg4ZBSkDJKjtAtanU95LAKbWJWg0tJX9RUwEz4bJq3fXdMpO635OBqQv43G/Tw
         9b0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Y7qSCXXFdmIfw1KzT4Uytl55I+cr6LBcxYgBrjTJfIE=;
        b=CEGr1okCO+ocznVO1e8wdelblUwzjdxgXr3e73k8/KGWFs0p2z/DyP41zpx3rM4450
         jFdXH/FdB12Be3xk1ChRunCTHin7Sglnl4N49mCAsd27czDc27tfmEn98LaiU3VfE3RB
         /4qRTbhCD/gpbu4ENh95w/OC1t03sFcDwoMF+aQsECLhYVWVjKHta2yH1/eK7MmsvdzU
         XWnZRSCB99MUv2vtXnIi6u3LeoNEN9atbraObDyAevVEsys7YRzkim2l5DCQCPaURRGl
         9MjTXwQYQCOAvOCHXk38eZujd89sow2Bn1UG2i3ORCMJcokaMWKGYEnFeEXhC1oApA8R
         lbag==
X-Gm-Message-State: AOAM531r4PW5p2mQRNjoU5ub628zJOeWxxOw/vGwvNPnFlbeTzt9+UWZ
        PiBIF97Rj6PEIGMBgzk5LjE=
X-Google-Smtp-Source: ABdhPJw4QrU5qOKu2l3yyY7P3vUcGvyPRv+JSOppLmRHrUDBSzrXjuG41ULsdiGoDkaNVUenkSs9ww==
X-Received: by 2002:a17:902:aa01:: with SMTP id be1mr3515082plb.63.1591712668298;
        Tue, 09 Jun 2020 07:24:28 -0700 (PDT)
Received: from garuda.localnet ([171.48.18.33])
        by smtp.gmail.com with ESMTPSA id w24sm10135987pfn.11.2020.06.09.07.24.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2020 07:24:27 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, bfoster@redhat.com,
        hch@infradead.org
Subject: Re: [PATCH 7/7] xfs: Extend attr extent counter to 32 bits
Date:   Tue, 09 Jun 2020 19:52:56 +0530
Message-ID: <2794380.k9REX4Dakv@garuda>
In-Reply-To: <20200608172121.GG1334206@magnolia>
References: <20200606082745.15174-1-chandanrlinux@gmail.com> <20200606082745.15174-8-chandanrlinux@gmail.com> <20200608172121.GG1334206@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Monday 8 June 2020 10:51:21 PM IST Darrick J. Wong wrote:
> On Sat, Jun 06, 2020 at 01:57:45PM +0530, Chandan Babu R wrote:
> > This commit extends the per-inode attr extent counter to 32 bits.
> > 
> > The following changes are made to accomplish this,
> > 1. A new ro-compat superblock flag to prevent older kernels from
> >    mounting the filesystem in read-write mode. This flag is set for the
> >    first time when an inode would end up having more than 2^15 extents.
> > 3. Carve out a new 16-bit field from xfs_dinode->di_pad2[]. This field
> >    holds the most significant 16 bits of the attr extent counter.
> 
> How difficult is it to end up with an attr fork mapping more than 2^32
> blocks?  Supposing I have a file with nlinks==2^32-1, each mapped to a
> 255-byte name and some number of other xattrs?

- 2^32 nlinks each having 255 byte sized name.
  - Size of one xattr
    - name + value = 16 + 255 = 271
      16 comes from the size of the following structure,
      #+BEGIN_SRC fundamental
        struct xfs_parent_name_rec {
                __be64  p_ino;
                __be32  p_gen;
                __be32  p_diroffset;
        };
      #+END_SRC
  - sizeof(xfs_attr_leaf_hdr_t)
    32
  - sizeof(xfs_attr_leaf_entry_t)
    8
  - Number of entries in a 1k leaf block
    (1024 - sizeof(xfs_attr_leaf_hdr_t)) / (8 + 271)
    = (1024 - 32) / 279
    = 992 / 279
    = floor(3.55)
    = 3
  - Nr leaves = (2^32 / 3) * 3 (magicpct) = 4.3 billion
  - Nr entries per node = (1024 - sizeof(struct xfs_da3_node_hdr)) / sizeof(struct xfs_da_node_entry)
    = (1024 - 64) / 8
    = 120 entries
  - Nr entries at level (n - 1) = 4.3 billion / 120 = 36 million
  - Nr entries at level (n - 2) = 36 million / 120 = 300k
  - Nr entries at level (n - 3) = 300k / 120 = 2.5k
  - Nr entries at level (n - 4) = 2.5k / 120 = 20
  - Nr entries at level (n - 5) = 20 / 120 = 1
  Hence with 1024 block size, the maximum height (i.e. XFS_DA_NODE_MAXDEPTH)
  allowed for a dabtree would act as a limit.

  With 4k block size,
  - Number of entries in a 4k leaf block
    (4096 - sizeof(xfs_attr_leaf_hdr_t)) / (8 + 271)
    = (4096 - 32) / 279
    = 4064 / 279
    = floor(14.56)
    = 14
  - Nr leaves = (2^32 / 14) * 3 (magicpct) = 920 million
  - Nr entries per node = (4096 - sizeof(struct xfs_da3_node_hdr)) / sizeof(struct xfs_da_node_entry)
    = (4096 - 64) / 8
    = 504 entries
  - Nr entries at level (n - 1) = 920 million / 504 = 1.8 million
  - Nr entries at level (n - 2) = 1.8 million / 504 = 3.6k
  - Nr entries at level (n - 3) = 3.6k / 504 = 7
  - Nr entries at level (n - 4) = 7 / 504 = 1

  Total number of extents = 920 million + 1.8 million
  = 922 million
  < 2^32 (4.2 billion).

So we still have ample space in the 32-bit counter. 

> 
> > 2. A new inode->di_flags2 flag to indicate that the newly added field
> >    contains valid data. This flag is set when one of the following two
> >    conditions are met,
> >    - When the inode is about to have more than 2^15 extents.
> >    - When flushing the incore inode (See xfs_iflush_int()), if
> >      the superblock ro-compat flag is already set.
> > 
> > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> > ---
> >  fs/xfs/libxfs/xfs_format.h      | 25 ++++++++++---
> >  fs/xfs/libxfs/xfs_inode_buf.c   | 23 +++++++++---
> >  fs/xfs/libxfs/xfs_inode_fork.c  | 62 ++++++++++++++++++++++++++-------
> >  fs/xfs/libxfs/xfs_log_format.h  |  5 +--
> >  fs/xfs/libxfs/xfs_types.h       |  5 +--
> >  fs/xfs/scrub/inode.c            |  5 +--
> >  fs/xfs/xfs_inode.c              |  4 +++
> >  fs/xfs/xfs_inode_item.c         |  5 ++-
> >  fs/xfs/xfs_inode_item_recover.c |  8 ++++-
> >  9 files changed, 113 insertions(+), 29 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> > index 91bee33aa988..2e37d887fd35 100644
> > --- a/fs/xfs/libxfs/xfs_format.h
> > +++ b/fs/xfs/libxfs/xfs_format.h
> > @@ -450,11 +450,13 @@ xfs_sb_has_compat_feature(
> >  #define XFS_SB_FEAT_RO_COMPAT_RMAPBT   (1 << 1)		/* reverse map btree */
> >  #define XFS_SB_FEAT_RO_COMPAT_REFLINK  (1 << 2)		/* reflinked files */
> >  #define XFS_SB_FEAT_RO_COMPAT_47BIT_DEXT_CNTR (1 << 3)	/* 47bit data extents */
> > +#define XFS_SB_FEAT_RO_COMPAT_32BIT_AEXT_CNTR (1 << 4)	/* 32bit attr extents */
> 
> Can we bundle both of these changes in a single feature flag?  I would
> like to keep our feature testing matrix as small as we can.
> 
> /* 64-bit data fork extent counts and 32-bit attr fork extent counts */
> #define XFS_SB_FEAT_RO_COMPAT_BIG_FORK	(1 << 4)

Sure, this should be easy to implement.

> 
> >  #define XFS_SB_FEAT_RO_COMPAT_ALL \
> >  		(XFS_SB_FEAT_RO_COMPAT_FINOBT | \
> >  		 XFS_SB_FEAT_RO_COMPAT_RMAPBT | \
> >  		 XFS_SB_FEAT_RO_COMPAT_REFLINK | \
> > -		 XFS_SB_FEAT_RO_COMPAT_47BIT_DEXT_CNTR)
> > +		 XFS_SB_FEAT_RO_COMPAT_47BIT_DEXT_CNTR | \
> > +		 XFS_SB_FEAT_RO_COMPAT_32BIT_AEXT_CNTR)
> >  #define XFS_SB_FEAT_RO_COMPAT_UNKNOWN	~XFS_SB_FEAT_RO_COMPAT_ALL
> >  static inline bool
> >  xfs_sb_has_ro_compat_feature(
> > @@ -577,6 +579,18 @@ static inline void xfs_sb_version_add47bitext(struct xfs_sb *sbp)
> >  	sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_47BIT_DEXT_CNTR;
> >  }
> >  
> > +static inline bool xfs_sb_version_has32bitaext(struct xfs_sb *sbp)
> > +{
> > +	return XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5 &&
> > +		(sbp->sb_features_ro_compat &
> > +			XFS_SB_FEAT_RO_COMPAT_32BIT_AEXT_CNTR);
> > +}
> > +
> > +static inline void xfs_sb_version_add32bitaext(struct xfs_sb *sbp)
> > +{
> > +	sbp->sb_features_ro_compat |= XFS_SB_FEAT_RO_COMPAT_32BIT_AEXT_CNTR;
> > +}
> > +
> >  /*
> >   * end of superblock version macros
> >   */
> > @@ -888,7 +902,7 @@ typedef struct xfs_dinode {
> >  	__be64		di_nblocks;	/* # of direct & btree blocks used */
> >  	__be32		di_extsize;	/* basic/minimum extent size for file */
> >  	__be32		di_nextents_lo;	/* number of extents in data fork */
> > -	__be16		di_anextents;	/* number of extents in attribute fork*/
> > +	__be16		di_anextents_lo;/* lower part of xattr extent count */
> >  	__u8		di_forkoff;	/* attr fork offs, <<3 for 64b align */
> >  	__s8		di_aformat;	/* format of attr fork's data */
> >  	__be32		di_dmevmask;	/* DMIG event mask */
> > @@ -906,7 +920,8 @@ typedef struct xfs_dinode {
> >  	__be64		di_flags2;	/* more random flags */
> >  	__be32		di_cowextsize;	/* basic cow extent size for file */
> >  	__be32		di_nextents_hi;
> > -	__u8		di_pad2[8];	/* more padding for future expansion */
> > +	__be16		di_anextents_hi;/* higher part of xattr extent count */
> > +	__u8		di_pad2[6];	/* more padding for future expansion */
> >  
> >  	/* fields only written to during inode creation */
> >  	xfs_timestamp_t	di_crtime;	/* time created */
> > @@ -1073,14 +1088,16 @@ static inline void xfs_dinode_put_rdev(struct xfs_dinode *dip, xfs_dev_t rdev)
> >  #define XFS_DIFLAG2_REFLINK_BIT	1	/* file's blocks may be shared */
> >  #define XFS_DIFLAG2_COWEXTSIZE_BIT   2  /* copy on write extent size hint */
> >  #define XFS_DIFLAG2_47BIT_NEXTENTS_BIT 3 /* Uses di_nextents_hi field */
> > +#define XFS_DIFLAG2_32BIT_ANEXTENTS_BIT 4 /* Uses di_anextents_hi field  */
> 
> Same thing here.

Ok.

> 
> >  #define XFS_DIFLAG2_DAX		(1 << XFS_DIFLAG2_DAX_BIT)
> >  #define XFS_DIFLAG2_REFLINK     (1 << XFS_DIFLAG2_REFLINK_BIT)
> >  #define XFS_DIFLAG2_COWEXTSIZE  (1 << XFS_DIFLAG2_COWEXTSIZE_BIT)
> >  #define XFS_DIFLAG2_47BIT_NEXTENTS (1 << XFS_DIFLAG2_47BIT_NEXTENTS_BIT)
> > +#define XFS_DIFLAG2_32BIT_ANEXTENTS (1 << XFS_DIFLAG2_32BIT_ANEXTENTS_BIT)
> >  
> >  #define XFS_DIFLAG2_ANY \
> >  	(XFS_DIFLAG2_DAX | XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE | \
> > -	 XFS_DIFLAG2_47BIT_NEXTENTS)
> > +	 XFS_DIFLAG2_47BIT_NEXTENTS | XFS_DIFLAG2_32BIT_ANEXTENTS)
> >  
> >  /*
> >   * Inode number format:
> > diff --git a/fs/xfs/libxfs/xfs_inode_buf.c b/fs/xfs/libxfs/xfs_inode_buf.c
> > index 8b89fe080f70..285cbce0cd10 100644
> > --- a/fs/xfs/libxfs/xfs_inode_buf.c
> > +++ b/fs/xfs/libxfs/xfs_inode_buf.c
> > @@ -309,7 +309,8 @@ xfs_inode_to_disk(
> >  	to->di_extsize = cpu_to_be32(from->di_extsize);
> >  	to->di_nextents_lo = cpu_to_be32(xfs_ifork_nextents(&ip->i_df) &
> >  					0xffffffffU);
> > -	to->di_anextents = cpu_to_be16(xfs_ifork_nextents(ip->i_afp));
> > +	to->di_anextents_lo = cpu_to_be16(xfs_ifork_nextents(ip->i_afp) &
> > +					0xffffU);
> >  	to->di_forkoff = from->di_forkoff;
> >  	to->di_aformat = xfs_ifork_format(ip->i_afp);
> >  	to->di_dmevmask = cpu_to_be32(from->di_dmevmask);
> > @@ -327,6 +328,10 @@ xfs_inode_to_disk(
> >  			to->di_nextents_hi
> >  				= cpu_to_be32(xfs_ifork_nextents(&ip->i_df)
> >  					>> 32);
> > +		if (from->di_flags2 & XFS_DIFLAG2_32BIT_ANEXTENTS)
> > +			to->di_anextents_hi
> > +				= cpu_to_be16(xfs_ifork_nextents(ip->i_afp)
> > +					>> 16);
> >  		to->di_ino = cpu_to_be64(ip->i_ino);
> >  		to->di_lsn = cpu_to_be64(lsn);
> >  		memset(to->di_pad2, 0, sizeof(to->di_pad2));
> > @@ -366,7 +371,7 @@ xfs_log_dinode_to_disk(
> >  	to->di_nblocks = cpu_to_be64(from->di_nblocks);
> >  	to->di_extsize = cpu_to_be32(from->di_extsize);
> >  	to->di_nextents_lo = cpu_to_be32(from->di_nextents_lo);
> > -	to->di_anextents = cpu_to_be16(from->di_anextents);
> > +	to->di_anextents_lo = cpu_to_be16(from->di_anextents_lo);
> >  	to->di_forkoff = from->di_forkoff;
> >  	to->di_aformat = from->di_aformat;
> >  	to->di_dmevmask = cpu_to_be32(from->di_dmevmask);
> > @@ -383,6 +388,9 @@ xfs_log_dinode_to_disk(
> >  		if (from->di_flags2 & XFS_DIFLAG2_47BIT_NEXTENTS)
> >  			to->di_nextents_hi =
> >  				cpu_to_be32(from->di_nextents_hi);
> > +		if (from->di_flags2 & XFS_DIFLAG2_32BIT_ANEXTENTS)
> > +			to->di_anextents_hi =
> > +				cpu_to_be16(from->di_anextents_hi);
> >  		to->di_ino = cpu_to_be64(from->di_ino);
> >  		to->di_lsn = cpu_to_be64(from->di_lsn);
> >  		memcpy(to->di_pad2, from->di_pad2, sizeof(to->di_pad2));
> > @@ -566,7 +574,7 @@ xfs_dinode_verify(
> >  		default:
> >  			return __this_address;
> >  		}
> > -		if (dip->di_anextents)
> > +		if (xfs_dfork_nextents(&mp->m_sb, dip, XFS_ATTR_FORK))
> >  			return __this_address;
> >  	}
> >  
> > @@ -745,8 +753,13 @@ xfs_dfork_nextents(
> >  			&& (dip->di_flags2 & XFS_DIFLAG2_47BIT_NEXTENTS))
> >  			nextents |= (u64)(be32_to_cpu(dip->di_nextents_hi))
> >  				<< 32;
> > -		return nextents;
> >  	} else {
> > -		return be16_to_cpu(dip->di_anextents);
> > +		nextents = be16_to_cpu(dip->di_anextents_lo);
> > +		if (xfs_sb_version_has_v3inode(sbp)
> > +			&& (dip->di_flags2 & XFS_DIFLAG2_32BIT_ANEXTENTS))
> > +			nextents |= (u32)(be16_to_cpu(dip->di_anextents_hi))
> 
> <same if test logic vs. if body statement indentation complaint>

Ok. I will fix this up.

> 
> > +				<< 16;
> >  	}
> > +
> > +	return nextents;
> >  }
> > diff --git a/fs/xfs/libxfs/xfs_inode_fork.c b/fs/xfs/libxfs/xfs_inode_fork.c
> > index ec682e2d5bcb..169e16947ece 100644
> > --- a/fs/xfs/libxfs/xfs_inode_fork.c
> > +++ b/fs/xfs/libxfs/xfs_inode_fork.c
> > @@ -301,7 +301,10 @@ xfs_iformat_attr_fork(
> >  	ip->i_afp->if_format = dip->di_aformat;
> >  	if (unlikely(ip->i_afp->if_format == 0)) /* pre IRIX 6.2 file system */
> >  		ip->i_afp->if_format = XFS_DINODE_FMT_EXTENTS;
> > -	ip->i_afp->if_nextents = be16_to_cpu(dip->di_anextents);
> > +	ip->i_afp->if_nextents = be16_to_cpu(dip->di_anextents_lo);
> > +	if (ip->i_d.di_flags2 & XFS_DIFLAG2_32BIT_ANEXTENTS)
> > +		ip->i_afp->if_nextents |=
> > +			(u32)(be16_to_cpu(dip->di_anextents_hi)) << 16;
> >  
> >  	switch (ip->i_afp->if_format) {
> >  	case XFS_DINODE_FMT_LOCAL:
> > @@ -777,6 +780,48 @@ xfs_next_set_data(
> >  	return 0;
> >  }
> >  
> > +static int
> > +xfs_next_set_attr(
> > +	struct xfs_trans	*tp,
> > +	struct xfs_inode	*ip,
> > +	struct xfs_ifork	*ifp,
> > +	int			delta)
> > +{
> > +	struct xfs_mount	*mp = ip->i_mount;
> > +	xfs_aextnum_t		nr_exts;
> > +
> > +	nr_exts = ifp->if_nextents + delta;
> > +
> > +	if ((delta > 0 && nr_exts < ifp->if_nextents) ||
> > +		(delta < 0 && nr_exts > ifp->if_nextents))
> > +		return -EOVERFLOW;
> > +
> > +	if (ifp->if_nextents <= MAXAEXTNUM15BIT &&
> > +		nr_exts > MAXAEXTNUM15BIT &&
> > +		!(ip->i_d.di_flags2 & XFS_DIFLAG2_32BIT_ANEXTENTS) &&
> > +		xfs_sb_version_has_v3inode(&mp->m_sb)) {
> > +		if (!xfs_sb_version_has32bitaext(&mp->m_sb)) {
> 
> Indentation complaint^2

Ok. I will fix this up.

> 
> > +			bool log_sb = false;
> > +
> > +			spin_lock(&mp->m_sb_lock);
> > +			if (!xfs_sb_version_has32bitaext(&mp->m_sb)) {
> > +				xfs_sb_version_add32bitaext(&mp->m_sb);
> > +				log_sb = true;
> > +			}
> > +			spin_unlock(&mp->m_sb_lock);
> > +
> > +			if (log_sb)
> > +				xfs_log_sb(tp);
> > +		}
> > +
> > +		ip->i_d.di_flags2 |= XFS_DIFLAG2_32BIT_ANEXTENTS;
> > +	}
> > +
> > +	ifp->if_nextents = nr_exts;
> > +
> > +	return 0;
> > +}
> > +
> >  int
> >  xfs_next_set(
> >  	struct xfs_trans	*tp,
> > @@ -785,23 +830,16 @@ xfs_next_set(
> >  	int			delta)
> >  {
> >  	struct xfs_ifork	*ifp;
> > -	int64_t			nr_exts;
> >  	int			error = 0;
> >  
> >  	ifp = XFS_IFORK_PTR(ip, whichfork);
> >  
> > -	if (whichfork == XFS_DATA_FORK || whichfork == XFS_COW_FORK) {
> > +	if (whichfork == XFS_DATA_FORK || whichfork == XFS_COW_FORK)
> >  		error = xfs_next_set_data(tp, ip, ifp, delta);
> > -	} else if (whichfork == XFS_ATTR_FORK) {
> > -		nr_exts = ifp->if_nextents + delta;
> > -		if ((delta > 0 && nr_exts > MAXAEXTNUM)
> > -			|| (delta < 0 && nr_exts < 0))
> > -			return -EOVERFLOW;
> > -
> > -		ifp->if_nextents = nr_exts;
> > -	} else {
> > +	else if (whichfork == XFS_ATTR_FORK)
> > +		error = xfs_next_set_attr(tp, ip, ifp, delta);
> > +	else
> >  		ASSERT(0);
> > -	}
> >  
> >  	return error;
> >  }
> > diff --git a/fs/xfs/libxfs/xfs_log_format.h b/fs/xfs/libxfs/xfs_log_format.h
> > index 879aadff7692..db419fc862bc 100644
> > --- a/fs/xfs/libxfs/xfs_log_format.h
> > +++ b/fs/xfs/libxfs/xfs_log_format.h
> > @@ -397,7 +397,7 @@ struct xfs_log_dinode {
> >  	xfs_rfsblock_t	di_nblocks;	/* # of direct & btree blocks used */
> >  	xfs_extlen_t	di_extsize;	/* basic/minimum extent size for file */
> >  	uint32_t	di_nextents_lo;	/* number of extents in data fork */
> > -	xfs_aextnum_t	di_anextents;	/* number of extents in attribute fork*/
> > +	uint16_t	di_anextents_lo;/* lower part of xattr extent count */
> >  	uint8_t		di_forkoff;	/* attr fork offs, <<3 for 64b align */
> >  	int8_t		di_aformat;	/* format of attr fork's data */
> >  	uint32_t	di_dmevmask;	/* DMIG event mask */
> > @@ -415,7 +415,8 @@ struct xfs_log_dinode {
> >  	uint64_t	di_flags2;	/* more random flags */
> >  	uint32_t	di_cowextsize;	/* basic cow extent size for file */
> >  	uint32_t	di_nextents_hi;
> > -	uint8_t		di_pad2[8];	/* more padding for future expansion */
> > +	uint16_t	di_anextents_hi;/* higher part of xattr extent count */
> > +	uint8_t		di_pad2[6];	/* more padding for future expansion */
> >  
> >  	/* fields only written to during inode creation */
> >  	xfs_ictimestamp_t di_crtime;	/* time created */
> > diff --git a/fs/xfs/libxfs/xfs_types.h b/fs/xfs/libxfs/xfs_types.h
> > index c68ff2178976..974737a9e9c1 100644
> > --- a/fs/xfs/libxfs/xfs_types.h
> > +++ b/fs/xfs/libxfs/xfs_types.h
> > @@ -13,7 +13,7 @@ typedef uint32_t	xfs_agino_t;	/* inode # within allocation grp */
> >  typedef uint32_t	xfs_extlen_t;	/* extent length in blocks */
> >  typedef uint32_t	xfs_agnumber_t;	/* allocation group number */
> >  typedef uint64_t	xfs_extnum_t;	/* # of extents in a file */
> > -typedef int16_t		xfs_aextnum_t;	/* # extents in an attribute fork */
> > +typedef uint32_t	xfs_aextnum_t;	/* # extents in an attribute fork */
> >  typedef int64_t		xfs_fsize_t;	/* bytes in a file */
> >  typedef uint64_t	xfs_ufsize_t;	/* unsigned bytes in a file */
> >  
> > @@ -62,7 +62,8 @@ typedef void *		xfs_failaddr_t;
> >  #define	MAXEXTNUM31BIT	((xfs_extnum_t)0x7fffffff)	/* 31 bits */
> >  #define	MAXEXTNUM	((xfs_extnum_t)0x7fffffffffff)	/* 47 bits */
> >  #define	MAXDIREXTNUM	((xfs_extnum_t)0x7ffffff)	/* 27 bits */
> > -#define	MAXAEXTNUM	((xfs_aextnum_t)0x7fff)		/* signed short */
> > +#define	MAXAEXTNUM15BIT	((xfs_aextnum_t)0x7fff)		/* 15 bits */
> > +#define	MAXAEXTNUM	((xfs_aextnum_t)0xffffffff)	/* 32 bits */
> >  
> >  /*
> >   * Minimum and maximum blocksize and sectorsize.
> > diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
> > index be41fd242ff2..01e60c78a3a3 100644
> > --- a/fs/xfs/scrub/inode.c
> > +++ b/fs/xfs/scrub/inode.c
> > @@ -371,10 +371,12 @@ xchk_dinode(
> >  		break;
> >  	}
> >  
> > +	nextents = xfs_dfork_nextents(&mp->m_sb, dip, XFS_ATTR_FORK);
> > +
> >  	/* di_forkoff */
> >  	if (XFS_DFORK_APTR(dip) >= (char *)dip + mp->m_sb.sb_inodesize)
> >  		xchk_ino_set_corrupt(sc, ino);
> > -	if (dip->di_anextents != 0 && dip->di_forkoff == 0)
> > +	if (nextents != 0 && dip->di_forkoff == 0)
> >  		xchk_ino_set_corrupt(sc, ino);
> >  	if (dip->di_forkoff == 0 && dip->di_aformat != XFS_DINODE_FMT_EXTENTS)
> >  		xchk_ino_set_corrupt(sc, ino);
> > @@ -386,7 +388,6 @@ xchk_dinode(
> >  		xchk_ino_set_corrupt(sc, ino);
> >  
> >  	/* di_anextents */
> > -	nextents = be16_to_cpu(dip->di_anextents);
> >  	fork_recs =  XFS_DFORK_ASIZE(dip, mp) / sizeof(struct xfs_bmbt_rec);
> >  	switch (dip->di_aformat) {
> >  	case XFS_DINODE_FMT_EXTENTS:
> > diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
> > index 4418a66cf6d6..6ec34e069344 100644
> > --- a/fs/xfs/xfs_inode.c
> > +++ b/fs/xfs/xfs_inode.c
> > @@ -3789,6 +3789,10 @@ xfs_iflush_int(
> >  		&& xfs_sb_version_has47bitext(&mp->m_sb))
> >  		ip->i_d.di_flags2 |= XFS_DIFLAG2_47BIT_NEXTENTS;
> >  
> > +	if (!(ip->i_d.di_flags2 & XFS_DIFLAG2_32BIT_ANEXTENTS)
> > +		&& xfs_sb_version_has32bitaext(&mp->m_sb))
> > +		ip->i_d.di_flags2 |= XFS_DIFLAG2_32BIT_ANEXTENTS;
> > +
> >  	/*
> >  	 * Copy the dirty parts of the inode into the on-disk inode.  We always
> >  	 * copy out the core of the inode, because if the inode is dirty at all
> > diff --git a/fs/xfs/xfs_inode_item.c b/fs/xfs/xfs_inode_item.c
> > index 6f27ac7c8631..40f0a19d1c07 100644
> > --- a/fs/xfs/xfs_inode_item.c
> > +++ b/fs/xfs/xfs_inode_item.c
> > @@ -327,7 +327,7 @@ xfs_inode_to_log_dinode(
> >  	to->di_nblocks = from->di_nblocks;
> >  	to->di_extsize = from->di_extsize;
> >  	to->di_nextents_lo = xfs_ifork_nextents(&ip->i_df) & 0xffffffffU;
> > -	to->di_anextents = xfs_ifork_nextents(ip->i_afp);
> > +	to->di_anextents_lo = xfs_ifork_nextents(ip->i_afp) & 0xffffU;
> >  	to->di_forkoff = from->di_forkoff;
> >  	to->di_aformat = xfs_ifork_format(ip->i_afp);
> >  	to->di_dmevmask = from->di_dmevmask;
> > @@ -347,6 +347,9 @@ xfs_inode_to_log_dinode(
> >  		if (from->di_flags2 & XFS_DIFLAG2_47BIT_NEXTENTS)
> >  			to->di_nextents_hi =
> >  				xfs_ifork_nextents(&ip->i_df) >> 32;
> > +		if (from->di_flags2 & XFS_DIFLAG2_32BIT_ANEXTENTS)
> > +			to->di_anextents_hi =
> > +				xfs_ifork_nextents(ip->i_afp) >> 16;
> >  		to->di_ino = ip->i_ino;
> >  		to->di_lsn = lsn;
> >  		memset(to->di_pad2, 0, sizeof(to->di_pad2));
> > diff --git a/fs/xfs/xfs_inode_item_recover.c b/fs/xfs/xfs_inode_item_recover.c
> > index 8d64b861fb66..c8b5fbba848b 100644
> > --- a/fs/xfs/xfs_inode_item_recover.c
> > +++ b/fs/xfs/xfs_inode_item_recover.c
> > @@ -135,6 +135,7 @@ xlog_recover_inode_commit_pass2(
> >  	uint				isize;
> >  	int				need_free = 0;
> >  	xfs_extnum_t			nextents;
> > +	xfs_aextnum_t			anextents;
> >  
> >  	if (item->ri_buf[0].i_len == sizeof(struct xfs_inode_log_format)) {
> >  		in_f = item->ri_buf[0].i_addr;
> > @@ -262,7 +263,12 @@ xlog_recover_inode_commit_pass2(
> >  		ldip->di_flags2 & XFS_DIFLAG2_47BIT_NEXTENTS)
> >  		nextents |= ((u64)(ldip->di_nextents_hi) << 32);
> >  
> > -	nextents += ldip->di_anextents;
> > +	anextents = ldip->di_anextents_lo;
> > +	if (xfs_sb_version_has_v3inode(&mp->m_sb) &&
> > +		ldip->di_flags2 & XFS_DIFLAG2_32BIT_ANEXTENTS)
> > +		anextents |= ((u32)(ldip->di_anextents_hi) << 16);
> > +
> > +	nextents += anextents;
> >  
> >  	if (unlikely(nextents > ldip->di_nblocks)) {
> >  		XFS_CORRUPTION_ERROR("xlog_recover_inode_pass2(5)",
> 

-- 
chandan



