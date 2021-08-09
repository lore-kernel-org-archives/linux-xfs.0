Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E11C5C4338F
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Aug 2021 16:14:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C51A260E76
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Aug 2021 16:14:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbhHIQOX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Aug 2021 12:14:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:35308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230179AbhHIQOU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 9 Aug 2021 12:14:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14D0F60EB9;
        Mon,  9 Aug 2021 16:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628525639;
        bh=+TSX2KjOr83Rv5VFAF5KV/dCv0OfWlTvU+MyqIFy30A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DSTj6IgCshwnGE7Ixupx/MVBMhJ0+tcoWMjYUkBDobFM/krrOJ4uGWjt39k4MawML
         JuQ9oNr/LtgRETORD0XvF+mcHd0xotZyhZkG/5nIneXl5RIScwP9c6OntBoMk92D++
         4hNr13Sb0yw/F0WSFzDAd11wpTWVodAsHZD+UrfdbamvxekakBUNxhCXScXT4uUIqg
         1YU1XFzP34t94JTM9uXp1I5XX7675pNsgsndzdyWPGp/1mxQoqD2+1X1KJA9zRYVNl
         wRvSc0fkNwAE8oryu9yuQyAqlpjiCGtdL7icc8qbl0alNwmybhi3iZYwiVepH9UwE6
         v7pkdvi5sxNZQ==
Date:   Mon, 9 Aug 2021 09:13:58 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: don't allow disabling quota accounting on a mounted file system
 v2
Message-ID: <20210809161358.GC3601443@magnolia>
References: <20210809065938.1199181-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210809065938.1199181-1-hch@lst.de>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 09, 2021 at 08:59:34AM +0200, Christoph Hellwig wrote:
> Hi all,
> 
> disabling quota accounting (vs just enforcement) on a running file system
> is a fundamentally race and hard to get right operation.  It also has
> very little practical use.
> 
> Note that the quotaitem log recovery code is left for to make sure we
> don't introduce inconsistent recovery states.
> 
> A series has been sent to make xfstests cope with this feature removal.
> 
> Changes since v1:
>  - fix a spelling mistake
>  - add a new patch to remove xfs_dqrele_all_inodes

Applied, thanks.

FWIW this matches 100% the patches that I had scooped up from the v1
series a week ago as a prerequisite for deferred inactivation, so
everything looks good from this end.

--D

> 
> Diffstat:
>  libxfs/xfs_quota_defs.h |   30 -----
>  libxfs/xfs_trans_resv.c |   30 -----
>  libxfs/xfs_trans_resv.h |    2 
>  scrub/quota.c           |    2 
>  xfs_dquot.c             |    3 
>  xfs_dquot_item.c        |  134 --------------------------
>  xfs_dquot_item.h        |   17 ---
>  xfs_icache.c            |  107 ---------------------
>  xfs_icache.h            |    6 -
>  xfs_ioctl.c             |    2 
>  xfs_iops.c              |    4 
>  xfs_mount.c             |    4 
>  xfs_qm.c                |   44 +++-----
>  xfs_qm.h                |    3 
>  xfs_qm_syscalls.c       |  243 ++----------------------------------------------
>  xfs_quotaops.c          |   30 +----
>  xfs_super.c             |   51 ++++------
>  xfs_trans_dquot.c       |   49 ---------
>  18 files changed, 78 insertions(+), 683 deletions(-)
