Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F87FC001E0
	for <linux-xfs@archiver.kernel.org>; Thu, 10 Aug 2023 15:29:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236152AbjHJP3Q (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 10 Aug 2023 11:29:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236039AbjHJP3Q (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 10 Aug 2023 11:29:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B60612690
        for <linux-xfs@vger.kernel.org>; Thu, 10 Aug 2023 08:29:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5438C66028
        for <linux-xfs@vger.kernel.org>; Thu, 10 Aug 2023 15:29:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0A5FC433C8;
        Thu, 10 Aug 2023 15:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691681354;
        bh=Qy5q5++nKvrPc8VfntsoP4sCi5cqNcwu5s7+iPL9iRg=;
        h=Date:From:To:Cc:Subject:From;
        b=OjhkfDehK0ZB9tZkDphbXZ/tEqQGHtpPKyGDfSgVq0aQgHTHjr3bd33T+eLQhSTyJ
         OFq4dr31q6Rwm27aes4EKG+sOXrH4sxAtEsOuGFN2PoLlrjmDe8Q4o/SX1PP06arl2
         RjJB2YNMYScaCKl6Jan6xVyMzEPrwGK+De8F53qSOzpPDQ6E7y+cAIo9O/zqSstFtC
         MTKecRoDDT0K0XAZbxcb6XRLcHwh+ii2ONjwqChcc796Acjdveu6VcPtCL+v7oWwde
         Thuw2HjxBKHSbxrNljt1NLi+YWwvij//LrRq1tjrqlMBTDEuZdLJbbOVzK6dNKFPnu
         cDxpmdj+qBVnA==
Date:   Thu, 10 Aug 2023 08:29:14 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     chandan.babu@oracle.com, djwong@kernel.org
Cc:     dchinner@redhat.com, linux-xfs@vger.kernel.org
Subject: [GIT PULL 6/9] xfs: miscellaneous repair tweaks
Message-ID: <169168057303.1060601.14161972148325883652.stg-ugh@frogsfrogsfrogs>
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

The following changes since commit 526aab5f5790e257cbdff1d1be89353257a3e451:

xfs: implement online scrubbing of rtsummary info (2023-08-10 07:48:09 -0700)

are available in the Git repository at:

https://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/repair-tweaks-6.6_2023-08-10

for you to fetch changes up to d728f4e3b21e74910e370b09bab54629eb66badb:

xfs: allow the user to cancel repairs before we start writing (2023-08-10 07:48:10 -0700)

----------------------------------------------------------------
xfs: miscellaneous repair tweaks [v26.1]

Before we start adding online repair functionality, there's a few tweaks
that I'd like to make to the common repair code.  First is a fix to the
integration between repair and the health status code that was
interfering with repair re-evaluations.  Second is a minor tweak to the
sole existing repair functions to make one last check that the user
hasn't terminated the calling process before we start writing to the
filesystem.  This is a pattern that will repeat throughout the rest of
the repair functions.

This has been running on the djcloud for years with no problems.  Enjoy!

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (2):
xfs: always rescan allegedly healthy per-ag metadata after repair
xfs: allow the user to cancel repairs before we start writing

fs/xfs/scrub/agheader_repair.c | 16 ++++++++++++++++
fs/xfs/scrub/health.c          | 10 ++++++++++
2 files changed, 26 insertions(+)
