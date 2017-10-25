Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:56302 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932162AbdJYS5H (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 25 Oct 2017 14:57:07 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5C90F5F159
        for <linux-xfs@vger.kernel.org>; Wed, 25 Oct 2017 18:57:07 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 41A8B61F32
        for <linux-xfs@vger.kernel.org>; Wed, 25 Oct 2017 18:57:07 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v2 0/3] xfs: miscellaneous log recovery fixes
Date: Wed, 25 Oct 2017 14:57:02 -0400
Message-Id: <20171025185705.64983-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

Here's v2 of the log recovery fixups for filesystems with undersized
logs and the v4 NULL buffer verifier problem. The most significant
change is that patch 1 is rewritten to take a different approach to
sanity check the log block addresses used during log recovery cycle and
record verification. Specifically, it validates the log block number
used for each buffer on read or write. Also, I've dropped patch 4 for
now since I've not heard anything to suggest it's really necessary. 

Brian

v2:
- Use xlog buffer validation rather than explicit checks.
- Don't push AIL on log recovery error.
- Drop patch 4 (rfc).
- Fix up commit logs.
v1: https://marc.info/?l=linux-xfs&m=150877001230751&w=2

Brian Foster (3):
  xfs: more robust recovery xlog buffer validation
  xfs: fix log block underflow during recovery cycle verification
  xfs: drain the buffer LRU on mount

 fs/xfs/xfs_log.c         | 16 ++++++++++++++++
 fs/xfs/xfs_log_recover.c | 40 +++++++++++++++++++++++++---------------
 2 files changed, 41 insertions(+), 15 deletions(-)

-- 
2.9.5

