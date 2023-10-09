Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61318CD611C
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Oct 2023 18:18:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377531AbjJISSv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Oct 2023 14:18:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377414AbjJISSu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Oct 2023 14:18:50 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEF1D9C;
        Mon,  9 Oct 2023 11:18:49 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C077C433C7;
        Mon,  9 Oct 2023 18:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696875529;
        bh=ckru4ZuflSB0ZQCZ5geOUkcMptR+CaaN8ftVQv8ntzw=;
        h=Subject:From:To:Cc:Date:From;
        b=jTJggfDiac5xQvtPdT088JiuJxPhOoEa5VsvZiHauyFIP9crg9UXxlwuHn8lWBIWN
         AlmVQ3ovqvEcSrQlV6KROsZ4oH0skRLMVkgzbs2/VRMBtmtlaAlS65PFPCIHpfIQWN
         NIrPVGYJ0N5Op5ty4XgZC4CNJ/F3JRtKuVZHSAkN0t294uXV1K+tmsH5mfHky0DrSQ
         PCnGCdlJwssX+rnLJ8aJqK0x4OZrBZIsRCY2PknUa7/Sw9obwSFsBRIwwgeUFRuOP+
         mUNAEz7ZXqra9UFxHHjd9rl6d8UnSa4Hw2PIl8sEBvk3noaMH6yaFIGuu3SQxXm4p2
         g7l0a57SFzwSA==
Subject: [PATCHSET v2 0/1] fstests: reload entire iunlink lists
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        david@fromorbit.com
Date:   Mon, 09 Oct 2023 11:18:48 -0700
Message-ID: <169687552892.3949084.287369396167434290.stgit@frogsfrogsfrogs>
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

