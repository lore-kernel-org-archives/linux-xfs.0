Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEB3AC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:00:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235691AbiL3XAA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:00:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235687AbiL3W77 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:59:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09F6C1CFC6
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 14:59:58 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A632CB81D68
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 22:59:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4ACCCC433EF;
        Fri, 30 Dec 2022 22:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672441195;
        bh=/myLHQ36tQtpOVGWc7sSkaJoGFcjHePUown7lzT7O/U=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=fAcfiJmSC/mTA0qJIchgIJvZqB5C79zuo/u0fElF4WIBTDkO8PPooaFmIpAw2xO/g
         GPHkk7k5Q9FBaEqeCPHBSfh4o3IMG23YO+4njWeoVVqWZ2EfJISLCR2XpDYh7RIbEY
         OsfgGIrbt13h9xM3skZNIAv2Vj2lQy9fwNQzA5zvD7SXYknln+XN0MlYnrM0M0ImtE
         Ou+JVHuv47l43Yx0H/1UFlfB9nfQ02hv7jg6X73uciVR8ysXRlYrHAjuJjmc+zom+I
         vXtHvC3jK9I6jyFQnaDUy2C/oZXeiapsNZI/O+D/XThOV9Ud/yQScLw4INT66gJeHF
         ZgdbsMlWIL7IQ==
Subject: [PATCHSET v24.0 0/9] xfs: fix online repair block reaping
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:12:26 -0800
Message-ID: <167243834673.691918.7562784486565988430.stgit@magnolia>
In-Reply-To: <Y69Unb7KRM5awJoV@magnolia>
References: <Y69Unb7KRM5awJoV@magnolia>
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
 fs/xfs/scrub/reap.c            |  489 ++++++++++++++++++++++++++++++++++++++++
 fs/xfs/scrub/reap.h            |   12 +
 fs/xfs/scrub/repair.c          |  367 ++++--------------------------
 fs/xfs/scrub/repair.h          |   10 -
 fs/xfs/scrub/trace.h           |   72 +++---
 fs/xfs/xfs_buf.c               |    5 
 fs/xfs/xfs_buf.h               |   10 +
 11 files changed, 649 insertions(+), 480 deletions(-)
 create mode 100644 fs/xfs/scrub/reap.c
 create mode 100644 fs/xfs/scrub/reap.h

