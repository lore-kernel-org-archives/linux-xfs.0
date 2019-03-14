Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:47936 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726856AbfCNV24 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 14 Mar 2019 17:28:56 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id x2ELStxI118195
        for <linux-xfs@vger.kernel.org>; Thu, 14 Mar 2019 21:28:55 GMT
Received: from userv0022.oracle.com (userv0022.oracle.com [156.151.31.74])
        by userp2130.oracle.com with ESMTP id 2r44wukj8p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 14 Mar 2019 21:28:55 +0000
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userv0022.oracle.com (8.14.4/8.14.4) with ESMTP id x2ELStp4006135
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
        for <linux-xfs@vger.kernel.org>; Thu, 14 Mar 2019 21:28:55 GMT
Received: from abhmp0014.oracle.com (abhmp0014.oracle.com [141.146.116.20])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id x2ELSsOH031853
        for <linux-xfs@vger.kernel.org>; Thu, 14 Mar 2019 21:28:54 GMT
Subject: [PATCH 0/4] xfs: various rough fixes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 14 Mar 2019 14:28:54 -0700
Message-ID: <155259893433.30230.6566995969675098053.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org

Hi all,

Here's a bunch of crazy fixes that I've been working on.  The first one
tries to solve the fragmentation problems that Dave reported[1] in the
stupidest way possible.  Namely, we only ever trim post-eof speculative
preallocations the /first/ time that we close a file, regardless of the
dirty state.

The second patch tries to fix a stale data exposure bug revealed by
generic/042.  It does this by changing xfs to convert delalloc extents
to unwritten extents and only converting those into real extents once
the data write succeeds.  We already do this for the cow fork, so it
seems pretty straightforward to do the same for the data fork.

The third patch adds instrumentation to make it easier to detect when
we roll a transaction beyond the initial logcount, and therefore are
having to reserve more log space.

The fourth patch effectively increases the number of times we can roll
an end_cow transaction without having to go back for more reservation.
This is intended to fix the problem outlined in [2] which will fix the
periodic xfs/347 deadlocks.

[1] https://marc.info/?l=linux-xfs&m=154951612101291&w=2
[2] https://marc.info/?l=linux-xfs&m=155241472431249&w=2


If you're going to start using this mess, you probably ought to just
pull from my git trees, which are linked below.

This is an extraordinary way to destroy everything.  Enjoy!
Comments and questions are, as always, welcome.

--D

kernel git tree:
https://git.kernel.org/cgit/linux/kernel/git/djwong/xfs-linux.git/log/?h=rough-fixes
