Return-Path: <SRS0=m/8K=CN=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE0D2C43461
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Sep 2020 08:57:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AEB820791
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Sep 2020 08:57:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zo3Nwd9y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729584AbgIDI5n (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Sep 2020 04:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728205AbgIDI5m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Sep 2020 04:57:42 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33A70C061244
        for <linux-xfs@vger.kernel.org>; Fri,  4 Sep 2020 01:57:42 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id 5so4004653pgl.4
        for <linux-xfs@vger.kernel.org>; Fri, 04 Sep 2020 01:57:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iR01A7huzHZs6TTC1vH1vlPnbngPMwISvaJ+JN8qj9Q=;
        b=Zo3Nwd9y27BAnS0vaiTUlh3IQpg65u7p3dC6h5qjTBxVi4ZnEtM83A0z3t4FbGOYzf
         X9me51UvtTfKjOgL38IomzUVUyKzZUpbGbXLmx2XZygLgdsbTqZ5y6HApZYqwKbPyKh0
         X0AaoqXom/pN3eFgi+YVRuqY3uZD73tGFMi8pMIBkHS8zHmWNLTv5RkBS8KsFpdbEy42
         5GRGt4yFUamZl/77fUjxcNF+5/ZjlPW/9VRF5qSYm8wAa4dJzXVbnCt6d5jfVcwdvLeD
         wn0+cAURuWoA8BTOzr9V+y1O7B3SrOfuE+Av6QpZfr9SXlzciKq+zWBo2u77gxFX9I8l
         XXCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iR01A7huzHZs6TTC1vH1vlPnbngPMwISvaJ+JN8qj9Q=;
        b=roFiGxmEPvp9/8umIMOxKB4x1xIQfiYoJfEbQ/mWS3Vw04eAW57aFVxQNsTBcMExx8
         J+HPybqfR5kSy87XFuBrQRpx6FOO8xQVcY36PdstAWEw+CF7TwiGIs1PEz8uPcQDXUNQ
         ElID33M6uvxkHc/MwLYM3s+9q5VzblHCrK3ijIwmdcQHUzINpeIILQG4aIVrLLbo81wX
         sK1TuEa65gsBXXY4dEOOScT3NTtmlCQapxix/A0JwqfPlivMDX7uil3k4uOY8XxJN5H1
         hs9A39FtbOnXGB0Io8DAdr87bmc6m2QQqZE4cFMfsa01NV4L03oTx39q8ZPA8yDV50Jw
         cLcg==
X-Gm-Message-State: AOAM531cbhp2MpSGuT5gDIUfu4usaWChI4F9MWN6FmAfLx295y1yZWVY
        TKZVyVeBiV/WZ5TVA0k5gJU=
X-Google-Smtp-Source: ABdhPJzvWfN+OUbA1KEYU/tsFLBphkvu1WHYc4Xn8DMBeQlg8ltBK5eaqqPAo4mlj1KitJTLEn9CHQ==
X-Received: by 2002:a63:2fc7:: with SMTP id v190mr6238525pgv.250.1599209859804;
        Fri, 04 Sep 2020 01:57:39 -0700 (PDT)
Received: from garuda.localnet ([122.171.52.177])
        by smtp.gmail.com with ESMTPSA id w4sm6128799pfu.215.2020.09.04.01.57.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2020 01:57:39 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org, darrick.wong@oracle.com,
        bfoster@redhat.com
Subject: Re: [PATCH 3/3] xfs: Extend data/attr fork extent counter width
Date:   Fri, 04 Sep 2020 14:27:35 +0530
Message-ID: <6807151.PTRk86Yujf@garuda>
In-Reply-To: <20200903225145.GG12131@dread.disaster.area>
References: <20200831130010.454-1-chandanrlinux@gmail.com> <20200831130010.454-4-chandanrlinux@gmail.com> <20200903225145.GG12131@dread.disaster.area>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Friday 4 September 2020 4:21:45 AM IST Dave Chinner wrote:
> On Mon, Aug 31, 2020 at 06:30:10PM +0530, Chandan Babu R wrote:
> > The commit xfs: fix inode fork extent count overflow
> > (3f8a4f1d876d3e3e49e50b0396eaffcc4ba71b08) mentions that 10 billion
> > data fork extents should be possible to create. However the
> > corresponding on-disk field has a signed 32-bit type. Hence this
> > commit extends the per-inode data extent counter to 47 bits. The
> > length of 47-bits was chosen because,
> > Maximum file size = 2^63.
> > Maximum extent count when using 64k block size = 2^63 / 2^16 = 2^47.
> > 
> > Also, XFS has a per-inode xattr extent counter which is 16 bits
> > wide. A workload which
> > 1. Creates 1 million 255-byte sized xattrs,
> > 2. Deletes 50% of these xattrs in an alternating manner,
> > 3. Tries to insert 400,000 new 255-byte sized xattrs
> >    causes the xattr extent counter to overflow.
> > 
> > Dave tells me that there are instances where a single file has more than
> > 100 million hardlinks. With parent pointers being stored in xattrs, we
> > will overflow the signed 16-bits wide xattr extent counter when large
> > number of hardlinks are created. Hence this commit extends the on-disk
> > field to 32-bits.
> > 
> > The following changes are made to accomplish this,
> > 
> > 1. A new incompat superblock flag to prevent older kernels from mounting
> >    the filesystem. This flag has to be set during mkfs time.
> > 2. Carve out a new 32-bit field from xfs_dinode->di_pad2[]. This field
> >    holds the most significant 15 bits of the data extent counter.
> > 3. Carve out a new 16-bit field from xfs_dinode->di_pad2[]. This field
> >    holds the most significant 16 bits of the attr extent counter.
> > 
> > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> > ---
> >  fs/xfs/libxfs/xfs_bmap.c        |  8 ++++---
> >  fs/xfs/libxfs/xfs_format.h      | 20 ++++++++++++----
> >  fs/xfs/libxfs/xfs_inode_buf.c   | 42 ++++++++++++++++++++++++++-------
> >  fs/xfs/libxfs/xfs_inode_buf.h   |  4 ++--
> >  fs/xfs/libxfs/xfs_inode_fork.h  | 17 +++++++++----
> >  fs/xfs/libxfs/xfs_log_format.h  |  8 ++++---
> >  fs/xfs/libxfs/xfs_types.h       | 10 ++++----
> >  fs/xfs/scrub/inode.c            |  2 +-
> >  fs/xfs/xfs_inode.c              |  2 +-
> >  fs/xfs/xfs_inode_item.c         | 12 ++++++++--
> >  fs/xfs/xfs_inode_item_recover.c | 20 ++++++++++++----
> >  11 files changed, 105 insertions(+), 40 deletions(-)
> > 
> > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > index 16b983b8977d..8788f47ba59e 100644
> > --- a/fs/xfs/libxfs/xfs_bmap.c
> > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > @@ -52,9 +52,9 @@ xfs_bmap_compute_maxlevels(
> >  	xfs_mount_t	*mp,		/* file system mount structure */
> >  	int		whichfork)	/* data or attr fork */
> >  {
> > +	xfs_extnum_t	maxleafents;	/* max leaf entries possible */
> >  	int		level;		/* btree level */
> >  	uint		maxblocks;	/* max blocks at this level */
> > -	uint		maxleafents;	/* max leaf entries possible */
> >  	int		maxrootrecs;	/* max records in root block */
> >  	int		minleafrecs;	/* min records in leaf block */
> >  	int		minnoderecs;	/* min records in node block */
> > @@ -64,7 +64,9 @@ xfs_bmap_compute_maxlevels(
> >  	 * The maximum number of extents in a file, hence the maximum number of
> >  	 * leaf entries, is controlled by the size of the on-disk extent count,
> >  	 * either a signed 32-bit number for the data fork, or a signed 16-bit
> > -	 * number for the attr fork.
> > +	 * number for the attr fork. With mkfs.xfs' wide-extcount option
> > +	 * enabled, the data fork extent count is unsigned 47-bits wide, while
> > +	 * the corresponding attr fork extent count is unsigned 32-bits wide.
> 
> This doesn't really need to state what the sizes of the on disk
> fields are. If anything should state that, it's a description of the
> helper function that returns the maximum supported extent count.
> Also, it's the maximum extents in a the fork, not the _file_.
> 
> i.e. this should probably just read
> 
> 	 * The maximum number of extents in a fork, hence the maximum number of
> 	 * leaf entries, is controlled by the size of the on-disk extent count.

I agree. I will fix this up.

> 
> > diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> > index 5f41e177dbda..2684cafd0356 100644
> > --- a/fs/xfs/libxfs/xfs_format.h
> > +++ b/fs/xfs/libxfs/xfs_format.h
> > @@ -465,10 +465,12 @@ xfs_sb_has_ro_compat_feature(
> >  #define XFS_SB_FEAT_INCOMPAT_FTYPE	(1 << 0)	/* filetype in dirent */
> >  #define XFS_SB_FEAT_INCOMPAT_SPINODES	(1 << 1)	/* sparse inode chunks */
> >  #define XFS_SB_FEAT_INCOMPAT_META_UUID	(1 << 2)	/* metadata UUID */
> > -#define XFS_SB_FEAT_INCOMPAT_ALL \
> > +#define XFS_SB_FEAT_INCOMPAT_WIDEEXTCNT	(1 << 3)	/* Wider data/attr fork extent counters */
> > +#define XFS_SB_FEAT_INCOMPAT_ALL		\
> >  		(XFS_SB_FEAT_INCOMPAT_FTYPE|	\
> >  		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
> > -		 XFS_SB_FEAT_INCOMPAT_META_UUID)
> > +		 XFS_SB_FEAT_INCOMPAT_META_UUID| \
> > +		 XFS_SB_FEAT_INCOMPAT_WIDEEXTCNT)
> 
> Don't we normally add the feature bit in a standalone patch once all
> the infrastructure has already been put in place?

Yes, I now realize that code changes like "defining new fields in on-disk
inode structure" and "promoting xfs_extnum_t to uint64_t" can be moved to a
separate patch. I will split this patch into as many required parts before
posting the next version.

> 
> >  #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
> >  static inline bool
> > @@ -551,6 +553,12 @@ static inline bool xfs_sb_version_hasmetauuid(struct xfs_sb *sbp)
> >  		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_META_UUID);
> >  }
> >  
> > +static inline bool xfs_sb_version_haswideextcnt(struct xfs_sb *sbp)
> > +{
> > +	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) &&
> > +		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_WIDEEXTCNT);
> > +}
> 
> I don't really like the name of the feature :/
> 
> Precendence in naming feature additions like this is "32 bit project
> IDs" - when we extended them from 16 to 32 bits, we didn't call them
> "wide project IDs" as "wide" could mean anything. What do we do if
> we later need to increase the size of the attribute fork extent
> count? :/
> 
> xfs_sb_version_hasextcount_64bit() would match the 
> xfs_sb_version_hasprojid_32bit() naming internally....

I agree. I will fix the name here and in xfsprogs.

> 
> >  static inline bool xfs_sb_version_hasrmapbt(struct xfs_sb *sbp)
> >  {
> >  	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) &&
> > @@ -873,8 +881,8 @@ typedef struct xfs_dinode {
> >  	__be64		di_size;	/* number of bytes in file */
> >  	__be64		di_nblocks;	/* # of direct & btree blocks used */
> >  	__be32		di_extsize;	/* basic/minimum extent size for file */
> > -	__be32		di_nextents;	/* number of extents in data fork */
> > -	__be16		di_anextents;	/* number of extents in attribute fork*/
> > +	__be32		di_nextents_lo;	/* lower part of data fork extent count */
> > +	__be16		di_anextents_lo;/* lower part of attr fork extent count */
> >  	__u8		di_forkoff;	/* attr fork offs, <<3 for 64b align */
> >  	__s8		di_aformat;	/* format of attr fork's data */
> >  	__be32		di_dmevmask;	/* DMIG event mask */
> > @@ -891,7 +899,9 @@ typedef struct xfs_dinode {
> >  	__be64		di_lsn;		/* flush sequence */
> >  	__be64		di_flags2;	/* more random flags */
> >  	__be32		di_cowextsize;	/* basic cow extent size for file */
> > -	__u8		di_pad2[12];	/* more padding for future expansion */
> > +	__be32		di_nextents_hi; /* higher part of data fork extent count */
> > +	__be16		di_anextents_hi;/* higher part of attr fork extent count */
> > +	__u8		di_pad2[6];	/* more padding for future expansion */
> 
> I think I've mentioned this before - I don't really like extending
> inode variables this way. We did it for projid32 because we did not
> have any spare space in the v4 inode to do anything else.

Yes, You had suggested the "add new inode member" approach in one of the older
versions of the patchset. But Christoph had objected to this approach
(https://www.spinics.net/lists/linux-xfs/msg40112.html). Hence I had dropped
the idea. Sorry, I should have consulted with you before taking that decision.

> 
> I would kinda prefer to do something like this:
> 
> -	__be32		di_nextents;	/* number of extents in data fork */
> -	__be16		di_anextents;	/* number of extents in attribute fork*/
> +	__be32		di_nextents32;	/* 32 bit fork extent count */
> +	__be16		di_nextents16;	/* 16 bit fork extent count */
> ....
> -	__u8		di_pad2[12];	/* more padding for future expansion */
> +	__u8		di_pad2[4];	/* more padding for future expansion */
> +	__be64		di_nextents64;	/* 64 bit fork extent count */
> 
> 
> And then depending on the hasextcount_64bit bit is set, we read from
> disk like this:
> 
> 	if (hasextcount_64bit) {
> 		to->di_nextents = be64_to_cpu(dip->di_nextents64);
> 		to->di_naextents = be32_to_cpu(dip->di_nextents32);
> 		if (dip->di_nextents16 != 0)
> 			return -EFSCORRUPTED;
> 	} else {
> 		to->di_nextents = be32_to_cpu(dip->di_nextents32);
> 		to->di_naextents = be16_to_cpu(dip->di_nextents16);
> 		if (dip->di_nextents64 != 0)
> 			return -EFSCORRUPTED;
> 	}
> 
> and the writing to disk is equally simple. There's no bit shifting
> or masking, and we still end up with the same amount of unused space
> in the inode when hasextcount_64bit is set because di_nextents16 can
> be reused by another new feature....
> 
> > @@ -408,10 +425,17 @@ xfs_dfork_nextents(struct xfs_sb *sbp, struct xfs_dinode *dip, int whichfork)
> >  {
> >  	xfs_extnum_t nextents;
> >  
> > -	if (whichfork == XFS_DATA_FORK)
> > -		nextents = be32_to_cpu(dip->di_nextents);
> > -	else
> > -		nextents = be16_to_cpu(dip->di_anextents);
> > +	if (whichfork == XFS_DATA_FORK) {
> > +		nextents = be32_to_cpu(dip->di_nextents_lo);
> > +		if (xfs_sb_version_haswideextcnt(sbp))
> > +			nextents |=
> > +				((xfs_extnum_t)be32_to_cpu(dip->di_nextents_hi) << 32);
> > +	} else {
> > +		nextents = be16_to_cpu(dip->di_anextents_lo);
> > +		if (xfs_sb_version_haswideextcnt(sbp))
> > +			nextents |=
> > +				((xfs_aextnum_t)be16_to_cpu(dip->di_anextents_hi) << 16);
> > +	}
> 
> ... and we get rid of this bit of messy code :)

I agree. I am pretty sure that this will also make it easy to code up the
corresponding changes in xfs_db.

> 
> > @@ -157,10 +157,17 @@ static inline xfs_extnum_t xfs_iext_max(struct xfs_sb *sbp, int whichfork)
> >  {
> >  	ASSERT(whichfork == XFS_DATA_FORK || whichfork == XFS_ATTR_FORK);
> >  
> > -	if (whichfork == XFS_DATA_FORK)
> > -		return MAXEXTNUM;
> > -	else
> > -		return MAXAEXTNUM;
> > +	if (whichfork == XFS_DATA_FORK) {
> > +		if (xfs_sb_version_haswideextcnt(sbp))
> > +			return MAXEXTNUM_HI;
> > +		else
> > +			return MAXEXTNUM;
> > +	} else {
> > +		if (xfs_sb_version_haswideextcnt(sbp))
> > +			return MAXAEXTNUM_HI;
> > +		else
> > +			return MAXAEXTNUM;
> > +	}
> 
> I think we should actually rework MAXEXTNUM/MAXAEXTNUM before doing
> this. They are defined in xfs_types.h as in-memory limits, while
> these are actually returning on-disk format limits which should be
> defined in xfs_format.h
> 
> e.g:
> 
> #define XFS_IFORK_EXTCNT_MAX64	....
> #define XFS_IFORK_EXTCNT_MAX32	....
> #define XFS_IFORK_EXTCNT_MAX16	....
> 
> And in xfs_iext_max() we do:
> 
> 	bool has64 = xfs_sb_version_haswideextcnt()
> 
> 	switch (whichfork) {
> 	case XFS_DATA_FORK:
> 		return has64 ? XFS_IFORK_EXTCNT_MAX64 : XFS_IFORK_EXTCNT_MAX32;
> 	case XFS_ATTR_FORK:
> 		return has64 ? XFS_IFORK_EXTCNT_MAX32 : XFS_IFORK_EXTCNT_MAX16;
> 	case XFS_COW_FORK:
> 		return XFS_IFORK_EXTCNT_MAX32;
> 	default:
> 		ASSERT(0);
> 		break;
> 	}
> 	return -EFSCORRUPTED;
> 
> > @@ -59,8 +59,10 @@ typedef void *		xfs_failaddr_t;
> >   * Max values for extlen, extnum, aextnum.
> >   */
> >  #define	MAXEXTLEN	((xfs_extlen_t)0x001fffff)	/* 21 bits */
> > -#define	MAXEXTNUM	((xfs_extnum_t)0x7fffffff)	/* signed int */
> > -#define	MAXAEXTNUM	((xfs_aextnum_t)0x7fff)		/* signed short */
> > +#define	MAXEXTNUM	((int32_t)0x7fffffff)		/* signed int */
> > +#define	MAXAEXTNUM	((int16_t)0x7fff)		/* signed short */
> > +#define MAXEXTNUM_HI	((xfs_extnum_t)0x7fffffffffff)	/* unsigned 47 bits */
> > +#define MAXAEXTNUM_HI	((xfs_aextnum_t)0xffffffff)	/* unsigned 32 bits */
> 
> Yeah, these on-disk limits need to go into xfs_format.h and not used
> directly anymore...
>

Sure. I will apply the above comments in the next version of this patchset.

Thanks a lot for your time!

-- 
chandan



