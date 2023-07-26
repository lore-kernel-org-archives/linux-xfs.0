Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EE73C001DE
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Jul 2023 01:56:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230331AbjGZB4n (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Jul 2023 21:56:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230286AbjGZB4m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jul 2023 21:56:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9846D26B8;
        Tue, 25 Jul 2023 18:56:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34EA96109A;
        Wed, 26 Jul 2023 01:56:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 875CBC433C7;
        Wed, 26 Jul 2023 01:56:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690336600;
        bh=r/WtS3QJ7vnL6XyzmGTlfnmMahHV19ajNnOpeL0nKO0=;
        h=Subject:From:To:Cc:Date:From;
        b=UcOz8dAqmahlHSvRRNxc0hGiRLGuLXbxaAM6cWIhF5lSJoYAHXx9yzJu8qPh1tkXc
         GTOWCmWUBNcrcmXJK6UWb7lz2xr9xVMMXfq25CZULHebYHMj6UADQ89cuLgN/YsFUJ
         Eu1VD99P0kqxSjpMcUWoBvi0DOTCE8TRK3MNLZdU8ZoXtWq/l1YViOzPG4h6GkdjJ2
         IBQSxX6NQ4p6YlUvRO57LR2M8ZLwebCI+H1ZaNJTjQX6XXHTSYXO2kxBx4EZhtO6j4
         5blknE8ks3TB4IYIAnn6sCel1WExsz68B1qMhRP/ceRtvVCtPDFJ1g8aoEeazawxmJ
         P4bECtpxSSz0g==
Subject: [PATCHSET v2 0/2] fstests: testing improvements
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     kent.overstreet@linux.dev, tytso@mit.edu,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 25 Jul 2023 18:56:39 -0700
Message-ID: <169033659987.3222210.11071346898413396128.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here's a couple of patches that improve the test framework itself.  The
first patch adds a -smoketest option that will run the generic file IO
loop tests each for 4 minutes apiece.  The goal here is to provide a
quick means for developers to check that their changes didn't cause
major problems.

The second patch adds kernel gcov coverage reporting if the kernel is
set up to record such information.

v2: move the gcov code to a separate file, document what -smoketest does
    and who the target audience is

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=testing-improvements
---
 README              |   12 +++++++
 check               |   24 +++++++++++++-
 common/gcov         |   87 +++++++++++++++++++++++++++++++++++++++++++++++++++
 doc/group-names.txt |    1 +
 tests/generic/475   |    2 +
 tests/generic/476   |    2 +
 tests/generic/521   |    2 +
 tests/generic/522   |    2 +
 tests/generic/642   |    2 +
 9 files changed, 128 insertions(+), 6 deletions(-)
 create mode 100644 common/gcov

