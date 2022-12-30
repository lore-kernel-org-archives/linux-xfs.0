Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61FD1C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:28:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbiL3W2g (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:28:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229749AbiL3W2f (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:28:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED4F31C90C
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:28:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3493B81C22
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:28:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66407C433EF;
        Fri, 30 Dec 2022 22:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672439311;
        bh=Fy7iA68Ob+tUtetsRFV5S6c4VHl3ieihN1v6T5U62lE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=KVFr66Ut8CZAj0tB67a6nYEkyLULdeHMDTX8xrKTH8G3gTJMLAi3WEIss5xRE+C+a
         se8z4HgEAzAB3bDWcHxRnaaKuxJ96ywqpKvCnLJDRUV+EQed4WM3shqmC7YJJcAvVl
         2lnP8YuoREtnCX36c+2RYm0BenIK9wVeD6rpU5+EsFLN5C+1Npx6+y75vlLSxWdljO
         3nTvB0rUyfmlvBaZo/F9D6Md2apiUC6L2a9BD1CWxYikGtgWOrkBpziFge+dhM4iUv
         Ft+OpUWGArCXzV3y78iQgXrUbKAU1Ev/7GUnUNk96KMwQmD0q34DsNm4S3szqmsHsL
         DcnSgS2KkOhkA==
Subject: [PATCHSET v24.0 0/4] xfs: fix rmap btree key flag handling
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:12:27 -0800
Message-ID: <167243834739.692079.8979395707061192623.stgit@magnolia>
In-Reply-To: <Y69UceeA2MEpjMJ8@magnolia>
References: <Y69UceeA2MEpjMJ8@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This series fixes numerous flag handling bugs in the rmapbt key code.
The most serious transgression is that key comparisons completely strip
out all flag bits from rm_offset, including the ones that participate in
record lookups.  The second problem is that for years we've been letting
the unwritten flag (which is an attribute of a specific record and not
part of the record key) escape from leaf records into key records.

The solution to the second problem is to filter attribute flags when
creating keys from records, and the solution to the first problem is to
preserve *only* the flags used for key lookups.  The ATTR and BMBT flags
are a part of the lookup key, and the UNWRITTEN flag is a record
attribute.

This has worked for years without generating user complaints because
ATTR and BMBT extents cannot be shared, so key comparisons succeed
solely on rm_startblock.  Only file data fork extents can be shared, and
those records never set any of the three flag bits, so comparisons that
dig into rm_owner and rm_offset work just fine.

A filesystem written with an unpatched kernel and mounted on a patched
kernel will work correctly because the ATTR/BMBT flags have been
conveyed into keys correctly all along, and we still ignore the
UNWRITTEN flag in any key record.  This was what doomed my previous
attempt to correct this problem in 2019.

A filesystem written with a patched kernel and mounted on an unpatched
kernel will also work correctly because unpatched kernels ignore all
flags.

With this patchset applied, the scrub code gains the ability to detect
rmap btrees with incorrectly set attr and bmbt flags in the key records.
After three years of testing, I haven't encountered any problems.
Online scrub is amended to recommend rebuilding of rmap btrees with the
unwritten flag set in key records.

The xfsprogs counterpart to this series amends xfs_repair to report key
records with the unwritten flag bit set, just prior to rebuilding the
rmapbt.  It also exposes the bit via xfs_db to enable testing back and
forth.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=rmap-btree-fix-key-handling

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=rmap-btree-fix-key-handling
---
 db/btblock.c            |    4 +++
 libxfs/xfs_rmap_btree.c |   40 ++++++++++++++++++++++++-------
 repair/scan.c           |   60 ++++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 93 insertions(+), 11 deletions(-)

