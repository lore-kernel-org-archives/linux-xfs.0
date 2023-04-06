Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2713AC7618D
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 00:07:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231219AbjDFAH6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 5 Apr 2023 20:07:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232739AbjDFAH4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 5 Apr 2023 20:07:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A54896E82
        for <linux-xfs@vger.kernel.org>; Wed,  5 Apr 2023 17:07:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E9FB6423A
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 00:07:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96783C433EF;
        Thu,  6 Apr 2023 00:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680739671;
        bh=dmubJbwXOyBsSdhZosmn4OU30jnjz+m7+cStjqC/7JQ=;
        h=Subject:From:To:Cc:Date:From;
        b=SylbdiBTO1RQf5TmTVkgeI7YSagbR9WAW5Niwq3up1BPPFDDw4SwvyogccM0Amopf
         0fzoAtUEamlo/5w3LUZQmQf0bor9RQW07CYewKhWnWQwhjSlafmQ9onI9dWAtkR/t7
         gSzNPD2USFWkcWKdXZJB4oNSxm4rQLakNcEFd9GPEOUFxxq+v1lnhu7jo5ZJ6CzG2t
         MM26GDEcLKPSTrrCIy8k25cT1PhT4PUZyj+TjobKhyrcXY1qeOKbkT1ciVxvGGooCL
         968u6y6//fhyz61voGEgiGT4vBPCjT7e0NE5AUvn3mJTH0xs623PobFzCxRDvzl16r
         AS/yCSKXKeeNQ==
Subject: [PATCHSET 0/2] xfsprogs: test the dir/attr hash function
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com
Date:   Wed, 05 Apr 2023 17:07:51 -0700
Message-ID: <168073967113.1654766.1707855494706927672.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Add a selftest program for the regular directory/xattr name hashing
code, then make mkfs and xfs_repair run it every time they start up.
This will help us catch any bugs in the implementation or the hardware
before users trash their systems.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.
xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=test-dahash-6.3
---
 libfrog/Makefile         |    7 -
 libfrog/crc32cselftest.h |  533 +---------------------------------------------
 libfrog/dahashselftest.h |  172 +++++++++++++++
 libfrog/randbytes.c      |  527 +++++++++++++++++++++++++++++++++++++++++++++
 libfrog/randbytes.h      |   11 +
 mkfs/xfs_mkfs.c          |    8 +
 repair/init.c            |    5 
 7 files changed, 738 insertions(+), 525 deletions(-)
 create mode 100644 libfrog/dahashselftest.h
 create mode 100644 libfrog/randbytes.c
 create mode 100644 libfrog/randbytes.h

