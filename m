Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49240 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752602AbdEJObx (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 10 May 2017 10:31:53 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B2B924E34D
        for <linux-xfs@vger.kernel.org>; Wed, 10 May 2017 14:31:52 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 95EBC7E842
        for <linux-xfs@vger.kernel.org>; Wed, 10 May 2017 14:31:52 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 0/2] xfs: make fatal assert failures conditional in debug mode
Date: Wed, 10 May 2017 10:31:49 -0400
Message-Id: <1494426711-6934-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

This version makes fatal asserts runtime and build time configurable.
Patch 1 creates the runtime tunable and patch 2 creates a Kconfig option
to control the default value of the runtime tunable. As before, default
DEBUG mode behavior is preserved (i.e., assert failures BUG() the
kernel).

Brian

v3:
- Add DEBUG mode sysfs tunable for runtime configuration.
- Refactor compile time flag to set default value of runtime flag.
v2: http://www.spinics.net/lists/linux-xfs/msg06520.html
- Clean up the Kconfig option help text.
v1: http://www.spinics.net/lists/linux-xfs/msg06498.html
- Use a new config option rather than reuse XFS_WARN.
- Disable BUG() in DEBUG mode by default and flip the logic of the new
  config option.
rfc: http://www.spinics.net/lists/linux-xfs/msg06390.html

Brian Foster (2):
  xfs: define bug_on_assert debug mode sysfs tunable
  xfs: define fatal assert build time tunable

 fs/xfs/Kconfig       | 13 +++++++++++++
 fs/xfs/xfs.h         |  4 ++++
 fs/xfs/xfs_globals.c |  5 +++++
 fs/xfs/xfs_message.c |  5 ++++-
 fs/xfs/xfs_sysctl.h  |  1 +
 fs/xfs/xfs_sysfs.c   | 33 +++++++++++++++++++++++++++++++++
 6 files changed, 60 insertions(+), 1 deletion(-)

-- 
2.7.4

