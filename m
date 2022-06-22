Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7588BCCA47D
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Jun 2022 17:02:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358395AbiFVRCY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Jun 2022 13:02:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236323AbiFVRCS (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Jun 2022 13:02:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0FA93ED20;
        Wed, 22 Jun 2022 10:02:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56702619FC;
        Wed, 22 Jun 2022 17:02:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAB8DC34114;
        Wed, 22 Jun 2022 17:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655917336;
        bh=BCZCdQOAKT9RtPZXoJrioG7UpSBacWlkpm5KW6ZoLtw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FAtBzQhiOlQd5BAlVjQErpJ2YmDT07e5Q7NVitMeUpUwjQAim1+Cn/N4VXwuQpgDx
         q5gW6t1nHVtU0p8p4eOHGHacXLzM5McsIUwCq21JZk1gtEC9iRcMkyDSobtxY4Na/s
         jiXSNUjcSv8p/cnK7Az5zWMGdF9gTpSnBTMb8QNOZb0L4/I2iN/uVSdzwYuwAXRNNC
         LKpHpN/5tdBXVhg2AoeLG0YSNujO/Di1lhNu5pel2/TgP/6Jt14p/m49BGwyZzRYME
         oN/G+m9RtcTj4ad2Inevy6RIh5OR8sqDgTkxUSOoQyRyG8GXMLM8f0EBu3R5av0qv5
         yyl9aMa7PYRlA==
Date:   Wed, 22 Jun 2022 10:02:16 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     fstests@vger.kernel.org, zlang@kernel.org, david@fromorbit.com,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH V3 0/4] Large extent counters tests
Message-ID: <YrNLGKchdYqshW4o@magnolia>
References: <20220611111037.433134-1-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220611111037.433134-1-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Sat, Jun 11, 2022 at 04:40:33PM +0530, Chandan Babu R wrote:
> Hi all,
> 
> This patchset adds two tests for verifying the behaviour of Large
> extent counters feature. It also fixes xfs/270 test failure when
> executed on a filesystem with Large extent counters enabled.
> 
> Changelog:
> V2 -> V3:
>    1. xfs/270: Fix regular expresssion used in inline awk script to
>       match hex number.

Why did all the patches lose their RVB tags?

--D

> V1 -> V2:
>    1. xfs/270: Replace bashisms with inline awk scripts.
>    2. Use _scratch_mkfs_xfs_supported helper in _require_xfs_nrext64().
>    3. Remove invocation of $XFS_INFO_PROG from _require_xfs_nrext64().
>    4. Use xfs_db's 'path' command instead of saving test file's inode
>       number in the two new tests introduced by the patchset.
> 
> Chandan Babu R (4):
>   xfs/270: Fix ro mount failure when nrext64 option is enabled
>   common/xfs: Add helper to check if nrext64 option is supported
>   xfs: Verify that the correct inode extent counters are updated
>     with/without nrext64
>   xfs: Verify correctness of upgrading an fs to support large extent
>     counters
> 
>  common/xfs        |  12 +++++
>  tests/xfs/270     |  26 ++++++++++-
>  tests/xfs/270.out |   1 -
>  tests/xfs/547     |  92 +++++++++++++++++++++++++++++++++++++
>  tests/xfs/547.out |  13 ++++++
>  tests/xfs/548     | 112 ++++++++++++++++++++++++++++++++++++++++++++++
>  tests/xfs/548.out |  12 +++++
>  7 files changed, 265 insertions(+), 3 deletions(-)
>  create mode 100755 tests/xfs/547
>  create mode 100644 tests/xfs/547.out
>  create mode 100755 tests/xfs/548
>  create mode 100644 tests/xfs/548.out
> 
> -- 
> 2.35.1
> 
