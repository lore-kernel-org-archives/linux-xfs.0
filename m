Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9744C197A0
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Nov 2023 19:35:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbjKTTfN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Nov 2023 14:35:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbjKTTfM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Nov 2023 14:35:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA3A8B9
        for <linux-xfs@vger.kernel.org>; Mon, 20 Nov 2023 11:35:09 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5092FC433C7;
        Mon, 20 Nov 2023 19:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700508909;
        bh=z5t+NDwY5/kJc2KrzYF7jl+E61eWwxJU1dAPnD0f9mk=;
        h=Subject:From:To:Cc:Date:From;
        b=ZDOCzXBTOFH3QqXejTYEJcdu33/qd5GMCVmsSFbM0VsrgnNP6YlPFohFA2DwVj9Ln
         SeAA1v00ACK46FyHriRn3nRdCs5Vy354syrcQ9n7lfOijzOUKdOi9HDUzhA1saAkIL
         9yHCI6EhUr6kg72Jj9Uj5MH7SfPYMftePvSjShtC6g/kbkzLhEhZHxIsNFv34b9Uu7
         LdWiUWG59Wl8NIKxQ565Gv2FeSuEi16pL/tW3lmnkQXsLqcFeCuIldKwDDLaukIfmO
         uv6A/xjV4kvwP/Br7H6src4cxjqjYtnBTI+QqFWMgmVW2OyjMoy/MUjsPNse5DzR4c
         jOBaOuRReoZjA==
Subject: [PATCHSET 0/2] fstests: random fixes for v2023.11.19
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, guan@eryu.me, fstests@vger.kernel.org
Date:   Mon, 20 Nov 2023 11:35:08 -0800
Message-ID: <170050890870.536459.4420904342934916414.stgit@frogsfrogsfrogs>
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
 tests/generic/734     |    3 ++-
 tests/generic/734.out |    2 +-
 tests/xfs/604         |    3 ++-
 3 files changed, 5 insertions(+), 3 deletions(-)
 rename tests/{xfs/601 => generic/734} (98%)
 rename tests/{xfs/601.out => generic/734.out} (78%)

