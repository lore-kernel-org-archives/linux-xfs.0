Return-Path: <SRS0=+mcJ=XP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9AFFC49ED7
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Sep 2019 09:55:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C4D01208C0
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Sep 2019 09:55:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408594AbfITJzi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Sep 2019 05:55:38 -0400
Received: from icp-osb-irony-out5.external.iinet.net.au ([203.59.1.221]:6242
        "EHLO icp-osb-irony-out5.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2405771AbfITJzh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 20 Sep 2019 05:55:37 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2BAAgDfoYRd/zmr0HYNVx0BAQUBBwU?=
 =?us-ascii?q?BgWcCgWyBF4EvhCKPZwEBBosrhR+MCQkBAQEBAQEBAQEnEAEBhDoDAoMsOBM?=
 =?us-ascii?q?CDAEBAQQBAQEBAQUDAYVYQk4BEAGEeScEUigNAiYCSRaDNoF2qwZzfzMahB0?=
 =?us-ascii?q?BCwGGBIEMKAGBYoo+eIEHgRGDUIJhAQOEaoJYBIxNJIJlhU1fQpZHgiyHBY4?=
 =?us-ascii?q?gDI4HA4sOli2TE4F5TS4KgycJFjGBfheBBAEChyE7hUxmgmuJbyuCJwEB?=
X-IPAS-Result: =?us-ascii?q?A2BAAgDfoYRd/zmr0HYNVx0BAQUBBwUBgWcCgWyBF4Evh?=
 =?us-ascii?q?CKPZwEBBosrhR+MCQkBAQEBAQEBAQEnEAEBhDoDAoMsOBMCDAEBAQQBAQEBA?=
 =?us-ascii?q?QUDAYVYQk4BEAGEeScEUigNAiYCSRaDNoF2qwZzfzMahB0BCwGGBIEMKAGBY?=
 =?us-ascii?q?oo+eIEHgRGDUIJhAQOEaoJYBIxNJIJlhU1fQpZHgiyHBY4gDI4HA4sOli2TE?=
 =?us-ascii?q?4F5TS4KgycJFjGBfheBBAEChyE7hUxmgmuJbyuCJwEB?=
X-IronPort-AV: E=Sophos;i="5.64,528,1559491200"; 
   d="scan'208";a="253491426"
Received: from unknown (HELO [192.168.1.222]) ([118.208.171.57])
  by icp-osb-irony-out5.iinet.net.au with ESMTP; 20 Sep 2019 17:55:33 +0800
Subject: [PATCH v3 00/16] xfs: mount API patch series
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Eric Sandeen <sandeen@sandeen.net>
Date:   Fri, 20 Sep 2019 17:55:33 +0800
Message-ID: <156897321789.20210.339237101446767141.stgit@fedora-28>
User-Agent: StGit/unknown-version
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

This patch series add support to xfs for the new kernel mount API
as described in the LWN article at https://lwn.net/Articles/780267/.

In the article there's a lengthy description of the reasons for
adopting the API and problems expected to be resolved by using it.

The series has been applied to the repository located at
git://git.kernel.org/pub/scm/fs/xfs/xfs-linux.git, and built and
some simple tests run on it.

Other things that continue to cause me concern:

- Message logging.
  There is error logging done in the VFS by the mount-api code, some
  is VFS specific while some is file system specific. This can lead
  to duplicated and often inconsistent logging.

  The mount-api feature of saving error message text to the mount
  context for later retrival by fsopen()/fsconfig()/fsmount() users
  is the reason the mount-api log macros are present. But, at the
  moment (last time I looked), these macros will either log the
  error message or save it to the mount context, there's not yet
  a way to modify this behaviour which can lead to messages,
  possibly needed for debug purposes, being lost. There's also
  the pr_xxx() log functions (not a problem for xfs AFAICS) that
  aren't aware of the mount context.

  Consequently I've tried to keep logging as it is in xfs and
  also tried to avoid duplicate log messages, deferring mount
  context messaging until more work has been done on mount-api
  convesions so that further discussions can take place.

- That large comment about mount option handling.
  I'm not sure what to do about that large comment. On one hand
  I think there's useful information there and don't really want
  to para-phrase it (largely) out of existence, not knowing of
  a sensible place to put it so I can refer to it instead.

Changes for v3:
- fix struct xfs_fs_context initialization in xfs_parseargs().
- move call to xfs_validate_params() below label "done".
- if allocation of xfs_mount fails return ENOMEM immediately.
- remove erroneous kfree(mp) in xfs_fill_super().
- move the removal of xfs_fs_remount() and xfs_test_remount_options()
  to the switch to mount api patch.
- retain original usage of distinct <option>, no<option> usage.
- fix line length and a white space problem in xfs_parseargs().
- defer introduction of struct fs_context_operations until mount
  api implementation.
- don't use a new line for the void parameter of xfs_mount_alloc().
- check for -ENOPARAM in xfs_parse_param() to report invalid options
  using the options switch (to avoid double entry log messages).
- remove obolete mount option biosize.
- try and make comment in xfs_fc_free() more understandable.

Changes for v2:
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

Al Viro has sent a pull request to Linus for the patch containing
the vfs_get_block_super() just recently so there will be conflicts
if this series is merged without dropping that patch.
---

David Howells (1):
      vfs: Create fs_context-aware mount_bdev() replacement

Ian Kent (15):
      xfs: remove very old mount option
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
 fs/xfs/xfs_super.c         |  960 ++++++++++++++++++++++++--------------------
 include/linux/fs_context.h |    9 
 4 files changed, 642 insertions(+), 440 deletions(-)

--
Ian
