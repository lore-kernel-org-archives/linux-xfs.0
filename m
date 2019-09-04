Return-Path: <SRS0=tdPo=W7=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDF56C3A5A9
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 04:24:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3F3621883
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Sep 2019 04:24:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725840AbfIDEY5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Sep 2019 00:24:57 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:41383 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725864AbfIDEY5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Sep 2019 00:24:57 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id CE59443E1FB
        for <linux-xfs@vger.kernel.org>; Wed,  4 Sep 2019 14:24:53 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i5Mqi-0007OI-S2
        for linux-xfs@vger.kernel.org; Wed, 04 Sep 2019 14:24:52 +1000
Received: from dave by discord.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i5Mqi-0002UF-O2
        for linux-xfs@vger.kernel.org; Wed, 04 Sep 2019 14:24:52 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/7] xfs: log race fixes and cleanups
Date:   Wed,  4 Sep 2019 14:24:44 +1000
Message-Id: <20190904042451.9314-1-david@fromorbit.com>
X-Mailer: git-send-email 2.23.0.rc1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=J70Eh1EUuV4A:10 a=8ivwr5y6RWh_1Ttar00A:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

HI folks,

This series of patches contain fixes for the generic/530 hangs that
Chandan and Jan reported recently. The first patch in the series is
the main fix for this, though in theory the last patch in the series
is necessary to totally close the problem off.

The second patch is an outstanding fix for a log flush wakeup race
in the xlog_state_do_callback() code from Rik van Riel. Given that
the next 5 patches in the series clean up iand address the tail
pushing race in xlog_state_do_callback(), it makes sense to get this
into the kernel at the same time.

Patches 3-6 factor several independent chunks out of
xlog_state_do_callback, greatly simplifying that function and
breaking the iclog IO completion processing down into discrete
chunks of separate functionality. This makes the code much easier
to read, follow and understand.

An the last patch kicks the AIL if necessary when the log tail is
moved to avod the situation where the AIL pushing has stalled
because the previous last_sync_lsn is further into the log than the
push target reaches.

Comments welcome.

-Dave.

