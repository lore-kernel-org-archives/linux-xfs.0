Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2230C4320E
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 00:10:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AC5D260F6B
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 00:10:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233544AbhG1AKU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 27 Jul 2021 20:10:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:56440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232731AbhG1AKU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Jul 2021 20:10:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9468E60F23;
        Wed, 28 Jul 2021 00:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627431019;
        bh=pfDqea+rGnqMRtSdD7OecDac9cqSrbCvqcFD59EjCBA=;
        h=Subject:From:To:Cc:Date:From;
        b=nT2FL5oNbfY5uSTSss6csOgVcRS9SYcDq4dJu9oKiV4zkT1Xih8T9vE4mzdlVTKWr
         NVK+jwlYaEaV45lkLjlVRKmkmvxQMG6i+JXatQaUIAw4Tsuwwm3lUlUfs2CPTQIDkI
         ONgLgS1yIpPpjUW5HLy4Ycv4Xp37PGcwpL6NjYzhJIb+6cuu0TqmAVPHVlILGH9yWg
         bvHZXRSYuOqHVnZLKSdUlkLdlyGjhgodEndvrleMDQ/egZcLW2QDy2apD5vHrIMuFg
         yIP9y08BpTMAmWUTY0udHMCQSM78KYCGEHJ6CQDFAZUCq6qOXpKh/M/QskMV3hJkEQ
         ua9MNOlfO/9/g==
Subject: [PATCHSET 0/3] fstests: exercise code refactored in 5.14
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 27 Jul 2021 17:10:19 -0700
Message-ID: <162743101932.3428896.8510279402246446036.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Add a few tests to exercise code that got refactored in 5.14.  The xattr
tests shook out some bugs in the big extended attributes refactoring,
and the nested shutdown test simulates the process of recovering after a
VM host filesystem goes down and the guests have to recover.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=new-tests-for-5.14
---
 tests/generic/724     |   57 +++++++++++++++
 tests/generic/724.out |    2 +
 tests/generic/725     |  136 +++++++++++++++++++++++++++++++++++
 tests/generic/725.out |    2 +
 tests/xfs/778         |  190 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/778.out     |    2 +
 6 files changed, 389 insertions(+)
 create mode 100755 tests/generic/724
 create mode 100644 tests/generic/724.out
 create mode 100755 tests/generic/725
 create mode 100644 tests/generic/725.out
 create mode 100755 tests/xfs/778
 create mode 100644 tests/xfs/778.out

