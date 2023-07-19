Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DC68EB64DD
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Jul 2023 01:10:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbjGSBKo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Jul 2023 21:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbjGSBKn (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jul 2023 21:10:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3632C1BCC;
        Tue, 18 Jul 2023 18:10:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2200615F8;
        Wed, 19 Jul 2023 01:10:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24336C433C8;
        Wed, 19 Jul 2023 01:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689729042;
        bh=qU9jPWpqsWVkRb+l5fS8PwBs7jqTjFLOLwyWF9W7Yas=;
        h=Subject:From:To:Cc:Date:From;
        b=q7Ujod2hgInLoNEGXUZ5OV2C/n/ybkHV2C0JGsRvrA4p38R/rLpBdYQ3W31230p/E
         50iSBeKZ3Q5FFE25Ge9wkRYvUPukN0v+IXBrayviDoctSzy5tVrE1Tt4cA/t60WNvR
         vRFJ3jIiu6kiof+6wraH88ym1SUZzySxHHEFfRXSDWOFGOkG1Utsg799m3bif+QCqF
         sWUwggAPO/lUnixPYecHrkwhHluL+9yylwZkTW/FoTnq/kXcyPf87MYSzm+N4u+Kba
         ROq46I2s+igz/rpFq0vzc0i2xPynnfMazNqXkM1uJrdQhKm0+xdS+AC0QRITB7Iqr8
         AzMpWrjCDHr8g==
Subject: [PATCHSET 0/1] fstests: random fixes for v2023.07.09
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     Mikulas Patocka <mpatocka@redhat.com>,
        Bill O'Donnell <bodonnel@redhat.com>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 18 Jul 2023 18:10:41 -0700
Message-ID: <168972904158.1698538.17755661226352965399.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here's the usual odd fixes for fstests.

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
 tests/generic/558 |   27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

