Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38906 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752665AbdK1AE4 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 27 Nov 2017 19:04:56 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 51CB783F40
        for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2017 00:04:56 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 288695C549
        for <linux-xfs@vger.kernel.org>; Tue, 28 Nov 2017 00:04:56 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs: calculate correct offset in xfs_scrub_quota_item
Message-ID: <44410519-fd0d-2527-c5cd-e23032eba299@redhat.com>
Date: Mon, 27 Nov 2017 18:04:55 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

It's only used for tracepoints so it's relatively harmless,
but the offset is calculated incorrectly in xfs_scrub_quota_item.

qi_dqperchunk is the nr. of dquots per "chunk" which we have
conveniently *cough* defined to always be 1 FSB.  Therefore 
block_offset * qi_dqperchunk == first id in that chunk,
and so offset = id / qi_dqperchunk

id * dqperchunk is ... meaningless.

Fixes-coverity-id: 1423965
Fixes: c2fc338c ("xfs: scrub quota information")
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

compile-tested only

diff --git a/fs/xfs/scrub/quota.c b/fs/xfs/scrub/quota.c
index 8e58ba8..2eac160 100644
--- a/fs/xfs/scrub/quota.c
+++ b/fs/xfs/scrub/quota.c
@@ -107,7 +107,7 @@
 	unsigned long long		rcount;
 	xfs_ino_t			fs_icount;
 
-	offset = id * qi->qi_dqperchunk;
+	offset = id / qi->qi_dqperchunk;
 
 	/*
 	 * We fed $id and DQNEXT into the xfs_qm_dqget call, which means
