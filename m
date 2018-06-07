Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:34354 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S932100AbeFGMlZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 7 Jun 2018 08:41:25 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 673D3407048B
        for <linux-xfs@vger.kernel.org>; Thu,  7 Jun 2018 12:41:25 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 498092026DEF
        for <linux-xfs@vger.kernel.org>; Thu,  7 Jun 2018 12:41:25 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 0/2] xfs: fix buffer delwri queue state race
Date: Thu,  7 Jun 2018 08:41:23 -0400
Message-Id: <20180607124125.38700-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

This is an attempt to fix a race when queuing a buffer to a delwri queue
that happens to already sit on a delwri queue wait list. The problem is
reproduced by xfs/305 under particular conditions. The details are
described in the commit log description of patch 2.

This survives xfstests and repeated runs of xfs/305. Note that the test
still reproduces the known log deadlock problem when quotaoff runs
against a heavily loaded fs. I've hacked around that problem locally to
rule it out from repetition testing of xfs/305.

Thoughts, reviews, flames appreciated.

Brian

Brian Foster (2):
  xfs: define internal buf flag for delwri queue wait list
  xfs: allow delwri requeue of wait listed buffers

 fs/xfs/xfs_buf.c | 79 +++++++++++++++++++++++++++++++-----------------
 fs/xfs/xfs_buf.h |  4 ++-
 2 files changed, 54 insertions(+), 29 deletions(-)

-- 
2.17.1

