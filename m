Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48212 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726547AbeJCTYA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Oct 2018 15:24:00 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B166D3081D83
        for <linux-xfs@vger.kernel.org>; Wed,  3 Oct 2018 12:35:47 +0000 (UTC)
Received: from odin.usersys.redhat.com (unknown [10.40.205.15])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0CE625D77E
        for <linux-xfs@vger.kernel.org>; Wed,  3 Oct 2018 12:35:46 +0000 (UTC)
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH 0/2] xfs stats fixes
Date: Wed,  3 Oct 2018 14:35:35 +0200
Message-Id: <20181003123537.30965-1-cmaiolino@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi,

this week I found a bug in the code for xqmstat file in procfs, caused by wrong
offsets while reading the __xfsstats structure fields in xqmstat_proc_show.

This patchset aims to fix the bug (patch 1) and add a way to reduce the
likelyhood of creating the same error again.

xqmstat_proc_show() uses a loop to walk through the quota-specific fields in
__xfsstats when printing the information. The problem is, since the start/end
offsets are hardcoded, any update to __xfsstats may also require an update on
the start offset in xqmstat_proc_show().

I decided to split it into two patches, because I think it is easier to let the
bugfix itself in a separated patch, and the approach on how to avoid it in the
future can be discussed in a separated patch.

My first idea was to try to add a method to check it at compile time, and I spent
some time discussing with Eric what would be the best way to avoid this problem
in the future.
We end up with an possible solution using offsetof() and a new constant in
xfs_stats.h to properly check the offsets at compile time.
Although, after giving it some extra thought, I found it better to only use a
new constant to mark the start of xqmstat in xfs_stats.h and not add any fancy
calculation in xqmstat_proc_show itself.
History told me that all updates to __xfsstats and its respective content/uses,
were properly done when needed, only the xqmstat was left behind because it's
unusual direct usage of the offset markers. So, I believe that the addition of a
new marker to specify the start offset of the quota stat fields is enough to
avoid future problems here, once no more changes will be needed in xqmstat code
whenever __xfsstats requires to be updated.

My idea though is still to move this file to sysfs together with the rest of
statistic code, but by now, I believe we should fix this bug.

Comments?

Cheers.


Carlos Maiolino (2):
  xfs: Fix xqmstats offsets in /proc/fs/xfs/xqmstat
  xfs: Add new constant to mark start of xqmstat

 fs/xfs/xfs_stats.c | 2 +-
 fs/xfs/xfs_stats.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

-- 
2.17.1
