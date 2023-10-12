Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE744CDB46E
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Oct 2023 17:58:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344076AbjJLR6h (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Oct 2023 13:58:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347358AbjJLR6f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2023 13:58:35 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CE2FCF
        for <linux-xfs@vger.kernel.org>; Thu, 12 Oct 2023 10:58:34 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05AD6C433C8;
        Thu, 12 Oct 2023 17:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697133514;
        bh=uCeXmWaLcSBbWnLwt8QnLjUCk4rhOMpNUrY588V/EEo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vEaNXJLpghJbDZ80gaN2r5DkJRlMW7FA1Mnf0d3bpwNgJ+rfRAOS2eWNGM/0i1gxc
         J+Ug1fnPaANZpduXc8hTCRpjdwgVGo/975G3+dTSMiXLAxsB8Ho2Cn2hMEQOsuOnyB
         IroxhBiuwlQQ5vUGWzdNMLBtDrXFtzSvkA60sLyDNrstlLOik4DEAZIrzMLJS9IieW
         JzkXL9GkovfJzZ8dtEsy+0zHEMxtUxK7lYJD9M9JJDETdsglfrJqgD2ZHe6rz5qCjl
         i9ekkKtdQZkkIgOz5NUSFKjpb9ohbE254tzqBSUROc4dscrtZbXbf784a75+45vvtX
         Ofcl62yGSAong==
Date:   Thu, 12 Oct 2023 10:58:33 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org, osandov@osandov.com
Subject: Re: [PATCH 4/7] xfs: create helpers to convert rt block numbers to
 rt extent numbers
Message-ID: <20231012175833.GI21298@frogsfrogsfrogs>
References: <169704721170.1773611.12311239321983752854.stgit@frogsfrogsfrogs>
 <169704721239.1773611.10087575278257926892.stgit@frogsfrogsfrogs>
 <20231012051713.GC2184@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20231012051713.GC2184@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Oct 12, 2023 at 07:17:13AM +0200, Christoph Hellwig wrote:
> On Wed, Oct 11, 2023 at 11:05:27AM -0700, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > Create helpers to do unit conversions of rt block numbers to rt extent
> > numbers.  There are two variations -- the suffix "t" denotes the one
> > that returns only the truncated extent number; the other one also
> > returns the misalignment.  Convert all the div_u64_rem users; we'll do
> > the do_div users in the next patch.
> 
> When trying to work with thee helpers I found the t prefix here a bit
> weird, as it works different than the T in say XFS_B_TO_FSB
> vs XFS_B_TO_FSBT which give you different results for the two versions.
> Here we get the same returned result, just with the additional
> return for the remainder.
> 
> Maybe have xfs_rtb_to_rtx and xfs_rtb_to_rtx_rem for the version with
> the modulo?

<nod> I've decided to go with:

/* Convert an rt block number into an rt extent number. */
static inline xfs_rtxnum_t
xfs_rtb_to_rtx(
	struct xfs_mount	*mp,
	xfs_rtblock_t		rtbno)
{
	return div_u64(rtbno, mp->m_sb.sb_rextsize);
}

/* Return the offset of an rt block number within an rt extent. */
static inline xfs_extlen_t
xfs_rtb_to_rtxoff(
	struct xfs_mount	*mp,
	xfs_rtblock_t		rtbno)
{
	return do_div(rtbno, mp->m_sb.sb_rextsize);
}

/*
 * Crack an rt block number into an rt extent number and an offset within that
 * rt extent.  Returns the rt extent number directly and the offset in @off.
 */
static inline xfs_rtxnum_t
xfs_rtb_to_rtxrem(
	struct xfs_mount	*mp,
	xfs_rtblock_t		rtbno,
	xfs_extlen_t		*off)
{
	return div_u64_rem(rtbno, mp->m_sb.sb_rextsize, off);
}

> We also have quite a few places that only care about the mod,
> so an additƣonal xfs_rtb_rem/mod might be useful as well.

Agreed, I had noticed that there were a fair number of places where
we're really only checking for rtx alignment.  xfs_rtb_to_rtxoff is
the new helper.

--D
