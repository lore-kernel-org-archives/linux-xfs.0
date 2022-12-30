Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3391C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:25:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235581AbiL3WZn (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:25:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235435AbiL3WZl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:25:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 281A31D0CF
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:25:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8BE061C17
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:25:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E6B0C433D2;
        Fri, 30 Dec 2022 22:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672439140;
        bh=f6xUFqe0tuL0gkFsXMaYpLY5bIZijg1sUNlCENNdntc=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=WuNSLTTVYOyTLigxfzvtzDm8ORrWHSL/N0AkDFtHGkZ+pMq2XDCadnjrSF7y8cAHN
         +t1c3rOsrfRAvQ2044y7rDKto+NQRO66Nmr8P4Dp1+u489fQrtZRo/klH5HZiQyFHu
         b27a/d7oQWvmFOwibXbbp2YDwJiVkxXiSTim4CP9XDRtEmWUk/eMx0H8kUVHeDNkGE
         i1v5VRzTxntgHjwimEdnwlfy84aw4pmrb1H30RnfFIIS4j3rcwPUyLgTJYX7dsb98Y
         hHLmqm4TB+rqCPwssqry8wFin0YKneims33pBf0Ki/TV/ggFWnJVkXjVI7+EL6AdVK
         bE9V5bqg01xGg==
Subject: [PATCHSET v24.0 0/2] xfs: fix rmap btree key flag handling
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:11:18 -0800
Message-ID: <167243827872.684208.12327644447561431612.stgit@magnolia>
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
 fs/xfs/libxfs/xfs_rmap_btree.c |   40 +++++++++++++++++++++++-------
 fs/xfs/scrub/btree.c           |   10 ++++++++
 fs/xfs/scrub/btree.h           |    2 ++
 fs/xfs/scrub/rmap.c            |   53 ++++++++++++++++++++++++++++++++++++++++
 4 files changed, 95 insertions(+), 10 deletions(-)

