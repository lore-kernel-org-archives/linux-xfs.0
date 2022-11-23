Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C407AC4332F
	for <linux-xfs@archiver.kernel.org>; Wed, 23 Nov 2022 17:09:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236647AbiKWRJk (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 23 Nov 2022 12:09:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239180AbiKWRJV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 23 Nov 2022 12:09:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 511AB30549
        for <linux-xfs@vger.kernel.org>; Wed, 23 Nov 2022 09:08:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D859C61DEC
        for <linux-xfs@vger.kernel.org>; Wed, 23 Nov 2022 17:08:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41460C433D6;
        Wed, 23 Nov 2022 17:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669223335;
        bh=pCrhq4qVRE0qV9P5Psm1CoLmsY6Dwu40iuEwT8MeQM4=;
        h=Subject:From:To:Cc:Date:From;
        b=fLEMKsqjw+oHC/vPmjIkL/xtVounAH6USExLEmrK1+9cQlhza7QOZ80i5WGfKNBM4
         VfS8SsnOYg5h4JNu2dqBkTsJhYHlEXPHnaKNQIksifsANvKzLte9zXFs5114KvrDgB
         DDJ6UL8oD2yHXmz2VCn3H9x9ok0xDkUAWn/QM27XYAYJ2J6ecsMyyFui2WtoN+/ImN
         3dV3AsYOFbrJSv9OWU6CTLbcaa0Uq3gnglm2pgvJ6Um92ZSDHn8SLLgnO5n2R7tjYs
         CSVJmxylEwRP0UFliOoWSAPbo3fIKTNo0wLc1Z+VGdr2NUyUQ6e0yroy8XQ1v1x/aR
         wYWRjFQax2KjQ==
Subject: [PATCHSET 0/9] xfsprogs: random fixes for 6.1
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Wed, 23 Nov 2022 09:08:54 -0800
Message-ID: <166922333463.1572664.2330601679911464739.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This is a rollup of all the random fixes I've collected for xfsprogs
6.1.  At this point it's just an assorted collection, no particular
theme.  Many of them are verbatim repostings from the 6.0 series.
There's also a mkfs config file for the 6.1 LTS.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=xfsprogs-fixes-6.1
---
 db/btblock.c             |    2 +
 db/check.c               |    4 +-
 db/namei.c               |    2 +
 db/write.c               |    4 +-
 io/pread.c               |    2 +
 libfrog/linux.c          |    1 +
 libxfs/libxfs_api_defs.h |    2 +
 libxfs/libxfs_io.h       |    1 +
 libxfs/libxfs_priv.h     |    2 +
 libxfs/rdwr.c            |    8 +++++
 libxfs/util.c            |    1 +
 mkfs/Makefile            |    3 +-
 mkfs/lts_6.1.conf        |   14 ++++++++
 mkfs/xfs_mkfs.c          |    2 +
 repair/phase2.c          |    8 +++++
 repair/phase6.c          |    9 +++++
 repair/protos.h          |    1 +
 repair/scan.c            |   22 ++++++++++---
 repair/xfs_repair.c      |   77 ++++++++++++++++++++++++++++++++++++++++------
 scrub/inodes.c           |    2 +
 20 files changed, 139 insertions(+), 28 deletions(-)
 create mode 100644 mkfs/lts_6.1.conf

