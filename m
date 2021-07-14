Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30838C12002
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 23:02:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 14FA1613C2
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 23:02:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbhGNXFM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jul 2021 19:05:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:33792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229928AbhGNXFM (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 14 Jul 2021 19:05:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1606A613C2;
        Wed, 14 Jul 2021 23:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626303740;
        bh=wvtbFhIQvnJ4r90Mqc5ugbcglTRlCQlWLxEq8ygHcb4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ay3JzselO+XeH6SpfdWzlTJgnNJ2g0OetMEXDiwquCiqxa3h6fbRHEYUiuWyD7zSa
         1qv+FtUOf8N8liBReevBWJcNMQTSzv9NtS0atU+HmijFWOD0VKm0Vbh+l8yV0uFelU
         qJADvRV+wbyFrYo2Fvjhi39yQxdP86Z65L4WQ7LRQ5PamDBL2z4ny7REfEqjKKW34m
         LRaczrtdhTGCu+8a7KDTKIEeNZGM/0oF0jF09nImtqarupK8paNxHI+o9UCLNeNcgM
         p1ekN4Hdo1AaGdTSzjFzqOdmB/AymMIGLJ8CWqwLHP2mKyai3C+vERDQZjz3AIh/8W
         ZxULp8s8V8gvA==
Date:   Wed, 14 Jul 2021 16:02:19 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 06/16] xfs: consolidate mount option features in
 m_features
Message-ID: <20210714230219.GY22402@magnolia>
References: <20210714041912.2625692-1-david@fromorbit.com>
 <20210714041912.2625692-7-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210714041912.2625692-7-david@fromorbit.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jul 14, 2021 at 02:19:02PM +1000, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> This provides separation of mount time feature flags from runtime
> mount flags and mount option state. It also makes the feature
> checks use the same interface as the superblock features. i.e. we
> don't care if the feature is enabled by superblock flags or mount
> options, we just care if it's enabled or not.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/xfs/xfs_mount.h | 50 +++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 47 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/xfs/xfs_mount.h b/fs/xfs/xfs_mount.h
> index 8c0f928febac..b0e8c3825ce8 100644
> --- a/fs/xfs/xfs_mount.h
> +++ b/fs/xfs/xfs_mount.h
> @@ -258,6 +258,25 @@ typedef struct xfs_mount {
>  #define XFS_FEAT_BIGTIME	(1ULL << 24)	/* large timestamps */
>  #define XFS_FEAT_NEEDSREPAIR	(1ULL << 25)	/* needs xfs_repair */
>  
> +/* Mount features */
> +#define XFS_FEAT_NOATTR2	(1ULL << 48)	/* disable attr2 creation */
> +#define XFS_FEAT_NOALIGN	(1ULL << 49)	/* ignore alignment */
> +#define XFS_FEAT_ALLOCSIZE	(1ULL << 50)	/* user specified allocation size */
> +#define XFS_FEAT_LARGE_IOSIZE	(1ULL << 51)	/* report large preferred
> +						 * I/O size in stat() */
> +#define XFS_FEAT_WSYNC		(1ULL << 52)	/* synchronous metadata ops */
> +#define XFS_FEAT_DIRSYNC	(1ULL << 53)	/* synchronous directory ops */
> +#define XFS_FEAT_DISCARD	(1ULL << 54)	/* discard unused blocks */
> +#define XFS_FEAT_GRPID		(1ULL << 55)	/* group-ID assigned from directory */
> +#define XFS_FEAT_SMALL_INUMS	(1ULL << 56)	/* user wants 32bit inodes */
> +#define XFS_FEAT_IKEEP		(1ULL << 57)	/* keep empty inode clusters*/
> +#define XFS_FEAT_SWALLOC	(1ULL << 58)	/* stripe width allocation */
> +#define XFS_FEAT_FILESTREAMS	(1ULL << 59)	/* use filestreams allocator */
> +#define XFS_FEAT_DAX_ALWAYS	(1ULL << 60)	/* DAX always enabled */
> +#define XFS_FEAT_DAX_NEVER	(1ULL << 61)	/* DAX never enabled */
> +#define XFS_FEAT_NORECOVERY	(1ULL << 62)	/* no recovery - dirty fs */
> +#define XFS_FEAT_NOUUID		(1ULL << 63)	/* ignore uuid during mount */
> +
>  #define __XFS_HAS_FEAT(name, NAME) \
>  static inline bool xfs_has_ ## name (struct xfs_mount *mp) \
>  { \
> @@ -273,6 +292,7 @@ static inline void xfs_add_ ## name (struct xfs_mount *mp) \
>  	xfs_sb_version_add ## name(&mp->m_sb); \
>  }
>  
> +/* Superblock features */
>  __XFS_ADD_FEAT(attr, ATTR)
>  __XFS_HAS_FEAT(nlink, NLINK)
>  __XFS_ADD_FEAT(quota, QUOTA)
> @@ -296,9 +316,33 @@ __XFS_HAS_FEAT(reflink, REFLINK)
>  __XFS_HAS_FEAT(sparseinodes, SPINODES)
>  __XFS_HAS_FEAT(metauuid, META_UUID)
>  __XFS_HAS_FEAT(realtime, REALTIME)
> -__XFS_HAS_FEAT(inobtcounts, REALTIME)
> -__XFS_HAS_FEAT(bigtime, REALTIME)
> -__XFS_HAS_FEAT(needsrepair, REALTIME)
> +__XFS_HAS_FEAT(inobtcounts, INOBTCNT)
> +__XFS_HAS_FEAT(bigtime, BIGTIME)
> +__XFS_HAS_FEAT(needsrepair, NEEDSREPAIR)

This ought to go in the previous patch.

Otherwise looks fine to me,
Reviewed-by: Darrick J. Wong <djwong@kernel.org>

--D

> +
> +/*
> + * Mount features
> + *
> + * These do not change dynamically - features that can come and go,
> + * such as 32 bit inodes and read-only state, are kept as flags rather than
> + * features.
> + */
> +__XFS_HAS_FEAT(noattr2, NOATTR2)
> +__XFS_HAS_FEAT(noalign, NOALIGN)
> +__XFS_HAS_FEAT(allocsize, ALLOCSIZE)
> +__XFS_HAS_FEAT(large_iosize, LARGE_IOSIZE)
> +__XFS_HAS_FEAT(wsync, WSYNC)
> +__XFS_HAS_FEAT(dirsync, DIRSYNC)
> +__XFS_HAS_FEAT(discard, DISCARD)
> +__XFS_HAS_FEAT(grpid, GRPID)
> +__XFS_HAS_FEAT(small_inums, SMALL_INUMS)
> +__XFS_HAS_FEAT(ikeep, IKEEP)
> +__XFS_HAS_FEAT(swalloc, SWALLOC)
> +__XFS_HAS_FEAT(filestreams, FILESTREAMS)
> +__XFS_HAS_FEAT(dax_always, DAX_ALWAYS)
> +__XFS_HAS_FEAT(dax_never, DAX_NEVER)
> +__XFS_HAS_FEAT(norecovery, NORECOVERY)
> +__XFS_HAS_FEAT(nouuid, NOUUID)
>  
>  /*
>   * Flags for m_flags.
> -- 
> 2.31.1
> 
