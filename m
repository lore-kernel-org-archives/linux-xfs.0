Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A318CC4332F
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Nov 2022 20:39:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231626AbiKJUjy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Nov 2022 15:39:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiKJUjw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Nov 2022 15:39:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0FED1E702
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 12:39:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B02DB8236B
        for <linux-xfs@vger.kernel.org>; Thu, 10 Nov 2022 20:39:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3655CC433D6;
        Thu, 10 Nov 2022 20:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668112789;
        bh=lGpaDoSNbbW/UCRTMD0ScX5O+Cf+jY1LMnMQKcORZEU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AO9teGUrEpu1idQSAPSAHRBe1tMTME5CQuxG9l3ZKmO1B6SIW1ZwJmmJKaf/WyJHD
         OccSrmQxaOP5KBfNjmVZVK3LKO+sXmhOmI7oG5bvuVHbEhzbuGmKjyqdBPiZXxQHP2
         8QCJV6QrtpWs105Eu3JtKiFvRGucn/sj+STUaHYb5h6fW+4oeqRphXyhAeyhYvKBup
         V+v5zZoFqB27OPSHN7VB6C0ASTR9Oh1kX495o0DlVKM2hjhFDVJjPZlo25wz6xrLvR
         Qb5oGu4rUrvlsd8T9kaMyLYRQhohUywSx1/V+mmagbP6az2BS910R1TIyFLqhLdHqr
         YQ4p8+Intft2A==
Date:   Thu, 10 Nov 2022 12:39:48 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        leah.rumancik@gmail.com
Subject: Re: [PATCH 5.4 CANDIDATE 0/6] xfs stable candidate patches for 5.4.y
 (from v5.9)
Message-ID: <Y21hlNdtZ4eOiQ7o@magnolia>
References: <20221110063608.629732-1-chandan.babu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221110063608.629732-1-chandan.babu@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Thu, Nov 10, 2022 at 12:06:02PM +0530, Chandan Babu R wrote:
> Hi Darrick,
> 
> This 5.4.y backport series contains fixes from v5.9 release.
> 
> This patchset has been tested by executing fstests (via kdevops) using
> the following XFS configurations,
> 
> 1. No CRC (with 512 and 4k block size).
> 2. Reflink/Rmapbt (1k and 4k block size).
> 3. Reflink without Rmapbt.
> 4. External log device.
> 
> The following lists patches which required other dependency patches to
> be included,
> 1. 00fd1d56dd08a
>    xfs: redesign the reflink remap loop to fix blkres depletion crash
>    - 877f58f53684
>      xfs: rename xfs_bmap_is_real_extent to is_written_extent
> 

Looks good to me!
Acked-by: Darrick J. Wong <djwong@kernel.org>

--D

> Brian Foster (2):
>   xfs: preserve rmapbt swapext block reservation from freed blocks
>   xfs: drain the buf delwri queue before xfsaild idles
> 
> Darrick J. Wong (2):
>   xfs: rename xfs_bmap_is_real_extent to is_written_extent
>   xfs: redesign the reflink remap loop to fix blkres depletion crash
> 
> Dave Chinner (1):
>   xfs: use MMAPLOCK around filemap_map_pages()
> 
> Eric Sandeen (1):
>   xfs: preserve inode versioning across remounts
> 
>  fs/xfs/libxfs/xfs_bmap.h     |  15 ++-
>  fs/xfs/libxfs/xfs_rtbitmap.c |   2 +-
>  fs/xfs/libxfs/xfs_shared.h   |   1 +
>  fs/xfs/xfs_bmap_util.c       |  18 +--
>  fs/xfs/xfs_file.c            |  15 ++-
>  fs/xfs/xfs_reflink.c         | 244 +++++++++++++++++++----------------
>  fs/xfs/xfs_super.c           |   4 +
>  fs/xfs/xfs_trace.h           |  52 +-------
>  fs/xfs/xfs_trans.c           |  19 ++-
>  fs/xfs/xfs_trans_ail.c       |  16 +--
>  10 files changed, 198 insertions(+), 188 deletions(-)
> 
> -- 
> 2.35.1
> 
