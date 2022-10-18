Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE6B7C43219
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Oct 2022 22:45:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbiJRWp0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Oct 2022 18:45:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbiJRWpZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Oct 2022 18:45:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E86E52FCC;
        Tue, 18 Oct 2022 15:45:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EDCA161705;
        Tue, 18 Oct 2022 22:45:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52EB9C433C1;
        Tue, 18 Oct 2022 22:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666133122;
        bh=wseIEonr9CAhKpSv7GJ/oXMOzUQI6PxtbTsslsAQtUE=;
        h=Subject:From:To:Cc:Date:From;
        b=PPmIBZ7ziJzmsC9ow+EYdfSaF7mUJDz0JeqyBEWYVbuQoD8mIWe9BnyF2E5Gg1Z+x
         zP75Z0uMDA5Jomh6+Z/a8eRJgH++NLxQ5y1pqbbB5Vfu8A7JJjWWOvLARwhUWiRaz8
         XTd+aS6wZvTzMTS30LbVhlTkGqx7++C/b/En1w/ZO5oK4xSyKzedV+i5hcVMXJiSEA
         kkpgi0g8QlwaglFBJqZqwahm2HuU8jSshG2/Tf9VWIDHr5aKEtBKdv1Hz7BXb6Xb5Q
         6G9egk2wSbidzRjzRu55jVlw6ceO6Ajs7G3+4rG9KBRdEJdnWhjl2uTZ2Gy38aUjgD
         naoS2jv4bOAZQ==
Subject: [PATCHSET v23.1 0/3] fstests: refactor xfs geometry computation
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 18 Oct 2022 15:45:21 -0700
Message-ID: <166613312194.868141.5162859918517610030.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

There are numerous tests that do things based on the geometry of a
mounted filesystem.  Before we start adding more tests that do this
(e.g. online fsck stress tests), refactor them into common/xfs helpers.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=refactor-xfs-geometry
---
 common/populate |   20 +++++------
 common/rc       |    9 ++++-
 common/xfs      |  103 +++++++++++++++++++++++++++++++++++++++++++++++++------
 tests/xfs/097   |    2 +
 tests/xfs/099   |    2 +
 tests/xfs/100   |    2 +
 tests/xfs/101   |    2 +
 tests/xfs/102   |    2 +
 tests/xfs/105   |    2 +
 tests/xfs/112   |    2 +
 tests/xfs/113   |    2 +
 tests/xfs/146   |    2 +
 tests/xfs/147   |    2 +
 tests/xfs/151   |    3 +-
 tests/xfs/271   |    2 +
 tests/xfs/307   |    2 +
 tests/xfs/308   |    2 +
 tests/xfs/348   |    2 +
 tests/xfs/530   |    3 +-
 19 files changed, 125 insertions(+), 41 deletions(-)

