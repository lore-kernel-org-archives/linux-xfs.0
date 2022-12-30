Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C513C3DA7D
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:18:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235705AbiL3XSs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:18:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235266AbiL3XSr (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:18:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2381FCCB;
        Fri, 30 Dec 2022 15:18:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3C7A7B81D67;
        Fri, 30 Dec 2022 23:18:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAA8EC433EF;
        Fri, 30 Dec 2022 23:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672442323;
        bh=R0jr2ekA3L81mokwcDowxOS4c75O6OeWmSs7vh/1pqY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=WxR4+evmFE9hbEAAKQHcL3AFAdlLb3YERQWl3enMyuTfHIVllInGZ+cmRIjANJzqp
         1I5bxxmRAo1RCLxJnatyr39QtIjEG3eESHb3uFnRDZ59n9PF10+LyDaIAI5Qn4Z06b
         AoLHEXT1tQ/aOC4sTklcuvCMOGcufOQfiyB64WegMB7XV8P08ZnGSY5Fqk+IbG2j+d
         XyYFyIMFiabSZDuo651WOghgPtxVBsOC/9PCMWOiD1bD72Hlq3AQa8T+xn3boNZ9Kn
         K1TN/u2DM3HgTiMn1AkGdxF7OSR548BvpnusvY2XtsAZv4pVJhWjKmkJZkkS/v/4Me
         gdYsxR1KievRg==
Subject: [PATCHSET v24.0 0/5] fstests: strengthen fuzz testing
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:44 -0800
Message-ID: <167243878469.731641.981302372644525592.stgit@magnolia>
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

This patchset fills some gaps in our fuzz testing for XFS.  I forgot to
include fuzz testing the data fork mappings of directories and xattrs to
see how scrub responds to nonsensical file maps, and I omitted tests to
fuzz the realtime metadata.  Add those.

Finally, add a new fuzz testing strategy known as bothrepair.  This
simulates what system administrators are most likely to do upon
receiving a health alert about a pet filesystem -- try to repair it with
xfs_scrub, and if that doesn't work, unmount the filesystem and run
xfs_repair.  Between the two, we ought to be able to fix every possible
problem.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=more-fuzz-testing
---
 common/fuzzy       |  139 +++++++++++++++++++++++++++++++++++++++++++++++++++-
 tests/xfs/1500     |   35 +++++++++++++
 tests/xfs/1500.out |    4 +
 tests/xfs/1501     |   35 +++++++++++++
 tests/xfs/1501.out |    4 +
 tests/xfs/1502     |   45 +++++++++++++++++
 tests/xfs/1502.out |    6 ++
 tests/xfs/1503     |   35 +++++++++++++
 tests/xfs/1503.out |    4 +
 tests/xfs/1504     |   38 ++++++++++++++
 tests/xfs/1504.out |    4 +
 tests/xfs/1505     |   38 ++++++++++++++
 tests/xfs/1505.out |    4 +
 tests/xfs/1506     |   38 ++++++++++++++
 tests/xfs/1506.out |    4 +
 tests/xfs/1507     |   38 ++++++++++++++
 tests/xfs/1507.out |    4 +
 tests/xfs/1508     |   39 +++++++++++++++
 tests/xfs/1508.out |    4 +
 tests/xfs/1509     |   39 +++++++++++++++
 tests/xfs/1509.out |    4 +
 tests/xfs/1510     |   39 +++++++++++++++
 tests/xfs/1510.out |    4 +
 tests/xfs/1511     |   40 +++++++++++++++
 tests/xfs/1511.out |    4 +
 tests/xfs/1512     |   40 +++++++++++++++
 tests/xfs/1512.out |    5 ++
 tests/xfs/1513     |   40 +++++++++++++++
 tests/xfs/1513.out |    5 ++
 tests/xfs/1514     |   40 +++++++++++++++
 tests/xfs/1514.out |    5 ++
 tests/xfs/1515     |   42 ++++++++++++++++
 tests/xfs/1515.out |    5 ++
 tests/xfs/1516     |   40 +++++++++++++++
 tests/xfs/1516.out |    5 ++
 tests/xfs/1517     |   40 +++++++++++++++
 tests/xfs/1517.out |    5 ++
 tests/xfs/1518     |   40 +++++++++++++++
 tests/xfs/1518.out |    5 ++
 tests/xfs/1519     |   41 +++++++++++++++
 tests/xfs/1519.out |    5 ++
 tests/xfs/1520     |   42 ++++++++++++++++
 tests/xfs/1520.out |    5 ++
 tests/xfs/1521     |   42 ++++++++++++++++
 tests/xfs/1521.out |    5 ++
 tests/xfs/1522     |   42 ++++++++++++++++
 tests/xfs/1522.out |    5 ++
 tests/xfs/1523     |   42 ++++++++++++++++
 tests/xfs/1523.out |    5 ++
 tests/xfs/1524     |   40 +++++++++++++++
 tests/xfs/1524.out |    5 ++
 tests/xfs/1525     |   40 +++++++++++++++
 tests/xfs/1525.out |    5 ++
 tests/xfs/1526     |   40 +++++++++++++++
 tests/xfs/1526.out |    5 ++
 tests/xfs/1527     |   40 +++++++++++++++
 tests/xfs/1527.out |    5 ++
 tests/xfs/1530     |   40 +++++++++++++++
 tests/xfs/1530.out |    4 +
 tests/xfs/1531     |   40 +++++++++++++++
 tests/xfs/1531.out |    5 ++
 tests/xfs/1532     |   40 +++++++++++++++
 tests/xfs/1532.out |    5 ++
 tests/xfs/1533     |   40 +++++++++++++++
 tests/xfs/1533.out |    5 ++
 tests/xfs/1534     |   38 ++++++++++++++
 tests/xfs/1534.out |    4 +
 tests/xfs/1535     |   38 ++++++++++++++
 tests/xfs/1535.out |    4 +
 tests/xfs/1536     |   38 ++++++++++++++
 tests/xfs/1536.out |    4 +
 tests/xfs/1537     |   41 +++++++++++++++
 tests/xfs/1537.out |    5 ++
 tests/xfs/1554     |   48 ++++++++++++++++++
 tests/xfs/1554.out |   10 ++++
 tests/xfs/1555     |   48 ++++++++++++++++++
 tests/xfs/1555.out |   10 ++++
 tests/xfs/1556     |   48 ++++++++++++++++++
 tests/xfs/1556.out |   10 ++++
 tests/xfs/1557     |   48 ++++++++++++++++++
 tests/xfs/1557.out |   10 ++++
 tests/xfs/1558     |   48 ++++++++++++++++++
 tests/xfs/1558.out |   10 ++++
 tests/xfs/1559     |   48 ++++++++++++++++++
 tests/xfs/1559.out |   10 ++++
 tests/xfs/1560     |   49 ++++++++++++++++++
 tests/xfs/1560.out |   10 ++++
 tests/xfs/1561     |   49 ++++++++++++++++++
 tests/xfs/1561.out |   10 ++++
 tests/xfs/1562     |   41 +++++++++++++++
 tests/xfs/1562.out |    4 +
 tests/xfs/1563     |   41 +++++++++++++++
 tests/xfs/1563.out |    4 +
 tests/xfs/1564     |   41 +++++++++++++++
 tests/xfs/1564.out |    4 +
 tests/xfs/1565     |   41 +++++++++++++++
 tests/xfs/1565.out |    4 +
 tests/xfs/1566     |   42 ++++++++++++++++
 tests/xfs/1566.out |    4 +
 tests/xfs/1567     |   42 ++++++++++++++++
 tests/xfs/1567.out |    4 +
 tests/xfs/1568     |   41 +++++++++++++++
 tests/xfs/1568.out |    4 +
 tests/xfs/1569     |   41 +++++++++++++++
 tests/xfs/1569.out |    4 +
 tests/xfs/1570     |   36 +++++++++++++
 tests/xfs/1570.out |    4 +
 tests/xfs/1571     |   36 +++++++++++++
 tests/xfs/1571.out |    4 +
 tests/xfs/1572     |   38 ++++++++++++++
 tests/xfs/1572.out |    4 +
 tests/xfs/1573     |   37 ++++++++++++++
 tests/xfs/1573.out |    4 +
 113 files changed, 2717 insertions(+), 4 deletions(-)
 create mode 100755 tests/xfs/1500
 create mode 100644 tests/xfs/1500.out
 create mode 100755 tests/xfs/1501
 create mode 100644 tests/xfs/1501.out
 create mode 100755 tests/xfs/1502
 create mode 100644 tests/xfs/1502.out
 create mode 100755 tests/xfs/1503
 create mode 100644 tests/xfs/1503.out
 create mode 100755 tests/xfs/1504
 create mode 100644 tests/xfs/1504.out
 create mode 100755 tests/xfs/1505
 create mode 100644 tests/xfs/1505.out
 create mode 100755 tests/xfs/1506
 create mode 100644 tests/xfs/1506.out
 create mode 100755 tests/xfs/1507
 create mode 100644 tests/xfs/1507.out
 create mode 100755 tests/xfs/1508
 create mode 100644 tests/xfs/1508.out
 create mode 100755 tests/xfs/1509
 create mode 100644 tests/xfs/1509.out
 create mode 100755 tests/xfs/1510
 create mode 100644 tests/xfs/1510.out
 create mode 100755 tests/xfs/1511
 create mode 100644 tests/xfs/1511.out
 create mode 100755 tests/xfs/1512
 create mode 100644 tests/xfs/1512.out
 create mode 100755 tests/xfs/1513
 create mode 100644 tests/xfs/1513.out
 create mode 100755 tests/xfs/1514
 create mode 100644 tests/xfs/1514.out
 create mode 100755 tests/xfs/1515
 create mode 100644 tests/xfs/1515.out
 create mode 100755 tests/xfs/1516
 create mode 100644 tests/xfs/1516.out
 create mode 100755 tests/xfs/1517
 create mode 100644 tests/xfs/1517.out
 create mode 100755 tests/xfs/1518
 create mode 100644 tests/xfs/1518.out
 create mode 100755 tests/xfs/1519
 create mode 100644 tests/xfs/1519.out
 create mode 100755 tests/xfs/1520
 create mode 100644 tests/xfs/1520.out
 create mode 100755 tests/xfs/1521
 create mode 100644 tests/xfs/1521.out
 create mode 100755 tests/xfs/1522
 create mode 100644 tests/xfs/1522.out
 create mode 100755 tests/xfs/1523
 create mode 100644 tests/xfs/1523.out
 create mode 100755 tests/xfs/1524
 create mode 100644 tests/xfs/1524.out
 create mode 100755 tests/xfs/1525
 create mode 100644 tests/xfs/1525.out
 create mode 100755 tests/xfs/1526
 create mode 100644 tests/xfs/1526.out
 create mode 100755 tests/xfs/1527
 create mode 100644 tests/xfs/1527.out
 create mode 100755 tests/xfs/1530
 create mode 100644 tests/xfs/1530.out
 create mode 100755 tests/xfs/1531
 create mode 100644 tests/xfs/1531.out
 create mode 100755 tests/xfs/1532
 create mode 100644 tests/xfs/1532.out
 create mode 100755 tests/xfs/1533
 create mode 100644 tests/xfs/1533.out
 create mode 100755 tests/xfs/1534
 create mode 100644 tests/xfs/1534.out
 create mode 100755 tests/xfs/1535
 create mode 100644 tests/xfs/1535.out
 create mode 100755 tests/xfs/1536
 create mode 100644 tests/xfs/1536.out
 create mode 100755 tests/xfs/1537
 create mode 100644 tests/xfs/1537.out
 create mode 100755 tests/xfs/1554
 create mode 100644 tests/xfs/1554.out
 create mode 100755 tests/xfs/1555
 create mode 100644 tests/xfs/1555.out
 create mode 100755 tests/xfs/1556
 create mode 100644 tests/xfs/1556.out
 create mode 100755 tests/xfs/1557
 create mode 100644 tests/xfs/1557.out
 create mode 100755 tests/xfs/1558
 create mode 100644 tests/xfs/1558.out
 create mode 100755 tests/xfs/1559
 create mode 100644 tests/xfs/1559.out
 create mode 100755 tests/xfs/1560
 create mode 100644 tests/xfs/1560.out
 create mode 100755 tests/xfs/1561
 create mode 100644 tests/xfs/1561.out
 create mode 100755 tests/xfs/1562
 create mode 100644 tests/xfs/1562.out
 create mode 100755 tests/xfs/1563
 create mode 100644 tests/xfs/1563.out
 create mode 100755 tests/xfs/1564
 create mode 100644 tests/xfs/1564.out
 create mode 100755 tests/xfs/1565
 create mode 100644 tests/xfs/1565.out
 create mode 100755 tests/xfs/1566
 create mode 100644 tests/xfs/1566.out
 create mode 100755 tests/xfs/1567
 create mode 100644 tests/xfs/1567.out
 create mode 100755 tests/xfs/1568
 create mode 100644 tests/xfs/1568.out
 create mode 100755 tests/xfs/1569
 create mode 100644 tests/xfs/1569.out
 create mode 100755 tests/xfs/1570
 create mode 100644 tests/xfs/1570.out
 create mode 100755 tests/xfs/1571
 create mode 100644 tests/xfs/1571.out
 create mode 100755 tests/xfs/1572
 create mode 100755 tests/xfs/1572.out
 create mode 100755 tests/xfs/1573
 create mode 100644 tests/xfs/1573.out

