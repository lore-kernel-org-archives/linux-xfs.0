Return-Path: <SRS0=+p7O=6B=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27848C38A2D
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Apr 2020 15:09:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 08D882223D
	for <linux-xfs@archiver.kernel.org>; Fri, 17 Apr 2020 15:09:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HrR2u8zJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728426AbgDQPJH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 17 Apr 2020 11:09:07 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:60961 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728867AbgDQPJG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 17 Apr 2020 11:09:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587136145;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=WY6/P5ee0t7nvLilAgpZp++mPCcQcBegkGBljdYjfDY=;
        b=HrR2u8zJpo7MzTDBmva21lD94q4dTZm1vPQf7SnW9vm5Umat5KYzzmm9FkrwPEk9pZXWtr
        XyOUi14fOfokKicpbFweTN7GHFz/lDKKvfygGJ0xIlKUZNgoA5blN9UKlcJT01dAYNIDha
        MhisuRsnJaAJWdCapu6I5jMyejoRpv8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-260-e2hLDlYiPiyFfeGYFpYMaA-1; Fri, 17 Apr 2020 11:09:00 -0400
X-MC-Unique: e2hLDlYiPiyFfeGYFpYMaA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 227028017F3
        for <linux-xfs@vger.kernel.org>; Fri, 17 Apr 2020 15:09:00 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D226860BE0
        for <linux-xfs@vger.kernel.org>; Fri, 17 Apr 2020 15:08:59 +0000 (UTC)
From:   Brian Foster <bfoster@redhat.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 00/12] xfs: flush related error handling cleanups
Date:   Fri, 17 Apr 2020 11:08:47 -0400
Message-Id: <20200417150859.14734-1-bfoster@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Content-Transfer-Encoding: quoted-printable
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Hi all,

This actually started as what I intended to be a cleanup of xfsaild
error handling and the fact that unexpected errors are kind of lost in
the ->iop_push() handlers of flushable log items. Some discussion with
Dave on that is available here[1]. I was thinking of genericizing the
behavior, but I'm not so sure that is possible now given the error
handling requirements of the associated items.

While thinking through that, I ended up incorporating various cleanups
in the somewhat confusing and erratic error handling on the periphery of
xfsaild, such as the flush handlers. Most of these are straightforward
cleanups except for patch 9, which I think requires careful review and
is of debatable value. I have used patch 12 to run an hour or so of
highly concurrent fsstress load against it and will execute a longer run
over the weekend now that fstests has completed.

Thoughts, reviews, flames appreciated.

Brian

[1] https://lore.kernel.org/linux-xfs/20200331114653.GA53541@bfoster/

Brian Foster (12):
  xfs: refactor failed buffer resubmission into xfsaild
  xfs: factor out buffer I/O failure simulation code
  xfs: always attach iflush_done and simplify error handling
  xfs: remove unnecessary shutdown check from xfs_iflush()
  xfs: ratelimit unmount time per-buffer I/O error warning
  xfs: remove duplicate verification from xfs_qm_dqflush()
  xfs: abort consistently on dquot flush failure
  xfs: remove unnecessary quotaoff intent item push handler
  xfs: elide the AIL lock on log item failure tracking
  xfs: clean up AIL log item removal functions
  xfs: remove unused iflush stale parameter
  xfs: random buffer write failure errortag

 fs/xfs/libxfs/xfs_errortag.h  |   4 +-
 fs/xfs/libxfs/xfs_inode_buf.c |   7 +--
 fs/xfs/xfs_bmap_item.c        |   2 +-
 fs/xfs/xfs_buf.c              |  36 ++++++++---
 fs/xfs/xfs_buf.h              |   1 +
 fs/xfs/xfs_buf_item.c         |  86 ++++----------------------
 fs/xfs/xfs_buf_item.h         |   2 -
 fs/xfs/xfs_dquot.c            |  84 ++++++++------------------
 fs/xfs/xfs_dquot_item.c       |  31 +---------
 fs/xfs/xfs_error.c            |   3 +
 fs/xfs/xfs_extfree_item.c     |   2 +-
 fs/xfs/xfs_icache.c           |   2 +-
 fs/xfs/xfs_inode.c            | 110 +++++++++-------------------------
 fs/xfs/xfs_inode_item.c       |  39 +++---------
 fs/xfs/xfs_inode_item.h       |   2 +-
 fs/xfs/xfs_refcount_item.c    |   2 +-
 fs/xfs/xfs_rmap_item.c        |   2 +-
 fs/xfs/xfs_trans_ail.c        |  52 +++++++++++++++-
 fs/xfs/xfs_trans_priv.h       |  22 +++----
 19 files changed, 175 insertions(+), 314 deletions(-)

--=20
2.21.1

