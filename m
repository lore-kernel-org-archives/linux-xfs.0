Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1113BC43217
	for <linux-xfs@archiver.kernel.org>; Mon, 21 Nov 2022 14:36:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbiKUOgE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Nov 2022 09:36:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiKUOf7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Nov 2022 09:35:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB07AC6D16
        for <linux-xfs@vger.kernel.org>; Mon, 21 Nov 2022 06:35:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 477BD61036
        for <linux-xfs@vger.kernel.org>; Mon, 21 Nov 2022 14:35:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27562C433D6
        for <linux-xfs@vger.kernel.org>; Mon, 21 Nov 2022 14:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669041350;
        bh=Lurt+4PWEB9ioe6lVMso0fV67EOpzh+GTCGGFj/IlrQ=;
        h=Date:From:To:Subject:From;
        b=jKHVbl5dQcUEJFcuudS1XYn868ni5PxiFhqTXZiJRHQ1HKHYxA3TDU8d+oNclVruc
         KqWKoBSOlhjoKsK03TdADq19rLfRWHdhLJGaXMYeRERfMc5G1InPhlkya/mG8u35qn
         3yObFYW43azHDHPJSStP/imj6Ry1pqoses6jWGOOPt1Llsz8kN8mEAB1DIC+H5FZiE
         nRdyrEH/1KIGyaDlF85Zcn1STXSxTifRndfMDUopw9UGlte1ZqLl7dlDREmk0JTlye
         816fItLK275O7BB7+uAm79qEU5LJnZEwIShGrjQso4YAdAi52iLCHt7ETB7OpBMbvh
         FVy4TwRj4I5Ww==
Date:   Mon, 21 Nov 2022 15:35:47 +0100
From:   Carlos Maiolino <cem@kernel.org>
To:     linux-xfs@vger.kernel.org
Subject: [ANNOUNCE] xfsprogs for-next branch updated
Message-ID: <20221121143547.m33n36fufbz2x626@andromeda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hello.

The xfsprogs, for-next branch located at:

https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/log/?h=for-next

has just been updated.

The new head is:

b827e2318 xfs: fix sb write verify for lazysbcount


This update contains only the libxfs-sync for Linux 6.1, and will serve as a
base for the xfsprogs 6.1 release.
Please, let me know if any issue.


The following commits are now in the for-next tree:

[b827e2318] xfs: fix sb write verify for lazysbcount
[7257eb3ed] xfs: rename XFS_REFC_COW_START to _COWFLAG
[7accbcd00] xfs: fix uninitialized list head in struct xfs_refcount_recovery
[8b2b27581] xfs: fix agblocks check in the cow leftover recovery function
[817ea9f0f] xfs: check record domain when accessing refcount records
[f275d70e8] xfs: remove XFS_FIND_RCEXT_SHARED and _COW
[cc2a3c2ad] xfs: refactor domain and refcount checking
[8160aeff0] xfs: report refcount domain in tracepoints
[6b2f464dd] xfs: track cow/shared record domains explicitly in xfs_refcount_irec
[bec88ec72] xfs: move _irec structs to xfs_types.h
[7ccbdec2b] xfs: check deferred refcount op continuation parameters
[b3f9ae08e] xfs: create a predicate to verify per-AG extents
[2d5166b9d] xfs: make sure aglen never goes negative in xfs_refcount_adjust_extents
[4b69afdc4] xfs: refactor all the EFI/EFD log item sizeof logic
[d267ac6a0] xfs: fix memcpy fortify errors in EFI log format copying
[227bc97f1] xfs: increase rename inode reservation
[20798cc06] xfs: fix exception caused by unexpected illegal bestcount in leaf dir
[11d2f5afc] treewide: use get_random_u32() when possible
[4947ac5b3] treewide: use prandom_u32_max() when possible, part 1
[1a3bfffee] xfs: rearrange the logic and remove the broken comment for xfs_dir2_isxx
[04d4c27af] xfs: trim the mapp array accordingly in xfs_da_grow_inode_int
[e8dbbca18] xfs: Remove the unneeded result variable
[be98db856] xfs: clean up "%Ld/%Lu" which doesn't meet C standard


-- 
Carlos Maiolino
