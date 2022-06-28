Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43C2FC43334
	for <linux-xfs@archiver.kernel.org>; Tue, 28 Jun 2022 20:49:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231294AbiF1Ut0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Jun 2022 16:49:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231338AbiF1UtW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Jun 2022 16:49:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98EAA3120B
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 13:49:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4BD99B81E06
        for <linux-xfs@vger.kernel.org>; Tue, 28 Jun 2022 20:49:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04CD7C341C8;
        Tue, 28 Jun 2022 20:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656449355;
        bh=M9lpKslyKLX3So6d0vFp5b0PKqom3eikla3/TZoY84U=;
        h=Subject:From:To:Cc:Date:From;
        b=P+NxwL5bSxLKWbP4rsEfgd7/4LWmNZhhpHXPybZ+X0Gdn+yWW35Ufg2kWVft0ah8U
         vl5M3VbBKINqFK33k2hfpqvyTwZ2C+uCZIMTQBRJaHE42D+P9teHtYblRjVPGD5ZHS
         96TC/DlvJdID0TVUuph+Ys0T+QaZTD387BzdXFuoIxPyLnWKB3+Qxux5S/rvcFJ6bN
         A5zysZLqnYN7Wb02+rIjCUi63hE56wTMdoizFjZPIkLAPkCnzLoO0gH1qRKR8CXhVg
         VCoHz88Qy1zjfoxRXbQiF0WXinrY+T4LbsuwVzV9Umrnl8F740CsiyNkIAnlXw+IjL
         Ti7VgEiKsJ68g==
Subject: [PATCHSET 0/6] xfsprogs: random fixes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 28 Jun 2022 13:49:14 -0700
Message-ID: <165644935451.1089996.13716062701488693755.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here are various fixes for the new code added in the 5.19 kernel.
They're pretty much all nrext64 fixes.

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
 copy/xfs_copy.c |    2 +-
 libxfs/util.c   |    9 ++++++---
 mkfs/xfs_mkfs.c |    2 +-
 repair/dinode.c |   39 +++++++++++++++++++++++++++++++++++++++
 4 files changed, 47 insertions(+), 5 deletions(-)

