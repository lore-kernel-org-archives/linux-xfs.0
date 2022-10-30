Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14B8EC38A02
	for <linux-xfs@archiver.kernel.org>; Sun, 30 Oct 2022 23:41:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229562AbiJ3XlY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 30 Oct 2022 19:41:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiJ3XlX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 30 Oct 2022 19:41:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 569189FED
        for <linux-xfs@vger.kernel.org>; Sun, 30 Oct 2022 16:41:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E259160F82
        for <linux-xfs@vger.kernel.org>; Sun, 30 Oct 2022 23:41:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45D93C433D6;
        Sun, 30 Oct 2022 23:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667173282;
        bh=xgkmb1/xOWStaBNiexhNoT4VGRSq30a4vdpn5Za9xWc=;
        h=Subject:From:To:Cc:Date:From;
        b=acuSx7xXMSBNsC7YPAQ43CXyDqwRFOii2RcRnNER4TfMDxLSSkt253spLQU0+W8Of
         +Zm6wOWEBctgetmM1Jy+SQp8MC/CuAAkYAIIi9rkvuQI9puwDKVTUvQgMargIFHh0X
         IyB7uBkZ18/APlgjuu6H5fbobzhDYjf/o7lvtiCoKuxs21ATUjsr2icbcd5yXC5Mic
         8Fg85r94wZheAkhW9HoyYGoBQpx4r/zreK7f6fWS3t89ecCICPUTMh5xX9n+i6Lqza
         GBfQndE6zb/DQh/GHRJ3SP6GGYL3IfLE5rVCA6gQnSsZ24pbm0UINTVUe0XpBbuai2
         1dKRvZqKtTbCg==
Subject: [PATCHSET v3 00/13] xfs: improve runtime refcountbt corruption
 detection
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Sun, 30 Oct 2022 16:41:21 -0700
Message-ID: <166717328145.417886.10627661186183843873.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Fuzz testing of the refcount btree demonstrated a weakness in validation
of refcount btree records during normal runtime.  The idea of using the
upper bit of the rc_startblock field to separate the refcount records
into one group for shared space and another for CoW staging extents was
added at the last minute.  The incore struct left this bit encoded in
the upper bit of the startblock field, which makes it all too easy for
arithmetic operations to overflow if we don't detect the cowflag
properly.

When I ran a norepair fuzz tester, I was able to crash the kernel on one
of these accidental overflows by fuzzing a key record in a node block,
which broke lookups.  To fix the problem, make the domain (shared/cow) a
separate field in the incore record.

Unfortunately, a customer also hit this once in production.  Due to bugs
in the kernel running on the VM host, writes to the disk image would
occasionally be lost.  Given sufficient memory pressure on the VM guest,
a refcountbt xfs_buf could be reclaimed and later reloaded from the
stale copy on the virtual disk.  The stale disk contents were a refcount
btree leaf block full of records for the wrong domain, and this caused
an infinite loop in the guest VM.

v2: actually include the refcount adjust loop invariant checking patch;
    move the deferred refcount continuation checks earlier in the series;
    break up the megapatch into smaller pieces; fix an uninitialized list
    error.
v3: in the continuation check patch, verify the per-ag extent before
    converting it to a fsblock

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=refcount-cow-domain-6.1
---
 fs/xfs/libxfs/xfs_ag.h             |   15 ++
 fs/xfs/libxfs/xfs_alloc.c          |    6 -
 fs/xfs/libxfs/xfs_format.h         |   22 ---
 fs/xfs/libxfs/xfs_refcount.c       |  286 +++++++++++++++++++++++++-----------
 fs/xfs/libxfs/xfs_refcount.h       |   40 +++++
 fs/xfs/libxfs/xfs_refcount_btree.c |   15 ++
 fs/xfs/libxfs/xfs_rmap.c           |    9 -
 fs/xfs/libxfs/xfs_types.h          |   30 ++++
 fs/xfs/scrub/alloc.c               |    4 -
 fs/xfs/scrub/ialloc.c              |    5 -
 fs/xfs/scrub/refcount.c            |   72 ++++-----
 fs/xfs/xfs_trace.h                 |   48 +++++-
 12 files changed, 368 insertions(+), 184 deletions(-)

