Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FEBBC433F5
	for <linux-xfs@archiver.kernel.org>; Mon,  7 Mar 2022 05:33:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235332AbiCGFdx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 7 Mar 2022 00:33:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232064AbiCGFdw (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 7 Mar 2022 00:33:52 -0500
Received: from mail104.syd.optusnet.com.au (mail104.syd.optusnet.com.au [211.29.132.246])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B0A463C483
        for <linux-xfs@vger.kernel.org>; Sun,  6 Mar 2022 21:32:58 -0800 (PST)
Received: from dread.disaster.area (pa49-186-17-0.pa.vic.optusnet.com.au [49.186.17.0])
        by mail104.syd.optusnet.com.au (Postfix) with ESMTPS id CF4DE52FDE2;
        Mon,  7 Mar 2022 16:32:57 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1nR5zM-002U7L-PC; Mon, 07 Mar 2022 16:32:56 +1100
Received: from dave by discord.disaster.area with local (Exim 4.95)
        (envelope-from <david@fromorbit.com>)
        id 1nR5zM-00AdZr-N6;
        Mon, 07 Mar 2022 16:32:56 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Cc:     willy@infradead.org
Subject: xfs: log recovery hang fixes
Date:   Mon,  7 Mar 2022 16:32:49 +1100
Message-Id: <20220307053252.2534616-1-david@fromorbit.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.4 cv=e9dl9Yl/ c=1 sm=1 tr=0 ts=6225990a
        a=+dVDrTVfsjPpH/ci3UuFng==:117 a=+dVDrTVfsjPpH/ci3UuFng==:17
        a=o8Y5sQTvuykA:10 a=PDD6-hFW_UmjMHP6HyoA:9
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

Willy reported generic/530 had started hanging on his test machines
and I've tried to reproduce the problem he reported. While I haven't
reproduced the exact hang he's been having, I've found a couple of
others while running g/530 in a tight loop on a couple of test
machines.

The first two patches are a result of a hang documented in patch 1.
The change to run the log worker earlier is defensive, but serves to
break generic log space deadlocks during intent and unlinked inode
recovery as it does at normal runtime. This doesn't fix the problem,
just adds a layer of protection that means stuff that gets stuck on
pinned buffers, push hangs, etc only stays hung up for 30s at most.

The second patch fixes the hang that results from delwri buffer
pushing racing with modifications that pin the buffer (i.e.
transaction commit) and then require access to it again soon after.
The buffer is locked by delwri submission that is waiting for it to
be unpinned, but the processes that might be able to trigger an
unpin are blocked waiting for the buffer lock itself. This happens
during log recovery when processing unlinked inodes that hit the
same inode cluster buffer.

The third patch is for log recovery hangs I've been seeing that
occur after unlinked inode recovery has completed and the AIL is
being pushed out. The trigger may be unique to the highly modified
kernel I was running (and mitigated to a 30s delay to log recovery
completion in g/530 by the first patch in the series), but I have
occasionally seen period hangs in xfs_ail_push_all_sync() in the
past where the AIL has not been fully emptied but it is sleeping
without making progress. Hence I think the problem is a real one,
just I don't have a way of reproducing it reliably an unmodified
kernel.

Willy, can you see if these patches fix the problem you are seeing?
If not, I still think they stand alone as necessary fixes, but I'll
have to keep digging to find out why you are seeing hangs in g/530.

Cheers,

Dave.

