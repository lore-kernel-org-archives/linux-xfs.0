Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ECCFC47088
	for <linux-xfs@archiver.kernel.org>; Wed, 26 May 2021 01:46:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5AC4E61090
	for <linux-xfs@archiver.kernel.org>; Wed, 26 May 2021 01:46:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231434AbhEZBsO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 May 2021 21:48:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:58070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230147AbhEZBsN (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 25 May 2021 21:48:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F4E061423;
        Wed, 26 May 2021 01:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621993603;
        bh=6jqZabQ60gjFRp8JeBDC/UJeqgPlwbRmkXDxgXPc8HY=;
        h=Subject:From:To:Cc:Date:From;
        b=YGP5NgdAOdh5AcOgR5EoXS6IgecnXmTgjJ/iCVrFLP2JRqYofTaeu1+dl5OtkNWCb
         k8WTCDKXFRDbCMpvLpxLRtJxdYVdyxpZa/7gltm+Sz+7qcF+rN0V9w7n1aCKcGZqXY
         uZv96xT9PzvTpY467+K8uj9CBDKWQjvEwDfETogwRJLymqsM9Pkq8Uw+kWXb7mXxja
         Iv00nw7VSXU2nirVltsitZLCx1ZMxgBVZ+44lZz7QS2LK9PRbMw+VHdNvfNis/OgFt
         2KFx+06s+NNASCllhdGVTqyQwFD6RXuRYJhOLB27zyM2kn29XXN5EP/13LqfTE2fyq
         4hYnPGvqbx+6w==
Subject: [PATCHSET RFC 00/10] fstests: move test group lists into test files
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 25 May 2021 18:46:42 -0700
Message-ID: <162199360248.3744214.17042613373014687643.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Test group files (e.g. tests/generic/group) are a pain to keep up.
Every week I rebase on Eryu's latest upstream, and every week I have to
slog through dozens of trivial merge conflicts because of the
groupfiles.  Moving tests is annoying because we have to maintain all
this code to move the group associations from one /group file to
another.

It doesn't need to be this way -- we could move each test's group
information into the test itself, and automatically generate the group
files as part of the make process.  This series does exactly that.

The first few patches add some convenient anchors for the new
per-testfile group tagging and a conversion script to migrate existing
test files.  Next there's a huge patch that is the results of running
the conversion script, followed by cleanup of the golden outputs.  After
that comes the build infrastructure to generate group files and other
tweaks to the existing maintainer scripts to use the new infrastructure.
Finally, remove the group files themselves and the (now unnecessary)
code that maintained them.

If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

fstests git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfstests-dev.git/log/?h=autogenerate-groupfiles
---
 common/test_names      |   19 +
 include/buildrules     |    6 
 new                    |  188 ++++----------
 tests/Makefile         |    4 
 tests/btrfs/001        |    8 -
 tests/btrfs/002        |    8 -
 tests/btrfs/003        |    8 -
 tests/btrfs/004        |    8 -
 tests/btrfs/006.out    |    2 
 tests/btrfs/012.out    |    2 
 tests/btrfs/Makefile   |    3 
 tests/btrfs/group      |  244 ------------------
 tests/ceph/Makefile    |    3 
 tests/ceph/group       |    4 
 tests/cifs/Makefile    |    3 
 tests/cifs/group       |    6 
 tests/ext4/Makefile    |    3 
 tests/ext4/group       |   62 ----
 tests/f2fs/Makefile    |    3 
 tests/f2fs/group       |    7 -
 tests/generic/184.out  |    2 
 tests/generic/Makefile |    3 
 tests/generic/group    |  662 ------------------------------------------------
 tests/nfs/Makefile     |    3 
 tests/nfs/group        |    6 
 tests/ocfs2/Makefile   |    3 
 tests/ocfs2/group      |    1 
 tests/overlay/Makefile |    3 
 tests/overlay/group    |  100 -------
 tests/perf/Makefile    |    3 
 tests/perf/group       |    1 
 tests/shared/Makefile  |    3 
 tests/shared/group     |    8 -
 tests/udf/Makefile     |    3 
 tests/udf/group        |    6 
 tests/xfs/Makefile     |    3 
 tests/xfs/group        |  622 ---------------------------------------------
 tools/convert-group    |   64 +++++
 tools/mkgroupfile      |   37 +++
 tools/mvtest           |   12 -
 tools/nextid           |    1 
 tools/nextid           |   39 +++
 tools/sort-group       |  112 --------
 43 files changed, 274 insertions(+), 2014 deletions(-)
 delete mode 100644 tests/btrfs/group
 delete mode 100644 tests/ceph/group
 delete mode 100644 tests/cifs/group
 delete mode 100644 tests/ext4/group
 delete mode 100644 tests/f2fs/group
 delete mode 100644 tests/generic/group
 delete mode 100644 tests/nfs/group
 delete mode 100644 tests/ocfs2/group
 delete mode 100644 tests/overlay/group
 delete mode 100644 tests/perf/group
 delete mode 100644 tests/shared/group
 delete mode 100644 tests/udf/group
 delete mode 100644 tests/xfs/group
 create mode 100755 tools/convert-group
 create mode 100755 tools/mkgroupfile
 delete mode 120000 tools/nextid
 create mode 100755 tools/nextid
 delete mode 100755 tools/sort-group

