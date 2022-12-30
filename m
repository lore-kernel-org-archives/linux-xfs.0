Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 602FFC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:23:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236367AbiLaDWd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:22:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236366AbiLaDW2 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:22:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A5C812A80;
        Fri, 30 Dec 2022 19:22:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09FE361D4F;
        Sat, 31 Dec 2022 03:22:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 675E0C433D2;
        Sat, 31 Dec 2022 03:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672456946;
        bh=+42Hr5ajMiGxNVKdONl/IvzYe0k4SUqHiOP+Ocp/dZ0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=biC6B5MwO7eRebTY4ojISgSZmBFWlYQ9Biiz7KvqUJJOXWsQ/T/14rwNf05btzoWS
         0/rUkq82rvKqoP3HsO8KY0CJU6ftQFkfiYwMrLZhr3ha2NhS9T30+NADmrGWnf6Yqb
         rV5FkWgXzMEZXqOdJ87Zvr2DcKuDXYX+IpLpGr/DaU7p5OYI8+K1Fj3YA0WP1REcF2
         q2Cj9ufcbX+nrp6zAt2KjmUj40uYYmYEvkw50RToVApJvkNuFr5kNnUxbFPNwyzkZq
         HiJkb7sEq61iGEwzY78e+2EKsrVfJ2i8wD74kGZDGmmIttw+8yPTmLcQO0LdTz42VL
         6ST2uK2I2mX5A==
Subject: [PATCHSET 0/1] fstests: defragment free space
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:21:17 -0800
Message-ID: <167243887781.742091.16659657751012326997.stgit@magnolia>
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

These patches contain experimental code to enable userspace to defragment
the free space in a filesystem.  Two purposes are imagined for this
functionality: clearing space at the end of a filesystem before
shrinking it, and clearing free space in anticipation of making a large
allocation.

The first patch adds a new fallocate mode that allows userspace to
allocate free space from the filesystem into a file.  The goal here is
to allow the filesystem shrink process to prevent allocation from a
certain part of the filesystem while a free space defragmenter evacuates
all the files from the doomed part of the filesystem.

The second patch amends the online repair system to allow the sysadmin
to forcibly rebuild metadata structures, even if they're not corrupt.
Without adding an ioctl to move metadata btree blocks, this is the only
way to dislodge metadata.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=defrag-freespace

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=defrag-freespace

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=defrag-freespace
---
 common/rc          |    2 +
 tests/xfs/1400     |   57 +++++++++++++++++++++++++++++++++++++
 tests/xfs/1400.out |    2 +
 tests/xfs/1401     |   80 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1401.out |    2 +
 5 files changed, 142 insertions(+), 1 deletion(-)
 create mode 100755 tests/xfs/1400
 create mode 100644 tests/xfs/1400.out
 create mode 100755 tests/xfs/1401
 create mode 100644 tests/xfs/1401.out

