Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F0EAC433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 04:47:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A762464E57
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 04:47:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbhBWErW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Feb 2021 23:47:22 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:46215 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230281AbhBWErV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 22 Feb 2021 23:47:21 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 5D70F827BA6
        for <linux-xfs@vger.kernel.org>; Tue, 23 Feb 2021 15:46:39 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lEPao-0006TA-Pd
        for linux-xfs@vger.kernel.org; Tue, 23 Feb 2021 15:46:38 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lEPao-00Dlc2-I3
        for linux-xfs@vger.kernel.org; Tue, 23 Feb 2021 15:46:38 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/3] xfs: buffer log item optimisations
Date:   Tue, 23 Feb 2021 15:46:33 +1100
Message-Id: <20210223044636.3280862-1-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=qa6Q16uM49sA:10 a=nfTSjt1qncTv52nSyaMA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

A couple of optimisations and a bug fix that I don't think we could
trigger.

The bug fix was that we weren't passing the segment offset into the
buffer log item sizing calculation, so we weren't calculating when
we spanned discontiguous pages in the buffers correctly. I don't
think this ever mattered, because all buffers larger than a single
page are vmapped (so a contiguous virtual address range) and the
only direct mapped buffers we have are inode cluster buffers and
they never span discontiguous extents. Hence while the code is
clearly wrong, we never actually trigger the situation where it
results in an incorrect calculation. However, changing the way we
calculate the size of the dirty regions is difficult if we don't do
this calc the same way as the formatting code, so fix it.

The first optimisation is simply a mechanism to reduce the amount of
allocation and freeing overhead on the buffer item shadow buffer as
we increase the amount of the buffer that is dirty as we relog it.

The last optimisation is (finally) addressing the overhead of bitmap
based dirty tracking of the buffer log item. We walk a bit at a
time, calling xfs_buf_offset() at least twice for each bit in both
the size and the formatting code to see if the region crosses a
discontiguity in the buffer address space. This is expensive. The
log recovery code uses contiguous bit range detection to do the
same thing, so I've updated the logging code to operate on
contiguous bit ranges and only fall back to bit-by-bit checking in
the rare case that a contiguous dirty range spans an address space
discontiguity and hence has to be split into multiple regions to
copy it into the log.

This enables big performance improvements when using large directory
block sizes.

Cheers,

Dave.

