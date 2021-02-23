Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 429B1C433E6
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 05:48:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EA19C64E4D
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 05:48:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbhBWFst (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Feb 2021 00:48:49 -0500
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:60928 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230439AbhBWFss (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Feb 2021 00:48:48 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id B9C86FA97D2
        for <linux-xfs@vger.kernel.org>; Tue, 23 Feb 2021 16:47:54 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lEQY5-000AX6-V2
        for linux-xfs@vger.kernel.org; Tue, 23 Feb 2021 16:47:54 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lEQY5-00Dofj-Lx
        for linux-xfs@vger.kernel.org; Tue, 23 Feb 2021 16:47:53 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/3] xfs: 64kb directory block verification hurts
Date:   Tue, 23 Feb 2021 16:47:45 +1100
Message-Id: <20210223054748.3292734-1-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=qa6Q16uM49sA:10 a=fOOSwP09aBwv3-grD08A:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

Quite simple: the debug code we have for internal directory block
verification does not scale to large directory blocks. What is a
minor nuisance at 4kB block size turns into a major problem at 64kB
block size.

These three patches work to reduce the worst of this overhead
without completely gutting the debug checks that are being done.
The type verification code that is generated is horrible - the
compiler does not inline all the nested 3 line functions and so
the function call overhead is significant. Adding a few inline
keywords so that the internal nesting is inlined cuts the overhead
by 30%.

The overhead is still huge. Some of the verification testing is
unnecessary - testing for error injection for a bad inode number
millions of times a second is hugely expensive, and getting rid of
that cuts overhead of directory inode number validation in half.

But the overhead is still huge. The biggest offender is the
directory leaf hash ordering checks. On every debug check call, of
which there is several for every directory modification, we walk the
entire hash entry table in the buffer (8k entries!) to check for
order. This is largely unnecessary, so only do this full order check
when the check function is called from the IO verifiers. If a kernel
dev needs more expensive checks to be re-instated, they only need to
change a single parameter from false to true to do so.

These changes make scalability testing with 64kB directory blocks on
debug kernels possible.

Cheers,

Dave.

