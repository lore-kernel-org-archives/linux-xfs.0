Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75685C4338F
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Aug 2021 05:21:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57E196101D
	for <linux-xfs@archiver.kernel.org>; Tue, 10 Aug 2021 05:21:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237639AbhHJFVv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 Aug 2021 01:21:51 -0400
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:42685 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237614AbhHJFVp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 Aug 2021 01:21:45 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id 54A07867624
        for <linux-xfs@vger.kernel.org>; Tue, 10 Aug 2021 15:21:23 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mDKCY-00GZcD-NZ
        for linux-xfs@vger.kernel.org; Tue, 10 Aug 2021 15:21:22 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1mDKCY-000Ago-D9
        for linux-xfs@vger.kernel.org; Tue, 10 Aug 2021 15:21:22 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/5 v3] xfs: strictly order log start records
Date:   Tue, 10 Aug 2021 15:21:15 +1000
Message-Id: <20210810052120.41019-1-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=F8MpiZpN c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=MhDmnRu9jo8A:10 a=VwQbUJbxAAAA:8 a=7-415B0cAAAA:8
        a=IGfJWdSb32bzu4Gr1ucA:9 a=AjGcO6oz07-iQ99wixmX:22
        a=biEYGPWJfzWAr4FL6Ov7:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

We recently found a zero-day log recovery issue where overlapping
log transactions used the wrong LSN for recovery operations despite
being replayed in the correct commit record order. The issue is that
the log recovery code uses the LSN of the start record of the log
transaction for ordering and metadata stamping, while the actual
order of transaction replay is determined by the commit record.
Hence if we pipeline CIL commits we can end up with overlapping
transactions in the log like:

Start A .. Start C .. Start B .... Commit A .. Commit B .. Commit C

The issue is that the "start B" lsn is later than the "start C" lsn.
When the same metadata block is modified in both transaction B and
C, writeback from "commit B" will correctly stamp "start B" into the
metadata.

However, when "commit C" runs, it will see the LSN in that metadata
block is "start B", which is *more recent than "Start C" and so
will, incorrectly, fail to recover that change into the metadata
block. This results in silent metadata corruption, which can then be
exposed by future recovery operations failing, runtime
inconsistencies causing shutdowns and/or xfs_scrub/xfs_repair check
failures.

We could fix log recovery to avoid this problem, but there's a
runtime problem as well: the AIL is ordered by start record LSN. We
cannot order the AIL by commit LSN as we cannot allow the tail of
the log to overwrite -any- of the log transaction until the entire
transaction has been written. As the lowest LSN of the items in the
AIL defines the current log tail, the same metadata writeback
ordering issues apply as with log recovery.

In this case, we run the callbacks for commit B first, which place
all the items at the head of the log at "start B". Then we run
callbacks for "commit C", which then do not insert at the head -
they get inserted before "start B". If the item was modified in both
B and C, then it moves *backwards* in the AIL and this screws up all
manner of things that assume relogging can only move objects
forwards in the log. One of these things it can screw up is the tail
lsn of the log. Nothing good comes from this...

Because we have both runtime and journal-based ordering requirements
for the start_lsn, we have multiple places where there is an
implicit assumption that transaction start records are strictly
ordered. Rather than play whack-a-mole with such assumptions, and to
avoid the eternal "are you running a fixed kernel" question, it's
better just to strictly order the start records in the same way we
strictly order the commit records.

This patch series takes the mechanisms of the strict commit record
ordering and utilises them for strict start record ordering. It
builds upon the shutdown rework patchset to guarantee that the CIL
context structure will not get freed from under it by a racing
shutdown, and so moves the LSN recording for ordering up into a
callback from xlog_write() once we have a guaranteed iclog write
location. This means we have one mechanism for both start and commit
record ordering, and they both work in exactly the same way.

Version 3:
- rebase on 5.14-rc4 + for-next + "xfs: shutdown is a racy mess"
- fixed typos in subject line

Version 2:
- https://lore.kernel.org/linux-xfs/20210714033656.2621741-1-david@fromorbit.com/
- rebase on 5.14-rc1 + "xfs: shutdown is a racy mess"
- fixed typos in commit messages

Version 1:
- https://lore.kernel.org/linux-xfs/20210630072108.1752073-1-david@fromorbit.com/

