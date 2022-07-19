Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95F80C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jul 2022 21:44:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237462AbiGSVov (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Jul 2022 17:44:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234972AbiGSVov (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jul 2022 17:44:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A9794F6A2
        for <linux-xfs@vger.kernel.org>; Tue, 19 Jul 2022 14:44:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3747E61A8D
        for <linux-xfs@vger.kernel.org>; Tue, 19 Jul 2022 21:44:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88534C341CA;
        Tue, 19 Jul 2022 21:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658267089;
        bh=3r74RFLja7z9SAtrr+X3kXaNS4eANyI+M2xJNMp/xOU=;
        h=Subject:From:To:Cc:Date:From;
        b=c5oAnzXhXXLNUKxbPaYMjniIHnUqAkJuWUW58bOgXarUuXcJn6D18SZL3VhgkD/tp
         WfgATiJBDUJtCyaFsWYh/6bgZmNzMuTcq1yyh/Vvjqn/KH95IR5zH8fSlsWBggpgyg
         /N0Bi5RrjmiGux1/pE3gnnrEupe+/rtTXM8R9oDWvcCIs5muaZWXK8PpItmqLWnepF
         OBTnr4rBt6NYVDGSkmRQMPBkHE9U5zHBHx2JO18Lzf3689V+Wtnl4shTlxntC6rVr2
         k9D5ObK9uE+6zgfls0s4Piz7rGVF9ZwAteStwi0pRpFPMZVgkAxhm2kM44lNDkxBmO
         5cTYJmvotfk5g==
Subject: [PATCHSET v2 0/1] xfsprogs: random fixes for 5.19
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 19 Jul 2022 14:44:49 -0700
Message-ID: <165826708900.3268805.5228849676662461141.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This is a rollup of all the random fixes I've collected for xfsprogs
5.19.  At this point it's just an assorted collection, no particular
theme.  Some of them are leftovers from last week's posting.

v2: note the actual cause (too small filesystem) when we abort due to
    impossible log geometry

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
 mkfs/xfs_mkfs.c |    7 +++++++
 1 file changed, 7 insertions(+)

