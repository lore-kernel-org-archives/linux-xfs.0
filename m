Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20B14ECAAD8
	for <linux-xfs@archiver.kernel.org>; Fri, 16 Sep 2022 09:54:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbiIPJyr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 16 Sep 2022 05:54:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230201AbiIPJyk (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 16 Sep 2022 05:54:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A0C4252B0
        for <linux-xfs@vger.kernel.org>; Fri, 16 Sep 2022 02:54:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C4BB0629CE
        for <linux-xfs@vger.kernel.org>; Fri, 16 Sep 2022 09:54:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59DA7C433C1;
        Fri, 16 Sep 2022 09:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663322077;
        bh=jb7QrMlCHO8GAs0lg5W5WqrGHrjE/TShCSQXwT3B5PM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oeOsFeii+YWvZjLbFquDt/vtWayRjJZoZBV0AgoZ0ql9ctpIg58zpZE8jPPmHwsij
         Fcgkvkhfifih2DMtfo6QuLHsCvF40BuAA7YB/imeFkjWRj96XGk86z+GpoLTAkkWgd
         EqhEdTfWKR5blvwofjAd1gvF/hUwrOnOi4IzdZ22CdOap9ufsA0KyxwxbBFwh+dvum
         bgMLY2nWuM4dqFxD+9GFo0EigeQHMeNEEmAm70v7xitBl/Gl67qoSCxJDafVAmxmLt
         pw8XRlk/f/WGQ2zaLMbiMJ9LJiJkJjV7oW+fxBFjkYIuCTsjhF6WJnGtpFRQfIzkL0
         q3lB9r1zdJ2jA==
Date:   Fri, 16 Sep 2022 11:54:32 +0200
From:   Carlos Maiolino <cem@kernel.org>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org
Subject: Re: [ANNOUNCE] xfsprogs updated to 6.0.0-rc0
Message-ID: <20220916095432.wuvssbxfiff47cni@andromeda>
References: <20220915130309.a72eyhog3jayy6rf@andromeda>
 <T-Etdf1kLPoooSutCa5_PdGEfZJjRNdHLmUwm0Ye_fxNdBE4ZNKjoiYUbFREtMulFGVU8pcVHplqDFCIhplcpA==@protonmail.internalid>
 <YyNRSsYQ2QHjUZzp@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YyNRSsYQ2QHjUZzp@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> 
> Er... is there a bug in your script?  Want to crib from mine? :D
> https://djwong.org/docs/kernel/git-announce
> 

D'oh :( thanks, I had tested this before sending to public, ended up I used an
old version of the same script. Correct output was supposed to be as below:


Andrey Strachuk (1):
      [798d43495] xfs: removed useless condition in function xfs_attr_node_get

Carlos Maiolino (1):
      [3c6e12a4a] xfsprogs: Release v6.0.0-rc0

Dan Carpenter (1):
      [17df7eb7e] xfs: delete unnecessary NULL checks

Darrick J. Wong (6):
      [722e81c12] xfs: convert XFS_IFORK_PTR to a static inline helper
      [7ff5f1edf] xfs: make inode attribute forks a permanent part of struct xfs_inode
      [d4292c669] xfs: use XFS_IFORK_Q to determine the presence of an xattr fork
      [4f8415858] xfs: replace XFS_IFORK_Q with a proper predicate function
      [eae3e30d4] xfs: replace inode fork size macros with functions
      [e373f06a3] xfs: don't leak memory when attr fork loading fails

Dave Chinner (17):
      [ef78f876e] xfs: make last AG grow/shrink perag centric
      [37dc5890e] xfs: kill xfs_ialloc_pagi_init()
      [4330a9e00] xfs: pass perag to xfs_ialloc_read_agi()
      [87db57baf] xfs: kill xfs_alloc_pagf_init()
      [f9084bd95] xfs: pass perag to xfs_alloc_read_agf()
      [bc87af992] xfs: pass perag to xfs_read_agi
      [c1030eda4] xfs: pass perag to xfs_read_agf
      [1d202c10b] xfs: pass perag to xfs_alloc_get_freelist
      [9a73333d9] xfs: pass perag to xfs_alloc_put_freelist
      [75c01cccf] xfs: pass perag to xfs_alloc_read_agfl
      [83af0d13a] xfs: Pre-calculate per-AG agbno geometry
      [8aa34dc9b] xfs: Pre-calculate per-AG agino geometry
      [cee2d89ae] xfs: replace xfs_ag_block_count() with perag accesses
      [54f6b9e5e] xfs: make is_log_ag() a first class helper
      [0b2f4162b] xfs: rework xfs_buf_incore() API
      [69535dadf] xfs: track the iunlink list pointer in the xfs_inode
      [b9846dc9e] xfs: double link the unlinked inode list

Slark Xiao (1):
      [e4a32219d] xfs: Fix typo 'the the' in comment

Xiaole He (1):
      [ec36ecd2d] xfs: fix comment for start time value of inode with bigtime enabled

hexiaole (1):
      [d3e53ab7c] xfs: fix inode reservation space for removing transaction




-- 
Carlos Maiolino
