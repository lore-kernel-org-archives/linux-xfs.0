Return-Path: <SRS0=/Wyv=XA=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A77AC3A5A5
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 08:47:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4068C2070C
	for <linux-xfs@archiver.kernel.org>; Thu,  5 Sep 2019 08:47:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730710AbfIEIrZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 5 Sep 2019 04:47:25 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:41091 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731881AbfIEIrZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 5 Sep 2019 04:47:25 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 445E936309C
        for <linux-xfs@vger.kernel.org>; Thu,  5 Sep 2019 18:47:20 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i5nQE-0004Ca-Pl
        for linux-xfs@vger.kernel.org; Thu, 05 Sep 2019 18:47:18 +1000
Received: from dave by discord.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i5nQE-0007xl-LN
        for linux-xfs@vger.kernel.org; Thu, 05 Sep 2019 18:47:18 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 1/8 v2] xfs: log race fixes and cleanups
Date:   Thu,  5 Sep 2019 18:47:09 +1000
Message-Id: <20190905084717.30308-1-david@fromorbit.com>
X-Mailer: git-send-email 2.23.0.rc1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=D+Q3ErZj c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=J70Eh1EUuV4A:10 a=VwQbUJbxAAAA:8 a=6b9XNPVGxMwJ31f6U04A:9
        a=AjGcO6oz07-iQ99wixmX:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

This is a followup to the original patchset here:

https://lore.kernel.org/linux-xfs/20190905072856.GE1119@dread.disaster.area/T/#m8ae6bdccbf4248b5d219ad40ab5caa92f9e0a979

It is aimed at solving the hangs occurring in generic/530 and
cleaning up the code around the iclog completion. This version is
largely just changes for review comments, though there is a new
patch (#3) to address what is probably the underlying cause of
all the issues.

Chandan has tested the new unbound workqueue change and it solved
the hang on his test machine, passes all the log group tests on my
test machines.

Cheers,

Dave.

Version 3:
- add patch to yeild the CPU in AGI unlinked list processing and to
  allow the CIL push work to be done on any CPU so it doesn't get
  stuck on a CPU that isn't being yeilded.
- Added comment to explain the AIL push added to an unsuccessful
  wakeup in xlog_grant_head_wake()
- removed "did callbacks" parameter from
  xlog_state_callback_check_state and cleaned up comments
- fixed detection of the icloglock being dropped during the iclog
  state scan.
- fixed unintended logic change with iclogs in IOERROR state when
  factoring out state processing
- other small whitespace and cleanup bits.


