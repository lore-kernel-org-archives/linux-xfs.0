Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5ECFC3DA7D
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:18:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235661AbiL3XSB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:18:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235266AbiL3XSA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:18:00 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81623FCCB;
        Fri, 30 Dec 2022 15:17:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D1A5B81D67;
        Fri, 30 Dec 2022 23:17:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7242C433D2;
        Fri, 30 Dec 2022 23:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672442276;
        bh=MmoAhAE/8EEW1oy70L2R2/kAJ+uLFTGQR27RRZGNY7U=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=EL8OhjK1z0V3ACC/71ZJ8Ju46x9DioGyib+ILki3unrWBqWYaBF27zaKNXJMQ2765
         cZ68Cpqwn1bLxXEQ0mlDKWz3KtHpNcWMYXMHXm2wU810CQw6M7ptNuWP/WWUf73JhS
         ePMqYM5Vcdxra3WIcRK/x4vPiWPYTltIJUgfCwIHz9dcEKdRCRvKrxLG6E1FcGsY8M
         N6/gO3qwV+39bxgpEpjOq73gwU0JUE6nws8WiQvI9RUW08Vgo2Sb4P/ULIB5pv9Z7N
         DrcYuxXCmcqqIisp1R5JCcTrnHu4J1DYwKiVCJXVl/cZGvVSHFzPsbRCPpkVCAIH5c
         aI7qlYlIzBQjg==
Subject: [PATCHSET v24.0 0/1] fstests: online repair of rmap btrees
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:33 -0800
Message-ID: <167243877345.728215.12907289289488316002.stgit@magnolia>
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

We have now constructed the four tools that we need to scan the
filesystem looking for reverse mappings: an inode scanner, hooks to
receive live updates from other writer threads, the ability to construct
btrees in memory, and a btree bulk loader.

This series glues those three together, enabling us to scan the
filesystem for mappings and keep it up to date while other writers run,
and then commit the new btree to disk atomically.

To reduce the size of each patch, the functionality is left disabled
until the end of the series and broken up into three patches: one to
create the mechanics of scanning the filesystem, a second to transition
to in-memory btrees, and a third to set up the live hooks.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=repair-rmap-btree

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=repair-rmap-btree

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=repair-rmap-btree
---
 tests/xfs/422 |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

