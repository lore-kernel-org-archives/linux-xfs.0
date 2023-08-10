Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE7FBC001E0
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Aug 2023 15:29:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234855AbjHJP3V (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Aug 2023 11:29:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236039AbjHJP3U (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Aug 2023 11:29:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DBBC212B
        for <linux-xfs@vger.kernel.org>; Thu, 10 Aug 2023 08:29:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C5C06508B
        for <linux-xfs@vger.kernel.org>; Thu, 10 Aug 2023 15:29:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BA1BC433C8;
        Thu, 10 Aug 2023 15:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691681359;
        bh=0aN40EJM1qo4lMwRBtfC6euvR7QOnDKDjpAKCJDKrAw=;
        h=Date:From:To:Cc:Subject:From;
        b=rf2isW3U5q/A7P1nlCUCvm8AIOyLLhQH6TxvpIGjGMn+P+V0JMsY0wvNdFWgcjhRz
         UUHY9KaDU7KPujGgvfoCx7Uoc1XpzDha8eEzxTp+KbcRKGu1Rd6hsX8VjK882BcTqw
         Epia0apcCGCwHEg1oF7efVAXTxRil24Xu9cZFS0YK2MDmxMbyHqaczQMLZ7HLU9Rgv
         k6+0RL4uweR2F5jq/v3QHorDFWrLi5A74E31gK+8oaR85bxzgICb2QQvSNRMF1QVzf
         hqasTanREWjCCvRk2qS3uNts/tvHliJZNvcK7kblWTMQTy6GAe7KqoXMdSYS/5PdUN
         F11xWtmSG+f5Q==
Date:   Thu, 10 Aug 2023 08:29:19 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     chandan.babu@oracle.com, djwong@kernel.org
Cc:     dchinner@redhat.com, linux-xfs@vger.kernel.org
Subject: [GIT PULL 7/9] xfs: force rebuilding of metadata
Message-ID: <169168057713.1060601.17208135472391286208.stg-ugh@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Chandan,

Please pull this branch with changes for xfs for 6.6-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit d728f4e3b21e74910e370b09bab54629eb66badb:

xfs: allow the user to cancel repairs before we start writing (2023-08-10 07:48:10 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/repair-force-rebuild-6.6_2023-08-10

for you to fetch changes up to 5c83df2e54b6af870e3e02ccd2a8ecd54e36668c:

xfs: allow userspace to rebuild metadata structures (2023-08-10 07:48:11 -0700)

----------------------------------------------------------------
xfs: force rebuilding of metadata [v26.1]

This patchset adds a new IFLAG to the scrub ioctl so that userspace can
force a rebuild of an otherwise consistent piece of metadata.  This will
eventually enable the use of online repair to relocate metadata during a
filesystem reorganization (e.g. shrink).  For now, it facilitates stress
testing of online repair without needing the debugging knobs to be
enabled.

This has been running on the djcloud for years with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (2):
xfs: don't complain about unfixed metadata when repairs were injected
xfs: allow userspace to rebuild metadata structures

fs/xfs/libxfs/xfs_fs.h |  6 +++++-
fs/xfs/scrub/common.h  | 12 ++++++++++++
fs/xfs/scrub/scrub.c   | 18 ++++++++++++------
fs/xfs/scrub/trace.h   |  3 ++-
4 files changed, 31 insertions(+), 8 deletions(-)
