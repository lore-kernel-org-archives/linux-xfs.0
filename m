Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63575EE3F0D
	for <linux-xfs@archiver.kernel.org>; Tue, 12 Sep 2023 19:00:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbjILTAr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 12 Sep 2023 15:00:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236299AbjILTAp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 12 Sep 2023 15:00:45 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E120B189
        for <linux-xfs@vger.kernel.org>; Tue, 12 Sep 2023 12:00:40 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EFA0C433C8;
        Tue, 12 Sep 2023 19:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694545240;
        bh=SZoVwyHD92n9cjOCl97HHrAFoJgbuPK+iimHB/ParR4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h9oxcV90qsSTwB4npdApgNc/nnImpj3ztJ3RknSwmrkqTeySgZimdvi3ds2Bxqrgy
         Q79FSQq2pmAw7jrGpYgE0ayn+iMZJ6Zsv55+Q87iVrKQdpjf27izYVW4ver1I/wLI0
         jibXKwr44DWOq3jPDxegMReezQFMMSqKstzoqZx/c0J0sUpFJlyt82nAj1BA3pCmq/
         bEug0kWeiThNDWKOZBDpBZ9iz/7+s/tbnBQWO1DCqkivJu+dtpegruB5OOe+IXl4Ja
         1tHh3HqukxdvkZVpC9098N6u7NvYCWUlSiEVb+8MH/Lk5lh3a8cE8H1D+20B9oFMFf
         kAqnjY6gLuMTw==
Date:   Tue, 12 Sep 2023 12:00:39 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Leah Rumancik <leah.rumancik@gmail.com>
Cc:     linux-xfs@vger.kernel.org, amir73il@gmail.com,
        chandan.babu@oracle.com
Subject: Re: [PATCH 5.15 CANDIDATE 0/6] 5.15 inodegc fixes
Message-ID: <20230912190039.GA3415652@frogsfrogsfrogs>
References: <20230912180040.3149181-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230912180040.3149181-1-leah.rumancik@gmail.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Sep 12, 2023 at 11:00:34AM -0700, Leah Rumancik wrote:
> Hello,
> 
> I have tested the inodegc fixes for 5.15 and saw no regrssions on 20
> runs x 14 configs. These patches are already in 6.1.y.
> 
> The patches included are the following:
> 
> -- [PATCH 0/2] xfs: non-blocking inodegc pushes --
> (https://www.spinics.net/lists/linux-xfs/msg61813.html)
> 
> 7cf2b0f9611b9971d663e1fc3206eeda3b902922
> [1/2] xfs: bound maximum wait time for inodegc work
> 
> 5e672cd69f0a534a445df4372141fd0d1d00901d
> [2/2] xfs: introduce xfs_inodegc_push()
> 
> 
> -- [PATCHSET v2 0/4] xfs: inodegc fixes for 6.4-rc1
> (https://www.spinics.net/lists/linux-xfs/msg71066.html)
> 
> 03e0add80f4cf3f7393edb574eeb3a89a1db7758
> [1/4] xfs: explicitly specify cpu when forcing inodegc delayed work to run immediately
> (fix for 7cf2b0f9611b)
> 
> b37c4c8339cd394ea6b8b415026603320a185651
> [2/4] xfs: check that per-cpu inodegc workers actually run on that cpu
> 
> 2d5f38a31980d7090f5bf91021488dc61a0ba8ee
> [3/4] xfs: disable reaping in fscounters scrub
> 
> 2254a7396a0ca6309854948ee1c0a33fa4268cec
> [4/4] xfs: fix xfs_inodegc_stop racing with mod_delayed_work
> 
> 
> Thanks,
> Leah

Looks good to me, and welcome back!!
Acked-by: Darrick J. Wong <djwong@kernel.org>

--D

> 
> 
> Darrick J. Wong (4):
>   xfs: explicitly specify cpu when forcing inodegc delayed work to run
>     immediately
>   xfs: check that per-cpu inodegc workers actually run on that cpu
>   xfs: disable reaping in fscounters scrub
>   xfs: fix xfs_inodegc_stop racing with mod_delayed_work
> 
> Dave Chinner (2):
>   xfs: bound maximum wait time for inodegc work
>   xfs: introduce xfs_inodegc_push()
> 
>  fs/xfs/scrub/common.c     | 25 -----------
>  fs/xfs/scrub/common.h     |  2 -
>  fs/xfs/scrub/fscounters.c | 13 +++---
>  fs/xfs/scrub/scrub.c      |  2 -
>  fs/xfs/scrub/scrub.h      |  1 -
>  fs/xfs/xfs_icache.c       | 92 +++++++++++++++++++++++++++++----------
>  fs/xfs/xfs_icache.h       |  1 +
>  fs/xfs/xfs_mount.h        |  5 ++-
>  fs/xfs/xfs_qm_syscalls.c  |  9 ++--
>  fs/xfs/xfs_super.c        | 12 +++--
>  fs/xfs/xfs_trace.h        |  1 +
>  11 files changed, 95 insertions(+), 68 deletions(-)
> 
> -- 
> 2.42.0.283.g2d96d420d3-goog
> 
