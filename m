Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39390 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753993AbdCOQA7 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Mar 2017 12:00:59 -0400
Received: from int-mx09.intmail.prod.int.phx2.redhat.com (int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2531D80468
        for <linux-xfs@vger.kernel.org>; Wed, 15 Mar 2017 16:00:59 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 18/22] mkfs: prevent sector/blocksize to be specified as a number of blocks
Date: Wed, 15 Mar 2017 17:00:13 +0100
Message-Id: <20170315160017.27805-19-jtulak@redhat.com>
In-Reply-To: <20170315160017.27805-1-jtulak@redhat.com>
References: <20170315160017.27805-1-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jan Tulak <jtulak@redhat.com>

Documentation states that the options blocked in this patch accepts the
size only in bytes. So prevent blocksize or sectorsize to be specified as
a number of blocks or sectors.

Signed-off-by: Jan Tulak <jtulak@redhat.com>

--
Change:
  * sectsize can be set in blocks and vice versa now
---
 mkfs/xfs_mkfs.c | 27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index bd2d81a3..767aeeea 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2044,6 +2044,33 @@ getnum(
 		}
 	}
 
+	/* Prevent things like specifying blocksize as a number of blocks. */
+	if (opts->index == OPT_B ||
+		(opts->index == OPT_N && (index == N_SIZE))
+		) {
+		if ('b' == str[strlen(str)-1]) {
+			fprintf(stderr,
+				_("You can't set a block size in "
+				  "number of blocks (-%c %s).\n"),
+				opts->name, opts->subopts[index]);
+			exit(1);
+		}
+	}
+	else if (opts->index == OPT_S ||
+		(opts->index == OPT_L && (index == L_SECTLOG ||
+			index == L_SECTSIZE)) ||
+		(opts->index == OPT_D && (index == D_SECTLOG ||
+			index == D_SECTSIZE))
+		) {
+		if ('s' == str[strlen(str)-1]) {
+			fprintf(stderr,
+				_("You can't set a sector size in "
+				  "number of sectors (-%c %s).\n"),
+				opts->name, opts->subopts[index]);
+			exit(1);
+		}
+	}
+
 	sp->seen = true;
 
 	if (test_uvalue_num(sp->type, sp->minval, 0) &&
-- 
2.11.0

