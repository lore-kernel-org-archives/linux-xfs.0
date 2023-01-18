Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12904C38159
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 00:53:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229967AbjARAxl (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Jan 2023 19:53:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbjARAxQ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Jan 2023 19:53:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E860D366B8;
        Tue, 17 Jan 2023 16:41:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 730B661592;
        Wed, 18 Jan 2023 00:41:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8EFFC43396;
        Wed, 18 Jan 2023 00:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674002511;
        bh=PnAwoSbmcar3/hSyBpCNoo0duOih06KKaoGdJbgQmYs=;
        h=Date:Subject:From:To:Cc:From;
        b=ky8WBIHd5LVv8Zdf8I57GcoFhg0DBUho9s90+yOsKMk6yGPxtCJEvCc2b4OLuHi1I
         4gxgihOHRhP/xHauF4xGB+RGP2yZaH/R67WUHudsAOahaeguMM9iKW1B/a53SxYf/V
         o1gXoCl6abQUhqx5aAYOOzu7Ugi7VcrZKDXjlziOhYh4GjiY6R3GOhxz2D3Md3c6Fi
         vYqYKdn2I7Yd8ST45aZuCeXhmOeT0jlMhxhg60bYkwVbCHGdHYvBGj0RBcMLRRjOQQ
         X7R0fLitE3cGCySB+NHUrt700hvw8/BBPgItT9D8XK3XBWWIMYVRilyODU07YkeJpT
         YkesDx51rhBwQ==
Date:   Tue, 17 Jan 2023 16:41:51 -0800
Subject: [PATCHSET 0/3] fstests: fix dax+reflink tests
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        yangx.jy@fujitsu.com
Message-ID: <167400102444.1914858.13132645140135239531.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This patchset adjusts a few tests to handle fsdax and reflink being
enabled at the same time.  This is new functionality for 6.2.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=fix-dax-reflink
---
 tests/xfs/128     |    2 +-
 tests/xfs/182     |    4 ++--
 tests/xfs/182.out |    1 -
 tests/xfs/184     |    1 +
 tests/xfs/192     |    1 +
 tests/xfs/200     |    1 +
 tests/xfs/204     |    1 +
 tests/xfs/232     |    1 +
 tests/xfs/440     |    1 +
 9 files changed, 9 insertions(+), 4 deletions(-)

