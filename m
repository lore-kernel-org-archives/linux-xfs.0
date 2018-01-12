Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34696 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933947AbeALQcj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 12 Jan 2018 11:32:39 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 90ACC6A7F1
        for <linux-xfs@vger.kernel.org>; Fri, 12 Jan 2018 16:32:39 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 306B717F28
        for <linux-xfs@vger.kernel.org>; Fri, 12 Jan 2018 16:32:39 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs_logprint: fix v3 inode formatting
Message-ID: <831989ff-14a7-5c22-2b9c-457033a99945@redhat.com>
Date: Fri, 12 Jan 2018 10:32:38 -0600
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

Line up flags2/cowextsize line with all the others, using
tabs.

Fixes: 1fe708d60 ("xfs_logprint: support cowextsize reporting in log contents")
Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/logprint/log_print_all.c b/logprint/log_print_all.c
index c80bf34..cdaf77b 100644
--- a/logprint/log_print_all.c
+++ b/logprint/log_print_all.c
@@ -273,7 +273,7 @@ xlog_recover_print_inode_core(
 	       (int)di->di_forkoff, di->di_dmevmask, (int)di->di_dmstate,
 	       (int)di->di_flags, di->di_gen);
 	if (di->di_version == 3) {
-		printf(_("flags2 0x%llx cowextsize 0x%x\n"),
+		printf(_("		flags2 0x%llx cowextsize 0x%x\n"),
 			(unsigned long long)di->di_flags2, di->di_cowextsize);
 	}
 }

