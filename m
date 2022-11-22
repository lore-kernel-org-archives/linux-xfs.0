Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8E31C433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 22 Nov 2022 00:25:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbiKVAZe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 21 Nov 2022 19:25:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiKVAZc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 21 Nov 2022 19:25:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B18C1BEB49
        for <linux-xfs@vger.kernel.org>; Mon, 21 Nov 2022 16:25:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AC463B818BC
        for <linux-xfs@vger.kernel.org>; Tue, 22 Nov 2022 00:25:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57959C433D6;
        Tue, 22 Nov 2022 00:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669076726;
        bh=f8qSJaJd+9voFuz6ZzysGj+j6xv0kVm682nu4Fb0MsU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=s8QKIP/barcrvOdwQvbP4zonPcCZhxIKDl4vWq1XtuFRfuSpYeAjs+/k4ystwYrDV
         b2Rp2Xu1TdTS7Kz96XFi/QqP3PiMgSYGf1BErK9XxdDb6+eZDSeqsNQqBPKkCBceG/
         /k1hzoz//dJEK3ebDZ056lgBv8xT7eND38lJc4pza7CyZTsoom7u5TmXf+zPMBhXyD
         5OTJs/e/F/OZfs4qEolhl8J0XEzttkO0BcMqkWJcpCV0iDHYgzoss6lzIXA2p8x44s
         jDhFDC94H2A3Z9n83YNjPukVjVK1sCDl6QNiSQFXym2U9+2JKP9+VK33XhdWMRjwsz
         buIwG3IqBpxfw==
Date:   Mon, 21 Nov 2022 16:25:25 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Carlos Maiolino <cem@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [ANNOUNCE] xfsprogs for-next branch updated
Message-ID: <Y3wW9SCRYmBX3K9a@magnolia>
References: <20221121143547.m33n36fufbz2x626@andromeda>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221121143547.m33n36fufbz2x626@andromeda>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Mon, Nov 21, 2022 at 03:35:47PM +0100, Carlos Maiolino wrote:
> Hello.
> 
> The xfsprogs, for-next branch located at:
> 
> https://git.kernel.org/pub/scm/fs/xfs/xfsprogs-dev.git/log/?h=for-next
> 
> has just been updated.
> 
> The new head is:
> 
> b827e2318 xfs: fix sb write verify for lazysbcount
> 
> 
> This update contains only the libxfs-sync for Linux 6.1, and will serve as a
> base for the xfsprogs 6.1 release.
> Please, let me know if any issue.
> 
> 
> The following commits are now in the for-next tree:
> 
> [b827e2318] xfs: fix sb write verify for lazysbcount

Why was this commit merged for xfsprogs 6.1?  That patch is queued for
kernel 6.2 in for-next, but the merge window is not open yet.

--D

> [7257eb3ed] xfs: rename XFS_REFC_COW_START to _COWFLAG
> [7accbcd00] xfs: fix uninitialized list head in struct xfs_refcount_recovery
> [8b2b27581] xfs: fix agblocks check in the cow leftover recovery function
> [817ea9f0f] xfs: check record domain when accessing refcount records
> [f275d70e8] xfs: remove XFS_FIND_RCEXT_SHARED and _COW
> [cc2a3c2ad] xfs: refactor domain and refcount checking
> [8160aeff0] xfs: report refcount domain in tracepoints
> [6b2f464dd] xfs: track cow/shared record domains explicitly in xfs_refcount_irec
> [bec88ec72] xfs: move _irec structs to xfs_types.h
> [7ccbdec2b] xfs: check deferred refcount op continuation parameters
> [b3f9ae08e] xfs: create a predicate to verify per-AG extents
> [2d5166b9d] xfs: make sure aglen never goes negative in xfs_refcount_adjust_extents
> [4b69afdc4] xfs: refactor all the EFI/EFD log item sizeof logic
> [d267ac6a0] xfs: fix memcpy fortify errors in EFI log format copying
> [227bc97f1] xfs: increase rename inode reservation
> [20798cc06] xfs: fix exception caused by unexpected illegal bestcount in leaf dir
> [11d2f5afc] treewide: use get_random_u32() when possible
> [4947ac5b3] treewide: use prandom_u32_max() when possible, part 1
> [1a3bfffee] xfs: rearrange the logic and remove the broken comment for xfs_dir2_isxx
> [04d4c27af] xfs: trim the mapp array accordingly in xfs_da_grow_inode_int
> [e8dbbca18] xfs: Remove the unneeded result variable
> [be98db856] xfs: clean up "%Ld/%Lu" which doesn't meet C standard
> 
> 
> -- 
> Carlos Maiolino
