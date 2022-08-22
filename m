Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD2D1C32774
	for <linux-xfs@archiver.kernel.org>; Mon, 22 Aug 2022 16:53:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235816AbiHVQxB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Aug 2022 12:53:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234803AbiHVQxA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Aug 2022 12:53:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 876231BEAA;
        Mon, 22 Aug 2022 09:52:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B4AAB81626;
        Mon, 22 Aug 2022 16:52:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5DA4C433D6;
        Mon, 22 Aug 2022 16:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661187177;
        bh=786U608bcYJ6Oj/Fu93LmNDbz3PrKXgXOgm41DsUmxw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VTB07C37fBPVgLT28gXsoz+HDKPaGP1Cqq6M2t+Vtnbi91DyoUaQ9DHmvHtzuQfJK
         SxoaEr+4o2jdZnhvf+AIL8J0Wkf97cqPXgjIvy4vzefiqozCuleCH1bto4zpUXDzXk
         Onyn3STEOIXNSiOYypej0XJSroA9a83TS56/ETG6nNH+jdFhgu3+oMkloLa+b4lxc9
         TKOK6p9uaKtvdcsgrAgjSw73vFhUStVOUG/jCafo5F3xYd1hkuKmEXkwxRQDg998Qx
         ZW/YDgLh9kcA0/mQveEEQNc8/APKSHt6acKPcFOB1VnTIAEG2xI/3tS50UX7rgb76s
         0wY+6D3yKSAVA==
Date:   Mon, 22 Aug 2022 09:52:56 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>,
        Chandan Babu R <chandan.babu@oracle.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 5.10 CANDIDATE 0/7] xfs stable candidate patches for
 5.10.y (from v5.17)
Message-ID: <YwO0aIOQ0HrZ78Sx@magnolia>
References: <20220822162802.1661512-1-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220822162802.1661512-1-amir73il@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Aug 22, 2022 at 07:27:56PM +0300, Amir Goldstein wrote:
> Hi Darrick,
> 
> This is my collection of backports from v5.17.
> 
> Patch 1 is a small fix picked from Leah's part 3 series for 5.15.y [1].
> 
> Patch 2 is a small fix picked from Leah's part 4 series [2].
> I have some more fixes queued from part 4, but they are not from v5.17,
> so will be posted in another series for v5.18/v5.19 fixes.
> 
> Patches 3-6 are debt from the joint 5.10.y/5.15.y series [3].
> Per your request in the review of that series, I collected all
> the sync_fs patches and verified that they fix test xfs/546.
> 
> These patches have been spinning on kdevops for several days with
> no regressions observed.
> 
> Please ACK.

Looks good to me,
Acked-by: Darrick J. Wong <djwong@kernel.org>

--D

> 
> Thanks,
> Amir.
> 
> [1] https://lore.kernel.org/linux-xfs/20220721213610.2794134-1-leah.rumancik@gmail.com/
> [2] https://lore.kernel.org/linux-xfs/20220819181431.4113819-1-leah.rumancik@gmail.com/
> [3] https://lore.kernel.org/linux-xfs/CAOQ4uxjrLUjStjDGOV2-0SK6ur07KZ8hAzb6JP+Dsm8=0iEbSA@mail.gmail.com/
> 
> Christoph Hellwig (1):
>   fs: remove __sync_filesystem
> 
> Dan Carpenter (1):
>   xfs: prevent a WARN_ONCE() in xfs_ioc_attr_list()
> 
> Darrick J. Wong (4):
>   xfs: reject crazy array sizes being fed to XFS_IOC_GETBMAP*
>   vfs: make sync_filesystem return errors from ->sync_fs
>   xfs: return errors in xfs_fs_sync_fs
>   xfs: only bother with sync_filesystem during readonly remount
> 
>  fs/sync.c          | 48 ++++++++++++++++++++++++----------------------
>  fs/xfs/xfs_ioctl.c |  4 ++--
>  fs/xfs/xfs_ioctl.h |  5 +++--
>  fs/xfs/xfs_super.c | 13 ++++++++++---
>  4 files changed, 40 insertions(+), 30 deletions(-)
> 
> -- 
> 2.25.1
> 
