Return-Path: <SRS0=lWMA=WT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6AB4C41514
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Aug 2019 01:08:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A7107233A2
	for <linux-xfs@archiver.kernel.org>; Fri, 23 Aug 2019 01:08:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729205AbfHWBI6 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 22 Aug 2019 21:08:58 -0400
Received: from icp-osb-irony-out2.external.iinet.net.au ([203.59.1.155]:5547
        "EHLO icp-osb-irony-out2.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732613AbfHWBI6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 22 Aug 2019 21:08:58 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2A3AwAROl9d/3Wz0XYNWB4BBgcGgWe?=
 =?us-ascii?q?DBYEuhCCPVgEBBoERihGRIwkBAQEBAQEBAQEnEAEBhDoDAoMEOBMCCQEBAQQ?=
 =?us-ascii?q?BAgEBBgMBhVhChVknBFIoDQImAkkWgzaBdqtQc38zGoQaAQsBhhmBDCiBY4o?=
 =?us-ascii?q?keIEHgREzgx2CYQEDhGqCWASMPYJXhTJdQpV3CYIfhmmNbwyCJYcwhAYDimC?=
 =?us-ascii?q?VQ5I+gXlNLgqDJwkWim47hUxligYrgiUBAQ?=
X-IPAS-Result: =?us-ascii?q?A2A3AwAROl9d/3Wz0XYNWB4BBgcGgWeDBYEuhCCPVgEBB?=
 =?us-ascii?q?oERihGRIwkBAQEBAQEBAQEnEAEBhDoDAoMEOBMCCQEBAQQBAgEBBgMBhVhCh?=
 =?us-ascii?q?VknBFIoDQImAkkWgzaBdqtQc38zGoQaAQsBhhmBDCiBY4okeIEHgREzgx2CY?=
 =?us-ascii?q?QEDhGqCWASMPYJXhTJdQpV3CYIfhmmNbwyCJYcwhAYDimCVQ5I+gXlNLgqDJ?=
 =?us-ascii?q?wkWim47hUxligYrgiUBAQ?=
X-IronPort-AV: E=Sophos;i="5.64,419,1559491200"; 
   d="scan'208";a="231796596"
Received: from unknown (HELO [192.168.1.222]) ([118.209.179.117])
  by icp-osb-irony-out2.iinet.net.au with ESMTP; 23 Aug 2019 08:59:17 +0800
Subject: [PATCH v2 00/15] xfs: mount API patch series
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Dave Chinner <dchinner@redhat.com>,
        David Howells <dhowells@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Date:   Fri, 23 Aug 2019 08:59:16 +0800
Message-ID: <156652158924.2607.14608448087216437699.stgit@fedora-28>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch series adds support to xfs for the new kernel mount API
as described in the LWN article at https://lwn.net/Articles/780267/.

In the article there's a lengthy description of the reasons for
adopting the API and problems expected to be resolved by using it.

The series has been applied to the repository located at
git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git, and built, and
the xfstests suite run against it.

I didn't see any failures that look like they are related to mounting.

Changes from the initial posting of the series:
- changed .name to uppercase in fs_parameter_description to ensure
  consistent error log messages between the vfs parser and the xfs
  parameter parser.
- clearify comment above xfs_parse_param() about when possibly
  allocated mp->m_logname or mp->m_rtname are freed.
- factor out xfs_remount_rw() and xfs_remount_ro() from  xfs_remount().
- changed xfs_mount_alloc() to not set super block in xfs_mount so it
  can be re-used when switching to the mount-api.
- fixed don't check for NULL when calling kfree() in xfs_fc_free().
- refactored xfs_parseargs() in an attempt to highlight the code
  that actually changes in converting to use the new mount api.
- dropped xfs-mount-api-rename-xfs_fill_super.patch, it didn't seem
  necessary.
- move comment about remount difficulties above xfs_reconfigure()
  and increase line length to try and make the comment managable.
- add patch vfs-Create-fs_context-aware-mount_bdev-replacement.patch
  that adds the vfs_get_block_super() needed by the series.

The patch "vfs: Create fs_context-aware mount_bdev() replacement" is
currently included in linux-next so there will be conflicts if this
series is merged in the next merge window so please be aware of it.

---

David Howells (1):
      vfs: Create fs_context-aware mount_bdev() replacement

Ian Kent (14):
      xfs: mount-api - add fs parameter description
      xfs: mount-api - refactor suffix_kstrtoint()
      xfs: mount-api - refactor xfs_parseags()
      xfs: mount-api - make xfs_parse_param() take context .parse_param() args
      xfs: mount-api - move xfs_parseargs() validation to a helper
      xfs: mount-api - refactor xfs_fs_fill_super()
      xfs: mount-api - add xfs_get_tree()
      xfs: mount-api - add xfs_remount_rw() helper
      xfs: mount-api - add xfs_remount_ro() helper
      xfs: mount api - add xfs_reconfigure()
      xfs: mount-api - add xfs_fc_free()
      xfs: mount-api - dont set sb in xfs_mount_alloc()
      xfs: mount-api - switch to new mount-api
      xfs: mount-api - remove legacy mount functions


 fs/fs_context.c            |    2 
 fs/super.c                 |  111 +++++
 fs/xfs/xfs_super.c         |  949 ++++++++++++++++++++++++--------------------
 include/linux/fs_context.h |    9 
 4 files changed, 631 insertions(+), 440 deletions(-)

--
Ian
