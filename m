Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18058C3DA7D
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:17:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235621AbiL3XRa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:17:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235266AbiL3XR3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:17:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E48CFCCB;
        Fri, 30 Dec 2022 15:17:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DC6D1B81DA2;
        Fri, 30 Dec 2022 23:17:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83348C433EF;
        Fri, 30 Dec 2022 23:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672442245;
        bh=QSsAFvHqTAhTe7TDnbIYkLH++eIF+qFg/jXZX1osJdk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=XxXR9nS5bJYEWpZg4xo54zmbM6AbaGA4UKanzxUcbj2sIGw0YhYoqO/dPXePmMiMQ
         s4GuV+7nGYKaocpCSxvSTYGoHUHmC/elCn14jrUJJTcY4JeMhI2Mv6fIDT1dPu5s/o
         nkyothXbrKfI84qzKKyzyLOuufCd9RAu536+KiZ1Rm3YJy0ZRli89+BPiaZMbQHZQn
         kXlrgRjbILkQa3pPB41t4jthhoQKmYIsjFWuSUVRMXGEve6XqllL1e3Yv9c7kFvRvE
         +bRAwsFZZ2HRpLBzjm8MOse28DouvEPu1QGzHraEq8O+KfOpoCvndniNWGogKwaIQR
         1NN6p3uEzkOeg==
Subject: [PATCHSET v24.0 0/1] fstests: online repair of file link counts
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:27 -0800
Message-ID: <167243876754.727436.356658000575058711.stgit@magnolia>
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

Now that we've created the infrastructure to perform live scans of every
file in the filesystem and the necessary hook infrastructure to observe
live updates, use it to scan directories to compute the correct link
counts for files in the filesystem, and reset those link counts.

This patchset creates a tailored readdir implementation for scrub
because the regular version has to cycle ILOCKs to copy information to
userspace.  We can't cycle the ILOCK during the nlink scan and we don't
need all the other VFS support code (maintaining a readdir cursor and
translating XFS structures to VFS structures and back) so it was easier
to duplicate the code.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=scrub-nlinks

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=scrub-nlinks

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=scrub-nlinks
---
 tests/xfs/772     |   38 ++++++++++++++++++++++++++++++++++++++
 tests/xfs/772.out |    2 ++
 tests/xfs/820     |   37 +++++++++++++++++++++++++++++++++++++
 tests/xfs/820.out |    2 ++
 4 files changed, 79 insertions(+)
 create mode 100755 tests/xfs/772
 create mode 100644 tests/xfs/772.out
 create mode 100755 tests/xfs/820
 create mode 100644 tests/xfs/820.out

