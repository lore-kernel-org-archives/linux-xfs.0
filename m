Return-Path: <SRS0=y7rh=X4=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BA82C10F14
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Oct 2019 10:25:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B98221A4C
	for <linux-xfs@archiver.kernel.org>; Thu,  3 Oct 2019 10:25:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728469AbfJCKZW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 3 Oct 2019 06:25:22 -0400
Received: from icp-osb-irony-out7.external.iinet.net.au ([203.59.1.107]:42874
        "EHLO icp-osb-irony-out7.external.iinet.net.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726199AbfJCKZW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 3 Oct 2019 06:25:22 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2CsAQDHy5Vd/7q70HYNWRwBAQEEAQE?=
 =?us-ascii?q?MBAEBgWeBbwWBF4EvhCKPKgMGgRGBI4h3j0WBZwkBAQEBAQEBAQEnEAEBhDs?=
 =?us-ascii?q?DAoJqOBMCDAEBAQQBAQEBAQUDAYVYQoVaJwRSKA0CJgJJFgqDLIF2rgx1fzM?=
 =?us-ascii?q?ahB4BCwGFfIEMKIFlikF4gQeBETOCKnOCYQEDgUeDJYJYBIxdJIIvN4VYYUO?=
 =?us-ascii?q?WVIIthwiOKwyOEwOLHJZJkyKBek0uCoMnCRYxgX8XgQQBAociO4VMZ45JK4I?=
 =?us-ascii?q?nAQE?=
X-IPAS-Result: =?us-ascii?q?A2CsAQDHy5Vd/7q70HYNWRwBAQEEAQEMBAEBgWeBbwWBF?=
 =?us-ascii?q?4EvhCKPKgMGgRGBI4h3j0WBZwkBAQEBAQEBAQEnEAEBhDsDAoJqOBMCDAEBA?=
 =?us-ascii?q?QQBAQEBAQUDAYVYQoVaJwRSKA0CJgJJFgqDLIF2rgx1fzMahB4BCwGFfIEMK?=
 =?us-ascii?q?IFlikF4gQeBETOCKnOCYQEDgUeDJYJYBIxdJIIvN4VYYUOWVIIthwiOKwyOE?=
 =?us-ascii?q?wOLHJZJkyKBek0uCoMnCRYxgX8XgQQBAociO4VMZ45JK4InAQE?=
X-IronPort-AV: E=Sophos;i="5.67,251,1566835200"; 
   d="scan'208";a="207652623"
Received: from unknown (HELO [192.168.1.222]) ([118.208.187.186])
  by icp-osb-irony-out7.iinet.net.au with ESMTP; 03 Oct 2019 18:25:18 +0800
Subject: [PATCH v4 00/17] xfs: mount API patch series
From:   Ian Kent <raven@themaw.net>
To:     linux-xfs <linux-xfs@vger.kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>,
        Eric Sandeen <sandeen@sandeen.net>,
        David Howells <dhowells@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Date:   Thu, 03 Oct 2019 18:25:18 +0800
Message-ID: <157009817203.13858.7783767645177567968.stgit@fedora-28>
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
some simple tests run on it along with the generic xfstests.

Other things that continue to cause me concern:

- Message logging.
  There is error logging done in the VFS by the mount-api code, some
  is VFS specific while some is file system specific. This can lead
  to duplicated and sometimes inconsistent logging.

  The mount-api feature of saving error message text to the mount
  context for later retrieval by fsopen()/fsconfig()/fsmount() users
  is the reason the mount-api log macros are present. But, at the
  moment (last time I looked), these macros will either log the
  error message or save it to the mount context. There's not yet
  a way to modify this behaviour so it which can lead to messages,
  possibly needed for debug purposes, not being sent to the kernel
  log. There's also the pr_xxx() log functions (not a problem for
  xfs AFAICS) that aren't aware of the mount context at all.

  In the xfs patches I've used the same method that is used in
  gfs2 and was suggested by Al Viro (essentially return the error
  if fs_parse() returns one) except that I've also not used the
  mount api log macros to minimise the possibility of lost log
  messages.

  This isn't the best so follow up patches for RFC (with a
  slightly wider audience) will be needed to try and improve
  this aspect of the mount api.

Changes for v4:
- changed xfs_fill_super() cleanup back to what it was in v2, until
  I can work out what's causing the problem had previously seen (I can't
  reproduce it myself), since it looks like it was right from the start.
- use get_tree_bdev() instead of vfs_get_block_super() in xfs_get_tree()
  as requested by Al Viro.
- removed redundant initialisation in xfs_fs_fill_super().
- fix long line in xfs_validate_params().
- no need to validate if parameter parsing fails, just return the error.
- summarise reconfigure comment about option handling, transfer bulk
  of comment to commit log message.
- use minimal change in xfs_parse_param(), deffer discussion of mount
  api logging improvements until later and with a wider audience.

Changes for v3:
- fix struct xfs_fs_context initialisation in xfs_parseargs().
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
- remove obsolete mount option biosize.
- try and make comment in xfs_fc_free() more understandable.

Changes for v2:
- changed .name to uppercase in fs_parameter_description to ensure
  consistent error log messages between the vfs parser and the xfs
  parameter parser.
- clarify comment above xfs_parse_param() about when possibly
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
  and increase line length to try and make the comment manageable.

Al Viro has sent a pull request to Linus for the patch containing
get_tree_bdev() recently and I think there's a small problem with
that patch too so there will be conflicts with merging this series
without dropping the first two patches of the series.

---

David Howells (1):
      vfs: Create fs_context-aware mount_bdev() replacement

Ian Kent (16):
      vfs: add missing blkdev_put() in get_tree_bdev()
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
      xfs: mount-api - remove remaining legacy mount code


 fs/super.c                 |   97 +++++
 fs/xfs/xfs_super.c         |  939 +++++++++++++++++++++++---------------------
 include/linux/fs_context.h |    5 
 3 files changed, 600 insertions(+), 441 deletions(-)

--
Ian
