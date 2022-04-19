Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7D72C4167B
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Apr 2022 17:32:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347669AbiDSRfA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Apr 2022 13:35:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354030AbiDSRey (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Apr 2022 13:34:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5922D36E26;
        Tue, 19 Apr 2022 10:32:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA3C061481;
        Tue, 19 Apr 2022 17:32:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52C3BC385A7;
        Tue, 19 Apr 2022 17:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650389530;
        bh=YqP7REiAv0RunlI7mcJx8eMV0oeqDf53nPtIlNgPKOI=;
        h=Subject:From:To:Cc:Date:From;
        b=iyKQYnNmZzAvafq3o8a7N+uNPPZHq3PvEacU5CQM7IRqrbF3mDHvDk3oyYYczvlzc
         cbbdILVpKdvr0oHTOGkvDI/lxl4ZbDsVGSTetNKctqcnhddX/tkz6agRfij3J8z4E1
         svq9M89MbpfmN4K6wRUP7zFXiNDgWRctj7QKn6osZIjkcNO/8IRznUqW2Tr4TZfI0D
         fgruvlNw98JhkvypKP4NgE+vbVU4O9QfXUxFSSqHZYVqiXcfmhpv5tGPMg2vREMPL9
         vmQajvSvc9eVU3BVO2SKXZqY5NS4Wl4zngbSqdYe33dIgeAilzYmNH03oKf5FjC9f8
         dBBAT188p9a5A==
Subject: [PATCHSET v2 0/2] fstests: new tests for kernel 5.18
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        amir73il@gmail.com
Date:   Tue, 19 Apr 2022 10:32:09 -0700
Message-ID: <165038952992.1677711.6313258860719066297.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Add new tests for bugfixes merged during 5.18.  Specifically, we now
check quota enforcement when linking and renaming into a directory
(merged), test that XFS reliably returns all errors captured by
xfs_sync_fs, and make sure that fallocate drops file privileges and
capabilities like any other file write would.

v2: move stuff around

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=xfs-merge-5.18

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=xfs-merge-5.18
---
 tests/generic/834     |  127 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/834.out |   33 +++++++++++++
 tests/generic/835     |  127 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/835.out |   33 +++++++++++++
 tests/generic/836     |  127 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/836.out |   33 +++++++++++++
 tests/generic/837     |  127 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/837.out |   33 +++++++++++++
 tests/generic/838     |  127 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/838.out |   33 +++++++++++++
 tests/generic/839     |   77 ++++++++++++++++++++++++++++++
 tests/generic/839.out |   13 +++++
 tests/xfs/839         |   42 ++++++++++++++++
 tests/xfs/839.out     |    2 +
 14 files changed, 934 insertions(+)
 create mode 100755 tests/generic/834
 create mode 100644 tests/generic/834.out
 create mode 100755 tests/generic/835
 create mode 100644 tests/generic/835.out
 create mode 100755 tests/generic/836
 create mode 100644 tests/generic/836.out
 create mode 100755 tests/generic/837
 create mode 100644 tests/generic/837.out
 create mode 100755 tests/generic/838
 create mode 100644 tests/generic/838.out
 create mode 100755 tests/generic/839
 create mode 100755 tests/generic/839.out
 create mode 100755 tests/xfs/839
 create mode 100644 tests/xfs/839.out

