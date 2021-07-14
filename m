Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30809C11F67
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 05:06:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1933D613AF
	for <linux-xfs@archiver.kernel.org>; Wed, 14 Jul 2021 05:06:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbhGNFI6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 14 Jul 2021 01:08:58 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:50935 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237849AbhGNFI5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 14 Jul 2021 01:08:57 -0400
Received: from dread.disaster.area (pa49-181-34-10.pa.nsw.optusnet.com.au [49.181.34.10])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id EF0721045304
        for <linux-xfs@vger.kernel.org>; Wed, 14 Jul 2021 15:06:04 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1m3X5v-006KAs-QK
        for linux-xfs@vger.kernel.org; Wed, 14 Jul 2021 15:06:03 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1m3X5v-00B2m9-GX
        for linux-xfs@vger.kernel.org; Wed, 14 Jul 2021 15:06:03 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/3 v6] xfs: make CIL pipelining work
Date:   Wed, 14 Jul 2021 15:05:57 +1000
Message-Id: <20210714050600.2632218-1-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=hdaoRb6WoHYrV466vVKEyw==:117 a=hdaoRb6WoHYrV466vVKEyw==:17
        a=e_q4qTt1xDgA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=TF2Z0k3je78k5Ci6_tQA:9 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patchset improves the behaviour of the CIL by increasing
the processing capacity available for pushing changes into the
journal.

There are two aspects to this. The first is to reduce latency for
callers that require non-blocking log force behaviour such as the
AIL.

The AIL only needs to push on the CIL to get items unpinned, and it
doesn't need to wait for it to complete, either, before it continues
onwards trying to push out items to disk. The AIL will back off when
it reaches it's push target, so it doesn't need to wait on log
forces to back off when there are pinned items in the AIL.

Hence we add a mechanism to async pushes on the CIL that do not
block and convert the AIL to use it. This results in the AIL backing
off on it's own short timeouts and trying to make progress
repeatedly instead of stalling for seconds waiting for log large CIL
forces to complete.

This ability to run async CIL pushes then highlights a problem with
pipelining of the CIL pushes. The pipelining isn't working as
intended, it's actually serialising and only allowing a single CIL
push work to be in progress at once.

This can result in the CIL push work being CPU bound and limiting
the rate at which items can be pushed to the journal. It is also
creating excessive push latency where the CIL fills and hits the
hard throttle while waiting for the push work to finish the current
push and then start on the new push and swap in a new CIL context
that can be committed to.

Essentially, the problem is an implementation problem, not a design
flaw. The implementation has a single work attached to the CIL,
meaning we can only have a single outstanding push work in progress
at any time. The workqueue can handle more, but we only have a
single work. So the fix is to move the work to the CIL context so we
can queue and process multiple works at the same time, thereby
actually allowing the CIL push work to pipeline in the intended
manner.

With this change, it's also very clear that the CIL workqueue really
belongs to the CIL, not the xfs_mount. Having the CIL push have to
reference through the log and the xfs_mount to reach it's private
workqueue is quite the layering violation, so fix this up, too.

This has been run through thousands of cycles of generic/019 and
generic/0475 since the start record ordering issues were fixed by
"xfs: strictly order log start records" without any log recovery
failures or corruptions being recorded.

Version 6:
- split out from aggregated patchset
- add dependency on "xfs: strictly order log start records" for
  correct log recovery and runtime AIL ordering behaviour.
- rebase on 5.14-rc1 + "xfs: strictly order log start records"
- add patch moving CIL push workqueue into the CIL itself rather
  than having to go back up to the xfs_mount to access it at
  runtime.

Version 5:
- https://lore.kernel.org/linux-xfs/20210603052240.171998-1-david@fromorbit.com/

