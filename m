Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54470 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751349AbdJWOqs (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Oct 2017 10:46:48 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 7D5B480B22
        for <linux-xfs@vger.kernel.org>; Mon, 23 Oct 2017 14:46:48 +0000 (UTC)
Received: from bfoster.bfoster (dhcp-41-20.bos.redhat.com [10.18.41.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 60E955DA60
        for <linux-xfs@vger.kernel.org>; Mon, 23 Oct 2017 14:46:48 +0000 (UTC)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH RFC 4/4] xfs: enforce a maximum total iclog buffer size
Date: Mon, 23 Oct 2017 10:46:46 -0400
Message-Id: <20171023144646.50107-5-bfoster@redhat.com>
In-Reply-To: <20171023144646.50107-1-bfoster@redhat.com>
References: <20171023144646.50107-1-bfoster@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Since mkfs has historically had an issue creating a very small
filesystems with a log smaller than the minimum log size, add an
extra layer of runtime protection around the log buffer count and
size parameters. Restrict the total log buffer size to 1/2 of the
physical log size, otherwise fail the mount.

The default log buffer count and size is 8 and 32k, respectively.
This total size of 256k results in a minimum log size requirement of
512k, which is well outside even the smallest logs created by broken
formats. Therefore, this change should only affect users who
explicitly attempt to use larger log buffer counts/sizes with such
filesystems.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_log.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/xfs/xfs_log.c b/fs/xfs/xfs_log.c
index e282fd8..5966cab 100644
--- a/fs/xfs/xfs_log.c
+++ b/fs/xfs/xfs_log.c
@@ -1453,6 +1453,14 @@ xlog_alloc_log(
 
 	xlog_get_iclog_buffer_size(mp, log);
 
+	error = -EINVAL;
+	if (log->l_iclog_bufs * log->l_iclog_size > (log->l_logsize >> 1)) {
+		xfs_warn(mp,
+	"total iclog buffer size (logbufs * logbsize) cannot exceed %d bytes",
+			 (log->l_logsize >> 1));
+		goto out_free_log;
+	}
+
 	/*
 	 * Use a NULL block for the extra log buffer used during splits so that
 	 * it will trigger errors if we ever try to do IO on it without first
-- 
2.9.5

