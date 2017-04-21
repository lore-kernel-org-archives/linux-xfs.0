Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55956 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1161119AbdDUMWO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 21 Apr 2017 08:22:14 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1B72AC00AFD5
        for <linux-xfs@vger.kernel.org>; Fri, 21 Apr 2017 12:22:14 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F07B690EE7
        for <linux-xfs@vger.kernel.org>; Fri, 21 Apr 2017 12:22:13 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH v3 0/2] xfs: quotacheck vs. dquot reclaim deadlock
Date: Fri, 21 Apr 2017 08:22:11 -0400
Message-Id: <1492777333-60156-1-git-send-email-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi all,

This incorporates Dave's feedback from review of v2 with one exception:

- After taking another look at xfs_qm_quotacheck(), it appears to
  intentionally jump to the normal exit path of the function in various
  error situations. I therefore opted to not to create a new error label
  for post delwri submit errors, since we still do the cancellation in
  the case of success as well. If desired, we can append a broader
  refactoring patch for that function, separate from the patches that
  fix bugs.

Brian

v3:
- Dropped the rfc/experiment patch.
- Created a _delwri_cancel() helper function.
- Refactored _delwri_pushbuf() to expect an unlocked buffer.
- Updated _delwri_pushbuf() with more detailed comments around delwri
  queue logic and reference counting.
v2: http://www.spinics.net/lists/linux-xfs/msg04483.html
- Added quotacheck error handling fixup patch.
- Push buffers with flush locked dquots for deadlock avoidance rather
  than bypass dquot reclaim.
- Added RFC patch for quotacheck early buffer list submission.
v1: http://www.spinics.net/lists/linux-xfs/msg04304.html

Brian Foster (2):
  xfs: fix up quotacheck buffer list error handling
  xfs: push buffer of flush locked dquot to avoid quotacheck deadlock

 fs/xfs/xfs_buf.c   | 84 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_buf.h   |  2 ++
 fs/xfs/xfs_qm.c    | 35 ++++++++++++++++++-----
 fs/xfs/xfs_trace.h |  1 +
 4 files changed, 115 insertions(+), 7 deletions(-)

-- 
2.7.4

