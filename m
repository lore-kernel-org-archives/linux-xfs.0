Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6888CC433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 17 Nov 2022 03:13:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233752AbiKQDNb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 16 Nov 2022 22:13:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234004AbiKQDNa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 16 Nov 2022 22:13:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33274BE31
        for <linux-xfs@vger.kernel.org>; Wed, 16 Nov 2022 19:13:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 990EFB81E82
        for <linux-xfs@vger.kernel.org>; Thu, 17 Nov 2022 03:13:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51B4CC433C1;
        Thu, 17 Nov 2022 03:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668654805;
        bh=4uLlKWe30bclA7z5L84/imAYnhEysMggcJxDbrmmCtw=;
        h=Date:From:To:Cc:Subject:From;
        b=Xu2n+WuDqP+j+p6aDGsWZ3ymnXSMuFZhnxiyFwTvxTU5fl2/xf8QOpsajRU/XQTN2
         jVZFyJtsm2DzHR2t6N7BSlvAm5+PV07gei7Z9XbKCZ2uNAsl+zxGtMgS5sS9VmpFzC
         xTrmF6txqQLLWlHkLkd4URP4jjtvKkQ3vpM+okSioxaD6/wf6kqMArkDVTrl9j5MZ0
         2rBLI5oS8fsCoUEKpojfmzDA16PXg+jBn5Qk8SPZr8vxEz3KKEf9f/h82x71LQftu4
         C7ETzrTudZXMHJc0fVLP6N9qPYQnNJWPwHrxEHcHqSsVKdM+VjGu+or4fF2+lsvEfA
         17O3jVo7IJEpQ==
Date:   Wed, 16 Nov 2022 19:13:24 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     dchinner@redhat.com, linux-xfs@vger.kernel.org
Subject: [GIT PULL 3/7] xfs: fix incorrect return values in online fsck
Message-ID: <166865411276.2381691.13135023380195566717.stg-ugh@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi Darrick,

Please pull this branch with changes for xfs for 6.2-rc1.

As usual, I did a test-merge with the main upstream branch as of a few
minutes ago, and didn't see any conflicts.  Please let me know if you
encounter any problems.

--D

The following changes since commit 306195f355bbdcc3eff6cffac05bcd93a5e419ed:

xfs: pivot online scrub away from kmem.[ch] (2022-11-16 15:25:02 -0800)

are available in the Git repository at:

git://git.kernel.org/pub/scm/linux/kernel/git/djwong/xfs-linux.git tags/scrub-fix-return-value-6.2_2022-11-16

for you to fetch changes up to 93b0c58ed04b6cbe45354f23bb5628fff31f9084:

xfs: don't return -EFSCORRUPTED from repair when resources cannot be grabbed (2022-11-16 15:25:03 -0800)

----------------------------------------------------------------
xfs: fix incorrect return values in online fsck

Here we fix a couple of problems with the errno values that we return to
userspace.

v23.2: fix vague wording of comment
v23.3: fix the commit message to discuss what's really going on in this
patch

Signed-off-by: Darrick J. Wong <djwong@kernel.org>

----------------------------------------------------------------
Darrick J. Wong (4):
xfs: return EINTR when a fatal signal terminates scrub
xfs: fix return code when fatal signal encountered during dquot scrub
xfs: don't retry repairs harder when EAGAIN is returned
xfs: don't return -EFSCORRUPTED from repair when resources cannot be grabbed

fs/xfs/scrub/common.h |  2 +-
fs/xfs/scrub/quota.c  |  2 +-
fs/xfs/scrub/repair.c | 10 +++++++---
3 files changed, 9 insertions(+), 5 deletions(-)
