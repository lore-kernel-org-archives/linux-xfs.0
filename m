Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53062 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751921AbdDKOMv (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 11 Apr 2017 10:12:51 -0400
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 1/2] metadump: warn about corruption if log is dirty
Date: Tue, 11 Apr 2017 16:12:36 +0200
Message-Id: <20170411141237.9274-2-jtulak@redhat.com>
In-Reply-To: <20170411141237.9274-1-jtulak@redhat.com>
References: <20170411141237.9274-1-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: sandeen@sandeen.net, Jan Tulak <jtulak@redhat.com>

Add a warning about possible corruption when exporting a dirty log, as
the log content does not agree with obfuscated metadata.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 db/metadump.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/db/metadump.c b/db/metadump.c
index 66952f6..74e24b2 100644
--- a/db/metadump.c
+++ b/db/metadump.c
@@ -2726,7 +2726,8 @@ copy_log(void)
 		/* keep the dirty log */
 		if (obfuscate)
 			print_warning(
-_("Filesystem log is dirty; image will contain unobfuscated metadata in log."));
+_("Filesystem log is dirty; image will contain unobfuscated metadata in log "
+  "and a log replay can cause a corruption."));
 		break;
 	case -1:
 		/* log detection error */
-- 
2.1.4

