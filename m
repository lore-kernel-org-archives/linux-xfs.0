Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C730C433FE
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Oct 2022 19:06:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234760AbiJZTGT (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Oct 2022 15:06:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234787AbiJZTF7 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Oct 2022 15:05:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6176105CC8;
        Wed, 26 Oct 2022 12:03:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A10E62033;
        Wed, 26 Oct 2022 19:03:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAD5EC433D6;
        Wed, 26 Oct 2022 19:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666810994;
        bh=JZaUz0hZJF56FPq9r0HxN++MlxzVyVThyssPRzp5ybE=;
        h=Subject:From:To:Cc:Date:From;
        b=XbXp8zqbnMTMWO4FD5wf0gzWM6lR/8WVhdzS7abQCwKFJ2c+11SLKW4yY0AQCmvst
         /WWzcDvTo0MsZvTkRqm9o1komlhtICQdKahlpxLRNLu0milW1/u41zOdxws2Fg+Ser
         NqK50d3rNGIq6iot6/q2LPUjhqjFVI9sHAfgiXBMidst6dalevW4llOxASS+b7pzDk
         HLLKM2hNfQEbgPk5IkJawri0wMhNDneRQcoUIfgSOFOnwJOINF0GUaq30K4EoOmSBQ
         lfHfYnefbRjCKuJlcv6MamfMdZjPPaoe0w/e/4nOZfAGPx4VVZpc74Alt1Vv9fANNV
         FpNB+fFCoAnYQ==
Subject: [PATCHSET v23.2 0/4] fstests: refactor xfs geometry computation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Wed, 26 Oct 2022 12:03:14 -0700
Message-ID: <166681099421.3403789.78493769502226810.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

There are numerous tests that do things based on the geometry of a
mounted filesystem.  Before we start adding more tests that do this
(e.g. online fsck stress tests), refactor them into common/xfs helpers.

v23.2: refactor more number extraction grep/sed patterns

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=refactor-xfs-geometry
---
 common/ext4     |    9 +++++
 common/populate |   24 ++++++-------
 common/rc       |    2 +
 common/xfs      |  104 ++++++++++++++++++++++++++++++++++++++++++++++++-------
 tests/xfs/097   |    2 +
 tests/xfs/099   |    2 +
 tests/xfs/100   |    2 +
 tests/xfs/101   |    2 +
 tests/xfs/102   |    2 +
 tests/xfs/105   |    2 +
 tests/xfs/112   |    2 +
 tests/xfs/113   |    2 +
 tests/xfs/146   |    2 +
 tests/xfs/147   |    2 +
 tests/xfs/151   |    3 +-
 tests/xfs/271   |    2 +
 tests/xfs/307   |    2 +
 tests/xfs/308   |    2 +
 tests/xfs/348   |    2 +
 tests/xfs/530   |    3 +-
 20 files changed, 129 insertions(+), 44 deletions(-)

