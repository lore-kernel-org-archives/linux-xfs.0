Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6BC1C3DA7D
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 01:03:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235878AbiLaBDj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 20:03:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235722AbiLaBDi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 20:03:38 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA5A31DDE4;
        Fri, 30 Dec 2022 17:03:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 87E75B81DF7;
        Sat, 31 Dec 2022 01:03:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B924C433D2;
        Sat, 31 Dec 2022 01:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672448615;
        bh=+z0DklPp1UFxRfQKXP7AF8J+xHAVKV/sUvK2ulsBCzg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=PPZKaRdILBCag8NLLIqIF6P/iULMnIOo0uEF300oAzyUBf4Ecdc9zG8Bg4In7uwH5
         1PR8i4qmDE2RlQMwDEG54KTfgW198TieBnvxHxVNMOGC1CRmBMgZVSbtJpA0PGo9Wo
         ZsJI8N7UEifo86Ph/+sTCY3CkSfPMiI0IGgtztnHt8Y+ZDaj4lNR47S7QbnQtI9ZcD
         9z7gAgvDpY09jvJq601oBbgrhhHQCUHnltYt3BWoyDZdSXGif5/WI1EzScw9LC9uC2
         DiSvJLT1uvV2EAwBej01uoPkwJvU1r1DdBE8Ya04z76kRnFMpixD5OK6LneSHmwxpR
         vGrpnMRzvSW0w==
Subject: [PATCHSET v1.0 0/9] fstests: test XFS metadata directories
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:20:32 -0800
Message-ID: <167243883244.736753.17143383151073497149.stgit@magnolia>
In-Reply-To: <Y69UsO7tDT3HcFri@magnolia>
References: <Y69UsO7tDT3HcFri@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Adjust fstests as needed to support the XFS metadata directory feature,
and add some new tests for online fsck and fuzz testing of the ondisk
metadata.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=metadir

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=metadir

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=metadir

xfsdocs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-documentation.git/log/?h=metadir
---
 common/filter      |    7 +++-
 common/repair      |    4 ++
 common/xfs         |   90 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 tests/xfs/007      |   16 +++++----
 tests/xfs/030      |    1 +
 tests/xfs/033      |    1 +
 tests/xfs/050      |    1 +
 tests/xfs/122.out  |    1 +
 tests/xfs/153      |    1 +
 tests/xfs/1546     |   37 +++++++++++++++++++++
 tests/xfs/1546.out |    4 ++
 tests/xfs/1547     |   37 +++++++++++++++++++++
 tests/xfs/1547.out |    4 ++
 tests/xfs/1548     |   37 +++++++++++++++++++++
 tests/xfs/1548.out |    4 ++
 tests/xfs/1549     |   38 ++++++++++++++++++++++
 tests/xfs/1549.out |    4 ++
 tests/xfs/1550     |   37 +++++++++++++++++++++
 tests/xfs/1550.out |    4 ++
 tests/xfs/1551     |   37 +++++++++++++++++++++
 tests/xfs/1551.out |    4 ++
 tests/xfs/1552     |   37 +++++++++++++++++++++
 tests/xfs/1552.out |    4 ++
 tests/xfs/1553     |   38 ++++++++++++++++++++++
 tests/xfs/1553.out |    4 ++
 tests/xfs/1562     |    9 +----
 tests/xfs/1563     |    9 +----
 tests/xfs/1564     |    9 +----
 tests/xfs/1565     |    9 +----
 tests/xfs/1566     |    9 +----
 tests/xfs/1567     |    9 +----
 tests/xfs/1568     |    9 +----
 tests/xfs/1569     |    9 +----
 tests/xfs/178      |    1 +
 tests/xfs/206      |    3 +-
 tests/xfs/299      |    1 +
 tests/xfs/330      |    6 +++
 tests/xfs/509      |   21 +++++++++++-
 tests/xfs/529      |    5 +--
 tests/xfs/530      |    6 +--
 tests/xfs/769      |    2 +
 41 files changed, 491 insertions(+), 78 deletions(-)
 create mode 100755 tests/xfs/1546
 create mode 100644 tests/xfs/1546.out
 create mode 100755 tests/xfs/1547
 create mode 100644 tests/xfs/1547.out
 create mode 100755 tests/xfs/1548
 create mode 100644 tests/xfs/1548.out
 create mode 100755 tests/xfs/1549
 create mode 100644 tests/xfs/1549.out
 create mode 100755 tests/xfs/1550
 create mode 100644 tests/xfs/1550.out
 create mode 100755 tests/xfs/1551
 create mode 100644 tests/xfs/1551.out
 create mode 100755 tests/xfs/1552
 create mode 100644 tests/xfs/1552.out
 create mode 100755 tests/xfs/1553
 create mode 100644 tests/xfs/1553.out

