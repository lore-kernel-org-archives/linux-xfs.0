Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60364 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751384AbdFFMI4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 6 Jun 2017 08:08:56 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 41D8880492
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2017 12:08:51 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2535417D82
        for <linux-xfs@vger.kernel.org>; Tue,  6 Jun 2017 12:08:51 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 0/2] xfs: fix a couple xfs_buf_log_item shutdown problems
Date: Tue,  6 Jun 2017 08:08:48 -0400
Message-Id: <1496750930-53954-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

This series fixes a couple filesystem shutdown corner cases related to
dealing with the xfs_buf_log_item reference count. Patch 1 fixes a
reference count leak that leads to an unmount hang due to a held buffer.
Patch 2 fixes a premature free of the bli that leads to a panic due to
use after free. Both of the above problems can be reproduced by running
generic/388 in a loop (though it may require 100-200 iterations).

I was originally considering reworking the bli reference counting, but I
don't have a clear idea on whether a cleaner solution is available atm.
These isolated fixes are lower risk and resolve the associated problems,
so should probably be considered independently regardless.

With these patches applied, generic/388 survives several thousand
iterations and otherwise no regressions are observed in my tests.
Thoughts, reviews, flames appreciated.

Brian

Brian Foster (2):
  xfs: release bli from transaction properly on fs shutdown
  xfs: remove bli from AIL before release on transaction abort

 fs/xfs/xfs_buf_item.c  | 21 ++++++++++++---------
 fs/xfs/xfs_trans_buf.c | 21 ++++++++++++++-------
 2 files changed, 26 insertions(+), 16 deletions(-)

-- 
2.7.5

