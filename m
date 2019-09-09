Return-Path: <SRS0=Pnyc=XE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96CD2C4360D
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Sep 2019 01:52:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 79E7620854
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Sep 2019 01:52:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732449AbfIIBwF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 8 Sep 2019 21:52:05 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:58726 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732476AbfIIBwF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 8 Sep 2019 21:52:05 -0400
Received: from dread.disaster.area (pa49-181-255-194.pa.nsw.optusnet.com.au [49.181.255.194])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id D6BCD43E694
        for <linux-xfs@vger.kernel.org>; Mon,  9 Sep 2019 11:52:02 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i78qX-0006Tx-BA
        for linux-xfs@vger.kernel.org; Mon, 09 Sep 2019 11:52:01 +1000
Received: from dave by discord.disaster.area with local (Exim 4.92)
        (envelope-from <david@fromorbit.com>)
        id 1i78qX-0005Fr-6z
        for linux-xfs@vger.kernel.org; Mon, 09 Sep 2019 11:52:01 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [RFC PATCH 0/2] xfs: hard limit background CIL push size
Date:   Mon,  9 Sep 2019 11:51:57 +1000
Message-Id: <20190909015159.19662-1-david@fromorbit.com>
X-Mailer: git-send-email 2.23.0.rc1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=P6RKvmIu c=1 sm=1 tr=0
        a=YO9NNpcXwc8z/SaoS+iAiA==:117 a=YO9NNpcXwc8z/SaoS+iAiA==:17
        a=J70Eh1EUuV4A:10 a=w8YcT5D2_y2piBY9aeIA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

As we've been discussing from the recent generic/530 hangs, the CIL
push work can get held off for an arbitrary amount of time and
result in the CIL checkpoint growing large enough that it can
consume the entire log. This is not allowed - the log recovery
algorithm for finding the head and tail of the log requires two
checkpoints in the log so it can find the last full checkpoint that
it needs to recover. That puts a hard limit on the size of the CIL
checkpoints of just under 50% of the log.

The CIL currently doesn't have any enforcement on that - log space
hangs due to CIL overruns are not something we've see in test or
production systems until the recent unlinked list modifications we
made. Hence this has laregely been a theoretical problem rather than
a practical problem up to this point.

While we've made changes that avoid the CIL hold-off vectors that
lead to the generic/530 hangs, we have enough data on the CIL
characteristics and performance to be able to put in place hard
limits without compromising performance.

The first patch limits the CIL size on large logs - we don't need to
aggregate hundreds of megabytes of metadata in the CIL to realise
the relogging benefits that the CIL provides. Measures show that the
point at which performance starts to be affected is somewhere
between 16MB and 32MB of aggregated changes in the CIL. Hence
the background push threshold is limited to be 32MB on large logs,
but remains at 12.5% of the log on small logs.

The second patch adds a hard limit on the CIL background push
threshold. This is set to double the size of the push threshold, so
at most a single CIL context will consume 25% of the log before
attempts to do background pushes will block waiting for the
background push of that context to start. This means that all
processes that commit to a push context that is over the hard limit
will sleep until the background CIL push work starts on that
context. At that point, they will be woken and their next
transaction commits will occur into the new CIL commit that the
background push will switch over to.

This provides a hard limit on the size of CIL checkpoint of ~1/4 of
the entire log, well inside the size limit that log recovery imposes
on us. For maximally sized logs, this hard limit ends up being about
3% of the entire log, so it serves to keep the logged objects moving
from the CIL to the AIL at a reasonable rate and spreads them over a
wider range of LSNs giving more graduated (less bursty) tail pushing
behaviour.

Comments welcome.

-Dave.

