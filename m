Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65E18CDB46E
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Oct 2023 05:44:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234119AbjJLFoi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Oct 2023 01:44:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233879AbjJLFoi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2023 01:44:38 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A586B7
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 22:44:37 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id D71276732D; Thu, 12 Oct 2023 07:44:33 +0200 (CEST)
Date:   Thu, 12 Oct 2023 07:44:33 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, osandov@osandov.com, hch@lst.de
Subject: Re: [PATCH 5/8] xfs: create helpers for rtbitmap block/wordcount
 computations
Message-ID: <20231012054433.GD2795@lst.de>
References: <169704721623.1773834.8031427054893583456.stgit@frogsfrogsfrogs> <169704721706.1773834.7063943000548807823.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169704721706.1773834.7063943000548807823.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 11, 2023 at 11:07:32AM -0700, Darrick J. Wong wrote:
> +/*
> + * Compute the number of rtbitmap blocks needed to track the given number of rt
> + * extents.
> + */
> +xfs_filblks_t
> +xfs_rtbitmap_blockcount(
> +	struct xfs_mount	*mp,
> +	xfs_rtbxlen_t		rtextents)
> +{
> +	return howmany_64(rtextents, NBBY * mp->m_sb.sb_blocksize);
> +}

Given that this only has a few users, the !RT stub is a pain, and
having a different result from before in the transaction reservation
is somewhat unexpected change (even if harmless), maybe just mark
this inline?

> +/*
> + * Compute the number of rtbitmap words needed to populate every block of a
> + * bitmap that is large enough to track the given number of rt extents.
> + */
> +unsigned long long
> +xfs_rtbitmap_wordcount(
> +	struct xfs_mount	*mp,
> +	xfs_rtbxlen_t		rtextents)
> +{
> +	xfs_filblks_t		blocks;
> +
> +	blocks = xfs_rtbitmap_blockcount(mp, rtextents);
> +	return XFS_FSB_TO_B(mp, blocks) >> XFS_WORDLOG;
> +}

This one isn't used in this patch or the rest of the series.  Maybe
move it to the patch (-series) that adds the caller in the repair
code?
