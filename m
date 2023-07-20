Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FD1EEB64DA
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jul 2023 16:46:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231136AbjGTQqd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 20 Jul 2023 12:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230233AbjGTQqd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Jul 2023 12:46:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E05A1B9
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jul 2023 09:46:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0B2D61B7A
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jul 2023 16:46:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 444C0C433C7;
        Thu, 20 Jul 2023 16:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689871591;
        bh=EwHzB7v27gP/xCFyxSxtYVRxpBA5KBHPWL0VmIoGw6o=;
        h=Date:From:To:Cc:Subject:From;
        b=WLNCOMECed/M7YF/hSTSxKj+JSDB0NJZfqjgv0G91uljRq1vo5PLOKgw1BvZL2s3j
         RBV+Gk8meH8wPTYEmvn46k8tIydHmNNT314XTYt+dX0bu9MGO8Z7f6Dv/HNG/JVTXj
         bCnWR4MeLY0YFa02iMkSWWYHC+6K4pFmCqxcJO/rZYGO5LrP/FOGCmq3pBYTmDaI/k
         0yAGqBhV4wwMi1PUjpajZJ8LsqExkJaAkixGVUINq/ZgeqNDOmyuAbciQwGB99+7Rv
         b0RbmM6CGvcQF5j5wReUonPwrYkhrKuVSNmwVOxCpbuIFjZQvhRVGkjDY8kcNAk9VZ
         dfiOJUfQ7vpSQ==
Date:   Thu, 20 Jul 2023 09:46:30 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, torvalds@linux-foundation.org
Cc:     david@fromorbit.com, hch@lst.de, keescook@chromium.org,
        linux-xfs@vger.kernel.org
Subject: [GIT PULL] xfs: ubsan fixes for 6.5-rc2
Message-ID: <168987105684.3204878.5341349915656531912.stg-ugh@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Linus,

Please pull this branch with flexarray declaration conversions.  This
probably should've been done with the merge window open, but I was not
aware that the UBSAN knob would be getting turned up for 6.5, and the
fstests failures due to the kernel warnings are getting in the way of
testing.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit fdf0eaf11452d72945af31804e2a1048ee1b574c:

Linux 6.5-rc2 (2023-07-16 15:10:37 -0700)

are available in the Git repository at:

git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git tags/xfs-6.5-fixes-1

for you to fetch changes up to f6250e205691a58c81be041b1809a2e706852641:

xfs: convert flex-array declarations in xfs attr shortform objects (2023-07-17 08:48:56 -0700)

----------------------------------------------------------------
Bug fixes for 6.5-rc2:

* Convert all the array[1] declarations into the accepted flex array[]
declarations so that UBSAN and friends will not get confused.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (3):
xfs: convert flex-array declarations in struct xfs_attrlist*
xfs: convert flex-array declarations in xfs attr leaf blocks
xfs: convert flex-array declarations in xfs attr shortform objects

fs/xfs/libxfs/xfs_da_format.h | 75 +++++++++++++++++++++++++++++++++++++------
fs/xfs/libxfs/xfs_fs.h        |  4 +--
fs/xfs/xfs_ondisk.h           |  5 +--
3 files changed, 71 insertions(+), 13 deletions(-)
