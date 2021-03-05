Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8020C433DB
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 05:18:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9377865005
	for <linux-xfs@archiver.kernel.org>; Fri,  5 Mar 2021 05:18:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbhCEFMA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 5 Mar 2021 00:12:00 -0500
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:58893 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229504AbhCEFLw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 5 Mar 2021 00:11:52 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id D93E71041369
        for <linux-xfs@vger.kernel.org>; Fri,  5 Mar 2021 16:11:50 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lI2kf-00Fbni-Vo
        for linux-xfs@vger.kernel.org; Fri, 05 Mar 2021 16:11:50 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lI2kf-000lYk-LN
        for linux-xfs@vger.kernel.org; Fri, 05 Mar 2021 16:11:49 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 00/45 v3] xfs: consolidated log and optimisation changes
Date:   Fri,  5 Mar 2021 16:10:58 +1100
Message-Id: <20210305051143.182133-1-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=dESyimp9J3IA:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=7FDdtEjNmoGwzhnI5dgA:9 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22 a=yLDStRjdRdRizzv_QTJ6:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

This is a consolidated patchset of all the outstanding patches I've
sent out recently. Previous versions and sub-series descriptions
can be found here:

https://lore.kernel.org/linux-xfs/20210226050158.GW4662@dread.disaster.area/T/#mf72a4f6acc05d117adec3fea5f6fee83432ecfd4
https://lore.kernel.org/linux-xfs/20210223033442.3267258-1-david@fromorbit.com/T/#m80819d7f7940e5f216f3219baf4f98ed35643d13
https://lore.kernel.org/linux-xfs/20210223053212.3287398-1-david@fromorbit.com/T/#mad305a62ab3532493c83b4c615f21fbaf9a87ae0
https://lore.kernel.org/linux-xfs/20210223044636.3280862-1-david@fromorbit.com/T/#m791941d515fd437bf07aa42d35df5ddb124cb80f
https://lore.kernel.org/linux-xfs/20210224063459.3436852-1-david@fromorbit.com/T/#mcb037e1495e6bb4f3289e52d581e53efe2d29765
https://lore.kernel.org/linux-xfs/20210223054748.3292734-1-david@fromorbit.com/T/#md88d8f88657f1e33008f864677921f54b4d64a2f
https://lore.kernel.org/linux-xfs/20210225033725.3558450-1-david@fromorbit.com/T/#mb6a91780514d5abe4d8b04ed1d78a8f8d681f101

The changes are largely just a rebase onto a current TOT kernel, bug
fixes and modifications from review comments. These are itemised in
the change log below. It runs though the fstests auto group fine on
e multiple machines here and performance test numbers are largely
unchanged from previous versions.

I've added a couple of new patches to the end of the series, the
most notable being an update to the delayed logging design document
to include descriptions of transaction types, log space accounting
and how we use relogging to ensure rolling transactions do not
deadlock on log space.

Cheers,

Dave.

Version 3:
- rebase onto 5.12-rc1+
- aggregate many small dependent patchsets in one large one.
- simplify xlog_wait_on_iclog_lsn() back to just a call to xlog_wait_on_iclog()
- remove xfs_blkdev_issue_flush() instead of moving and renaming it.
- pass bio to xfs_flush_bdev_async() so it doesn't need allocation.
- skip cache flush in xfs_flush_bdev_async() if the underlying queue does not
  require it.
- fixed whitespace in xfs_flush_bdev_async()
- remove the implicit external log's data device cache flush code and replace it
  with an explicit flush in the unmount record write so that it works the same
  as the new CIL checkpoint cache pre-flush mechanism. This mechanism now
  guarantees metadata vs journal ordering for both internal and external logs.
- updated various commit messages
- fixed incorrect/unintended changes to xfs_log_force() behaviour
- typedef uint64_t xfs_csn_t; and conversion.
- removed stray trace_printk()s that were used for debugging.
- fixed minor formatting details.
- uninlined xlog_prepare_iovec()
- fixed up "lv chain vector and size calculation" commit message to reflect we
  are only calculating and passin gin the vector byte count.
- reworked the loop in xlog_write_single() based on Christoph's suggestion. Much
  cleaner!
- added patch to pass log ticket down to xlog_sync() so that it accounts the
  roundoff to the log ticket rather than directly modifying grant heads. Grant
  heads are hot, so every little bit helps.
- added patch to update delayed logging design doc with background material on
  how transactions and log space accounting works in XFS.

Version 2:
- fix ticket reservation roundoff to include 2 roundoffs
- removed stale copied comment from roundoff initialisation.
- clarified "separation" to mean "separation for ordering purposes" in commit
  message.
- added comment that newly activated, clean, empty iclogs have a LSN of 0 so are
  captured by the "iclog lsn < start_lsn" case that avoids needing to wait
  before releasing the commit iclog to be written.
- added async cache flush infrastructure
- convert CIL checkpoint push work it issue an unconditional metadata device
  cache flush rather than asking the first iclog write to issue it via
  REQ_PREFLUSH.
- cleaned up xlog_write() to remove a redundant parameter and prepare the logic
  for setting flags on the iclog based on the type of operational data is being
  written to the log.
- added XLOG_ICL_NEED_FUA flag to complement the NEED_FLUSH flag, allowing
  callers to issue explicit flushes and clear the NEED_FLUSH flag before the
  iclog is written without dropping the REQ_FUA requirement in /dev/null...
- added CIL commit-in-start-iclog optimisation that clears the NEED_FLUSH flag
  to avoid an unnecessary cache flush when issuing the iclog.
- fixed typo in CIL throttle bugfix comment.
- fixed trailing whitespace in commit message.


