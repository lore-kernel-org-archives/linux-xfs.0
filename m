Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BE29C47071
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Nov 2023 17:30:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229468AbjKPRaN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Nov 2023 12:30:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjKPRaL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Nov 2023 12:30:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97297E6
        for <linux-xfs@vger.kernel.org>; Thu, 16 Nov 2023 09:30:08 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AE8EC433C7;
        Thu, 16 Nov 2023 17:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700155808;
        bh=8fgMiaOwvvo0LjagEIQNbD5Cef9tfwK2MmuSYtBow2s=;
        h=Subject:From:To:Cc:Date:From;
        b=gkJAwVbNanDjDTRuC6R6JdUO+kJIitlx0jEGGoCgHMsrh7zMKHfh8korTckLMWEfQ
         u959BRVVZPdMDvAnwF9I1X/s3dYYYSgE4SFhBgUpheel3PiMpkcKqc01DV7x/CKulN
         Rym9QMxO8HDHmT8erDS6Cf58zB1kF7OJ2OlQSKcf30OyRSVBO60HO4m0AY3N0R45Av
         AqmKKwrfIugcaplmOzn3j8kjRTXnynNe8nked7ZAdSu3ySx5vXtWMtyhdP25oQ4iAQ
         nuy+kSKNA08abB2w8JVFuDDhJef1KD4NZAY0WK1O22JRK77gFF4T0FHN3Mo95cS/JR
         ZJilWN8Nu2umw==
Subject: [PATCHSET v5 0/2] fstests: reload entire iunlink lists
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, fstests@vger.kernel.org,
        david@fromorbit.com, guan@eryu.me, linux-xfs@vger.kernel.org
Date:   Thu, 16 Nov 2023 09:30:07 -0800
Message-ID: <170015580749.3367597.13675483508180016662.stgit@frogsfrogsfrogs>
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

v2: rebase to for-next, resend without changes
v3: add necessary prerequisites
v4: fix accidental commit to wrong patch
v5: add more review tags

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
 common/fuzzy       |    4 -
 common/rc          |   36 ++++++++-
 tests/xfs/1872     |  111 +++++++++++++++++++++++++++
 tests/xfs/1872.out |    5 +
 tests/xfs/1873     |  215 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/1873.out |    6 +
 tests/xfs/329      |    4 -
 tests/xfs/434      |    2 
 tests/xfs/435      |    2 
 tests/xfs/436      |    2 
 tests/xfs/444      |    2 
 tests/xfs/516      |    2 
 12 files changed, 381 insertions(+), 10 deletions(-)
 create mode 100755 tests/xfs/1872
 create mode 100644 tests/xfs/1872.out
 create mode 100755 tests/xfs/1873
 create mode 100644 tests/xfs/1873.out

