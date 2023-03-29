Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C2C2C6FD18
	for <linux-xfs@archiver.kernel.org>; Wed, 29 Mar 2023 00:58:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229682AbjC2A6H (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 28 Mar 2023 20:58:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbjC2A6G (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 28 Mar 2023 20:58:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 517E01FE2;
        Tue, 28 Mar 2023 17:58:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E2ECF61A21;
        Wed, 29 Mar 2023 00:58:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B321C433EF;
        Wed, 29 Mar 2023 00:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680051485;
        bh=dHDb11lm5pqalOUbvM0H38rnZIWu3hu4818ZZaCZJrY=;
        h=Subject:From:To:Cc:Date:From;
        b=uWefCC+pSLCCwlZ+5mzVv6/uIcZnoMFkKTWwsApjzVbLkfa4Om+Fokv5YD7RTynVn
         DbsABVW7clPDmy5JLQ5tG5qKd3P9bdlA8L6lgi+Dtg1M/BQEJ2bpjRS306KVj/bRRd
         zKqgMWtMfzJeG/zWfHAyX1CIHDy0FgWzwYRFcO4m7xlwNNnocxR2P6UJpJ+757dR7P
         4qOxN07o3dDKpelwQ5Ux/Hi1oVKbJmoLZvbEBZJS2BiC/VaLhSk7Gmo9CPlIDj1d9e
         P/Wpp/ONy6IWTwA0hxoRKe3j2s7RrkMdBlOk5WK5GBO3GBP8XUQLDkL3mu2vR09/e8
         RYqtqopSoUVXA==
Subject: [PATCHSET 0/3] fstests: random fixes for v2023.03.26
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 28 Mar 2023 17:58:04 -0700
Message-ID: <168005148468.4147931.1986862498548445502.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here's the usual odd fixes for fstests.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=random-fixes

xfsprogs git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfsprogs-dev.git/log/?h=random-fixes

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=random-fixes
---
 common/punch      |    8 ++++++++
 common/rc         |   15 +++++++++++++++
 common/report     |    2 +-
 common/xfs        |   11 +++++++++++
 tests/generic/251 |    2 +-
 tests/generic/260 |    2 +-
 6 files changed, 37 insertions(+), 3 deletions(-)

