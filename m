Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7077C43334
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Jun 2022 16:20:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229798AbiF2QUn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 29 Jun 2022 12:20:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbiF2QUm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 29 Jun 2022 12:20:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BA26344C7;
        Wed, 29 Jun 2022 09:20:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5174AB82573;
        Wed, 29 Jun 2022 16:20:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DC6DC34114;
        Wed, 29 Jun 2022 16:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656519639;
        bh=jUEvfkzTsecPy2ArOdW6RgMus29RLcrXT85mz+60n3A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MH+t8R+d0DWRiUwAzIkCTnagGELNtNcy5YzGi440s1Me+G9pZYmeAWFeC/4VH32aP
         SUQ+UhRBzhHuvG+FTOrd3qCWSqkiD5l2S0Hpc3RHcbuDlm8q3t7V5z2p6xFJ6IH70w
         SM1wKkC8rEjR4SOzYYMtgq2kgqge5aixRDlzyTa3O0J/zlaxb/YuiFIVcQ3c2wOVC7
         gyezjl7ooyC3hcZkJY2GXf9u6oNxJzASMk9zg1DeygVQ4ENz8MxNiZAdZ3L+GjUlTH
         PX4SM6TqTFbLSEe5ZKqzcvJCEwRI4atWBsR78pf0+7CinRXH76vWd/rk3/Ij/+OWxG
         1jJD7Ew9hWioQ==
Date:   Wed, 29 Jun 2022 09:20:38 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Dave Chinner <david@fromorbit.com>,
        Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 5.10 CANDIDATE v2 0/7] xfs stable candidate patches for
 5.10.y (from v5.13)
Message-ID: <Yrx71vp2SFsjVdzg@magnolia>
References: <20220627073311.2800330-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220627073311.2800330-1-amir73il@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Jun 27, 2022 at 10:33:04AM +0300, Amir Goldstein wrote:
> Hi all,
> 
> This is a resend of the series that was posted 3 weeks ago [v1].
> The backports in this series are from circa v5.12..v5.13.
> The remaining queue of tested 5.10 backports [1] contains 25 more patches
> from v5.13..v5.19-rc1.
> 
> There have been no comments on the first post except for Dave's request
> to collaborate the backports review process with Leah who had earlier
> sent out another series of backports for 5.15.y.
> 
> Following Dave's request, I had put this series a side to collaborate
> the shared review of 5.15/5.10 series with Leah and now that the shared
> series has been posted to stable, I am re-posting to request ACKs on this
> 5.10.y specific series.
> 
> There are four user visible fixes in this series, one patch for dependency
> ("rename variable mp") and two patches to improve testability of LTS.

Aha, I had wondered why the journal_info thing was in this branch, and
if that would even fit under the usual stable rules...

> Specifically, I selected the fix ("use current->journal_info for
> detecting transaction recursion") after I got a false positive assert
> while testing LTS kernel with XFS_DEBUG and at another incident, it
> helped me triage a regression that would have been harder to trace
> back to the offending code otherwise.

...but clearly maintainers have been hitting this, so that's ok by /me/ to
have it.  If nothing else, XFS doesn't support nested transactions, so any
weird stuff that falls out was already a dangerous bug.

Acked-by: Darrick J. Wong <djwong@kernel.org>

--D

> This series has been looping in kdevops for a long while, with and
> without the shared 5.15 backport with no regressions observed.
> 
> Thanks,
> Amir.
> 
> Changes since [v1]:
> - Rebased and tested on top of the v5.15+ ACKed backports [2]
> 
> [1] https://github.com/amir73il/linux/commits/xfs-5.10.y
> [2] https://lore.kernel.org/linux-xfs/20220624063702.2380990-1-amir73il@gmail.com/
> [v1] https://lore.kernel.org/linux-xfs/20220606160537.689915-1-amir73il@gmail.com/
> 
> Anthony Iliopoulos (1):
>   xfs: fix xfs_trans slab cache name
> 
> Darrick J. Wong (1):
>   xfs: fix xfs_reflink_unshare usage of filemap_write_and_wait_range
> 
> Dave Chinner (2):
>   xfs: use current->journal_info for detecting transaction recursion
>   xfs: update superblock counters correctly for !lazysbcount
> 
> Gao Xiang (1):
>   xfs: ensure xfs_errortag_random_default matches XFS_ERRTAG_MAX
> 
> Pavel Reichl (2):
>   xfs: rename variable mp to parsing_mp
>   xfs: Skip repetitive warnings about mount options
> 
>  fs/iomap/buffered-io.c    |   7 ---
>  fs/xfs/libxfs/xfs_btree.c |  12 +++-
>  fs/xfs/libxfs/xfs_sb.c    |  16 ++++-
>  fs/xfs/xfs_aops.c         |  17 +++++-
>  fs/xfs/xfs_error.c        |   2 +
>  fs/xfs/xfs_reflink.c      |   3 +-
>  fs/xfs/xfs_super.c        | 120 +++++++++++++++++++++-----------------
>  fs/xfs/xfs_trans.c        |  23 +++-----
>  fs/xfs/xfs_trans.h        |  30 ++++++++++
>  9 files changed, 148 insertions(+), 82 deletions(-)
> 
> -- 
> 2.25.1
> 
