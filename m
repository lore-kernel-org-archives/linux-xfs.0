Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C240FC432BE
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Aug 2021 23:53:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA24C6101A
	for <linux-xfs@archiver.kernel.org>; Tue, 17 Aug 2021 23:53:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236730AbhHQXxs (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Aug 2021 19:53:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:46502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236690AbhHQXxs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 17 Aug 2021 19:53:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 822F061008;
        Tue, 17 Aug 2021 23:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629244394;
        bh=8kCdBVocxHWXvZnyxHcSInELZLr0AO+6E445iqbYmaY=;
        h=Subject:From:To:Cc:Date:From;
        b=XbZTmbR4bSC4lu9kanbVmlChmfRv1dW6EiM9pN5U3QnSt64oaD28YqKXM6veqK8mQ
         ZeSYvhWGn+F5YY+1xgNuunDo40zCgfI2Y9nuVkzbFKoX5Z4XQIqlSNEMM8f4v0EcWD
         bc7ktjyJ6SYCP/tnDk4MDHEeNfjrKbumaQtSEHEc6bbMyO5S8tmSJN7Ty94Em/BXqS
         84kRkU+9MMJJLy0q5D/0uzR5bAdsbWvFj1ojNf/ZJaHlFiFJxrVnm21oCRm1q7lkbM
         Fcw4UqydaVRve8KR7Y5kjqaibg9xGtu7+Omum+8JO3EBEQ1khNhpqYIb1FH8iZrX7y
         k5TB8wSI+/oQQ==
Subject: [PATCHSET v2 0/2] fstests: exercise code refactored in 5.14
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 17 Aug 2021 16:53:14 -0700
Message-ID: <162924439425.779465.16029390956507261795.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Add one new test to exercise code that got refactored in 5.14.  The
nested shutdown test simulates the process of recovering after a VM host
filesystem goes down and the guests have to recover.

v2: fix some bugs pointed out by the maintainer, add cpu offlining stress test

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=new-tests-for-5.14
---
 common/rc             |   20 +++++++
 tests/generic/725     |  136 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/725.out |    2 +
 tests/generic/726     |   71 ++++++++++++++++++++++++++
 tests/generic/726.out |    2 +
 5 files changed, 231 insertions(+)
 create mode 100755 tests/generic/725
 create mode 100644 tests/generic/725.out
 create mode 100755 tests/generic/726
 create mode 100644 tests/generic/726.out

