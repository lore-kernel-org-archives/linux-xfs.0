Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26B3DC0015E
	for <linux-xfs@archiver.kernel.org>; Wed, 19 Jul 2023 01:10:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229823AbjGSBKy (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Jul 2023 21:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbjGSBKx (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Jul 2023 21:10:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 413751BCA;
        Tue, 18 Jul 2023 18:10:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B486960FB0;
        Wed, 19 Jul 2023 01:10:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 194E7C433C7;
        Wed, 19 Jul 2023 01:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689729051;
        bh=fQ6Eo6i7Ozsno2PdqVBhqXSMiwCU7j5cgin6PKpvFJU=;
        h=Subject:From:To:Cc:Date:From;
        b=WwMXqnXXxKeGuKHRgoknhBSRemWPzuLkQpdX3mlnyevQ8pLJil2/zhJeoj3z7kOn6
         hV0cW4Qw8GV2QvOLCXQowB7y2Ofkv3U5PZwDqenCqNNd8EK2KLkZSoKTKtygJfid/V
         A0yI6qQZV6PLDgfg8G8qP7179Jn3YDh1WdH1C3T2OPLiquROjZttUjj9qM9P6GmAbx
         lsTs+g0r7FjanELUGXjc62cnRaSlbJNcMk9Sn9u/uNgou9SCnMqbZt8gDqpB2kg0xP
         Ef1i2hBXFI/tNlMnLD8n8SaCMA9RpEnws3O/BR8LBzMzQP8AJkrPMSFd3YPYXkL8Ez
         QCc4DoqaUkD1w==
Subject: [PATCHSET 0/2] fstests: testing improvements
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     tytso@mit.edu, kent.overstreet@linux.dev,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 18 Jul 2023 18:10:50 -0700
Message-ID: <168972905065.1698606.6829635791058054610.stgit@frogsfrogsfrogs>
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

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=testing-improvements
---
 README              |    3 ++
 check               |   92 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 doc/group-names.txt |    1 +
 tests/generic/475   |    2 +
 tests/generic/476   |    2 +
 tests/generic/521   |    2 +
 tests/generic/522   |    2 +
 tests/generic/642   |    2 +
 8 files changed, 100 insertions(+), 6 deletions(-)

