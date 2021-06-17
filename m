Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F894C49EA6
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 08:26:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75E9D613FB
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Jun 2021 08:26:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbhFQI2d (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 17 Jun 2021 04:28:33 -0400
Received: from mail110.syd.optusnet.com.au ([211.29.132.97]:51631 "EHLO
        mail110.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230411AbhFQI2c (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 17 Jun 2021 04:28:32 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail110.syd.optusnet.com.au (Postfix) with ESMTPS id D26BE10B706
        for <linux-xfs@vger.kernel.org>; Thu, 17 Jun 2021 18:26:22 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ltnLx-00DjwK-CB
        for linux-xfs@vger.kernel.org; Thu, 17 Jun 2021 18:26:21 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1ltnLx-0044v1-3R
        for linux-xfs@vger.kernel.org; Thu, 17 Jun 2021 18:26:21 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/8 V2] xfs: log fixes for for-next
Date:   Thu, 17 Jun 2021 18:26:09 +1000
Message-Id: <20210617082617.971602-1-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=r6YtysWOX24A:10 a=VwQbUJbxAAAA:8 a=eHPav1ZAIdXSiaH8SJwA:9
        a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

This is followup from the first set of log fixes for for-next that
were posted here:

https://lore.kernel.org/linux-xfs/20210615175719.GD158209@locust/T/#mde2cf0bb7d2ac369815a7e9371f0303efc89f51b

The first two patches of this series are updates for those patches,
change log below. The rest is the fix for the bigger issue we
uncovered in investigating the generic/019 failures, being that
we're triggering a zero-day bug in the way log recovery assigns LSNs
to checkpoints.

The "simple" fix of using the same ordering code as the commit
record for the start records in the CIL push turned into a lot of
patches once I started cleaning it up, separating out all the
different bits and finally realising all the things I needed to
change to avoid unintentional logic/behavioural changes. Hence
there's some code movement, some factoring, API changes to
xlog_write(), changing where we attach callbacks to commit iclogs so
they remain correctly ordered if there are multiple commit records
in the one iclog and then, finally, strictly ordering the start
records....

The original "simple fix" I tested last night ran almost a thousand
cycles of generic/019 without a log hang or recovery failure of any
kind. The refactored patchset has run a couple hundred cycles of
g/019 and g/475 over the last few hours without a failure, so I'm
posting this so we can get a review iteration done while I sleep so
we can - hopefully - get this sorted out before the end of the week.

Cheers,

Dave.

Version 2:

- tested on 5.13-rc6 + linux-xfs/for-next
- added strings for XLOG_STATE* variables to tracepoint output.
- rewrote the past/future iclog detection to use iclog header LSNs
  rather than iclog states as the state values do not tell us anything
  useful about the temporal relativity of the iclog in relation to
  the current commit iclog.
- added patches to strictly order checkpoint start records the same
  way we strictly order checkpoint commit records.


