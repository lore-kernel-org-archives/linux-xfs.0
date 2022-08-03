Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98AA9C19F2B
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Aug 2022 04:22:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235515AbiHCEWH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Aug 2022 00:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232409AbiHCEWE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 3 Aug 2022 00:22:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C343654CA5;
        Tue,  2 Aug 2022 21:22:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65A8BB82188;
        Wed,  3 Aug 2022 04:22:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17C5FC433C1;
        Wed,  3 Aug 2022 04:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659500521;
        bh=kt0EP7fVJksON+yKfkV5gvtVXAaqvLUJkE7aheCQ6u0=;
        h=Subject:From:To:Cc:Date:From;
        b=sWevbM3XDJ+DoFofdPKP8/3McVz8Rx78xU8PtO4RwOmrKVIc+/3E3zfjBjxAmBT60
         w4MPS6lzLeR3rzJAEzAM3ZhFNk0YvhIA0bXIRjJ3/cgzYX8ot/EzzX4Or++Gvp/rH1
         hnvL9gkmE0p/skSYTM2dPnD7NyBrI5L1xE1ESV6eFXjTTI0NwV0Vpzu3tOGq/V1r4E
         DF21yS7ttfbwQMBJAJpdirhkUMCK40hx6vrDRGCBEj2UpE03wZknc+XhH9ZNfVJdoE
         6cu+zyXPpp8orrAL9TRpMDwQl4rpZ18142OmhkBTXh7aj93j1s2EZI2SpLen9jRat5
         JXmcc/PYzBeuA==
Subject: [PATCHSET v2 0/1] dmerror: support external log and rt devices
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        tytso@mit.edu, leah.rumancik@gmail.com
Date:   Tue, 02 Aug 2022 21:22:00 -0700
Message-ID: <165950052067.199065.15026954987755102109.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

There are a growing number of fstests that examine what happens to a
filesystem when the block device underneath it goes offline.  Many of
them do this to simulate system crashes, and none of them (outside of
btrfs) can handle filesystems with multiple devices.  XFS is one of
those beasts that does, so enhance the dm-error helpers to take the log
and rt devices offline when they're testing the data device.

v2: rebase atop ext4 fixes and v2022-07-31 release.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=dmerror-on-rt-devices
---
 common/dmerror    |  159 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 tests/generic/441 |    2 -
 tests/generic/487 |    2 -
 3 files changed, 156 insertions(+), 7 deletions(-)

