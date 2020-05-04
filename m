Return-Path: <SRS0=lfYe=6S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F84DC3A5A9
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 14:12:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F6D520705
	for <linux-xfs@archiver.kernel.org>; Mon,  4 May 2020 14:12:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cSS3tyX8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729013AbgEDOMJ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 4 May 2020 10:12:09 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:37608 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729000AbgEDOMJ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 4 May 2020 10:12:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588601527;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=f+KQllpEXSezBNAose/wvqg+/OQoBt2E1id9F+H5VZ8=;
        b=cSS3tyX8i1Y2BMYnSxTjXVApZ5/zzJBguI/E1YUiH1D2HFNhtWoL/Pa8SzSKM0YI/e3Zlr
        6HbyBBsXTkbNvYXqjIFUOQD6S6fhMGWFv4sovHqxwEJUdBotcmtR9Ys22ZjJBBBh+HlyCK
        0C+EUvv/XPl33gajtmm5edX43q+O1tI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-450-h8fd6DrgOzOKwNqKYE1zoQ-1; Mon, 04 May 2020 10:11:55 -0400
X-MC-Unique: h8fd6DrgOzOKwNqKYE1zoQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E61C58014C0
        for <linux-xfs@vger.kernel.org>; Mon,  4 May 2020 14:11:54 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 9E0F81C92D
        for <linux-xfs@vger.kernel.org>; Mon,  4 May 2020 14:11:54 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v4 00/17] xfs: flush related error handling cleanups
Date:   Mon,  4 May 2020 10:11:37 -0400
Message-Id: <20200504141154.55887-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

I think everything has been reviewed to this point. Only minor changes
noted below in this release. A git repo is available here[1].

The only outstanding feedback that I'm aware of is Dave's comment on
patch 7 of v3 [2] regarding the shutdown assert check. I'm not aware of
any means to get through xfs_wait_buftarg() with a dirty buffer that
hasn't undergone the permanant error sequence and thus shut down the fs.
I'm personally fine with any option among dropping the assert, keeping
it or replacing it with a shutdown invocation because atm I don't see it
making much of a functional difference, but I left it alone because the
patch is otherwise reviewed.

Thoughts, reviews, flames appreciated.

Brian

[1] https://github.com/bsfost/linux-xfs/tree/xfs-flush-error-handling-cle=
anups-v4
[2] https://lore.kernel.org/linux-xfs/20200501112408.GB40250@bfoster/

v4:
- Remove unnecessary xfs_trans_ail_delete() comment.
- Add Fixes: tag to dqflush duplicate verification patch.
v3: https://lore.kernel.org/linux-xfs/20200429172153.41680-1-bfoster@redh=
at.com/
- Drop flags param from xfs_buf_ioend_fail().
- Fix up iflush error handling patch subject and comments.
- Drop failed buffer ->ail_lock bypass patch.
- Split up AIL removal cleanup patch and dropped switch of call from
  xfs_buf_item_put().
- Rework XBF_WRITE_FAIL to reflect current buffer state.
- Create helper for ratelimited buffer alerts and use appropriately.
- Use BLK_STS_IOERR instead of errno_to_blk_status().
- Drop unused param from xfs_imap_to_bp().
v2: https://lore.kernel.org/linux-xfs/20200422175429.38957-1-bfoster@redh=
at.com/
- Rename some helper functions.
- Fix up dquot flush verifier instead of removing it.
- Drop quotaoff push handler removal patch.
- Reuse existing ratelimit state for buffer error messages.
- Combine AIL removal helpers.
- Refactor iflush error handling rework to update log item.
- Remove unused shutdown types.
v1: https://lore.kernel.org/linux-xfs/20200417150859.14734-1-bfoster@redh=
at.com/

Brian Foster (17):
  xfs: refactor failed buffer resubmission into xfsaild
  xfs: factor out buffer I/O failure code
  xfs: simplify inode flush error handling
  xfs: remove unnecessary shutdown check from xfs_iflush()
  xfs: reset buffer write failure state on successful completion
  xfs: refactor ratelimited buffer error messages into helper
  xfs: ratelimit unmount time per-buffer I/O error alert
  xfs: fix duplicate verification from xfs_qm_dqflush()
  xfs: abort consistently on dquot flush failure
  xfs: acquire ->ail_lock from xfs_trans_ail_delete()
  xfs: use delete helper for items expected to be in AIL
  xfs: drop unused shutdown parameter from xfs_trans_ail_remove()
  xfs: combine xfs_trans_ail_[remove|delete]()
  xfs: remove unused iflush stale parameter
  xfs: random buffer write failure errortag
  xfs: remove unused shutdown types
  xfs: remove unused iget_flags param from xfs_imap_to_bp()

 fs/xfs/libxfs/xfs_errortag.h  |   4 +-
 fs/xfs/libxfs/xfs_inode_buf.c |  12 +--
 fs/xfs/libxfs/xfs_inode_buf.h |   2 +-
 fs/xfs/scrub/ialloc.c         |   3 +-
 fs/xfs/xfs_bmap_item.c        |   2 +-
 fs/xfs/xfs_buf.c              |  65 ++++++++++++----
 fs/xfs/xfs_buf.h              |   2 +
 fs/xfs/xfs_buf_item.c         | 106 +++++---------------------
 fs/xfs/xfs_buf_item.h         |   2 -
 fs/xfs/xfs_dquot.c            |  47 +++++-------
 fs/xfs/xfs_dquot_item.c       |  17 +----
 fs/xfs/xfs_error.c            |   3 +
 fs/xfs/xfs_extfree_item.c     |   2 +-
 fs/xfs/xfs_fsops.c            |   5 +-
 fs/xfs/xfs_icache.c           |   2 +-
 fs/xfs/xfs_inode.c            | 139 ++++++++++++----------------------
 fs/xfs/xfs_inode_item.c       |  28 +------
 fs/xfs/xfs_inode_item.h       |   2 +-
 fs/xfs/xfs_log_recover.c      |   2 +-
 fs/xfs/xfs_message.c          |  22 ++++++
 fs/xfs/xfs_message.h          |   3 +
 fs/xfs/xfs_mount.h            |   2 -
 fs/xfs/xfs_refcount_item.c    |   2 +-
 fs/xfs/xfs_rmap_item.c        |   2 +-
 fs/xfs/xfs_trans_ail.c        |  68 +++++++++++------
 fs/xfs/xfs_trans_priv.h       |  18 +----
 26 files changed, 231 insertions(+), 331 deletions(-)

--=20
2.21.1

