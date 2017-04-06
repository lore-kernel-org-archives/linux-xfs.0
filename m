Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48277 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934551AbdDFOzj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 6 Apr 2017 10:55:39 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9C3F36AACE
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2017 14:55:38 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH] mkfs: Add a note for people changing input options
Date: Thu,  6 Apr 2017 16:55:43 +0200
Message-Id: <20170406145543.21781-1-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jan Tulak <jtulak@redhat.com>

A simple reminder to update test xfs/191-input-validation
if input behaviour is changed (e.g. new option added).

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 mkfs/xfs_mkfs.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 5aac4d1b..7a5c49fc 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -50,6 +50,14 @@ unsigned int		sectorsize;
 /*
  * Table for parsing mkfs parameters.
  *
+ * !!! NOTE ==================================================================
+ *
+ * If you are adding a new option, or changing an existing one,
+ * please, update also xfstests - test xfs/191-input-validation
+ * with expected behaviour (simple fail/pass).
+ *
+ * !!! END OF NOTE ===========================================================
+ *
  * Description of the structure members follows:
  *
  * name MANDATORY
@@ -110,6 +118,14 @@ unsigned int		sectorsize;
  *     sets what is used with simple specifying the subopt (-d file).
  *     A special SUBOPT_NEEDS_VAL can be used to require a user-given
  *     value in any case.
+ *
+ * !!! NOTE ==================================================================
+ *
+ * If you are adding a new option, or changing an existing one,
+ * please, update also xfstests - test xfs/191-input-validation
+ * with expected behaviour (simple fail/pass).
+ *
+ * !!! END OF NOTE ===========================================================
  */
 struct opt_params {
 	const char	name;
-- 
2.12.1

