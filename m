Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:49232 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752314AbeA3DjZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Jan 2018 22:39:25 -0500
Date: Mon, 29 Jan 2018 19:39:22 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 6/2] mkfs: always explain why numeric inputs are invalid
Message-ID: <20180130033922.GN9068@magnolia>
References: <151692412532.32390.5360363880930671862.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <151692412532.32390.5360363880930671862.stgit@magnolia>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@redhat.com
Cc: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Always explain why invalid numeric inputs are not valid, and in a
complete sentence since that's what illegal_optio() sets us up for.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 mkfs/xfs_mkfs.c |   14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 6285b24..f527476 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1269,7 +1269,7 @@ illegal_option(
 	fprintf(stderr,
 		_("Invalid value %s for -%c %s option. %s\n"),
 		value, opts->name, opts->subopts[index],
-		reason ? reason : "");
+		reason);
 	usage();
 }
 
@@ -1360,18 +1360,20 @@ getnum(
 
 		c = strtoll(str, &str_end, 0);
 		if (c == 0 && str_end == str)
-			illegal_option(str, opts, index, NULL);
+			illegal_option(str, opts, index,
+					_("Value not recognized as number."));
 		if (*str_end != '\0')
-			illegal_option(str, opts, index, NULL);
+			illegal_option(str, opts, index,
+					_("Unit suffixes are not allowed."));
 	}
 
 	/* Validity check the result. */
 	if (c < sp->minval)
-		illegal_option(str, opts, index, _("value is too small"));
+		illegal_option(str, opts, index, _("Value is too small."));
 	else if (c > sp->maxval)
-		illegal_option(str, opts, index, _("value is too large"));
+		illegal_option(str, opts, index, _("Value is too large."));
 	if (sp->is_power_2 && !ispow2(c))
-		illegal_option(str, opts, index, _("value must be a power of 2"));
+		illegal_option(str, opts, index, _("Value must be a power of 2."));
 	return c;
 }
 
