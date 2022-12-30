Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55191C3DA7D
	for <linux-xfs@archiver.kernel.org>; Fri, 30 Dec 2022 23:18:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235703AbiL3XSc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 18:18:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235266AbiL3XSb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 18:18:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D475C1C134;
        Fri, 30 Dec 2022 15:18:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8CE97B81DA2;
        Fri, 30 Dec 2022 23:18:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BCD4C433D2;
        Fri, 30 Dec 2022 23:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672442308;
        bh=R7X0JNdN6AkQSlJz3axl/e/SD6PVuwryn0G/aPc02nw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=LgTGZAKe+cc6Z+FIisf4QPoZShUlbN7qToJGVPQ+NFuV9tq414l/BbRl5qkccsDVV
         GZrpXBbV7hgYP3kVNuinaShKD7VJBptmun6NZOLpIwx/GNZQyLG9Zp1J/X88voKtC5
         9R9Ny3LMro1+uRfMrKFGvYOZG3V2r0LCP++zyErbPf/pIGD/r1CnlgQY7ksYJCb2LT
         WtkeEx5pZNquZzWW94gFPKZ1IFaUV7GCfqa7DH7BkktTQV4mEMkjS9d9589kuiTSQO
         OCzvIuiOi7jzt5gddqmZDlBlREOLCj+jJRrfFhqKYaih++ymW7MD9jV3ch2o03bfIV
         htzXK2MgJYXog==
Subject: [PATCHSET v24.0 00/24] fstests: improve xfs fuzzing
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:39 -0800
Message-ID: <167243877899.730387.9276624623424433346.stgit@magnolia>
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

There are a ton of improvements to the XFS fuzzing code in this update.
We start by disabling by default two parts of the fuzz testing that
don't lead to predictable golden output: fuzzing with the 'random' verb,
and fuzzing the 'LSN' field.

Next, refactor the inner fuzzing loop so that each of the four repair
strategies are broken out into separate functions, as well as the
post-repair attempts to modify the filesystem.  This splitting makes it
much easier to fix some longstanding problems with the fuzzer logic.  We
also revise the strategies a bit so that they more accurately reflect
the intended usage patterns of the repair programs.

Then, strengthen other parts of the fuzzing -- we make the post-repair
modification exercises a bit more strenuous by running fsstress on the
repaired fs; adding an evaluation of xfs_check vs.  xfs_repair; and
making it possible to check the xfs health reporting system.  The
xfs_check changes were key to disabling it in fstests in 2021.

Finally, improve the array handling of the xfs fuzz tests so that we
actually know about array indices as a first class concept, instead of
the current mucking around we do with regular expressions.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=fuzzer-improvements
---
 common/fuzzy  |  513 ++++++++++++++++++++++++++++++++++++++++++++-------------
 common/xfs    |   80 +++++++++
 tests/xfs/354 |    7 +
 tests/xfs/355 |    7 +
 tests/xfs/358 |    5 -
 tests/xfs/359 |    5 -
 tests/xfs/360 |    5 -
 tests/xfs/361 |    5 -
 tests/xfs/362 |    5 -
 tests/xfs/363 |    5 -
 tests/xfs/364 |    5 -
 tests/xfs/365 |    5 -
 tests/xfs/366 |    5 -
 tests/xfs/367 |    5 -
 tests/xfs/368 |    5 -
 tests/xfs/369 |    5 -
 tests/xfs/370 |    5 -
 tests/xfs/371 |    5 -
 tests/xfs/372 |    5 -
 tests/xfs/373 |    7 +
 tests/xfs/410 |    5 -
 tests/xfs/411 |    5 -
 tests/xfs/455 |    7 +
 tests/xfs/457 |    5 -
 tests/xfs/458 |    5 -
 tests/xfs/459 |    5 -
 tests/xfs/460 |    5 -
 tests/xfs/461 |    5 -
 tests/xfs/462 |    5 -
 tests/xfs/463 |    5 -
 tests/xfs/464 |    7 +
 tests/xfs/483 |    5 -
 32 files changed, 606 insertions(+), 147 deletions(-)

