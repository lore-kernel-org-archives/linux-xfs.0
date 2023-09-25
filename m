Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 878A6E7D0C4
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Sep 2023 21:43:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233469AbjIYVnH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Sep 2023 17:43:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233471AbjIYVnG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Sep 2023 17:43:06 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74AF6A3;
        Mon, 25 Sep 2023 14:43:00 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15DEEC433C8;
        Mon, 25 Sep 2023 21:43:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695678180;
        bh=eR12UzxTRibda9SuwyHgi7gU3zYhslqxESCOKLjcnz0=;
        h=Subject:From:To:Cc:Date:From;
        b=YA8F4Sf0VK2qbS4TftynWgfQLiFJ/QcCIWq1d3pRa/B5OHOeEilJKC8u82Jpx0Vjk
         zzHyYn/XlhigPLtONCvIAN/c+YpIXUP5935easRZ5ST/vajeN1+QzXt4uywyuSf2iK
         b9/3I/aMi/0b806Ug0XD7t0rYAxTCNMtuMDIBx0v59newTjzbmK9uCsrKNSutLh/Wj
         c2bncVxLgcpaVw++tnziOSVz9iBJEiE86Rv6C2CLNDH+1H8CptbvIiVCvKntx+AN9n
         VBWKX/mQ6f7RpzYIcs5ewq9rmF5/4q+mTbN6t9GGmVAG9vwqjItklUjOujGEuJ/+ax
         eD4qPit//yQ5g==
Subject: [PATCHSET 0/1] fstests: reload entire iunlink lists
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        david@fromorbit.com
Date:   Mon, 25 Sep 2023 14:42:59 -0700
Message-ID: <169567817962.2269957.4542023123910859483.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This is the second part of correcting XFS to reload the incore unlinked
inode list from the ondisk contents.  Whereas part one tackled failures
from regular filesystem calls, this part takes on the problem of needing
to reload the entire incore unlinked inode list on account of somebody
loading an inode that's in the /middle/ of an unlinked list.  This
happens during quotacheck, bulkstat, or even opening a file by handle.

In this case we don't know the length of the list that we're reloading,
so we don't want to create a new unbounded memory load while holding
resources locked.  Instead, we'll target UNTRUSTED iget calls to reload
the entire bucket.

Note that this changes the definition of the incore unlinked inode list
slightly -- i_prev_unlinked == 0 now means "not on the incore list".

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=fix-iunlink-list

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=fix-iunlink-list
---
 common/rc          |    4 +
 tests/xfs/1872     |  113 +++++++++++++++++++++++++++
 tests/xfs/1872.out |    5 +
 tests/xfs/1873     |  217 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1873.out |    6 +
 5 files changed, 344 insertions(+), 1 deletion(-)
 create mode 100755 tests/xfs/1872
 create mode 100644 tests/xfs/1872.out
 create mode 100755 tests/xfs/1873
 create mode 100644 tests/xfs/1873.out

