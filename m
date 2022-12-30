Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6994BC3DA7C
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:16:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235627AbiL3XQm (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:16:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235506AbiL3XQl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:16:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB22910FC6;
        Fri, 30 Dec 2022 15:16:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5389E61C32;
        Fri, 30 Dec 2022 23:16:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABBB5C433D2;
        Fri, 30 Dec 2022 23:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672442198;
        bh=WPIIVfYTgeySBzu2k90OvCo/jdfShPI2pXILVvGgcjE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=E/3NHWg8dhIodHAOqMA59RckuP2zypBjAfOkAA+iza2WTFTaNNXH0gZSzGbLI1ktv
         RjeLpi6tp1qvhv+MTCbHrQEvtjGB5tfGkegqZgxcpL2fJZNLRA3HPhB1eEYly6UbPk
         VmiZf4Vlya9hk0CLicYhYH78qoWNs1t82vATg4erqG5vmbR7OGty5UFpsaEpR14exb
         FW0ohCiQBS7eK8u+4xODFnKdz6Ie5K/3n23LwQ8ssEbckbQlRh+EcHrrHDejwbgUSO
         2el5TL9pDI0ZcB7Nyh/+VrsvtA1aNe6ejymbAupxHIFUVtUIcy+y2e+4YFSOxJnpkj
         RYgdIjTNTZfYA==
Subject: [PATCHSET v24.0 0/4] fstests: online repair of file fork mappings
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:18 -0800
Message-ID: <167243875835.725760.8458608166534095780.stgit@magnolia>
In-Reply-To: <Y69Unb7KRM5awJoV@magnolia>
References: <Y69Unb7KRM5awJoV@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

In this series, online repair gains the ability to rebuild data and attr
fork mappings from the reverse mapping information.  It is at this point
where we reintroduce the ability to reap file extents.

Repair of CoW forks is a little different -- on disk, CoW staging
extents are owned by the refcount btree and cannot be mapped back to
individual files.  Hence we can only detect staging extents that don't
quite look right (missing reverse mappings, shared staging extents) and
replace them with fresh allocations.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-file-mappings

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-file-mappings

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=repair-file-mappings
---
 tests/xfs/746     |   85 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/746.out |    2 +
 tests/xfs/807     |   37 +++++++++++++++++++++++
 tests/xfs/807.out |    2 +
 tests/xfs/808     |   39 ++++++++++++++++++++++++
 tests/xfs/808.out |    2 +
 tests/xfs/828     |   38 ++++++++++++++++++++++++
 tests/xfs/828.out |    2 +
 tests/xfs/829     |   39 ++++++++++++++++++++++++
 tests/xfs/829.out |    2 +
 tests/xfs/840     |   72 +++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/840.out |    3 ++
 tests/xfs/846     |   39 ++++++++++++++++++++++++
 tests/xfs/846.out |    2 +
 14 files changed, 364 insertions(+)
 create mode 100755 tests/xfs/746
 create mode 100644 tests/xfs/746.out
 create mode 100755 tests/xfs/807
 create mode 100644 tests/xfs/807.out
 create mode 100755 tests/xfs/808
 create mode 100644 tests/xfs/808.out
 create mode 100755 tests/xfs/828
 create mode 100644 tests/xfs/828.out
 create mode 100755 tests/xfs/829
 create mode 100644 tests/xfs/829.out
 create mode 100755 tests/xfs/840
 create mode 100644 tests/xfs/840.out
 create mode 100755 tests/xfs/846
 create mode 100644 tests/xfs/846.out

