Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40414 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751054AbdDMIN7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 13 Apr 2017 04:13:59 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 905873D941
        for <linux-xfs@vger.kernel.org>; Thu, 13 Apr 2017 08:13:58 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 1/2] metadump: warn about corruption if log is dirty
Date: Thu, 13 Apr 2017 10:13:53 +0200
Message-Id: <20170413081354.22170-2-jtulak@redhat.com>
In-Reply-To: <20170413081354.22170-1-jtulak@redhat.com>
References: <20170413081354.22170-1-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jan Tulak <jtulak@redhat.com>

Add a warning about possible corruption when exporting a dirty log, as
the log content does not agree with obfuscated metadata.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
Change: More elaborate warning message.
---
 db/metadump.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/db/metadump.c b/db/metadump.c
index 66952f6..2dd8593 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -2726,7 +2726,9 @@ copy_log(void)
 		/* keep the dirty log */
 		if (obfuscate)
 			print_warning(
-_("Filesystem log is dirty; image will contain unobfuscated metadata in log."));
+_("Warning: log recovery of an obfuscated metadata image can leak "
+"unobfuscated metadata and/or cause image corruption. Please mount "
+"the source filesystem to clean the log or disable obfuscation, if possible."));
 		break;
 	case -1:
 		/* log detection error */
-- 
2.1.4

