Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C862CD611C
	for <linux-xfs@archiver.kernel.org>; Mon,  9 Oct 2023 18:18:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377469AbjJISSa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 9 Oct 2023 14:18:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377414AbjJISSa (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 9 Oct 2023 14:18:30 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 384F49C;
        Mon,  9 Oct 2023 11:18:29 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C632FC433C7;
        Mon,  9 Oct 2023 18:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1696875508;
        bh=JsBqHwzGEm/ttdPIPP3SSlRQdInjHVPt7JxIxMiWzIQ=;
        h=Subject:From:To:Cc:Date:From;
        b=DgqR7Ksi00MjnuS6EiwlQcbJXde/YH1Ptxem9kNu2WxUo1H6jzQ8BDCkxf5K+uqn1
         3J2tjd1+p50kI3KU+mJDDOH7rzDpc5IUxPS6ruUyM+SSb2TaF+Tdaz6HWw8Qk8HOmJ
         S6PTZkXwv20ivX5denRTxa69mh0NJ8xx5nKbjHlppEWkfBBvK9sts2Btr7VGTdU9Cq
         TzHtVVw05p30rJV99zoMSySESnC4xELQF3KlEe71jJ5lr00eHjq+faxOB3fZHRy15u
         TzaTukSbK5yJsPR8Mu51b9AHAOW7XXT0BSq1Zha/ka9293h8ms9Zh3grSToNusAwDE
         JaWiGw02Za7Lg==
Subject: [PATCHSET 0/3] fstests: random fixes for v2023.10.08
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     tytso@mit.edu, jack@suse.cz, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 09 Oct 2023 11:18:28 -0700
Message-ID: <169687550821.3948976.6892161616008393594.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here's the usual odd fixes for fstests.

If you're going to start using this code, I strongly recommend pulling
from my git trees, which are linked below.

This has been running on the djcloud for months with no problems.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=random-fixes

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-fixes
---
 .../aio-dio-append-write-read-race.c               |    2 +-
 tests/generic/269                                  |    2 +-
 tests/xfs/051                                      |    2 +-
 tests/xfs/178                                      |    9 ++++++++-
 tests/xfs/178.out                                  |    2 --
 5 files changed, 11 insertions(+), 6 deletions(-)

