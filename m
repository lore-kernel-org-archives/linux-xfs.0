Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AEE0C433FE
	for <linux-xfs@archiver.kernel.org>; Sun,  2 Oct 2022 18:24:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbiJBSY4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 2 Oct 2022 14:24:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229935AbiJBSYy (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Oct 2022 14:24:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E69739591
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 11:24:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8182060EFD
        for <linux-xfs@vger.kernel.org>; Sun,  2 Oct 2022 18:24:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9569C433D6;
        Sun,  2 Oct 2022 18:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664735091;
        bh=g9D8xzqj8CCK43nlC7PcLLdB1DIw6f4nX/bJv47ykqA=;
        h=Subject:From:To:Cc:Date:From;
        b=XYjYfyCrrCl1Le4qVjy2uLC+qSQbH0XDb6UK7doibycgiR72TyOrksHu5ExdUT0UJ
         OSxd7I8hLgP5WaHZL2VHu15fBfVEtiGuELR6psqxU5HE1ELoZgOdrz70EmmNLCovRz
         eaaVQraGmOzd4XSArfENfvt9g3AOnmDIPIOXQI6WlwkPjPdInzdU3jK03nl3mAIfAi
         ja3AfhjOgokXxlzgmkRJIWRPmGLYWXXknmFFjJvo19FLq2PjfrU3noIYoOwbWNqnQU
         7B7fH6uTp2ZlmswaRzrdvcMHOXnUMcT8IfmfBYe4DzIgg+2poFUgJ0zCbPdlMs4o9B
         VBIHobU13RAkw==
Subject: [PATCHSET v23.1 0/9] xfs: clean up memory management in xattr scrub
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Sun, 02 Oct 2022 11:20:40 -0700
Message-ID: <166473483982.1085108.101544412199880535.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Currently, the extended attribute scrubber uses a single VLA to store
all the context information needed in various parts of the scrubber
code.  This includes xattr leaf block space usage bitmaps, and the value
buffer used to check the correctness of remote xattr value block
headers.  We try to minimize the insanity through the use of helper
functions, but this is a memory management nightmare.  Clean this up by
making the bitmap and value pointers explicit members of struct
xchk_xattr_buf.

Second, strengthen the xattr checking by teaching it to look for overlapping
data structures in the shortform attr data.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=scrub-fix-xattr-memory-mgmt
---
 fs/xfs/scrub/attr.c  |  284 +++++++++++++++++++++++++++++++++++---------------
 fs/xfs/scrub/attr.h  |   60 +----------
 fs/xfs/scrub/scrub.c |    3 +
 fs/xfs/scrub/scrub.h |   10 ++
 4 files changed, 221 insertions(+), 136 deletions(-)

