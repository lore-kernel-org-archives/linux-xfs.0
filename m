Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FAF6C47082
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 05:22:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5633B61361
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Jun 2021 05:22:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbhFCFYg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Jun 2021 01:24:36 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:33823 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229727AbhFCFYg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Jun 2021 01:24:36 -0400
Received: from dread.disaster.area (pa49-179-138-183.pa.nsw.optusnet.com.au [49.179.138.183])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 23505861CFA
        for <linux-xfs@vger.kernel.org>; Thu,  3 Jun 2021 15:22:51 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lofog-008Mpu-86
        for linux-xfs@vger.kernel.org; Thu, 03 Jun 2021 15:22:50 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lofof-000ilC-U9
        for linux-xfs@vger.kernel.org; Thu, 03 Jun 2021 15:22:50 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 00/39 v5] xfs: CIL and log optimisations
Date:   Thu,  3 Jun 2021 15:22:01 +1000
Message-Id: <20210603052240.171998-1-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=YKPhNiOx c=1 sm=1 tr=0
        a=MnllW2CieawZLw/OcHE/Ng==:117 a=MnllW2CieawZLw/OcHE/Ng==:17
        a=r6YtysWOX24A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=ls2P_PHNIlZtCV2PHz0A:9 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

This is an update of the consolidated log scalability patchset I've been working
on. Version 4 was posted here:

https://lore.kernel.org/linux-xfs/20210519121317.585244-1-david@fromorbit.com/

This version contains the changes Darrick requested during review. The only
patch remaining without at least one RVB tag is patch 30.

Performance improvements are largely documented in the change logs of the
individual patches. Headline numbers are an increase in transaction rate from
700k commits/s to 1.7M commits/s, and a reduction in fua/flush operations by
2-3 orders of magnitude on metadata heavy workloads that don't use fsync.

Summary of series:

Patches		Modifications
-------		-------------
1-7:		log write FUA/FLUSH optimisations
8:		bug fix
9-11:		Async CIL pushes
12-25:		xlog_write() rework
26-39:		CIL commit scalability

Change log is below.

Cheers,

Dave.

Version 5:
- fix typo in comment (patch 4)
- fix typo in commit msg (patch 7)
- removed unnecessary update of num_iovecs (patch 20)
- fixed whitespace (patch 29)
- removed unused space_used/curr_res from CIL pcp structure (patch 29)
- added space_used to CIL pcp structure (patch 30)
- add comment to xlog_cil_pcp_aggregate() (patch 30)
- added space_reserved to CIL pcp structure (patch 31)
- removed unnecessary commentary about CIL ordering issues from commit msg in
  patch 33 as patch 35 addresses these issues..
- fix whitespace in xlog_cil_free_logvec() (patch 35)
- fix weird sentence in docco (patch 39)
- propagate changes through patches to fix conflicts due to dependent changes.
  (various patches)


Version 4:
- rebase on 5.13-rc2+
- fixed completion logic for async cache flush
- trimmed superflous comments about not requiring REQ_PREFLUSH for iclog IO
  anymore.
- ensure that setting/clearing XLOG_ICL_NEED_FLUSH is atomic (i.e. only modified
  while holding the icloglock)
- ensure callers only add iclog flush/fua flags appropriately before releasing
  the iclog so that multiple independent writes to an iclog doesn't clear flags
  other writes into the iclog depend on.
- buffer log item dirty tracking patches merged so removed from series
- replaced XFS_LSN_CMP() checks with direct lsn1 == lsn2 comparisons to simplify
  the code
- changed "push_async" to "push_commit_stable" to indicate that the push caller
  wants the entire CIL checkpoint and commit record to be on stable storage when
  it completes.
- updated comment to indicate that iclog sync state is set according to the
  caller's desire for a stable checkpoint to be performed.
- Added comment explaining why the CIL workqueue is limited to 4 concurrent
  works per filesystem.
- debug overhead reduction patches merged so removed from series
- cleaned up a couple of typedef uses.
- updated pahole output for checkpoint header in commit message
- Added BUILD_BUG_ON() to check the size of unmount records.
- got rid of XFS_VOLUME define.
- got rid of XLOG_TIC_LEN_MAX define.
- cleaned up extra blank lines.
- fixed double initialisation of lv in xlog_write_single().
- removed the unnecessary change for reserved iclog space in
  xlog_state_get_iclog_space().
- no need to check for XLOG_CONTINUE_TRANS in xlog_write_partial() as it will
  always be set.
- added a patch for removing the optype parameter from xlog_write()
- removed unused nvecs from struct xfs_cil_ctx
- fixed whitespace damage in xlog_cil_pcp_dead()
- added missing cpu dead accounting transfer in xlog_cil_pcp_dead().
- factored out CIL push percpu structure aggregation into
  xlog_cil_pcp_aggregate()
- added the ctx->ticket->t_unit_res update back into the code even though it is
  largely unnecessary.
- cleaned up the pcp, cilpcp, pcptr mess in xlog_cil_pcp_alloc() and elsewhere
  to use variable names consistently.
- simplified the CIL sort comparison functions to a single comparison operation
- fixed percpu CIL item list sort order where items in the same transaction
  (order id) were reversed, leading to intents being replayed in the wrong
  order.
- split out log vector chain conversion to list_head into separate patch
- Updated documentation with all the fixes and suggestions made.


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


