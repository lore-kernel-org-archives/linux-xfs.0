Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBC56C433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Dec 2021 19:25:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240902AbhLPTZv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Dec 2021 14:25:51 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:52140 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231376AbhLPTZu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Dec 2021 14:25:50 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A419861F2A
        for <linux-xfs@vger.kernel.org>; Thu, 16 Dec 2021 19:25:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 024C4C36AE3;
        Thu, 16 Dec 2021 19:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639682750;
        bh=bqkoxqojgixNXaZ4wDoQ/5873zRznHIbizGsVw1N1C8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VrKBqSBr/YDdAbON4MT90Iq60FT90mxR00gRUtbjR7AbEz5NH3UlF/82qSIto/EQW
         BLao6lPwg2EBjX/W3EzgAV4yrDzQ8L20iBr4zts+IRFpdYb7cCELtjX0dlbCo9Ijqr
         A+VM7h72hrObn4W3pqftyg8dk200MYi71Bi2zz3CIWr7Zh0K3PpMxO0daVjJU4EIab
         sSIrW4XVXPqvOCJRbttfyfyz2VVgWQlV//FN/ZJH5hucTI6zb3RC9tiPOgRSv0VY9H
         wcUo0TYrm2VkV5TXoWzd2/T5zd1EseRAw2y8ZZPHk2xhVVvGffHhamQlYv9DCmGRZo
         v+Pv2RL/NP54Q==
Date:   Thu, 16 Dec 2021 11:25:49 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Dave Chinner <david@fromorbit.com>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [PATCH 3/7] xfs: fix a bug in the online fsck directory leaf1
 bestcount check
Message-ID: <20211216192549.GC27664@magnolia>
References: <163961695502.3129691.3496134437073533141.stgit@magnolia>
 <163961697197.3129691.1911552605195534271.stgit@magnolia>
 <20211216050537.GA449541@dread.disaster.area>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211216050537.GA449541@dread.disaster.area>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Dec 16, 2021 at 04:05:37PM +1100, Dave Chinner wrote:
> On Wed, Dec 15, 2021 at 05:09:32PM -0800, Darrick J. Wong wrote:
> > From: Darrick J. Wong <djwong@kernel.org>
> > 
> > When xfs_scrub encounters a directory with a leaf1 block, it tries to
> > validate that the leaf1 block's bestcount (aka the best free count of
> > each directory data block) is the correct size.  Previously, this author
> > believed that comparing bestcount to the directory isize (since
> > directory data blocks are under isize, and leaf/bestfree blocks are
> > above it) was sufficient.
> > 
> > Unfortunately during testing of online repair, it was discovered that it
> > is possible to create a directory with a hole between the last directory
> > block and isize.
> 
> We have xfs_da3_swap_lastblock() that can leave an -empty- da block
> between the last referenced block and isize, but that's not a "hole"
> in the file. If you don't mean xfs_da3_swap_lastblock(), then can
> you clarify what you mean by a "hole" here and explain to me how the
> situation it occurs in comes about?

I don't actually know how it comes about.  I wrote a test that sets up
fsstress to expand and contract directories and races xfs_scrub -n, and
noticed that I'd periodically get complaints about directories (usually
$SCRATCH_MNT/p$CPU) where the last block(s) before i_size were actually
holes.

I began reading the dir2 code to try to figure out how this came about
(clearly we're not updating i_size somewhere) but then took the shortcut
of seeing if xfs_repair or xfs_check complained about this situation.
Neither of them did, and I found a couple more directories in a similar
situation on my crash test dummy machine, and concluded "Wellllp, I
guess this is part of the ondisk format!" and committed the patch.

Also, I thought xfs_da3_swap_lastblock only operates on leaf and da
btree blocks, not the blocks containing directory entries?  I /think/
the actual explanation is that something goes wrong in
xfs_dir2_shrink_inode (maybe?) such that the mapping goes away but
i_disk_size doesn't get updated?  Not sure how /that/ can happen,
though...

--D

> 
> Cheers,
> 
> Dave.
> -- 
> Dave Chinner
> david@fromorbit.com
