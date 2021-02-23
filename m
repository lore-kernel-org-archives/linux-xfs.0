Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92801C433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 05:33:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5BE5B64E4B
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 05:33:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229961AbhBWFdC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Feb 2021 00:33:02 -0500
Received: from mail104.syd.optusnet.com.au ([211.29.132.246]:40364 "EHLO
        mail104.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230429AbhBWFc7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 23 Feb 2021 00:32:59 -0500
Received: from dread.disaster.area (pa49-179-130-210.pa.nsw.optusnet.com.au [49.179.130.210])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id E1412827E5E
        for <linux-xfs@vger.kernel.org>; Tue, 23 Feb 2021 16:32:16 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1lEQIy-0009cT-1i
        for linux-xfs@vger.kernel.org; Tue, 23 Feb 2021 16:32:16 +1100
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1lEQIx-00DnTt-Nn
        for linux-xfs@vger.kernel.org; Tue, 23 Feb 2021 16:32:15 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 0/3] xfs: CIL improvements
Date:   Tue, 23 Feb 2021 16:32:09 +1100
Message-Id: <20210223053212.3287398-1-david@fromorbit.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0 cx=a_idp_d
        a=JD06eNgDs9tuHP7JIKoLzw==:117 a=JD06eNgDs9tuHP7JIKoLzw==:17
        a=qa6Q16uM49sA:10 a=y-eqr125no_FFCfN46cA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

HI folks,

The following patches improve the behaviour of the CIL and increase
the processing capacity available for pushing changes into the
journal.

The first patch is an interface change, fixing something I did when
first introducing delayed logging to ease the understanding of the
change the CIL placed on the rest of the code. That was to "pretend"
that the log items still recorded the log sequence numbers that they
were comitted to, and that these LSNs could be passed to
xfs_log_force_lsn() to force the log to a certain LSN.

Truth is that the CIL hands out CIL sequence numbers to log items on
commits, not journal log sequence numbers. The LSNs are now
essentially and internal log and AIL implementation detail,
everything else that runs transactions and interfaces with log items
to force the log store around CIL sequences.

Hence the first patch converts xfs_log_force_lsn() to
xfs_log_force_seq() and all the high level stuff to refer to
sequence numbers rather than LSNs.

The second patch gets rid of severe latency issues that the AIL can
see due to having to force the log to unpin items. While it is
running a log force, it does nothing and hence we can run out of log
space before the log force returns and the AIL starts pushing again.

The AIL only needs to push on the CIL to get items unpinned, and it
doesn't need to wait for it to complete, either, before it continues
onwards trying to push out items to disk. The AIL will back off when
it reaches target, so it doesn't need to wait on log forces to back
off when there are pinned items in the AIL.

Hence this patch adds a mechanism to do an async push on the CIL
that does not block and changes the AIL to use it. This results in
the AIL backing off on it's own short timeouts and trying to make
progress repeatedly instead of stalling for seconds waiting for log
forces to complete.

The last patch is a fix to the pipelining of the CIL pushes. The
pipelining isn't working as intended, it's actually serialising and
resulting in the CIL push work being CPU bound and limiting the rate
at which items can be pushed to the journal. It is also creating
excessive push latency where the CIL fills and hits the hard
throttle while waiting for the push work to finish the current push
and then start on the new push and swap in a new CIL context that
can be committed to.

Essentially, the problem is an implementation problem, not a design
flaw. The implementation has a single work attached to the CIL,
meaning we can only have a single outstanding push work in progress
at any time. The workqueue can handle more, but we only have a
single work. So the fix is to move the work to the CIL context so we
can queue and process multiple works at the same time, thereby
actually allowing the CIL push work to pipeline in the intended
manner.

Cheers,

Dave.


