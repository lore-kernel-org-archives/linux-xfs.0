Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAAD7C07E95
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 02:35:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 907DC61361
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 02:35:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237415AbhGNChv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 13 Jul 2021 22:37:51 -0400
Received: from mail107.syd.optusnet.com.au ([211.29.132.53]:56861 "EHLO
        mail107.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237375AbhGNChv (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 13 Jul 2021 22:37:51 -0400
Received: from dread.disaster.area (pa49-181-34-10.pa.nsw.optusnet.com.au [49.181.34.10])
        by mail107.syd.optusnet.com.au (Postfix) with ESMTPS id 137BA5EB0;
        Wed, 14 Jul 2021 12:34:47 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m3UjW-006Hee-PQ; Wed, 14 Jul 2021 12:34:46 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1m3UjW-00Awef-Ev; Wed, 14 Jul 2021 12:34:46 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     linux-mm@kvack.org
Subject: [PATCH 0/3 v3] xfs, mm: memory allocation improvements
Date:   Wed, 14 Jul 2021 12:34:37 +1000
Message-Id: <20210714023440.2608690-1-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=hdaoRb6WoHYrV466vVKEyw==:117 a=hdaoRb6WoHYrV466vVKEyw==:17
        a=e_q4qTt1xDgA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=QLtZUzOzXB423iHX4GcA:9 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We're slowly trying to move the XFS code closer to the common memory
allocation routines everyone else uses. This patch set addresses a
regression from a previous set of changes (kmem_realloc() removal)
and removes another couple of kmem wrappers from within the XFS
code.

The first patch addresses a regression - using large directory
blocks triggers a warning when calling krealloc() recombine a buffer
split across across two log records into a single contiguous
memory buffer. this results in krealloc() being called to allocate a
64kB buffer with __GFP_NOFAIL being set. This warning is trivially
reproduced by generic/040 and generic/041 when run with 64kB
directory block sizes on a 4kB page size machine.

Log recovery really needs to use kvmalloc() like all the other
"allocate up to 64kB and can't fail" cases in filesystem code (e.g.
for xattrs), but there's no native kvrealloc() function that
provides us with the necessary semantics. So rather than add a new
wrapper, the first patch adds this helper to the common code and
converts XFS to use it for log recovery.

The latter two patches are removing what are essentially kvmalloc()
wrappers from XFS. With the more widespread use of
memalloc_nofs_save/restore(), we can call kvmalloc(GFP_KERNEL) and
just have it do the right thing because GFP_NOFS contexts are
covered by PF_MEMALLOC_NOFS task flags now. Hence we don't need
kmem_alloc_large() anymore. And with the slab code guaranteeing at
least 512 byte alignment for sector and block sized heap
allocations, we no longer need the kmem_alloc_io() variant of
kmem_alloc_large() for IO buffers. So these wrappers can all go
away...

Version 3:
- rebase on v5.14-rc1
- handle kvrealloc() failure in xlog_recover_add_to_cont_trans()

Version 2:
- https://lore.kernel.org/linux-xfs/20210630061431.1750745-1-david@fromorbit.com/
- rebase on v5.13 + xfs/for-next
- moved kvrealloc() to mm/util.c
- made incoming pointer const void *
- added null check for vmalloc() failure
- removed xfs_buftarg_dma_alignment()

Original:
- https://lore.kernel.org/linux-xfs/20210625023029.1472466-1-david@fromorbit.com/

