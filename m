Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:40574 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753741AbeFOSFh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 15 Jun 2018 14:05:37 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1EC85818BAF8
        for <linux-xfs@vger.kernel.org>; Fri, 15 Jun 2018 18:05:37 +0000 (UTC)
Received: from bfoster.bos.redhat.com (dhcp-41-2.bos.redhat.com [10.18.41.2])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 07AB92166BB2
        for <linux-xfs@vger.kernel.org>; Fri, 15 Jun 2018 18:05:37 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 0/2] xfs: fix buffer delwri queue state race
Date: Fri, 15 Jun 2018 14:05:34 -0400
Message-Id: <20180615180536.17282-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

I'll post the xfs_buf_submit[_wait]() refactoring patch separately after
waiting for some feedback in the previous thread and/or doing some
testing. It really has nothing to do with fixing this problem, anyways.

Brian

v3:
- Leave tracepoint in __xfs_buf_submit and kill
  trace_xfs_buf_submit_wait().
- Comment tweaks.
v2: https://marc.info/?l=linux-xfs&m=152888792024447&w=2
- Implement sync buffer I/O for sync delwri queues instead of buffer
  wait list stealing.
v1: https://marc.info/?l=linux-xfs&m=152837528705511&w=2

Brian Foster (2):
  xfs: refactor buffer submission into a common helper
  xfs: use sync buffer I/O for sync delwri queue submission

 fs/xfs/xfs_buf.c   | 163 ++++++++++++++++++++++-----------------------
 fs/xfs/xfs_trace.h |   1 -
 2 files changed, 78 insertions(+), 86 deletions(-)

-- 
2.17.1

