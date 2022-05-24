Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00E06C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 24 May 2022 06:38:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232478AbiEXGiL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 May 2022 02:38:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232414AbiEXGiJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 24 May 2022 02:38:09 -0400
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8653795DE2
        for <linux-xfs@vger.kernel.org>; Mon, 23 May 2022 23:38:07 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-2-147.pa.nsw.optusnet.com.au [49.181.2.147])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id CC67D5345F1;
        Tue, 24 May 2022 16:38:06 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1ntOBA-00FjS3-OF; Tue, 24 May 2022 16:38:04 +1000
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1ntOBA-0088W1-Mb;
        Tue, 24 May 2022 16:38:04 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     chris@onthe.net.au
Subject: [RFC PATCH 0/2] xfs: non-blocking inodegc pushes
Date:   Tue, 24 May 2022 16:38:00 +1000
Message-Id: <20220524063802.1938505-1-david@fromorbit.com>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=628c7d4e
        a=ivVLWpVy4j68lT4lJFbQgw==:117 a=ivVLWpVy4j68lT4lJFbQgw==:17
        a=oZkIemNP1mAA:10 a=QgLqNt_jwlfLc-SMgakA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

I've had time to forward port the non-blocking inodegc push changes
I had in a different LOD to the current for-next tree. I've run it
through fstests auto group a couple of times and it hasn't caused
any space accounting related failures on the machines I've run it
on.

The first patch introduces the bound maximum work start time for the
inodegc queues - it's short, only 10ms (IIRC), but we don't want to
delay inodegc for an arbitrarily long period of time. However, it
means that work always starts quickly and so that reduces the need
for statfs() to have to wait for background inodegc to start and
complete to catch space "freed" by recent unlinks.

The second patch converts statfs to use a "push" rather than a
"flush". The push simply schedules any pending work that hasn't yet
timed out to run immediately and returns. It does not wait for the
inodegc work to complete - that's what a flush does, and that's what
caused all the problems for statfs(). Hence statfs() is converted to
push semantics at the same time, thereby removing the blocking
behaviour it currently has.

This should prevent a large amount of the issues that Chris has been
seeing with lots of processes stuck in statfs() - that will no long
happen. The only time user processes should get stuck now is when
the inodegc throttle kicks in (unlinks only at this point) or if we
are waiting for a lock a long running inodegc operation holds to be
released. We had those specific problems before background inodegc -
they manifested as unkillable unlink operations that had every
backed up on them instead of background inodegc that has everything
backed up on them.

Hence I think these patches largely restore the status quo that we
had before the background inodegc code was added.

Comments, thoughts and testing appreciated.

Cheers,

Dave.

