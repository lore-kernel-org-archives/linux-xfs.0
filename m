Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6110C25B0C
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Aug 2022 16:24:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238023AbiHKQY0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Aug 2022 12:24:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237688AbiHKQXl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 11 Aug 2022 12:23:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 574089DF81
        for <linux-xfs@vger.kernel.org>; Thu, 11 Aug 2022 09:05:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E41C66133D
        for <linux-xfs@vger.kernel.org>; Thu, 11 Aug 2022 16:05:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AA70C433D6
        for <linux-xfs@vger.kernel.org>; Thu, 11 Aug 2022 16:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660233900;
        bh=nxFhaRXIv/brlgHdvVCCMC9NZjeYD+RIyDiK3JJ/iPM=;
        h=Date:From:To:Subject:From;
        b=mAJMkXtHGTYJYhorNbGFIFsA625E9zSxhR0M7t+Z6TS7rTqp82BPghw+UY7JoGrtt
         oz6d93CPVGw+6pR+ND88Bh23ATxBWaxWKN0gliS+hLZd9O9+pmNlmv+po+qZdtpZHk
         IYSFslPyEuVx6kxYxVLQUZWLH97gfqmEzfBCr8WOPka3pdSVOHOcmNUrmBbP/PSZyB
         7xq8cz3XSyn+F26S5/2gk7Du7VXJNGHrUNZ0wanzopCRMr/Rop41qXH+IxWTh45qS/
         TA78/2c2ttqR1yGlODSDG9U/Og/09Fz8uF35gUN8QYasN5uXIrbq+c8lfsqUSJ6I9L
         zfNP2NSZZnuWg==
Date:   Thu, 11 Aug 2022 09:04:59 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 031d166f968e
Message-ID: <YvUoq3UIolkCQLcx@magnolia>
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
the next update.  This is the last of the bugfixes before I hand things
over to Dave on Sunday.

The new head of the for-next branch is commit:

031d166f968e xfs: fix inode reservation space for removing transaction

4 new commits:

Chandan Babu R (1):
      [d62113303d69] xfs: Fix false ENOSPC when performing direct write on a delalloc extent in cow fork

Darrick J. Wong (2):
      [7d839e325af2] xfs: check return codes when flushing block devices
      [f0c2d7d2abca] xfs: fix intermittent hang during quotacheck

hexiaole (1):
      [031d166f968e] xfs: fix inode reservation space for removing transaction

Code Diffstat:

 fs/xfs/libxfs/xfs_trans_resv.c |   2 +-
 fs/xfs/xfs_file.c              |  22 +++--
 fs/xfs/xfs_log.c               |  12 ++-
 fs/xfs/xfs_qm.c                |   5 ++
 fs/xfs/xfs_reflink.c           | 198 +++++++++++++++++++++++++++++++++--------
 5 files changed, 193 insertions(+), 46 deletions(-)
