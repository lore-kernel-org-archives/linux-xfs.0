Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40630 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932300AbdJJQr6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 10 Oct 2017 12:47:58 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 735EB883C3
        for <linux-xfs@vger.kernel.org>; Tue, 10 Oct 2017 16:47:58 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5573469554
        for <linux-xfs@vger.kernel.org>; Tue, 10 Oct 2017 16:47:58 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 0/2] xfs: test support for xattr inactivate
Date: Tue, 10 Oct 2017 12:47:54 -0400
Message-Id: <20171010164756.28390-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

This series adds some testability to the issue fixed by "xfs: reinit
btree pointer on attr tree inactivation walk." Patch 1 adds an assert
and patch 2 adds an error injection tag to disable buffer LRU caching. I
have an xfstests test that reproduces the aforementioned problem
reliably using the error injection tag.

Note that patch 1 is kind of a cautious attempt to detect the issue. I'm
wondering if the better fix is to pass -1 if we indeed should not ever
expect to hit a hole in this particular path. Thoughts?

Brian

Brian Foster (2):
  xfs: assert that xattr inactivation never reaches a hole
  xfs: buffer lru reference count error injection tag

 fs/xfs/xfs_attr_inactive.c |  1 +
 fs/xfs/xfs_buf.c           | 16 ++++++++++++++++
 fs/xfs/xfs_buf.h           |  5 +----
 fs/xfs/xfs_error.c         |  3 +++
 fs/xfs/xfs_error.h         |  4 +++-
 5 files changed, 24 insertions(+), 5 deletions(-)

-- 
2.9.5

