Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48600 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751165AbdJODZv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sat, 14 Oct 2017 23:25:51 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8CDDC13AAC
        for <linux-xfs@vger.kernel.org>; Sun, 15 Oct 2017 03:25:51 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-12-41.pek2.redhat.com [10.72.12.41])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B0823600CD
        for <linux-xfs@vger.kernel.org>; Sun, 15 Oct 2017 03:25:50 +0000 (UTC)
From: Zorro Lang <zlang@redhat.com>
Subject: [PATCH] xfsprogs: add xfs_spaceman to .gitignore
Date: Sun, 15 Oct 2017 11:25:46 +0800
Message-Id: <20171015032546.4503-1-zlang@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

The new binary xfs_spaceman isn't in .gitignore, so ignore it in
this patch.

Signed-off-by: Zorro Lang <zlang@redhat.com>
---

Hi,

If you don't think it's worth fixing it in a single patch, feel free
to fix it in next xfs_spaceman related patchset :)

Thanks,
Zorro

 .gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/.gitignore b/.gitignore
index 913b371f..e839e2a1 100644
--- a/.gitignore
+++ b/.gitignore
@@ -67,6 +67,7 @@ cscope.*
 /quota/xfs_quota
 /repair/xfs_repair
 /rtcp/xfs_rtcp
+/spaceman/xfs_spaceman
 
 # generated crc files
 /libxfs/crc32selftest
-- 
2.13.6

