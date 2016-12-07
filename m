Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34620 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752932AbcLGNfG (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 7 Dec 2016 08:35:06 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 8C0337AEAA
        for <linux-xfs@vger.kernel.org>; Wed,  7 Dec 2016 13:27:59 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 18/22] mkfs: prevent sector/blocksize to be specified as a number of blocks
Date: Wed,  7 Dec 2016 14:27:25 +0100
Message-Id: <1481117249-21273-19-git-send-email-jtulak@redhat.com>
In-Reply-To: <1481117249-21273-1-git-send-email-jtulak@redhat.com>
References: <1481117249-21273-1-git-send-email-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jan Tulak <jtulak@redhat.com>

Documentation states that the options blocked in this patch accepts the
size only in bytes. So prevent blocksize or sectorsize to be specified as
a number of blocks or sectors.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 mkfs/xfs_mkfs.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index d55eb9a..e8fd49b 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2041,6 +2041,27 @@ getnum(
 		}
 	}
 
+	/* Prevent things like specifying blocksize as a number of blocks. */
+	if (opts->index == OPT_B || opts->index == OPT_S ||
+		(opts->index == OPT_L && (index == L_SECTLOG ||
+			index == L_SECTSIZE)) ||
+		(opts->index == OPT_N && (index == N_SIZE)) ||
+		(opts->index == OPT_D && (index == D_SECTLOG ||
+			index == D_SECTSIZE))
+
+		) {
+		switch (str[strlen(str)-1]) {
+		case 'b':
+		case 's':
+			fprintf(stderr,
+				_("You can't set a sector or block size in "
+				  "number of blocks or sectors (-%c %s).\n"),
+				opts->name, opts->subopts[index]);
+			exit(1);
+		}
+
+	}
+
 	sp->seen = true;
 
 	if (test_uvalue_num(sp->type, sp->minval, 0) &&
-- 
2.8.1

