Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 875FFC4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Oct 2022 22:45:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbiJRWpJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Oct 2022 18:45:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbiJRWpJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Oct 2022 18:45:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 690681D655;
        Tue, 18 Oct 2022 15:45:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21228B82113;
        Tue, 18 Oct 2022 22:45:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D739DC433C1;
        Tue, 18 Oct 2022 22:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666133104;
        bh=zPjs1/nYnOapjCl5X9K4Hjy/6FZ6j+gbi68c8ECPZXE=;
        h=Subject:From:To:Cc:Date:From;
        b=RKy7YADLyutxf/nHtZPO0gXYo9Fz47B/ttKY1fEs6jOrMmb0q+kxi7PcY/X0Pm3iY
         2OQKoi/YwqhhB6ujiRrdnqjiG60p8ulzYQK27Tr5dg1JpdQHrngYKVmZ5k67T9AoSI
         qSYL6qYDGe7lsgvbHkr2y1MBK7PPpvFZ9V6s2UciGhLsKzAryDQqs4RUYCB3Lplqpx
         Zhv9lb3i8A4w/0Xye40WEE+9FrXImbCYGbIGJkc7SqinhwuYCVnyCHHBOBnxNcCDe1
         8GFCrKkVxtk/zKDGHKRNR63PiVk8/PBDqWYujTJklTKjq3nDKkIFai1nuyN2jjGZL7
         C6MnfmoSQH6Jg==
Subject: [PATCHSET 0/1] fstests: random fixes for v2022.10.16
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 18 Oct 2022 15:45:04 -0700
Message-ID: <166613310432.868003.6099082434184908563.stgit@magnolia>
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
 common/populate |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

