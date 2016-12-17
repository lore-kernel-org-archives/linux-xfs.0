Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33932 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932697AbcLQAFV (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 16 Dec 2016 19:05:21 -0500
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3F15761B95
        for <linux-xfs@vger.kernel.org>; Sat, 17 Dec 2016 00:05:21 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id uBH05KpD026468
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
        for <linux-xfs@vger.kernel.org>; Fri, 16 Dec 2016 19:05:21 -0500
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs: don't wrap ID in xfs_dq_get_next_id
Message-ID: <f52de68d-abe6-1960-c0ef-1d199346f689@redhat.com>
Date: Fri, 16 Dec 2016 18:05:20 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

The GETNEXTQOTA ioctl takes whatever ID is sent in,
and looks for the next active quota for an user
equal or higher to that ID.

But if we are at the maximum ID and then ask for the "next"
one, we may wrap back to zero.  In this case, userspace
may loop forever, because it will start querying again
at zero.

We'll fix this in userspace as well, but for the kernel,
return -ENOENT if we ask for the next quota ID
past UINT_MAX so the caller knows to stop.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 7a30b8f..dbeddd9 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -710,6 +710,10 @@
 	/* Simple advance */
 	next_id = *id + 1;
 
+	/* If we'd wrap past the max ID, stop */
+	if (next_id < *id)
+		return -ENOENT;
+
 	/* If new ID is within the current chunk, advancing it sufficed */
 	if (next_id % mp->m_quotainfo->qi_dqperchunk) {
 		*id = next_id;

