Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55AC5C433EF
	for <linux-xfs@archiver.kernel.org>; Tue,  5 Jul 2022 22:02:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232246AbiGEWCG (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 5 Jul 2022 18:02:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232265AbiGEWCE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 5 Jul 2022 18:02:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58552192A2;
        Tue,  5 Jul 2022 15:02:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E725B61CDD;
        Tue,  5 Jul 2022 22:02:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50941C341C7;
        Tue,  5 Jul 2022 22:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657058523;
        bh=Z3+OxP14D66Ri/jA6ctlo6DRusdYdUqMBkcvyRytei0=;
        h=Subject:From:To:Cc:Date:From;
        b=GE4mvsKIlcGyNND2yYRXEKqkZW7HrikElrZunat2W0nC+jCrSP9sBNgluLYARO0yU
         yc0yDJAo1Z7A6jqUYEjkMKIEPbBLNoda8+lOBfS3WBkVQdTpj+gDTQ7w0JXsU0FEFe
         q1YNOVmd/xgZX+PGxylFHkU+vlZS/lEYYoJPp1HHuXjwlq0Zr9zHPFKhFrCvJQXccY
         Y3tdTWECqHF+HHEYXqw2STLReABO+HyX1/dwlaP7ULKms236hcrYoVsXD2BmsddslR
         QeL4+eu+SrPFwT5E0qiqIOZQwQhWVQHb0nZsik+iSEW6lPaZP6IYpprYSJGJkmzZCQ
         YKkVPg2sZJzAQ==
Subject: [PATCHSET v2 0/3] fstests: random fixes
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 05 Jul 2022 15:02:02 -0700
Message-ID: <165705852280.2820493.17559217951744359102.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here's the usual batch of odd fixes for fstests.

v2: rebase against v2022.07.03, add another correction

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
 tests/xfs/018     |   52 +++++++++++++++++++++++++++++++++++++++++++++++-----
 tests/xfs/018.out |   16 ++++------------
 tests/xfs/144     |   14 +++++++++-----
 tests/xfs/547     |   14 ++++++++++----
 4 files changed, 70 insertions(+), 26 deletions(-)

