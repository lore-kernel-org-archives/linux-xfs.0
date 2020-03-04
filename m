Return-Path: <SRS0=37eZ=4V=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43984C3F2D8
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 07:54:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 27EEB2166E
	for <linux-xfs@archiver.kernel.org>; Wed,  4 Mar 2020 07:54:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbgCDHyG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 4 Mar 2020 02:54:06 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:43676 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725271AbgCDHyG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 4 Mar 2020 02:54:06 -0500
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 400327EA12E
        for <linux-xfs@vger.kernel.org>; Wed,  4 Mar 2020 18:54:03 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j9Oqv-0007lO-PC
        for linux-xfs@vger.kernel.org; Wed, 04 Mar 2020 18:54:01 +1100
Received: from dave by discord.disaster.area with local (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1j9Oqv-0005cR-L0
        for linux-xfs@vger.kernel.org; Wed, 04 Mar 2020 18:54:01 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 00/11] xfs: clean up log tickets and record writes
Date:   Wed,  4 Mar 2020 18:53:50 +1100
Message-Id: <20200304075401.21558-1-david@fromorbit.com>
X-Mailer: git-send-email 2.24.0.rc0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=LYdCFQXi c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=SS2py6AdgQ4A:10 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8
        a=ZksPV3yDyTq3zX-UmBgA:9 a=AjGcO6oz07-iQ99wixmX:22
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This series follows up on conversions about relogging infrastructure
and the way xfs_log_done() does two things but only one of several
callers uses both of those functions. It also pointed out that
xfs_trans_commit() never writes to the log anymore, so only
checkpoints pass a ticket to xlog_write() with this flag set and
no transaction makes multiple calls to xlog_write() calls on the
same ticket. Hence there's no real need for XLOG_TIC_INITED to track
whether a ticket has written a start record to the log anymore.

A lot of further cleanups fell out of this. Once we no longer use
XLOG_TIC_INITED to carry state inside the write loop, the logic
can be simplified in both xlog_write and xfs_log_done. xfs_log_done
can be split up, and then the call chain can be flattened because
xlog_write_done() and xlog_commit_record() are basically the same.

This then leads to cleanups writing both commit and unmount records,
and removes a heap of duplicated error handling code in the unmount
record writing path.

And in looking over all this code, I noticed a heap of stale and
unnecessary comments through the code which can be cleaned up.

Finally, to complete what started all this, the XLOG_TIC_INITED flag
is removed.

This has made it through fstests without causing any obvious
regressions, so it's time for thoughts and comments. This can also
be found at:

https://git.kernel.org/pub/scm/linux/kernel/git/dgc/linux-xfs.git/h?xlog-ticket-cleanup

Note that this message appears as the first (empty) commit of the
series, as this is how I get my local hacked version of guilt to
format this cover message automatically.

Diffstat:
 fs/xfs/xfs_log.c      | 509 +++++++++++++++++++-------------------------------
 fs/xfs/xfs_log.h      |   4 -
 fs/xfs/xfs_log_cil.c  |  13 +-
 fs/xfs/xfs_log_priv.h |  22 +--
 fs/xfs/xfs_trans.c    |  24 +--
 5 files changed, 225 insertions(+), 347 deletions(-)

Signed-off-by: Dave Chinner <dchinner@redhat.com>


Dave Chinner (11):
  xfs: don't try to write a start record into every iclog
  xfs: re-order initial space accounting checks in xlog_write
  xfs: refactor and split xfs_log_done()
  xfs: merge xlog_commit_record with xlog_write_done()
  xfs: factor out unmount record writing
  xfs: move xlog_state_ioerror()
  xfs: clean up xlog_state_ioerror()
  xfs: rename the log unmount writing functions.
  xfs: merge unmount record write iclog cleanup.
  xfs: remove some stale comments from the log code
  xfs: kill XLOG_TIC_INITED

 fs/xfs/xfs_log.c      | 509 ++++++++++++++++--------------------------
 fs/xfs/xfs_log.h      |   4 -
 fs/xfs/xfs_log_cil.c  |  13 +-
 fs/xfs/xfs_log_priv.h |  22 +-
 fs/xfs/xfs_trans.c    |  24 +-
 5 files changed, 225 insertions(+), 347 deletions(-)

-- 
2.24.0.rc0

