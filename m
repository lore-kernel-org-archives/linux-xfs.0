Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9111CCE79A5
	for <linux-xfs@archiver.kernel.org>; Mon, 25 Sep 2023 21:42:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233425AbjIYVm6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 25 Sep 2023 17:42:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231358AbjIYVm5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 25 Sep 2023 17:42:57 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45BBB101;
        Mon, 25 Sep 2023 14:42:51 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD0A8C433C8;
        Mon, 25 Sep 2023 21:42:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695678170;
        bh=89z2WOsZfRv07omdTre+ysFmJ/LS/MVWRXRLNwYSaiY=;
        h=Subject:From:To:Cc:Date:From;
        b=cvtSW8g9KlvehvKLqNHjQloKZpIstmi13e8MtfAWA5a/mAhA7/ydyYSdnblXJY1l0
         xkLVWp6qD8flqTqtjaKz+ko/tS+37lQETT3P7vwTaS+sVQJup/XnxHmXK50Taz2II9
         FzWxbrZg+47MHq8kChcwiVzd3tyEp1TiqEF3EBgvJFXEH2IftE+K/+GjaS+mRca9En
         roEzlJWfrQzfDln6s001Fe6c7KtxuGWSSDsa7IxmV+47BEE9B3zGeu0r7jZ2w2sQ7Z
         zoDyshOVKl2wUw/6bDfayiR4CBxvXtoXeql5o62l3XtTJVIlj2xGH3audiV0RwT48D
         C0RC5wJSWC90A==
Subject: [PATCHSET v2 0/1] fstests: fix ro mounting with unknown rocompat
 features
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        david@fromorbit.com, sandeen@sandeen.net
Date:   Mon, 25 Sep 2023 14:42:50 -0700
Message-ID: <169567817047.2269889.16262169848413312221.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Dave pointed out some failures in xfs/270 when he upgraded Debian
unstable and util-linux started using the new mount apis.  Upon further
inquiry I noticed that XFS is quite a hot mess when it encounters a
filesystem with unrecognized rocompat bits set in the superblock.

Whereas we used to allow readonly mounts under these conditions, a
change to the sb write verifier several years ago resulted in the
filesystem going down immediately because the post-mount log cleaning
writes the superblock, which trips the sb write verifier on the
unrecognized rocompat bit.  I made the observation that the ROCOMPAT
features RMAPBT and REFLINK both protect new log intent item types,
which means that we actually cannot support recovering the log if we
don't recognize all the rocompat bits.

Therefore -- fix inode inactivation to work when we're recovering the
log, disallow recovery when there's unrecognized rocompat bits, and
don't clean the log if doing so would trip the rocompat checks.

v2: change direction of series to allow log recovery on ro mounts

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=fix-ro-mounts

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=fix-ro-mounts
---
 tests/xfs/270 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

