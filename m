Return-Path: <SRS0=54lF=CQ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 372BCC43461
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Sep 2020 04:02:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ECCC220DD4
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Sep 2020 04:02:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I9dP9dPt"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725925AbgIGECW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Sep 2020 00:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725778AbgIGECU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Sep 2020 00:02:20 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBE29C061573
        for <linux-xfs@vger.kernel.org>; Sun,  6 Sep 2020 21:02:19 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id d19so438854pld.0
        for <linux-xfs@vger.kernel.org>; Sun, 06 Sep 2020 21:02:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VehSt3KovLcz+Qhg8LTsLV3UCwd3lAQDENPX2WuiHbg=;
        b=I9dP9dPtV9y8qEp0mylPh/OK4ocnP3XiMW8kK/6ar4JHb4Et1NEvDOka5tI/gOwK2a
         AzpVU2wspCwguHmDS5rR42k9jObeLFl+mlFSCmvh/LkRCkv5Kzzu0HQTTwQdkE26qEqg
         d942s6z+9nSNZLS2jJRva9FrheS4oC5Qds21AluHkdRELAwGKC3ewSoAeyD5PxiJI6ma
         fxbSHZ4VtmwX2+thsqVooRN8/KXB2j7yq0Ps6DIQuslF7XlpuJPgPwfwIqjYLAOvTW/o
         BPlXlVa5T5K/CZMAjjh9qyc84wQXM9aJsdyn8dE/SVUMV9k2MiLCygrYW7oXvwV6u9ZE
         C5tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VehSt3KovLcz+Qhg8LTsLV3UCwd3lAQDENPX2WuiHbg=;
        b=b9tOwcY9IjL2n4wtvnmIrrr/qj608WSNw9Tun0YocgJt0btgBUv9uUCrSg0olFPUrE
         hUakWjCkKs+DNIFGW/K8qhYv9+S8KaY8e3VDRBL28auRoTSUzx7AS+5E/eWouhCo/Fd0
         WO6vWyGSaHUH2NbyLkcLPWEnJZcL2h5GXKaIH8uBrXOAV+WOqpEDahBLigczWiGlmEDU
         IWUDdrml+olCbbroXyXaN51jgHrc2rzZOFLa70TYeTkfjEwSZ/K++e/8lRj7lH81Hveq
         acfSqnCUpVVRpkJDocewmBsuoCCqqR1nbBBknyDZORiwoaIeysQa+AhctAev7WUc3qBc
         o87g==
X-Gm-Message-State: AOAM531HPY7Wfvtyu4Lmnd52exRU9lfw8DSssm792G6csUZqEM6BXZAp
        R4vfmBC3uHy6NYNdo8uv4dVAmsrg2T4=
X-Google-Smtp-Source: ABdhPJxc5FK5Vr0fKGG2/aDhgvyrlbXhdCuw1pkM6YtGz5SFGZzCxWyOltjIxeHSpdGjeRd+zAescQ==
X-Received: by 2002:a17:90a:c253:: with SMTP id d19mr18612225pjx.113.1599451339147;
        Sun, 06 Sep 2020 21:02:19 -0700 (PDT)
Received: from garuda.localnet ([122.179.41.226])
        by smtp.gmail.com with ESMTPSA id f4sm12263708pfj.147.2020.09.06.21.02.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2020 21:02:18 -0700 (PDT)
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <darrick.wong@oracle.com>
Cc:     Dave Chinner <david@fromorbit.com>, linux-xfs@vger.kernel.org,
        bfoster@redhat.com
Subject: Re: [PATCH 3/3] xfs: Extend data/attr fork extent counter width
Date:   Mon, 07 Sep 2020 09:32:10 +0530
Message-ID: <2827845.zS5pBWUM0r@garuda>
In-Reply-To: <20200904155123.GH6096@magnolia>
References: <20200831130010.454-1-chandanrlinux@gmail.com> <6807151.PTRk86Yujf@garuda> <20200904155123.GH6096@magnolia>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Friday 4 September 2020 9:21:35 PM IST Darrick J. Wong wrote:
> On Fri, Sep 04, 2020 at 02:27:35PM +0530, Chandan Babu R wrote:
> > On Friday 4 September 2020 4:21:45 AM IST Dave Chinner wrote:
> > > On Mon, Aug 31, 2020 at 06:30:10PM +0530, Chandan Babu R wrote:
> > > > The commit xfs: fix inode fork extent count overflow
> > > > (3f8a4f1d876d3e3e49e50b0396eaffcc4ba71b08) mentions that 10 billion
> > > > data fork extents should be possible to create. However the
> > > > corresponding on-disk field has a signed 32-bit type. Hence this
> > > > commit extends the per-inode data extent counter to 47 bits. The
> > > > length of 47-bits was chosen because,
> > > > Maximum file size = 2^63.
> > > > Maximum extent count when using 64k block size = 2^63 / 2^16 = 2^47.
> > > > 
> > > > Also, XFS has a per-inode xattr extent counter which is 16 bits
> > > > wide. A workload which
> > > > 1. Creates 1 million 255-byte sized xattrs,
> > > > 2. Deletes 50% of these xattrs in an alternating manner,
> > > > 3. Tries to insert 400,000 new 255-byte sized xattrs
> > > >    causes the xattr extent counter to overflow.
> > > > 
> > > > Dave tells me that there are instances where a single file has more than
> > > > 100 million hardlinks. With parent pointers being stored in xattrs, we
> > > > will overflow the signed 16-bits wide xattr extent counter when large
> > > > number of hardlinks are created. Hence this commit extends the on-disk
> > > > field to 32-bits.
> > > > 
> > > > The following changes are made to accomplish this,
> > > > 
> > > > 1. A new incompat superblock flag to prevent older kernels from mounting
> > > >    the filesystem. This flag has to be set during mkfs time.
> > > > 2. Carve out a new 32-bit field from xfs_dinode->di_pad2[]. This field
> > > >    holds the most significant 15 bits of the data extent counter.
> > > > 3. Carve out a new 16-bit field from xfs_dinode->di_pad2[]. This field
> > > >    holds the most significant 16 bits of the attr extent counter.
> > > > 
> > > > Signed-off-by: Chandan Babu R <chandanrlinux@gmail.com>
> > > > ---
> > > >  fs/xfs/libxfs/xfs_bmap.c        |  8 ++++---
> > > >  fs/xfs/libxfs/xfs_format.h      | 20 ++++++++++++----
> > > >  fs/xfs/libxfs/xfs_inode_buf.c   | 42 ++++++++++++++++++++++++++-------
> > > >  fs/xfs/libxfs/xfs_inode_buf.h   |  4 ++--
> > > >  fs/xfs/libxfs/xfs_inode_fork.h  | 17 +++++++++----
> > > >  fs/xfs/libxfs/xfs_log_format.h  |  8 ++++---
> > > >  fs/xfs/libxfs/xfs_types.h       | 10 ++++----
> > > >  fs/xfs/scrub/inode.c            |  2 +-
> > > >  fs/xfs/xfs_inode.c              |  2 +-
> > > >  fs/xfs/xfs_inode_item.c         | 12 ++++++++--
> > > >  fs/xfs/xfs_inode_item_recover.c | 20 ++++++++++++----
> > > >  11 files changed, 105 insertions(+), 40 deletions(-)
> > > > 
> > > > diff --git a/fs/xfs/libxfs/xfs_bmap.c b/fs/xfs/libxfs/xfs_bmap.c
> > > > index 16b983b8977d..8788f47ba59e 100644
> > > > --- a/fs/xfs/libxfs/xfs_bmap.c
> > > > +++ b/fs/xfs/libxfs/xfs_bmap.c
> > > > @@ -52,9 +52,9 @@ xfs_bmap_compute_maxlevels(
> > > >  	xfs_mount_t	*mp,		/* file system mount structure */
> > > >  	int		whichfork)	/* data or attr fork */
> > > >  {
> > > > +	xfs_extnum_t	maxleafents;	/* max leaf entries possible */
> > > >  	int		level;		/* btree level */
> > > >  	uint		maxblocks;	/* max blocks at this level */
> > > > -	uint		maxleafents;	/* max leaf entries possible */
> > > >  	int		maxrootrecs;	/* max records in root block */
> > > >  	int		minleafrecs;	/* min records in leaf block */
> > > >  	int		minnoderecs;	/* min records in node block */
> > > > @@ -64,7 +64,9 @@ xfs_bmap_compute_maxlevels(
> > > >  	 * The maximum number of extents in a file, hence the maximum number of
> > > >  	 * leaf entries, is controlled by the size of the on-disk extent count,
> > > >  	 * either a signed 32-bit number for the data fork, or a signed 16-bit
> > > > -	 * number for the attr fork.
> > > > +	 * number for the attr fork. With mkfs.xfs' wide-extcount option
> > > > +	 * enabled, the data fork extent count is unsigned 47-bits wide, while
> > > > +	 * the corresponding attr fork extent count is unsigned 32-bits wide.
> > > 
> > > This doesn't really need to state what the sizes of the on disk
> > > fields are. If anything should state that, it's a description of the
> > > helper function that returns the maximum supported extent count.
> > > Also, it's the maximum extents in a the fork, not the _file_.
> > > 
> > > i.e. this should probably just read
> > > 
> > > 	 * The maximum number of extents in a fork, hence the maximum number of
> > > 	 * leaf entries, is controlled by the size of the on-disk extent count.
> > 
> > I agree. I will fix this up.
> > 
> > > 
> > > > diff --git a/fs/xfs/libxfs/xfs_format.h b/fs/xfs/libxfs/xfs_format.h
> > > > index 5f41e177dbda..2684cafd0356 100644
> > > > --- a/fs/xfs/libxfs/xfs_format.h
> > > > +++ b/fs/xfs/libxfs/xfs_format.h
> > > > @@ -465,10 +465,12 @@ xfs_sb_has_ro_compat_feature(
> > > >  #define XFS_SB_FEAT_INCOMPAT_FTYPE	(1 << 0)	/* filetype in dirent */
> > > >  #define XFS_SB_FEAT_INCOMPAT_SPINODES	(1 << 1)	/* sparse inode chunks */
> > > >  #define XFS_SB_FEAT_INCOMPAT_META_UUID	(1 << 2)	/* metadata UUID */
> > > > -#define XFS_SB_FEAT_INCOMPAT_ALL \
> > > > +#define XFS_SB_FEAT_INCOMPAT_WIDEEXTCNT	(1 << 3)	/* Wider data/attr fork extent counters */
> > > > +#define XFS_SB_FEAT_INCOMPAT_ALL		\
> > > >  		(XFS_SB_FEAT_INCOMPAT_FTYPE|	\
> > > >  		 XFS_SB_FEAT_INCOMPAT_SPINODES|	\
> > > > -		 XFS_SB_FEAT_INCOMPAT_META_UUID)
> > > > +		 XFS_SB_FEAT_INCOMPAT_META_UUID| \
> > > > +		 XFS_SB_FEAT_INCOMPAT_WIDEEXTCNT)
> > > 
> > > Don't we normally add the feature bit in a standalone patch once all
> > > the infrastructure has already been put in place?
> > 
> > Yes, I now realize that code changes like "defining new fields in on-disk
> > inode structure" and "promoting xfs_extnum_t to uint64_t" can be moved to a
> > separate patch. I will split this patch into as many required parts before
> > posting the next version.
> > 
> > > 
> > > >  #define XFS_SB_FEAT_INCOMPAT_UNKNOWN	~XFS_SB_FEAT_INCOMPAT_ALL
> > > >  static inline bool
> > > > @@ -551,6 +553,12 @@ static inline bool xfs_sb_version_hasmetauuid(struct xfs_sb *sbp)
> > > >  		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_META_UUID);
> > > >  }
> > > >  
> > > > +static inline bool xfs_sb_version_haswideextcnt(struct xfs_sb *sbp)
> > > > +{
> > > > +	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) &&
> > > > +		(sbp->sb_features_incompat & XFS_SB_FEAT_INCOMPAT_WIDEEXTCNT);
> > > > +}
> > > 
> > > I don't really like the name of the feature :/
> > > 
> > > Precendence in naming feature additions like this is "32 bit project
> > > IDs" - when we extended them from 16 to 32 bits, we didn't call them
> > > "wide project IDs" as "wide" could mean anything. What do we do if
> > > we later need to increase the size of the attribute fork extent
> > > count? :/
> > > 
> > > xfs_sb_version_hasextcount_64bit() would match the 
> > > xfs_sb_version_hasprojid_32bit() naming internally....
> 
> I was about to suggest "nexts64" but my brain typo'd that into "next4"
> and no don't go there. ;)
> 
> > 
> > I agree. I will fix the name here and in xfsprogs.
> > 
> > > 
> > > >  static inline bool xfs_sb_version_hasrmapbt(struct xfs_sb *sbp)
> > > >  {
> > > >  	return (XFS_SB_VERSION_NUM(sbp) == XFS_SB_VERSION_5) &&
> > > > @@ -873,8 +881,8 @@ typedef struct xfs_dinode {
> > > >  	__be64		di_size;	/* number of bytes in file */
> > > >  	__be64		di_nblocks;	/* # of direct & btree blocks used */
> > > >  	__be32		di_extsize;	/* basic/minimum extent size for file */
> > > > -	__be32		di_nextents;	/* number of extents in data fork */
> > > > -	__be16		di_anextents;	/* number of extents in attribute fork*/
> > > > +	__be32		di_nextents_lo;	/* lower part of data fork extent count */
> > > > +	__be16		di_anextents_lo;/* lower part of attr fork extent count */
> > > >  	__u8		di_forkoff;	/* attr fork offs, <<3 for 64b align */
> > > >  	__s8		di_aformat;	/* format of attr fork's data */
> > > >  	__be32		di_dmevmask;	/* DMIG event mask */
> > > > @@ -891,7 +899,9 @@ typedef struct xfs_dinode {
> > > >  	__be64		di_lsn;		/* flush sequence */
> > > >  	__be64		di_flags2;	/* more random flags */
> > > >  	__be32		di_cowextsize;	/* basic cow extent size for file */
> > > > -	__u8		di_pad2[12];	/* more padding for future expansion */
> > > > +	__be32		di_nextents_hi; /* higher part of data fork extent count */
> > > > +	__be16		di_anextents_hi;/* higher part of attr fork extent count */
> > > > +	__u8		di_pad2[6];	/* more padding for future expansion */
> > > 
> > > I think I've mentioned this before - I don't really like extending
> > > inode variables this way. We did it for projid32 because we did not
> > > have any spare space in the v4 inode to do anything else.
> > 
> > Yes, You had suggested the "add new inode member" approach in one of the older
> > versions of the patchset. But Christoph had objected to this approach
> > (https://www.spinics.net/lists/linux-xfs/msg40112.html). Hence I had dropped
> > the idea. Sorry, I should have consulted with you before taking that decision.
> > 
> > > 
> > > I would kinda prefer to do something like this:
> > > 
> > > -	__be32		di_nextents;	/* number of extents in data fork */
> > > -	__be16		di_anextents;	/* number of extents in attribute fork*/
> > > +	__be32		di_nextents32;	/* 32 bit fork extent count */
> > > +	__be16		di_nextents16;	/* 16 bit fork extent count */
> > > ....
> > > -	__u8		di_pad2[12];	/* more padding for future expansion */
> > > +	__u8		di_pad2[4];	/* more padding for future expansion */
> > > +	__be64		di_nextents64;	/* 64 bit fork extent count */
> 
> The comments for these fields had better document the fact that we have
> this shifty encoding scheme.  Something like:
> 
> 	/*
> 	 * On a extcount64 filesystem, di_nextents64 holds the data fork
> 	 * extent count, di_nextents32 holds the attr fork extent count,
> 	 * and di_nextents16 must be zero.
> 	 *
> 	 * Without that feature, di_nextents32 holds the data fork
> 	 * extent count, di_nextents16 holds the attr fork extent count,
> 	 * and di_nextents64 must be zero.
> 	 */
> 	__be32		di_nextents32;
> 	__be16		di_nextents16;
> 	....
> 	__be64		di_nextents64;
>

Ok. I will add the relevant descriptions.

-- 
chandan



