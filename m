Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A20FDC433E1
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Mar 2021 04:20:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D8DB61990
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Mar 2021 04:20:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229472AbhCWET4 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 23 Mar 2021 00:19:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:45840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229451AbhCWETn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 23 Mar 2021 00:19:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D221061990;
        Tue, 23 Mar 2021 04:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616473182;
        bh=yJNZ557IvZqa5pftWAR0VtUTYFViE7l3Ff9pSkGIwjM=;
        h=Subject:From:To:Cc:Date:From;
        b=DADSg80tR2twH5r5ACpDlEMMTMTPqltPvOiWujp8MfVxWziysRI1OZFXzO07cP67+
         gz80h2FXc7nfw20Ht65zK+CvQ3np8rhS/0Hn2VZ5pCiXGIR/fxzjluqh0CnQNV5dFN
         e/fHv484tVSzI2cQ1wwBa9fH8yQ845+iCxcO5HY07pO+ICKpt2eTc7CUlntXcKylji
         zhd8FQ83xs0I6/+8Afy/HRtBKmdHXHS6iVuD5utBz0/gp/XyXT5xFm0LfIgJgNT3u1
         WShk2kxAhYsTYUzLI0HA7WKzjYifOOfpTZHciQSTdDiutCrdpM1SYRl68XdHzdTL5j
         XYg3rFhGfepnA==
Subject: [PATCHSET 0/3] populate: fix a few bugs with fs pre-population
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 22 Mar 2021 21:19:42 -0700
Message-ID: <161647318241.3429609.1862044070327396092.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

While I was auditing the efficacy of the xfs repair tools I noticed a
few deficiencies in the code that populates filesystems, so I fixed
them.  Most notable are the fact that we didn't create fifos, messed up
blockdev creation, and while the cache tags should record the size of
external devices, the actual device names aren't exciting.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=random-fixes

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-fixes
---
 common/populate |   22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

