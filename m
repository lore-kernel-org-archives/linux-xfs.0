Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 765CEC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 18 May 2022 18:55:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241697AbiERSz2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 May 2022 14:55:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241704AbiERSz1 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 May 2022 14:55:27 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BB29230201
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 11:55:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6B2CCCE21B9
        for <linux-xfs@vger.kernel.org>; Wed, 18 May 2022 18:55:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE4C2C385A5;
        Wed, 18 May 2022 18:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652900123;
        bh=5szLGsFviOgUKnkv6odnH8KVdMVhBKpKKE12HbW8Pls=;
        h=Subject:From:To:Cc:Date:From;
        b=PIAphpnNsHptf+GZWvYAOdtZHgyKVVLlG/Ek3ipRl6E3gecOT05eWbmFkl20oBHQM
         uqw7UUAhAdfeFVUN1XdJ/fqQWuwoTRGUZDwCIhsuNyK50gWBL6gjl6snQEN6LX+vlu
         6EVMKRqm/IXC2il5vqnpU0Whtou/xeqtvBZiAlejhkRxMUbK1LzEYuX4bc0mB9g3Ba
         FwXXmJpsluGwug67E9PjsazcJLVRjXqBcgNXeM1dCC1otBxYK6j8DSpzZ2gfWkEqNT
         XGvGXtewvMVWg4y75uLukaOY68Eq3G2BOd7NMCKjVWMSR3UoNS2VREMz7s4CwJM3mt
         efUYVxBJA29Yw==
Subject: [PATCHSET 0/3] xfs: fix buffer cancellation table leak during log
 recovery
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Wed, 18 May 2022 11:55:23 -0700
Message-ID: <165290012335.1646290.10769144718908005637.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

As part of solving the memory leaks and UAF problems, kmemleak also
reported that log recovery will leak the table used to hash buffer
cancellations if the recovery fails.  Fix this problem by creating
alloc/free helpers that initialize and free the hashtable contents
correctly.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=log-recovery-leak-fixes-5.19
---
 fs/xfs/libxfs/xfs_log_recover.h |    2 ++
 fs/xfs/xfs_buf_item_recover.c   |   45 +++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_log_recover.c        |   23 ++++++++------------
 3 files changed, 56 insertions(+), 14 deletions(-)

