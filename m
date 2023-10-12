Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEE60CDB46E
	for <linux-xfs@archiver.kernel.org>; Thu, 12 Oct 2023 05:22:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235278AbjJLFWX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 12 Oct 2023 01:22:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233879AbjJLFWX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 12 Oct 2023 01:22:23 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5419B7
        for <linux-xfs@vger.kernel.org>; Wed, 11 Oct 2023 22:22:21 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id A63F36732D; Thu, 12 Oct 2023 07:22:18 +0200 (CEST)
Date:   Thu, 12 Oct 2023 07:22:18 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, osandov@osandov.com, hch@lst.de
Subject: Re: [PATCH 5/7] xfs: convert do_div calls to xfs_rtb_to_rtx helper
 calls
Message-ID: <20231012052218.GD2184@lst.de>
References: <169704721170.1773611.12311239321983752854.stgit@frogsfrogsfrogs> <169704721255.1773611.7719978115841778913.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169704721255.1773611.7719978115841778913.stgit@frogsfrogsfrogs>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Oct 11, 2023 at 11:05:42AM -0700, Darrick J. Wong wrote:
> -	if (isrt) {
> -		uint64_t rtexts = XFS_FSB_TO_B(mp, del->br_blockcount);
> -
> -		do_div(rtexts, mp->m_sb.sb_rextsize);
> -		xfs_mod_frextents(mp, rtexts);
> -	}
> +	if (isrt)
> +		xfs_mod_frextents(mp, xfs_rtb_to_rtxt(mp, del->br_blockcount));

This is losing the XFS_FSB_TO_B conversion.  Now that conversion is
bogus and doesn't match the rest of the code, and only the fact that
we don't currently support delalloc on the RT device has saved our
ass since fa5c836ca8e.  Maybe split this into a little prep patch with
the a fixes tag?
