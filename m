Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0AC9C83F12
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Aug 2023 23:07:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbjH2XHS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Aug 2023 19:07:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241089AbjH2XGu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2023 19:06:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55E72CC0
        for <linux-xfs@vger.kernel.org>; Tue, 29 Aug 2023 16:06:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E92ED639FB
        for <linux-xfs@vger.kernel.org>; Tue, 29 Aug 2023 23:06:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E51EC433C7;
        Tue, 29 Aug 2023 23:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693350407;
        bh=Xyrq9rBzuF3DXvaDiUhQ5nw1PFkQL12UB9oP4Pn3j/Y=;
        h=Subject:From:To:Cc:Date:From;
        b=GlE08av+teOqpF/kL+l/h2/kvkiIyEwjEgANpVOzIGHZP429u+OQfgEtz/Qrvg9m6
         va90JIwpAXn8xyB+ikxJlyEVZ+S6pnNOW8jK207Q3/jwkhW+YDgay42NbJhggbSAja
         dokhyk6J7ghn9ZZsvzAUh3A+O2pWgq+lMU2CRTzvcxUblTg/UbTJxz23T7hi8wSYbb
         5oxCa0D4EDp/J+W8dIIq/FS9H9IOGgpqQ+zvGXnjWfUoe1hlgsakwyngQtqgKVLJr/
         CsEjEIplM2ERlnyOAoQ0p+ptWOl9abRKr7hhpA/Uo1yVf/ou7LVOxIYWVUF+9n4HrX
         zk9/rrN3Ag6rg==
Subject: [PATCHSET v2 0/4] xfs: fix cpu hotplug mess
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, chandan.babu@gmail.com
Cc:     sandeen@sandeen.net, Dave Chinner <dchinner@redhat.com>,
        ritesh.list@gmail.com, tglx@linutronix.de, peterz@infradead.org,
        linux-xfs@vger.kernel.org, david@fromorbit.com,
        ritesh.list@gmail.com, sandeen@sandeen.net
Date:   Tue, 29 Aug 2023 16:06:46 -0700
Message-ID: <169335040678.3522698.12786707653439539265.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Ritesh and Eric separately reported crashes in XFS's hook function for
CPU hot remove if the remove event races with a filesystem being
mounted.  I also noticed via generic/650 that once in a while the log
will shut down over an apparent overrun of a transaction reservation;
this turned out to be due to CIL percpu list aggregation failing to pick
up the percpu list items from a dying CPU.

Either way, the solution here is to eliminate the need for a CPU dying
hook by using a private cpumask to track which CPUs have added to their
percpu lists directly, and iterating with that mask.  This fixes the log
problems and (I think) solves a theoretical UAF bug in the inodegc code
too.

v2: fix a few put_cpu uses, add necessary memory barriers, and use
    atomic cpumask operations

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been lightly tested with fstests.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=fix-percpu-lists-6.6
---
 fs/xfs/xfs_icache.c        |   78 ++++++++++++++--------------------------
 fs/xfs/xfs_icache.h        |    1 -
 fs/xfs/xfs_log_cil.c       |   52 ++++++++-------------------
 fs/xfs/xfs_log_priv.h      |   14 +++----
 fs/xfs/xfs_mount.h         |    7 ++--
 fs/xfs/xfs_super.c         |   86 +-------------------------------------------
 include/linux/cpuhotplug.h |    1 -
 7 files changed, 56 insertions(+), 183 deletions(-)

