Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA7FCC4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 20 Dec 2022 00:05:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229441AbiLTAFB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 19 Dec 2022 19:05:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiLTAFA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 19 Dec 2022 19:05:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01E6D636C
        for <linux-xfs@vger.kernel.org>; Mon, 19 Dec 2022 16:04:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 915BD61184
        for <linux-xfs@vger.kernel.org>; Tue, 20 Dec 2022 00:04:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE92AC433D2;
        Tue, 20 Dec 2022 00:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671494698;
        bh=uSOuGxQ1EihhjyNg2p+GMRn59xiSWKucI8aXRJ70tS0=;
        h=Subject:From:To:Cc:Date:From;
        b=Gzo8jXaQnLN69+HIlH/nSQzHk5ndOrBWSGN/sNZKU7k/XahZL72epB4Q6YTfXPvs/
         vhLlWKyh5eS4/4f9fcF+rSB52Ivu76I0+CP3i/rm9HkoC3dRQnjVGUfF11bnpU/k1O
         s5j6zhBdglASi4zl8a1mx0E0oocxZeAtJGIa4QumI4mdDxGqwXrr+RNzrTaoYwP785
         ErtPK7SnljgcGFjxKFZnY4BpqxbU7TjGSA+Aj/s51TjgT858LTAhutiouSbeOT3+UR
         vF86N1MoOxzVbXINJsTTLGgR4nwgqy24Mbzq5Zhsvh1RfbJ1KUmZzZxvI8wqrPyx6Y
         Gruedf9i3qmtA==
Subject: [PATCHSET 0/4] xfs: random fixes for 6.2, part 3
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 19 Dec 2022 16:04:57 -0800
Message-ID: <167149469744.336919.13748690081866673267.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here's a sprinkling of bug fixes to start the 6.2 stabilization process.
I would imagine that the most controversial ones are going to be the one
that detaches background memory reclaim from the inodegc threads, and
the last one, which corrects the calculation of max btree height from
the given amount of space.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=xfs-fixes-6.2
---
 fs/xfs/libxfs/xfs_btree.c |    6 +++++-
 fs/xfs/xfs_icache.c       |    5 +++++
 fs/xfs/xfs_iomap.c        |    2 +-
 fs/xfs/xfs_reflink.c      |    2 --
 4 files changed, 11 insertions(+), 4 deletions(-)

