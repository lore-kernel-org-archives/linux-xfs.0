Return-Path: <SRS0=4ojB=6G=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E8F0C5518F
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 17:54:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13A622075A
	for <linux-xfs@archiver.kernel.org>; Wed, 22 Apr 2020 17:54:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UQhDTUrG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726592AbgDVRyh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 22 Apr 2020 13:54:37 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:29161 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726181AbgDVRyh (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 22 Apr 2020 13:54:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587578075;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=dBwV14e/ZmngMehU3JK6il0OANXFtRdWGAwlcibzgQ0=;
        b=UQhDTUrGHGtqxdfNJqGVtUaMZp0GnP1W3/G3OUV+NV+tkvr1ksEu/TtLnDsNZrpeBIaepg
        tw83QZYsUWu+rQF3gf2gf4YdaEsiMWzWm3fF+0mf6S4SkdgR27MaATkCQhAq7ys12UhZCG
        cXdy9h0h0XQxv0S6BNiOwBivvvyowUE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-368-UWtfKTUkPNylOtUQTaFnMQ-1; Wed, 22 Apr 2020 13:54:31 -0400
X-MC-Unique: UWtfKTUkPNylOtUQTaFnMQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 79314107ACC7
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 17:54:30 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 33F126084C
        for <linux-xfs@vger.kernel.org>; Wed, 22 Apr 2020 17:54:30 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH v2 00/13] xfs: flush related error handling cleanups
Date:   Wed, 22 Apr 2020 13:54:16 -0400
Message-Id: <20200422175429.38957-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

Here's a v2 of the various error handling cleanup patches. I opted to
retain and slightly rework the xfs_qm_dqflush() error handling patch
into something that seems a bit more graceful by simply expanding the
error path to include the buffer association. The dqflush verifier check
has been fixed up to cover the in-core structure instead of being
removed (note that this results in a small tweak to patch 7, but I
retained the R-b tags from v1). Finally, a couple new patches are
inserted to combine the AIL item removal functions and remove unused
shutdown types. Various other small changes are noted in the changelog
below.

Thoughts, reviews, flames appreciated.

Brian

git repo: https://github.com/bsfost/linux-xfs/tree/xfs-flush-error-handli=
ng-cleanups-v2

v2:
- Rename some helper functions.
- Fix up dquot flush verifier instead of removing it.
- Drop quotaoff push handler removal patch.
- Reuse existing ratelimit state for buffer error messages.
- Combine AIL removal helpers.
- Refactor iflush error handling rework to update log item.
- Remove unused shutdown types.
v1: https://lore.kernel.org/linux-xfs/20200417150859.14734-1-bfoster@redh=
at.com/

Brian Foster (13):
  xfs: refactor failed buffer resubmission into xfsaild
  xfs: factor out buffer I/O failure simulation code
  xfs: fallthru to buffer attach on error and simplify error handling
  xfs: remove unnecessary shutdown check from xfs_iflush()
  xfs: ratelimit unmount time per-buffer I/O error message
  xfs: fix duplicate verification from xfs_qm_dqflush()
  xfs: abort consistently on dquot flush failure
  xfs: elide the AIL lock on log item failure tracking
  xfs: clean up AIL log item removal functions
  xfs: combine xfs_trans_ail_[remove|delete]()
  xfs: remove unused iflush stale parameter
  xfs: random buffer write failure errortag
  xfs: remove unused shutdown types

 fs/xfs/libxfs/xfs_errortag.h  |   4 +-
 fs/xfs/libxfs/xfs_inode_buf.c |   7 +-
 fs/xfs/xfs_bmap_item.c        |   2 +-
 fs/xfs/xfs_buf.c              |  42 ++++++++++--
 fs/xfs/xfs_buf.h              |   2 +
 fs/xfs/xfs_buf_item.c         |  96 ++++----------------------
 fs/xfs/xfs_buf_item.h         |   2 -
 fs/xfs/xfs_dquot.c            |  84 +++++++++--------------
 fs/xfs/xfs_dquot_item.c       |  17 +----
 fs/xfs/xfs_error.c            |   3 +
 fs/xfs/xfs_extfree_item.c     |   2 +-
 fs/xfs/xfs_fsops.c            |   5 +-
 fs/xfs/xfs_icache.c           |   2 +-
 fs/xfs/xfs_inode.c            | 124 ++++++++++------------------------
 fs/xfs/xfs_inode_item.c       |  39 ++---------
 fs/xfs/xfs_inode_item.h       |   2 +-
 fs/xfs/xfs_mount.h            |   2 -
 fs/xfs/xfs_refcount_item.c    |   2 +-
 fs/xfs/xfs_rmap_item.c        |   2 +-
 fs/xfs/xfs_trans_ail.c        |  79 ++++++++++++++++------
 fs/xfs/xfs_trans_priv.h       |  23 +------
 21 files changed, 200 insertions(+), 341 deletions(-)

--=20
2.21.1

