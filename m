Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42584C001E0
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Aug 2023 15:29:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236154AbjHJP30 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Aug 2023 11:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236039AbjHJP3Z (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Aug 2023 11:29:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AF5210C7
        for <linux-xfs@vger.kernel.org>; Thu, 10 Aug 2023 08:29:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B4856601E
        for <linux-xfs@vger.kernel.org>; Thu, 10 Aug 2023 15:29:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88C3AC433C7;
        Thu, 10 Aug 2023 15:29:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691681364;
        bh=u5vb7TQEw5xop/NdPD1KnoqcqGAAdUvMjltSSRQwDlw=;
        h=Date:From:To:Cc:Subject:From;
        b=cojzWVPDOdZns8nUZpkwWAjAy+ApDcHHp2zJah/1bDdXxcorjBe+269odVUc1mv6P
         VuMnKhWUYOaGBFZYwqU4/P1SWAAIGgoePHyEdZPkRH0imsgQm44NHckQYGNnU1RDxR
         eciu6UTP5TzfxJAV0bxosMpJx2nt8xnxzcIxC7H6XuRC+himk+b607mVADGYzBx6dt
         Rc5cot8FaPhnabjCF7JbWZluxH7zOQU7QExerRjLMGgGOIpPYZO4ZGWP32Bu2VUjdZ
         YK7vkYT+zgf/y6R9KV1TVqYzTXiN9Hy7JnGrHTTgmkxoXnUZUJQjkPYwtdchfAfJP6
         UXEbqO/5SFSNA==
Date:   Thu, 10 Aug 2023 08:29:24 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     chandan.babu@oracle.com, djwong@kernel.org
Cc:     dchinner@redhat.com, linux-xfs@vger.kernel.org
Subject: [GIT PULL 8/9] xfs: fixes to the AGFL repair code
Message-ID: <169168058113.1060601.12287707141857169672.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit 5c83df2e54b6af870e3e02ccd2a8ecd54e36668c:

xfs: allow userspace to rebuild metadata structures (2023-08-10 07:48:11 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/repair-agfl-fixes-6.6_2023-08-10

for you to fetch changes up to a634c0a60b9c7942630b4f68b0af55c62d74b8fc:

xfs: fix agf_fllast when repairing an empty AGFL (2023-08-10 07:48:11 -0700)

----------------------------------------------------------------
xfs: fixes to the AGFL repair code [v26.1]

This series contains a couple of bug fixes to the AGFL repair code that
came up during QA.

This has been running on the djcloud for years with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (2):
xfs: clear pagf_agflreset when repairing the AGFL
xfs: fix agf_fllast when repairing an empty AGFL

fs/xfs/scrub/agheader_repair.c | 10 ++++++++--
1 file changed, 8 insertions(+), 2 deletions(-)
