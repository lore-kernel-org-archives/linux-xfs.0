Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC332C6FA82
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Sep 2022 15:59:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232936AbiIWP7Y (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 23 Sep 2022 11:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232367AbiIWP6n (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 23 Sep 2022 11:58:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B6E614A787
        for <linux-xfs@vger.kernel.org>; Fri, 23 Sep 2022 08:58:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C35E0B822C1
        for <linux-xfs@vger.kernel.org>; Fri, 23 Sep 2022 15:58:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68A3AC433D7;
        Fri, 23 Sep 2022 15:58:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663948706;
        bh=iul/oj96nI6c3asVFdqFGTtoalR4Ubg2RomIBO2vBhU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GC82R8H8ygP5eYOuzlT4tFCi+uK6q7Nuiw5cg0OBb1JrRCLyRLGpRe1vmroFMEjJS
         j97CrtcvwDr17us2G6guxtdrCcKNZQ9xmngdDRJCVlhVJc28aqaiQrVt1YiYO/+bVI
         Cxm56cAaoDlhaGtiTQ8WCw6eH07nF6HVgZUYd0jvmLHQ1fxL//KStfsQjMi4BFTtH7
         seY81jCNF778Xj0mwF3vKAMCz21Zl8UhOVourwEeSvGdAxFooq5WnX3RUBqxpXJ80N
         K2zuE6edga3z82UxjEyv9zFZm6BceAa7vdpU5qQE0vNEJPCzlQO42uX4VUX2MhFIQb
         SwT7M/IiioIeQ==
Date:   Fri, 23 Sep 2022 08:58:25 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        leah.rumancik@gmail.com
Subject: Re: [PATCH 5.4 CANDIDATE 0/2] xfs stable candidate patches for 5.4.y
Message-ID: <Yy3XoX9I+9haKG2V@magnolia>
References: <20220923072149.928439-1-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220923072149.928439-1-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Sep 23, 2022 at 12:51:47PM +0530, Chandan Babu R wrote:
> Hi Darrick,
> 
> Two of the commits backported from v5.5
> (https://lore.kernel.org/linux-xfs/YywzGEFApUMalXNn@kroah.com/T/#t)
> introduced regressions of their own. Hence this patchset includes two
> backported commits to fix those regressions.
> 
> The first patch i.e. "xfs: fix an ABBA deadlock in xfs_rename" fixes a
> regression that was introduced by "xfs: Fix deadlock between AGI and
> AGF when target_ip exists in xfs_rename()".
> 
> The second patch i.e. "xfs: fix use-after-free when aborting corrupt
> attr inactivation" fixes a regression that was introduced by "xfs: fix
> use-after-free when aborting corrupt attr inactivation".

Looks good to me, thanks for fishing out these two extra fixes.
Acked-by: Darrick J. Wong <djwong@kernel.org>

--D

>    
> This patchset has been tested by executing fstests (via kdevops) using
> the following XFS configurations,
> 1. No CRC (with 512 and 4k block size).
> 2. Reflink/Rmapbt (1k and 4k block size).
> 3. Reflink without Rmapbt.
> 4. External log device.
> 
> Darrick J. Wong (2):
>   xfs: fix an ABBA deadlock in xfs_rename
>   xfs: fix use-after-free when aborting corrupt attr inactivation
> 
>  fs/xfs/libxfs/xfs_dir2.h    |  2 --
>  fs/xfs/libxfs/xfs_dir2_sf.c |  2 +-
>  fs/xfs/xfs_attr_inactive.c  |  2 +-
>  fs/xfs/xfs_inode.c          | 42 ++++++++++++++++++++++---------------
>  4 files changed, 27 insertions(+), 21 deletions(-)
> 
> -- 
> 2.35.1
> 
