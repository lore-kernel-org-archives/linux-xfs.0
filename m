Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42001 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754002AbdKIT1C (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 9 Nov 2017 14:27:02 -0500
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH v4 1/4] xfs_io: Disable -V if pwritev is not available
Date: Thu,  9 Nov 2017 13:26:45 -0600
Message-Id: <20171109192648.6356-1-rgoldwyn@suse.de>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: sandeen@sandeen.net, Goldwyn Rodrigues <rgoldwyn@suse.com>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

This results in default case which will display the error message
that command is not found. This is required for xfs_io builds which
did not support pwritev and an attempt is made to use -V.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 io/pwrite.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/io/pwrite.c b/io/pwrite.c
index 1c5dfca1..5f149a68 100644
--- a/io/pwrite.c
+++ b/io/pwrite.c
@@ -312,6 +312,7 @@ pwrite_f(
 		case 'u':
 			uflag = 1;
 			break;
+#ifdef HAVE_PWRITEV
 		case 'V':
 			vectors = strtoul(optarg, &sp, 0);
 			if (!sp || sp == optarg) {
@@ -320,6 +321,7 @@ pwrite_f(
 				return 0;
 			}
 			break;
+#endif
 		case 'w':
 			wflag = 1;
 			break;
@@ -334,6 +336,7 @@ pwrite_f(
 			}
 			break;
 		default:
+			printf(_("command -%c not supported\n"), c);
 			return command_usage(&pwrite_cmd);
 		}
 	}
-- 
2.14.2

