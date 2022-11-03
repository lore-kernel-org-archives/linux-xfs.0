Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B2C0C433FE
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Nov 2022 15:36:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230098AbiKCPgF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Nov 2022 11:36:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbiKCPgE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Nov 2022 11:36:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9F14167D3
        for <linux-xfs@vger.kernel.org>; Thu,  3 Nov 2022 08:36:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7790961F37
        for <linux-xfs@vger.kernel.org>; Thu,  3 Nov 2022 15:36:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2967C433D7;
        Thu,  3 Nov 2022 15:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667489762;
        bh=BHbUG1UkjsNf+bza4QZcpF30mTWC+aXsTwrcRCmuF3Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bG5tsgfpCcCqDDNBa3f2i0lOxSSyBfeevsb3H+3oRsUmbj+nlmMpickkcxSHNPiA9
         cX9lFcd0CSyFPz3OpPcxNoC/nTW+1HCNVXcwyJzj4J+w1pDKOO/ywubD+ebWmBjrDl
         lUg1tj9zy2n8E0ONEIcIsE9yVBxqhytFFDk4ROdWQb5yhl2VRVo2Vt5XetUhSbTJpk
         SYhxiXEshs0ccbeUfOfZcNjzRsJz2kpf82EQWquPzrjSNRREEG7YLyj9LRAPzSAbOV
         pIWSdNqI8mWBO5R7xFrm4n7ArXSjYXOAZhLWXFrQGeVKZddEYtsSuNUbXNFpv0irbO
         MiVk1ZM2pzYfQ==
Date:   Thu, 3 Nov 2022 08:36:02 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        leah.rumancik@gmail.com
Subject: Re: [PATCH 5.4 CANDIDATE 0/6] xfs stable candidate patches for 5.4.y
 (from v5.8)
Message-ID: <Y2Pf4qNn7LJxrJO0@magnolia>
References: <20221103115401.1810907-1-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221103115401.1810907-1-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 03, 2022 at 05:23:55PM +0530, Chandan Babu R wrote:
> Hi Darrick,
> 
> This 5.4.y backport series contains fixes from v5.8 release.
> 
> This patchset has been tested by executing fstests (via kdevops) using
> the following XFS configurations,
> 
> 1. No CRC (with 512 and 4k block size).
> 2. Reflink/Rmapbt (1k and 4k block size).
> 3. Reflink without Rmapbt.
> 4. External log device.
> 
> None of the fixes required any other dependent patches to be
> backported.

Patch 2 is missing quite a bit of commit message context.  Something
filtered out the shell screencap:

"# mkfs.xfs -f /dev/sda"

Probably because some smart tool thought it was eliding unnecessary
comments or something?

For the other 5 patches,
Acked-by: Darrick J. Wong <djwong@kernel.org>

--D

> 
> Brian Foster (1):
>   xfs: don't fail verifier on empty attr3 leaf block
> 
> Chuhong Yuan (1):
>   xfs: Add the missed xfs_perag_put() for xfs_ifree_cluster()
> 
> Darrick J. Wong (2):
>   xfs: use ordered buffers to initialize dquot buffers during quotacheck
>   xfs: don't fail unwritten extent conversion on writeback due to edquot
> 
> Dave Chinner (1):
>   xfs: gut error handling in xfs_trans_unreserve_and_mod_sb()
> 
> Eric Sandeen (1):
>   xfs: group quota should return EDQUOT when prj quota enabled
> 
>  fs/xfs/libxfs/xfs_attr_leaf.c |   8 --
>  fs/xfs/libxfs/xfs_defer.c     |  10 ++-
>  fs/xfs/xfs_dquot.c            |  56 +++++++++---
>  fs/xfs/xfs_inode.c            |   4 +-
>  fs/xfs/xfs_iomap.c            |   2 +-
>  fs/xfs/xfs_trans.c            | 163 +++++-----------------------------
>  fs/xfs/xfs_trans_dquot.c      |   3 +-
>  7 files changed, 78 insertions(+), 168 deletions(-)
> 
> -- 
> 2.35.1
> 
