Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C54F9C3DA7C
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 22:29:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235266AbiL3W3F (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 17:29:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229821AbiL3W3E (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 17:29:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95D001C90C;
        Fri, 30 Dec 2022 14:29:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3128261C17;
        Fri, 30 Dec 2022 22:29:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D6D1C433EF;
        Fri, 30 Dec 2022 22:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672439342;
        bh=os+K+va8d1tbPqZV0o2zBc6Xpaq89j9f8WJKk0XjXp4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=qlnFMdATcjNLO6sVVP/4ZgQp6eJ7WaCwo8VP9denhRCp9FhKqMgl1SI4NWGE7HhOJ
         F4Hbk0D6YEpHy/DYtuBY9NTBcGHn8sZO8BPKBbRnmejHQRu36U0cQsU4hAjlCUl4xa
         1E9hyOrCebeoH6DR5R58P5S8viLwNowqYH2uF8tfE/Vj4D/jpZw66FN6gv3QVW74V+
         TGNXWNdDhVG3WRpjZl226jIR7rFSC6Rw/mUDydcAoBDnWQjS6oGJ7b5AGRCCYr6Wyp
         3dqU0fOfd4gSDdL5P31OTwUEXTx2YVwYE6BbFs88PMIHBFamzEwbn6EB0iEHdT0LUQ
         6UX6fKlQWgblg==
Subject: [PATCHSET v24.0 0/3] fstests: refactor GETFSMAP stress tests
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:12:57 -0800
Message-ID: <167243837772.695156.17793145241363597974.stgit@magnolia>
In-Reply-To: <Y69UceeA2MEpjMJ8@magnolia>
References: <Y69UceeA2MEpjMJ8@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Refactor the fsmap racing tests to use the general scrub stress loop
infrastructure that we've now created, and then add a bit more
functionality so that we can test racing remounting the filesystem
readonly and readwrite.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=refactor-fsmap-stress
---
 common/fuzzy      |  161 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 ltp/fsstress.c    |   18 ++++++
 tests/xfs/517     |   91 +-----------------------------
 tests/xfs/517.out |    4 -
 tests/xfs/732     |   38 +++++++++++++
 tests/xfs/732.out |    2 +
 tests/xfs/847     |   38 +++++++++++++
 tests/xfs/847.out |    2 +
 tests/xfs/848     |   38 +++++++++++++
 tests/xfs/848.out |    2 +
 10 files changed, 300 insertions(+), 94 deletions(-)
 create mode 100755 tests/xfs/732
 create mode 100644 tests/xfs/732.out
 create mode 100755 tests/xfs/847
 create mode 100644 tests/xfs/847.out
 create mode 100755 tests/xfs/848
 create mode 100644 tests/xfs/848.out

