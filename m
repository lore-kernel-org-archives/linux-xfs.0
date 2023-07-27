Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 543FBEB64DD
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jul 2023 22:18:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbjG0WSg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 27 Jul 2023 18:18:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbjG0WSf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 27 Jul 2023 18:18:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02D59187
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 15:18:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8AC6161F57
        for <linux-xfs@vger.kernel.org>; Thu, 27 Jul 2023 22:18:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7182C433C8;
        Thu, 27 Jul 2023 22:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690496312;
        bh=8UQQjgrsGdr+WktLba0R6cx+oEyC6EIMBGl2tIFe5n4=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=J5BZFWVVZQFBU7RQN94FKuXC4lDlUld+0+9Us4h//Qct3r5Y264geqYEgYD1aKJdt
         tOtQ1RkfQnZfq+IE7LONPigvZgjK96EhccSEJf/H0+u5At8EAYGLy9Ge+q+ze3HdAX
         lQWJ0cJlITUwKKKgYbYmOw43NiMaFIe3ipSnxMH35R8YXLwvk6Sz1rbWiMZaajOckg
         1/4Z+osoZng8H6cgpwVUVf23jHGgl25QxSjKW4KJg7moT+kWdIYXRkbHDYYXzJo8UI
         2yBevJGhLsYSE+yyUTJx8cjXucm6mqZFfK5/x+KXai6wTMIYL37Cgep3Zb0lNDxBX1
         C+nOtqf1ZK8lw==
Date:   Thu, 27 Jul 2023 15:18:32 -0700
Subject: [PATCHSET v26.0 0/9] xfs: fix online repair block reaping
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Message-ID: <169049622719.921010.16542808514375882520.stgit@frogsfrogsfrogs>
In-Reply-To: <20230727221158.GE11352@frogsfrogsfrogs>
References: <20230727221158.GE11352@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

These patches fix a few problems that I noticed in the code that deals
with old btree blocks after a successful repair.

First, I observed that it is possible for repair to incorrectly
invalidate and delete old btree blocks if they were crosslinked.  The
solution here is to consult the reverse mappings for each block in the
extent -- singly owned blocks are invalidated and freed, whereas for
crosslinked blocks, we merely drop the incorrect reverse mapping.

A largeish change in this patchset is moving the reaping code to a
separate file, because the code are mostly interrelated static
functions.  For now this also drops the ability to reap file blocks,
which will return when we add the bmbt repair functions.

Second, we convert the reap function to use EFIs so that we can commit
to freeing as many blocks in as few transactions as we dare.  We would
like to free as many old blocks as we can in the same transaction that
commits the new structure to the ondisk filesystem to minimize the
number of blocks that leak if the system crashes before the repair fully
completes.

The third change made in this series is to avoid tripping buffer cache
assertions if we're merely scanning the buffer cache for buffers to
invalidate, and find a non-stale buffer of the wrong length.  This is
primarily cosmetic, but makes my life easier.

The fourth change restructures the reaping code to try to process as many
blocks in one go as possible, to reduce logging traffic.

The last change switches the reaping mechanism to use per-AG bitmaps
defined in a previous patchset.  This should reduce type confusion when
reading the source code.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-reap-fixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-reap-fixes
---
 fs/xfs/Makefile                |    1 
 fs/xfs/scrub/agheader_repair.c |   75 +++---
 fs/xfs/scrub/bitmap.c          |   78 ------
 fs/xfs/scrub/bitmap.h          |   10 -
 fs/xfs/scrub/reap.c            |  499 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/reap.h            |   12 +
 fs/xfs/scrub/repair.c          |  366 ++++-------------------------
 fs/xfs/scrub/repair.h          |   10 -
 fs/xfs/scrub/trace.h           |   72 +++---
 fs/xfs/xfs_buf.c               |    9 +
 fs/xfs/xfs_buf.h               |   13 +
 11 files changed, 666 insertions(+), 479 deletions(-)
 create mode 100644 fs/xfs/scrub/reap.c
 create mode 100644 fs/xfs/scrub/reap.h

