Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED1DEC19F2A
	for <linux-xfs@archiver.kernel.org>; Sun,  7 Aug 2022 18:36:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233475AbiHGSgK (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 7 Aug 2022 14:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232582AbiHGSgJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 7 Aug 2022 14:36:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 402085F87
        for <linux-xfs@vger.kernel.org>; Sun,  7 Aug 2022 11:36:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C81F161052
        for <linux-xfs@vger.kernel.org>; Sun,  7 Aug 2022 18:36:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01EB3C433D6
        for <linux-xfs@vger.kernel.org>; Sun,  7 Aug 2022 18:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659897368;
        bh=R4qUArLI1edReQEtPoxWp8r/6NCUD4imETH6TBS8P9o=;
        h=Date:From:To:Subject:From;
        b=UsyyHDJzmLAWxO/CToxEtD2Jt68cWRR7a2YEwahWSASmFAjWqfITKBzizvHF8Nshv
         q3/XRm+rJD2310fB/17dD41pfceMu7RA3C/cgNZJCu4j03kDL5u9a9OwDTz3x8R3m6
         yN2ESjj6aN//OWKiZrIc13Iemsl2ufbIs1OPdpPGINegGiUj8o+XkQdP9FZ/3wwLnW
         pP1wNvH2MviOVGbSX+Av7e7ugy3A6EXyPYZsn4FMuqNekeJpvOyr5O7bDWla2/yx3N
         MH8DR0ZkW86Z+XwNWriijasJX6SuoS2FH1Yg3pXYkpe2jov1r0W1BX0MCZkANi0hlL
         2AJOxJnM5duXA==
Date:   Sun, 7 Aug 2022 11:36:07 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to d62113303d69
Message-ID: <YvAGFwNVtmXBC4Ma@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi folks,

The for-next branch of the xfs-linux repository at:

	git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git

has just been updated.

Patches often get missed, so please check if your outstanding patches
were in this update. If they have not been in this update, please
resubmit them to linux-xfs@vger.kernel.org so they can be picked up in
the next update.  These are the accumulated bugfixes before I hand
things off to Dave.

The new head of the for-next branch is commit:

d62113303d69 xfs: Fix false ENOSPC when performing direct write on a delalloc extent in cow fork

3 new commits:

Chandan Babu R (1):
      [d62113303d69] xfs: Fix false ENOSPC when performing direct write on a delalloc extent in cow fork

Darrick J. Wong (2):
      [7d839e325af2] xfs: check return codes when flushing block devices
      [f0c2d7d2abca] xfs: fix intermittent hang during quotacheck

Code Diffstat:

 fs/xfs/xfs_file.c    |  22 +++---
 fs/xfs/xfs_log.c     |  12 +++-
 fs/xfs/xfs_qm.c      |   5 ++
 fs/xfs/xfs_reflink.c | 198 ++++++++++++++++++++++++++++++++++++++++++---------
 4 files changed, 192 insertions(+), 45 deletions(-)
