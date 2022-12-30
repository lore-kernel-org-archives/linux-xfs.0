Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F6DCC46467
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:22:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236376AbiLaDWR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:22:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236382AbiLaDV5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:21:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5496812A80;
        Fri, 30 Dec 2022 19:21:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5AC061D4F;
        Sat, 31 Dec 2022 03:21:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51B79C433D2;
        Sat, 31 Dec 2022 03:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672456915;
        bh=9H3F4oFjcI/oiqJ4LYgu9M0T2t5Itsadeniw/2T4wto=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=FamzfkKoVcz8o08W3lKBVFXvcZ/QeijyplZ9RbxmmYqpq87cRphWAUniGe6TLapL0
         E/q95n1ph8e6MuzWUx5URRZamBdjyFCGgqYvlJaniyl47f058lkpqdNXwy2M/ZP7/C
         gt9ZWuk/kq78y7ctqJhfbocbbNPunho6Int/22CrRYu6S6xpJFxpcBSm3wsckQfrJJ
         kU625/dkwK8MKe2+U3ujQnkupl8GawNYJrsut8SBLvoXnQH+IWLWmFyCBaIwHQLkN6
         fIePXgdJhHNsEAZHYGj2zP1t7A3LNjEcCwnxZRPSpcqHrFuR5+VOLJcZJmMhJHgJ6P
         EP3xubI/bzDzQ==
Subject: [PATCHSET 0/1] xfs_scrub: vectorize kernel calls
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:21:11 -0800
Message-ID: <167243887190.741937.14206419277494972578.stgit@magnolia>
In-Reply-To: <Y69Uw6W5aclS115x@magnolia>
References: <Y69Uw6W5aclS115x@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Create a vectorized version of the metadata scrub and repair ioctl, and
adapt xfs_scrub to use that.  This is an experiment to measure overhead
and to try refactoring xfs_scrub.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=vectorized-scrub

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=vectorized-scrub

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=vectorized-scrub
---
 tests/xfs/122.out |    2 ++
 1 file changed, 2 insertions(+)

