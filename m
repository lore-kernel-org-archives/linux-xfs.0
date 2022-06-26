Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EAE5C433EF
	for <linux-xfs@archiver.kernel.org>; Sun, 26 Jun 2022 22:03:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231314AbiFZWDv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 26 Jun 2022 18:03:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbiFZWDu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 26 Jun 2022 18:03:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CC072DC6
        for <linux-xfs@vger.kernel.org>; Sun, 26 Jun 2022 15:03:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B4EBB80DFB
        for <linux-xfs@vger.kernel.org>; Sun, 26 Jun 2022 22:03:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7853C34114;
        Sun, 26 Jun 2022 22:03:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656281027;
        bh=plfwpt0r3jwk0xp3IEXWAJEg+9KoxRpLR5W8jfQQSTE=;
        h=Subject:From:To:Cc:Date:From;
        b=eVBxIZQwMgBHFWjxXqqxU/KPqo24HxjHoKSmFJRxi07xgA1SiWmZ7V8C+4EAFqLYa
         oNudh/5d0MGEBJqav6ltoLljZDNAW9rKwYggUekxP4di6qlNDOpglH1WqvKjogRpX+
         ibRt2iBeo08BtmRSWDZQXq64UWj1sLcYiDODlwA3Vv5YCNEts85bQptplJb8xIFIdt
         F52z+ZQiQhXE80JNnFznDJbedScqX/cAkzvUyYIq8K77quEAfWDC8f6HyV47b56sQ/
         zqcYO2+tTsE3NGUd1vdzHTTXo7I11pxhtkEG4P5FhZHNb+Iudwe6hAlrGWSSCXj/8k
         soGbpjMOYeATA==
Subject: [PATCHSET 0/3] xfs: random fixes for 5.19-rc5
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com,
        allison.henderson@oracle.com
Date:   Sun, 26 Jun 2022 15:03:47 -0700
Message-ID: <165628102728.4040423.16023948770805941408.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This week, we're fixing a log recovery regression that appeared in
5.19-rc1 due to an incorrect verifier patch, and a problem where closing
an O_RDONLY realtime file on a frozen fs incorrectly triggers eofblocks
removal.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=xfs-fixes-5.19
---
 fs/xfs/libxfs/xfs_attr.c      |   38 ++++++---------------------
 fs/xfs/libxfs/xfs_attr.h      |    5 ----
 fs/xfs/libxfs/xfs_attr_leaf.c |   57 ++++++++++++++++++++++++++++++++---------
 fs/xfs/libxfs/xfs_attr_leaf.h |    3 +-
 fs/xfs/xfs_attr_item.c        |   22 ----------------
 fs/xfs/xfs_bmap_util.c        |    2 +
 6 files changed, 56 insertions(+), 71 deletions(-)

