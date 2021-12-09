Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CBAEC433F5
	for <linux-xfs@archiver.kernel.org>; Thu,  9 Dec 2021 18:10:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234322AbhLISN4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 9 Dec 2021 13:13:56 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:45734 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243210AbhLISNz (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 9 Dec 2021 13:13:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 49EAAB825F5
        for <linux-xfs@vger.kernel.org>; Thu,  9 Dec 2021 18:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF7D7C004DD
        for <linux-xfs@vger.kernel.org>; Thu,  9 Dec 2021 18:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639073420;
        bh=ziwB1UaZ7ZI0W6T5JC8IOnIQ1TUawwSre4zoZAU5QQE=;
        h=Date:From:To:Subject:From;
        b=JH8YptAizWeVHwyE7KtwE/UXhLYW6IGrfqq2BSdfCJ2kH6yxd34YGHK7KKgtJ46zO
         K2FJykg+HxLKBdaAxEhYSrUTtKOkPfdSOlUn9TH/frJik6xKqhMidj6FZlo5B2ND6b
         m7cTxfcZY8UIOZ435ejJpWWd3Hjp+QpbTFvZMRmLcJYJNkYjqwdCgaXm0OFJ/qsULf
         CsTNF4fmA2zXaUfhGfjTM6nJSgx2FRMARuZJCKtJQHhyFwpEfxL60nBULYuKoC/3ph
         27rQ4V+cbDug5tsN8hHp9EKinOkLPBBRGC/K+PP6ubZgAlXxqh9v2Hg5LDTNCB/F6J
         lriJiyZDxWdQA==
Date:   Thu, 9 Dec 2021 10:10:19 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [ANNOUNCE] xfs-linux: for-next updated to 089558bc7ba7
Message-ID: <20211209181019.GB69235@magnolia>
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
the next update.  This is the last bugfix for 5.16 before I move on to
the 5.17 merge.

The new head of the for-next branch is commit:

089558bc7ba7 xfs: remove all COW fork extents when remounting readonly

New Commits:

Darrick J. Wong (1):
      [089558bc7ba7] xfs: remove all COW fork extents when remounting readonly


Code Diffstat:

 fs/xfs/xfs_super.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)
