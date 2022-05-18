Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 854E4C433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 18 May 2022 18:54:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241671AbiERSyj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 May 2022 14:54:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241646AbiERSyi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 May 2022 14:54:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4FE31CEEE6
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 11:54:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3FFBD61799
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 18:54:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98780C385A5;
        Wed, 18 May 2022 18:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652900076;
        bh=goqr0d9E6M8mJTmSkraI0p4ukfwywgFrR8mfFWsfHpo=;
        h=Subject:From:To:Cc:Date:From;
        b=haefZK8BnBhCuQXZvdvaVEHDab0BBkLDkNAxC1k5l/q+tzrrfhlcWhzclG/AgjZsG
         qq21ebX39kqJczNLpP1ztJ5uI9/1FBTTj++QLVL1tX8J/RBuk9qd7XBdVE2xb3NLNU
         NIxs/V3RQPbL1/j+xfBON1bbrwy9Q62eHcl6HASE+RpreUy5bEHrQkcKDRGE3Uewjg
         M7KpinqIsyGyQnHnxTpNU2m2xgLfkSCSljikDLxb2aubMIIfWFcIeecCCbd1iT/3V/
         MuXNUx9pYFPSzCGliQto96xe3pbMmbFTV/QKDFC+KXe2Rlk0tdtBgzuIxX/rLGZDqL
         tqsmCowS1xZWw==
Subject: [PATCHSET v2 0/4] xfs: fix leaks and validation errors in logged
 xattr updates
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, david@fromorbit.com,
        allison.henderson@oracle.com
Date:   Wed, 18 May 2022 11:54:35 -0700
Message-ID: <165290007585.1646028.11376304341026166988.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This short series fixes a couple of places where the deferred xattr
state machine could leak the xfs_da_state structure.  Make log recovery
more robust by checking the op state and attr filter flags of the
recovered log items.

v2: Don't create a new flags namespace for the attr_filter values, since we
    already have one, and add RVB tags.  Fix a crash that Dave found in the
    first patch when node_removename decides to free the da state, but we
    never set the state variable.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=attr-intent-fixes-5.19
---
 fs/xfs/libxfs/xfs_attr.c       |   32 ++++++++++++++++++++++----------
 fs/xfs/libxfs/xfs_log_format.h |   10 +++++++++-
 fs/xfs/xfs_attr_item.c         |   34 ++++++++++++++++++++++++++--------
 3 files changed, 57 insertions(+), 19 deletions(-)

