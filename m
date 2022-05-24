Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEF23C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 02:22:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233249AbiEXCWJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 May 2022 22:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233244AbiEXCWI (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 May 2022 22:22:08 -0400
Received: from mail105.syd.optusnet.com.au (mail105.syd.optusnet.com.au [211.29.132.249])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DDE26644F0
        for <linux-xfs@vger.kernel.org>; Mon, 23 May 2022 19:22:02 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id D1F2010E6A63
        for <linux-xfs@vger.kernel.org>; Tue, 24 May 2022 12:22:01 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ntKBM-00Fexk-9Y
        for linux-xfs@vger.kernel.org; Tue, 24 May 2022 12:22:00 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1ntKBM-007lAk-8d
        for linux-xfs@vger.kernel.org;
        Tue, 24 May 2022 12:22:00 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/3] xfs: small fixes for 5.19 cycle
Date:   Tue, 24 May 2022 12:21:55 +1000
Message-Id: <20220524022158.1849458-1-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=VuxAv86n c=1 sm=1 tr=0 ts=628c414a
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=oZkIemNP1mAA:10 a=NLyhF6UNh0fL3KyrJ9QA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

In this series are two small changes to debug code that have made
test runs a little more resilient for me over this cycle. One if a
fix to an assert that is popping on an error handling path that
doesn't take into account an error occurring. The other is to
convert a hard ASSERT fail to a XFS_IS_CORRUPT check that will dump
a failure to dmesg and fail tests taht way instead of hanging the
machine by killing an unmount process.

The other patch is a small optimisation to the new btree sibling
pointer checking. This explicitly inlines the new checking function,
reducing the code size significantly and making the code simpler and
faster to execute. This should address the small performance
regressions reported on AIM7 workloads caused by the sibling checks.

Cheers,

Dave.

