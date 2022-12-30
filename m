Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EEB0C4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:06:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235622AbiL3XGa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:06:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235580AbiL3XG3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:06:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EEF72DC7
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 15:06:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB174B81CBC
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 23:06:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BD59C433D2;
        Fri, 30 Dec 2022 23:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672441586;
        bh=YsRC1sF3wJn+De+3Demw5RkbNgO8w6/RW0sN/L8CggY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=esdgAKuxu3z3x7Hs6GRUVP9XSn07ixBm5bxfSVNwIM7qcdqQWk90FJdV95KhfOiDY
         YltI2J2sdgvLJ6pMH0OoaBrzOdFvBqc5vwVsuMRYjhNYC5RLuZv1+1tMKVpN0ZLRF+
         RYAhgOGEmPQBkWYQGbu6Wku5ONaKwnt17mXAkh79ufUyDxRs3Wm1Pd/Amc1MhZNluc
         vlAmV6TjpUMq8lNoKeuouQAZXpnuarwBH6XZ+OYUvbIdHhl3vwptTmj7IH4m7re0cS
         KfZkeJ+khvVbBlP2foaMjW1EihXshRYx4cG91Qtrw9OMh4NJ55rP9iySK1NSW/kAD+
         AigTYxJ5H2Ujw==
Subject: [PATCHSET v24.0 0/4] xfs: create temporary files for online repair
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:14:01 -0800
Message-ID: <167243844115.699982.6114366012860370017.stgit@magnolia>
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

As mentioned earlier, the repair strategy for file-based metadata is to
build a new copy in a temporary file and swap the file fork mappings
with the metadata inode.  We've built the atomic extent swap facility,
so now we need to build a facility for handling private temporary files.

The first step is to teach the filesystem to ignore the temporary files.
We'll mark them as PRIVATE in the VFS so that the kernel security
modules will leave it alone.  The second step is to add the online
repair code the ability to create a temporary file and reap extents from
the temporary file after the extent swap.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-tempfiles
---
 fs/xfs/Makefile         |    1 
 fs/xfs/scrub/common.c   |    6 +
 fs/xfs/scrub/parent.c   |    2 
 fs/xfs/scrub/reap.c     |  427 +++++++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/scrub/reap.h     |   21 ++
 fs/xfs/scrub/scrub.c    |    3 
 fs/xfs/scrub/scrub.h    |    4 
 fs/xfs/scrub/tempfile.c |  231 +++++++++++++++++++++++++
 fs/xfs/scrub/tempfile.h |   27 +++
 fs/xfs/scrub/trace.h    |   96 +++++++++++
 fs/xfs/xfs_export.c     |    2 
 fs/xfs/xfs_inode.c      |    3 
 fs/xfs/xfs_inode.h      |    2 
 fs/xfs/xfs_itable.c     |    8 +
 14 files changed, 806 insertions(+), 27 deletions(-)
 create mode 100644 fs/xfs/scrub/tempfile.c
 create mode 100644 fs/xfs/scrub/tempfile.h

