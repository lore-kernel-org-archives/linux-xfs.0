Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14642C4338F
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Aug 2021 05:28:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E753760295
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Aug 2021 05:28:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237264AbhHJF3R (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Aug 2021 01:29:17 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:52137 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237249AbhHJF3R (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Aug 2021 01:29:17 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id A78CC80BC72
        for <linux-xfs@vger.kernel.org>; Tue, 10 Aug 2021 15:28:54 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mDKJq-00GZt7-3C
        for linux-xfs@vger.kernel.org; Tue, 10 Aug 2021 15:28:54 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1mDKJp-000B4E-Rl
        for linux-xfs@vger.kernel.org; Tue, 10 Aug 2021 15:28:53 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/3] xfs: clean up buffer cache disk addressing
Date:   Tue, 10 Aug 2021 15:28:48 +1000
Message-Id: <20210810052851.42312-1-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=MhDmnRu9jo8A:10 a=AxGcN0OE7OLTWqCLmmIA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Over time, we've moved from using bp->b_bn as the physical disk
address for a buffer to using the address of the first buffer map
attached to the buffer. This can be seen by the implementation of
XFS_BUF_ADDR() macro:

#define XFS_BUF_ADDR(bp) ((bp)->b_maps[0].bm_bn)

The bp->b_bn value is now used as the buffer cache index for the
buffer, and it is always set to XFS_BUF_DADDR_NULL for uncached
buffers. Hence code that uses bp->b_bn for the physical address of
the buffer will not do the right thing when passed an uncached
buffer.

This series of patches addresses this problem. It adds a helper
function xfs_buf_daddr() to extract the physical address of the
buffer from it, and replaces all the open coded bp->b_bn accesses
and the XFS_BUF_ADDR() users to use it. It then renames b_bn to
b_index and converts all the internal cache lookup code to use
b_index rather than b_bn.

The result is that all code now uses xfs_buf_daddr() where physical
addresses are required, and the cache index variable isn't named in
a manner that engenders external use of access. The changes end up
being relatively small, and the impact on userspace outside libxfs
is even smaller (only a couple of dozen references to b_bn or
XFS_BUF_ADDR).

Version 1
- based on 5.14-rc4 + for-next + "xfs: rework feature flags"

