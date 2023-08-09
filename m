Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D893C41513
	for <linux-xfs@archiver.kernel.org>; Wed,  9 Aug 2023 08:43:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230435AbjHIInG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 9 Aug 2023 04:43:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231971AbjHIInF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 9 Aug 2023 04:43:05 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 441831FDE
        for <linux-xfs@vger.kernel.org>; Wed,  9 Aug 2023 01:43:03 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id d9443c01a7336-1bc8b15c3c3so10409235ad.0
        for <linux-xfs@vger.kernel.org>; Wed, 09 Aug 2023 01:43:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20221208.gappssmtp.com; s=20221208; t=1691570583; x=1692175383;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iOzUwpQ1cs4szofsoVqJoODrxn5mjUpuudTf/A+DKg4=;
        b=ZMRJA80UJuqZV3cJui/GqBolq46kkJQbPWonNAi0ahPHdfvCExtrpy7rocg73VQcEx
         Z1PniEuBHbHXhq9Zw0isvGS7v2OhqzP99tkjd/54WwPfz0q2T/+v6ueC6+Eqq2rXWHBN
         j4g658y2KHRAiKCQZMB+4EXFA+MbL8GClfd6eL4SgsXdZecJzRdQ/9i47spdwXi/JAiV
         odInJn3vFAi/+4Sb52XP63idn5nyXgEN4KLZnrWrU2n79eHMw94Oa+MHGsu3qyoZlG89
         apeC/bz3LChAjZVgTyuNAvdNvv5JQWR8YSXVS6rvOF+Zt1iRnBFN9CvuTfBHOrI3s8F5
         JMag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691570583; x=1692175383;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iOzUwpQ1cs4szofsoVqJoODrxn5mjUpuudTf/A+DKg4=;
        b=G4tm74ZAEYOkiJ7NVhJ6jFLpC8ZLh7gcdN1HSDZJB3nzLLJTEoUrRBqrzkOFJIsBAm
         M9WgecaIImLJu/p9EY6OtgrB5VwZBbhfCEj2Ufg3U7rT3gwS73bWas07UJs/N0Z51h3R
         12X0r/0MsmfV3T5L913ndwr13PmV43sznLjNhC+PsPA4/Qqa0fn1+orBT7YGY67stS87
         y5A/oUoKg2n4xwfy4+N6qkI5flKdQhTCDVUIcPxNvp7wpmK1pZN656yhwnnLGBvGrXPw
         R5Azltx5dWp/c2kBZV62w+5CIobC8wHqHetvgwJMCWr/jo/oEn4e+8rhABebwcafOo7t
         n0Fg==
X-Gm-Message-State: AOJu0YyiM1uOGVivcERYC04PpUtZPk/u5r+uKUtChYKGJEIEPoBsN4it
        T3UQwLQGmq1Goe+1xuA/H1Ppg8P6jfB12f8Uzec=
X-Google-Smtp-Source: AGHT+IGAvv027kB0pmNJHWi6B4BhR4CPWUDg410rgrlUfnHewZqvXzcDYKCcgn2GsayLcGJMKer2XQ==
X-Received: by 2002:a17:902:e550:b0:1b8:76fc:5bf6 with SMTP id n16-20020a170902e55000b001b876fc5bf6mr2337442plf.43.1691570582533;
        Wed, 09 Aug 2023 01:43:02 -0700 (PDT)
Received: from dread.disaster.area (pa49-180-166-213.pa.nsw.optusnet.com.au. [49.180.166.213])
        by smtp.gmail.com with ESMTPSA id l6-20020a170902d34600b001b9df8f14d7sm10494281plk.267.2023.08.09.01.43.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Aug 2023 01:43:01 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
        (envelope-from <david@fromorbit.com>)
        id 1qTemQ-0034px-1k;
        Wed, 09 Aug 2023 18:42:58 +1000
Date:   Wed, 9 Aug 2023 18:42:58 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/6] xfs: repair inode records
Message-ID: <ZNNRkggtITHqTjm9@dread.disaster.area>
References: <169049626432.922543.2560381879385116722.stgit@frogsfrogsfrogs>
 <169049626483.922543.14635359971498732607.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169049626483.922543.14635359971498732607.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Jul 27, 2023 at 03:32:53PM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> If an inode is so badly damaged that it cannot be loaded into the cache,
> fix the ondisk metadata and try again.  If there /is/ a cached inode,
> fix any problems and apply any optimizations that can be solved incore.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
.....
> diff --git a/fs/xfs/scrub/inode_repair.c b/fs/xfs/scrub/inode_repair.c
> new file mode 100644
> index 0000000000000..952832e9fd029
> --- /dev/null
> +++ b/fs/xfs/scrub/inode_repair.c
> @@ -0,0 +1,763 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * Copyright (C) 2018-2023 Oracle.  All Rights Reserved.
> + * Author: Darrick J. Wong <djwong@kernel.org>
> + */
> +#include "xfs.h"
> +#include "xfs_fs.h"
> +#include "xfs_shared.h"
> +#include "xfs_format.h"
> +#include "xfs_trans_resv.h"
> +#include "xfs_mount.h"
> +#include "xfs_defer.h"
> +#include "xfs_btree.h"
> +#include "xfs_bit.h"
> +#include "xfs_log_format.h"
> +#include "xfs_trans.h"
> +#include "xfs_sb.h"
> +#include "xfs_inode.h"
> +#include "xfs_icache.h"
> +#include "xfs_inode_buf.h"
> +#include "xfs_inode_fork.h"
> +#include "xfs_ialloc.h"
> +#include "xfs_da_format.h"
> +#include "xfs_reflink.h"
> +#include "xfs_rmap.h"
> +#include "xfs_bmap.h"
> +#include "xfs_bmap_util.h"
> +#include "xfs_dir2.h"
> +#include "xfs_dir2_priv.h"
> +#include "xfs_quota_defs.h"
> +#include "xfs_quota.h"
> +#include "xfs_ag.h"
> +#include "scrub/xfs_scrub.h"
> +#include "scrub/scrub.h"
> +#include "scrub/common.h"
> +#include "scrub/btree.h"
> +#include "scrub/trace.h"
> +#include "scrub/repair.h"
> +
> +/*
> + * Inode Repair
> + *
> + * Roughly speaking, inode problems can be classified based on whether or not
> + * they trip the dinode verifiers.  If those trip, then we won't be able to
> + * _iget ourselves the inode.
> + *
> + * Therefore, the xrep_dinode_* functions fix anything that will cause the
> + * inode buffer verifier or the dinode verifier.  The xrep_inode_* functions
> + * fix things on live incore inodes.
> + */

I'd like to see some of the decisions made documented here. Stuff
like:

- "unknown di_mode converts inode to a regular file only root can
  read" needs to be clearly documented because that "regular file"
  that results might not actually contain user data....
- what we do with setuid/setgid on repaired inodes
- things we just trash and leave to other parts of repair to clean
  up stuff we leak or trash...


> +/* Fix any conflicting flags that the verifiers complain about. */
> +STATIC void
> +xrep_dinode_flags(
> +	struct xfs_scrub	*sc,
> +	struct xfs_dinode	*dip)
> +{
> +	struct xfs_mount	*mp = sc->mp;
> +	uint64_t		flags2;
> +	uint16_t		mode;
> +	uint16_t		flags;
> +
> +	trace_xrep_dinode_flags(sc, dip);
> +
> +	mode = be16_to_cpu(dip->di_mode);
> +	flags = be16_to_cpu(dip->di_flags);
> +	flags2 = be64_to_cpu(dip->di_flags2);
> +
> +	if (xfs_has_reflink(mp) && S_ISREG(mode))
> +		flags2 |= XFS_DIFLAG2_REFLINK;
> +	else
> +		flags2 &= ~(XFS_DIFLAG2_REFLINK | XFS_DIFLAG2_COWEXTSIZE);
> +	if (flags & XFS_DIFLAG_REALTIME)
> +		flags2 &= ~XFS_DIFLAG2_REFLINK;
> +	if (flags2 & XFS_DIFLAG2_REFLINK)
> +		flags2 &= ~XFS_DIFLAG2_DAX;

IIRC, reflink and DAX co-exist just fine now....

> +	if (!xfs_has_bigtime(mp))
> +		flags2 &= ~XFS_DIFLAG2_BIGTIME;
> +	if (!xfs_has_large_extent_counts(mp))
> +		flags2 &= ~XFS_DIFLAG2_NREXT64;
> +	if (flags2 & XFS_DIFLAG2_NREXT64)
> +		dip->di_nrext64_pad = 0;
> +	else if (dip->di_version >= 3)
> +		dip->di_v3_pad = 0;
> +	dip->di_flags = cpu_to_be16(flags);
> +	dip->di_flags2 = cpu_to_be64(flags2);
> +}
> +
> +/*
> + * Blow out symlink; now it points to the current dir.  We don't have to worry
> + * about incore state because this inode is failing the verifiers.
> + */
> +STATIC void
> +xrep_dinode_zap_symlink(
> +	struct xfs_scrub	*sc,
> +	struct xfs_dinode	*dip)
> +{
> +	char			*p;
> +
> +	trace_xrep_dinode_zap_symlink(sc, dip);
> +
> +	dip->di_format = XFS_DINODE_FMT_LOCAL;
> +	dip->di_size = cpu_to_be64(1);
> +	p = XFS_DFORK_PTR(dip, XFS_DATA_FORK);
> +	*p = '.';

What if this was in extent form? Didn't we just leak an extent?

> +}
> +
> +/*
> + * Blow out dir, make it point to the root.  In the future repair will
> + * reconstruct this directory for us.  Note that there's no in-core directory
> + * inode because the sf verifier tripped, so we don't have to worry about the
> + * dentry cache.
> + */
> +STATIC void
> +xrep_dinode_zap_dir(
> +	struct xfs_scrub	*sc,
> +	struct xfs_dinode	*dip)
> +{
> +	struct xfs_mount	*mp = sc->mp;
> +	struct xfs_dir2_sf_hdr	*sfp;
> +	int			i8count;
> +
> +	trace_xrep_dinode_zap_dir(sc, dip);
> +
> +	dip->di_format = XFS_DINODE_FMT_LOCAL;
> +	i8count = mp->m_sb.sb_rootino > XFS_DIR2_MAX_SHORT_INUM;
> +	sfp = XFS_DFORK_PTR(dip, XFS_DATA_FORK);
> +	sfp->count = 0;
> +	sfp->i8count = i8count;
> +	xfs_dir2_sf_put_parent_ino(sfp, mp->m_sb.sb_rootino);
> +	dip->di_size = cpu_to_be64(xfs_dir2_sf_hdr_size(i8count));
> +}

Same here?

> +
> +/* Make sure we don't have a garbage file size. */
> +STATIC void
> +xrep_dinode_size(
> +	struct xfs_scrub	*sc,
> +	struct xfs_dinode	*dip)
> +{
> +	uint64_t		size;
> +	uint16_t		mode;
> +
> +	trace_xrep_dinode_size(sc, dip);
> +
> +	mode = be16_to_cpu(dip->di_mode);
> +	size = be64_to_cpu(dip->di_size);
> +	switch (mode & S_IFMT) {
> +	case S_IFIFO:
> +	case S_IFCHR:
> +	case S_IFBLK:
> +	case S_IFSOCK:
> +		/* di_size can't be nonzero for special files */
> +		dip->di_size = 0;
> +		break;
> +	case S_IFREG:
> +		/* Regular files can't be larger than 2^63-1 bytes. */
> +		dip->di_size = cpu_to_be64(size & ~(1ULL << 63));
> +		break;
> +	case S_IFLNK:
> +		/*
> +		 * Truncate ridiculously oversized symlinks.  If the size is
> +		 * zero, reset it to point to the current directory.  Both of
> +		 * these conditions trigger dinode verifier errors, so there
> +		 * is no in-core state to reset.
> +		 */
> +		if (size > XFS_SYMLINK_MAXLEN)
> +			dip->di_size = cpu_to_be64(XFS_SYMLINK_MAXLEN);
> +		else if (size == 0)
> +			xrep_dinode_zap_symlink(sc, dip);
> +		break;
> +	case S_IFDIR:
> +		/*
> +		 * Directories can't have a size larger than 32G.  If the size
> +		 * is zero, reset it to an empty directory.  Both of these
> +		 * conditions trigger dinode verifier errors, so there is no
> +		 * in-core state to reset.
> +		 */
> +		if (size > XFS_DIR2_SPACE_SIZE)
> +			dip->di_size = cpu_to_be64(XFS_DIR2_SPACE_SIZE);
> +		else if (size == 0)
> +			xrep_dinode_zap_dir(sc, dip);
> +		break;
> +	}
> +}
> +
> +/* Fix extent size hints. */
> +STATIC void
> +xrep_dinode_extsize_hints(
> +	struct xfs_scrub	*sc,
> +	struct xfs_dinode	*dip)
> +{
> +	struct xfs_mount	*mp = sc->mp;
> +	uint64_t		flags2;
> +	uint16_t		flags;
> +	uint16_t		mode;
> +	xfs_failaddr_t		fa;
> +
> +	trace_xrep_dinode_extsize_hints(sc, dip);
> +
> +	mode = be16_to_cpu(dip->di_mode);
> +	flags = be16_to_cpu(dip->di_flags);
> +	flags2 = be64_to_cpu(dip->di_flags2);
> +
> +	fa = xfs_inode_validate_extsize(mp, be32_to_cpu(dip->di_extsize),
> +			mode, flags);
> +	if (fa) {
> +		dip->di_extsize = 0;
> +		dip->di_flags &= ~cpu_to_be16(XFS_DIFLAG_EXTSIZE |
> +					      XFS_DIFLAG_EXTSZINHERIT);
> +	}
> +
> +	if (dip->di_version < 3)
> +		return;
> +
> +	fa = xfs_inode_validate_cowextsize(mp, be32_to_cpu(dip->di_cowextsize),
> +			mode, flags, flags2);
> +	if (fa) {
> +		dip->di_cowextsize = 0;
> +		dip->di_flags2 &= ~cpu_to_be64(XFS_DIFLAG2_COWEXTSIZE);
> +	}
> +}
> +
> +/* Inode didn't pass verifiers, so fix the raw buffer and retry iget. */
> +STATIC int
> +xrep_dinode_core(
> +	struct xrep_inode	*ri)
> +{
> +	struct xfs_scrub	*sc = ri->sc;
> +	struct xfs_buf		*bp;
> +	struct xfs_dinode	*dip;
> +	xfs_ino_t		ino = sc->sm->sm_ino;
> +	int			error;
> +
> +	/* Read the inode cluster buffer. */
> +	error = xfs_trans_read_buf(sc->mp, sc->tp, sc->mp->m_ddev_targp,
> +			ri->imap.im_blkno, ri->imap.im_len, XBF_UNMAPPED, &bp,
> +			NULL);
> +	if (error)
> +		return error;
> +
> +	/* Make sure we can pass the inode buffer verifier. */
> +	xrep_dinode_buf(sc, bp);
> +	bp->b_ops = &xfs_inode_buf_ops;

Hmmmmm. Don't we at least need to check this looks like an inode
cluster buffer first?

....
> +
> +/* Check for invalid uid/gid/prid. */
> +STATIC void
> +xrep_inode_ids(
> +	struct xfs_scrub	*sc)
> +{
> +	trace_xrep_inode_ids(sc);
> +
> +	if (i_uid_read(VFS_I(sc->ip)) == -1U) {
> +		i_uid_write(VFS_I(sc->ip), 0);
> +		VFS_I(sc->ip)->i_mode &= ~(S_ISUID | S_ISGID);
> +		if (XFS_IS_UQUOTA_ON(sc->mp))
> +			xrep_force_quotacheck(sc, XFS_DQTYPE_USER);
> +	}
> +
> +	if (i_gid_read(VFS_I(sc->ip)) == -1U) {
> +		i_gid_write(VFS_I(sc->ip), 0);
> +		VFS_I(sc->ip)->i_mode &= ~(S_ISUID | S_ISGID);
> +		if (XFS_IS_GQUOTA_ON(sc->mp))
> +			xrep_force_quotacheck(sc, XFS_DQTYPE_GROUP);
> +	}

IF we are repairing an inode that has setuid or setgid, I think we
should just strip those permissions regardless of whether the
uid/gid are valid. It think it's better to be cautious here rather
than leave setuid on a file that we reconstructed but have no real
way of knowing that data in the file is untainted.

> +
> +	if (sc->ip->i_projid == -1U) {
> +		sc->ip->i_projid = 0;
> +		if (XFS_IS_PQUOTA_ON(sc->mp))
> +			xrep_force_quotacheck(sc, XFS_DQTYPE_PROJ);
> +	}
> +}
> +
> +static inline void
> +xrep_clamp_nsec(
> +	struct timespec64	*ts)
> +{
> +	ts->tv_nsec = clamp_t(long, ts->tv_nsec, 0, NSEC_PER_SEC);
> +}
> +
> +/* Nanosecond counters can't have more than 1 billion. */
> +STATIC void
> +xrep_inode_timestamps(
> +	struct xfs_inode	*ip)
> +{
> +	xrep_clamp_nsec(&VFS_I(ip)->i_atime);
> +	xrep_clamp_nsec(&VFS_I(ip)->i_mtime);
> +	xrep_clamp_nsec(&VFS_I(ip)->i_ctime);
> +	xrep_clamp_nsec(&ip->i_crtime);
> +}

Should we be clamping the entire timestamp within the valid
filesystem timestamp range here?

> +
> +/* Fix inode flags that don't make sense together. */
> +STATIC void
> +xrep_inode_flags(
> +	struct xfs_scrub	*sc)
> +{
> +	uint16_t		mode;
> +
> +	trace_xrep_inode_flags(sc);
....
> +	/* No mixing reflink and DAX yet. */
> +	if (sc->ip->i_diflags2 & XFS_DIFLAG2_REFLINK)
> +		sc->ip->i_diflags2 &= ~XFS_DIFLAG2_DAX;

This can go, too...

.....
> @@ -750,6 +750,38 @@ xrep_ino_dqattach(
>  }
>  #endif /* CONFIG_XFS_QUOTA */
>  
> +/*
> + * Ensure that the inode being repaired is ready to handle a certain number of
> + * extents, or return EFSCORRUPTED.  Caller must hold the ILOCK of the inode
> + * being repaired and have joined it to the scrub transaction.
> + */
> +int
> +xrep_ino_ensure_extent_count(
> +	struct xfs_scrub	*sc,
> +	int			whichfork,
> +	xfs_extnum_t		nextents)
> +{
> +	xfs_extnum_t		max_extents;
> +	bool			large_extcount;
> +
> +	large_extcount = xfs_inode_has_large_extent_counts(sc->ip);
> +	max_extents = xfs_iext_max_nextents(large_extcount, whichfork);
> +	if (nextents <= max_extents)
> +		return 0;
> +	if (large_extcount)
> +		return -EFSCORRUPTED;
> +	if (!xfs_has_large_extent_counts(sc->mp))
> +		return -EFSCORRUPTED;

This logic took me a bit of peering at to work out. large_extcount says
whether the inode has the large extcount flag set, which is
different to whether the superblock has large extcoutn flag set.

Can change large_extcount to inode_has_nrext64 or something like
that just so it's really clear that there are two different flags
being checked here?

> diff --git a/fs/xfs/scrub/repair.h b/fs/xfs/scrub/repair.h
> index ac8f0200b2963..e239b432d19e8 100644
> --- a/fs/xfs/scrub/repair.h
> +++ b/fs/xfs/scrub/repair.h
> @@ -28,6 +28,16 @@ bool xrep_ag_has_space(struct xfs_perag *pag, xfs_extlen_t nr_blocks,
>  		enum xfs_ag_resv_type type);
>  xfs_extlen_t xrep_calc_ag_resblks(struct xfs_scrub *sc);
>  
> +static inline int
> +xrep_trans_commit(
> +	struct xfs_scrub	*sc)
> +{
> +	int			error = xfs_trans_commit(sc->tp);
> +
> +	sc->tp = NULL;
> +	return error;
> +}

That's .... interesting formatting. I'd be happy with using standard
linux format for this:

static inline int xrep_trans_commit(struct xfs_scrub *sc)
{
	int error = xfs_trans_commit(sc->tp);

	sc->tp = NULL;
	return error;
}

But that's just personal preference....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
