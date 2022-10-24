Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 940D7C67871
	for <linux-xfs@archiver.kernel.org>; Mon, 24 Oct 2022 23:13:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbiJXXNh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 24 Oct 2022 19:13:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230478AbiJXXNT (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Oct 2022 19:13:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13892198999
        for <linux-xfs@vger.kernel.org>; Mon, 24 Oct 2022 14:34:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CAFB7B8120F
        for <linux-xfs@vger.kernel.org>; Mon, 24 Oct 2022 21:33:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81296C433D6;
        Mon, 24 Oct 2022 21:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666647189;
        bh=RdeCxynwDRmPAFilUlrlw2Vgs6ijFAW8HyLpZf8qtdI=;
        h=Subject:From:To:Cc:Date:From;
        b=Vi6frMqBBtmX9nm9Fs1tMcqTPKhnYdzuqBvSOfPgCDgvf5K1gGKQqbeiymT6EuNvl
         x+c5wyJ+LBUUElykZaku6yAwBYoC6km8YbbIv5GQBEKybGnnbOr3Ssx56aFEOTDmr1
         RuaYCKTaIT+mebAxCq6MmdjgAsQpFAgCIoNDmFtUs84swXRijeyh18C9QOJCYHoHQN
         85SiUZjQa/GmfU2hNU5Q9JXA02A0FP1RuljgnEmPmI5rd+72dCIgwnbPTcTcUhAFCf
         JoTyQxiwRazk4O7j/yXNwnxTIZU+oCDw9b8FcjxywJ20WlMwlZkqkc6EgwCn6bvO4i
         26V34D8OR171w==
Subject: [PATCHSET 0/5] xfs: improve runtime refcountbt corruption detection
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 24 Oct 2022 14:33:09 -0700
Message-ID: <166664718897.2690245.5721183007309479393.stgit@magnolia>
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

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=refcount-cow-domain-6.1
---
 fs/xfs/libxfs/xfs_format.h         |   22 ---
 fs/xfs/libxfs/xfs_refcount.c       |  269 ++++++++++++++++++++++++++----------
 fs/xfs/libxfs/xfs_refcount.h       |    9 +
 fs/xfs/libxfs/xfs_refcount_btree.c |   26 +++
 fs/xfs/libxfs/xfs_types.h          |   30 ++++
 fs/xfs/scrub/refcount.c            |   72 ++++------
 fs/xfs/xfs_trace.h                 |   48 +++++-
 7 files changed, 324 insertions(+), 152 deletions(-)

