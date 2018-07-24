Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:57632 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388263AbeGXC3X (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 23 Jul 2018 22:29:23 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1A69085547
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jul 2018 01:25:29 +0000 (UTC)
Received: from Liberator-5.local (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DF0B660BE7
        for <linux-xfs@vger.kernel.org>; Tue, 24 Jul 2018 01:25:28 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs_db: add -d to short help for write command
Message-ID: <fba33a51-50c1-ade6-79d2-f7ceaceb372f@redhat.com>
Date: Mon, 23 Jul 2018 18:25:27 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>

And note in the man page that -c and -d are exclusive.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/db/write.c b/db/write.c
index 5ef76bcd..bbaa609d 100644
--- a/db/write.c
+++ b/db/write.c
@@ -38,7 +38,7 @@ static int	write_f(int argc, char **argv);
 static void     write_help(void);
 
 static const cmdinfo_t	write_cmd =
-	{ "write", NULL, write_f, 0, -1, 0, N_("[-c] [field or value]..."),
+	{ "write", NULL, write_f, 0, -1, 0, N_("[-c|-d] [field or value]..."),
 	  N_("write value to disk"), write_help };
 
 void
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index 10f2beb9..a1ee3514 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -837,7 +837,7 @@ and
 bits respectively, and their string equivalent reported
 (but no modifications are made).
 .TP
-.BI "write [\-c] [\-d] [" "field value" "] ..."
+.BI "write [\-c|\-d] [" "field value" "] ..."
 Write a value to disk.
 Specific fields can be set in structures (struct mode),
 or a block can be set to data values (data mode),

