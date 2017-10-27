Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46960 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752473AbdJ0MhT (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 27 Oct 2017 08:37:19 -0400
From: Nikolay Borisov <nborisov@suse.com>
Subject: [PATCH v2 0/2] Fiemap's range query 
Date: Fri, 27 Oct 2017 15:37:08 +0300
Message-Id: <1509107832-22286-1-git-send-email-nborisov@suse.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: fstests@vger.kernel.org, Nikolay Borisov <nborisov@suse.com>

So here is an implementation of fiemap's range query. The only major change 
apart from range support is that for files which consists of only a hole fiemap
will print a line saying so, rather than being silent. Naturally, this breaks a 
bunch of generic fstests but I've attached fixes for them. The code also comes
with xfstests. Furthermore, I've verified that none of the generic tests fail 
with this implementation apart from those tests which I've fixed. 

V2: Considered all of Darrick's review for the preivous posting, as a result 
this is being posted as the fiemap patches coupled with the xfstest patches. 

Nikolay Borisov (2):
  fiemap: Factor out actual fiemap call code
  fiemap: Implement ranged query

 io/fiemap.c       | 110 +++++++++++++++++++++++++++++++++++++++++++-----------
 man/man8/xfs_io.8 |   5 ++-
 2 files changed, 92 insertions(+), 23 deletions(-)

-- 
2.7.4

