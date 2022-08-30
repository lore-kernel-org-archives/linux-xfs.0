Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A693ECAAA1
	for <linux-xfs@archiver.kernel.org>; Tue, 30 Aug 2022 15:12:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbiH3PMZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 30 Aug 2022 11:12:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbiH3PMX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 30 Aug 2022 11:12:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48C661286C5
        for <linux-xfs@vger.kernel.org>; Tue, 30 Aug 2022 08:12:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5507B81C55
        for <linux-xfs@vger.kernel.org>; Tue, 30 Aug 2022 15:12:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67E84C433D6;
        Tue, 30 Aug 2022 15:12:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661872338;
        bh=1rivftKpFQ+WJDD+XmIcR/odUbrwcc0kIVxFmz1J80U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jpXy+aCAhVostHQYi3QE5lNhMKEBhmfWf914dteiWer3ZBDaFAMxHlcoBVteQbAMZ
         AXvtNwItB6u6IA3QuGtdE3mR6MFcZc0bgEtlk3B1f0H0mxjweeHtPrYmOkxPVY2OHC
         r38MJvT3CRsuecdub5qYOwCCceK/w4y7oc0q9zDkIb2kWqHjeNcrm91cx+NRJPF0xD
         lmdKksshmIcaoyMcbC6rAaL6msGtpbXriW+7b0ToXEWNmPSPjeH4fQnMMq9N0kSRLv
         Wm9HdA/7UKGM1yOEuwMeTYQG4oySKR1OKTrrdCt1jTOmucad8XoXywT3Ap6USb+nX9
         qhT3hZpgbelig==
Date:   Tue, 30 Aug 2022 08:12:17 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Carlos Maiolino <cem@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [ANNOUNCE] xfsprogs for-next updated
Message-ID: <Yw4o0fBFRqrCHQsY@magnolia>
References: <20220830115220.5s2nlztp56fbf4xa@andromeda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220830115220.5s2nlztp56fbf4xa@andromeda>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Tue, Aug 30, 2022 at 01:52:20PM +0200, Carlos Maiolino wrote:
> Hi folks,
> 
> The for-next branch of the xfsprogs repository at:
> 
>         git://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git
> 
> has just been updated.
> 
> This update contains the initial libxfs sync to Linux 6.0 and should be turned
> into -rc0 once it (hopefully) gets some testing (and no complains) for more people.

Wooo, welcome, new maintainer! :)

> Please, if any questions, let me know.

For the repair deadlock fix[1], do you want me to pin the primary
superblock buffer to the xfs_mount like Dave suggested in [2]?

[1] https://lore.kernel.org/linux-xfs/166007921743.3294543.7334567013352169774.stgit@magnolia/
[2] https://lore.kernel.org/linux-xfs/20220811221541.GQ3600936@dread.disaster.area/

--D

> 
> The new head of the for-next branch is commit:
> 
> d3e53ab7c xfs: fix inode reservation space for removing transaction
> 
> 
> New Commits:
> 
> Andrey Strachuk (1):
>       [798d43495] xfs: removed useless condition in function xfs_attr_node_get
> 
> Dan Carpenter (1):
>       [17df7eb7e] xfs: delete unnecessary NULL checks
> 
> Darrick J. Wong (6):
>       [722e81c12] xfs: convert XFS_IFORK_PTR to a static inline helper
>       [7ff5f1edf] xfs: make inode attribute forks a permanent part of struct xfs_inode
>       [d4292c669] xfs: use XFS_IFORK_Q to determine the presence of an xattr fork
>       [4f8415858] xfs: replace XFS_IFORK_Q with a proper predicate function
>       [eae3e30d4] xfs: replace inode fork size macros with functions
>       [e373f06a3] xfs: don't leak memory when attr fork loading fails
> 
> Dave Chinner (17):
>       [ef78f876e] xfs: make last AG grow/shrink perag centric
>       [37dc5890e] xfs: kill xfs_ialloc_pagi_init()
>       [4330a9e00] xfs: pass perag to xfs_ialloc_read_agi()
>       [87db57baf] xfs: kill xfs_alloc_pagf_init()
>       [f9084bd95] xfs: pass perag to xfs_alloc_read_agf()
>       [bc87af992] xfs: pass perag to xfs_read_agi
>       [c1030eda4] xfs: pass perag to xfs_read_agf
>       [1d202c10b] xfs: pass perag to xfs_alloc_get_freelist
>       [9a73333d9] xfs: pass perag to xfs_alloc_put_freelist
>       [75c01cccf] xfs: pass perag to xfs_alloc_read_agfl
>       [83af0d13a] xfs: Pre-calculate per-AG agbno geometry
>       [8aa34dc9b] xfs: Pre-calculate per-AG agino geometry
>       [cee2d89ae] xfs: replace xfs_ag_block_count() with perag accesses
>       [54f6b9e5e] xfs: make is_log_ag() a first class helper
>       [0b2f4162b] xfs: rework xfs_buf_incore() API
>       [69535dadf] xfs: track the iunlink list pointer in the xfs_inode
>       [b9846dc9e] xfs: double link the unlinked inode list
> 
> Slark Xiao (1):
>       [e4a32219d] xfs: Fix typo 'the the' in comment
> 
> Xiaole He (1):
>       [ec36ecd2d] xfs: fix comment for start time value of inode with bigtime enabled
> 
> hexiaole (1):
>       [d3e53ab7c] xfs: fix inode reservation space for removing transaction
> 
> -- 
> Carlos Maiolino


