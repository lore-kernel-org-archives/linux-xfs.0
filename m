Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBE81C43216
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Sep 2021 09:59:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CF60961041
	for <linux-xfs@archiver.kernel.org>; Thu,  2 Sep 2021 09:59:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233451AbhIBKAf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 2 Sep 2021 06:00:35 -0400
Received: from mail106.syd.optusnet.com.au ([211.29.132.42]:48527 "EHLO
        mail106.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233700AbhIBKAe (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 2 Sep 2021 06:00:34 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail106.syd.optusnet.com.au (Postfix) with ESMTPS id D009980D64D
        for <linux-xfs@vger.kernel.org>; Thu,  2 Sep 2021 19:59:32 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mLjVL-007nIi-JQ
        for linux-xfs@vger.kernel.org; Thu, 02 Sep 2021 19:59:31 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1mLjVL-003pCj-96
        for linux-xfs@vger.kernel.org; Thu, 02 Sep 2021 19:59:31 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [RFC PATCH 0/7] xfs: intent item whiteouts
Date:   Thu,  2 Sep 2021 19:59:20 +1000
Message-Id: <20210902095927.911100-1-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=7QKq2e-ADPsA:10 a=nY6raksJD63ZZ8U0MZ4A:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

HI folks,

This is a patchset built on top of Allison's Logged Attributes
and my CIL Scalibility patch sets. It is inspired by the performance
regressions that were seen from logging 64k xattrs and trying to
work out how to minimise the impact of logging xattrs. Most of that
is explained in the "[RFC] xfs: intent item whiteouts" patch, so
I won't repeat it here.

The whiteouts massively reduce the journal write overhead of logging
xattrs - with this patchset I've reduced 2.5GB/s of log traffic (16
way file create w/64k xattr workload) down to approximately 220MB of
log traffic, and performance has increased from 9k creates/s to 36k
creates/s. The workload still writes to disk at 2.5GB/s, but that's
what writing 35k x 64k xattrs to disk does.

This is still short of the non-logged attribute mechanism, which
runs at 45-50k creates a second and 3.5-4GB/s to disk, but it brings
logged attrs to within roughly 5-15% of non-logged attrs across the
full range of attribute sizes.

The biggest limitation to logged attr throughput at this point in
time is the memory allocation overhead of the shadow buffers for
logging the xattr name. I have some ideas on how to avoid that, but
nothing concrete yet, so in the mean time there's a patch to make
"kvmalloc()" behave how we need it to behave and the whiteout
implementation frees shadow buffers attached to the intents when the
whiteout is applied so that we don't hold lots of memory allocated
unnecessarily.

This patchset is separate to the attr code, though, because
intent whiteouts are not specific to the attr code. They are a
generic mechanism that can be applied to all the intent/intent done
item pairs we already have. This patch set modifies all those
intents to use whiteouts, and so there is benefits from the patch
set for all operations that use these intents.

I haven't done anything other than smoke test these patches with
xattr performance tests, so don't use them on anything you care
about. This posting is for early feedback so I can try to land them
with the logged attribute code to minimise the impact of the perf
regressions.

What do people think of the approach I've taken for this feature?

Cheers,

Dave.

