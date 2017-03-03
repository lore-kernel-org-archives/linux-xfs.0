Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:45372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752170AbdCCXOZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 3 Mar 2017 18:14:25 -0500
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: [PATCH 8/9] mkfs.xfs: use parse_subopts() to parse sopts
Date: Fri,  3 Mar 2017 15:13:15 -0800
Message-Id: <20170303231316.12716-9-mcgrof@kernel.org>
In-Reply-To: <20170303231316.12716-1-mcgrof@kernel.org>
References: <20170303231316.12716-1-mcgrof@kernel.org>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: sandeen@sandeen.net, linux-xfs@vger.kernel.org
Cc: jack@suse.com, jeffm@suse.com, okurz@suse.com, lpechacek@suse.com, "Luis R. Rodriguez" <mcgrof@kernel.org>

All sopt parameters are already part of struct mkfs_xfs_opts, so
all we need to do is use the helper.

Signed-off-by: Luis R. Rodriguez <mcgrof@kernel.org>
---
 mkfs/xfs_mkfs.c | 70 +++++++++++++++++++++++++++------------------------------
 1 file changed, 33 insertions(+), 37 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 39ab08148687..2a3786ece6b6 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1760,6 +1760,38 @@ parse_subopts(
 			}
 		}
 		break;
+	case 's':
+		while (*p != '\0') {
+			switch (getsubopt(&p, (char **)sopts.subopts, &value)) {
+			case S_LOG:
+			case S_SECTLOG:
+				if (params->lssflag)
+					conflict('s', (char **)sopts.subopts,
+						 S_SECTSIZE, S_SECTLOG);
+				params->sectorlog =
+					getnum(value, &sopts, S_SECTLOG);
+				params->lsectorlog = params->sectorlog;
+				sectorsize = 1 << params->sectorlog;
+				params->lsectorsize = sectorsize;
+				params->lslflag = params->slflag = 1;
+				break;
+			case S_SIZE:
+			case S_SECTSIZE:
+				if (params->lslflag)
+					conflict('s', (char **)sopts.subopts,
+						 S_SECTLOG, S_SECTSIZE);
+				sectorsize = getnum(value, &sopts, S_SECTSIZE);
+				params->lsectorsize = sectorsize;
+				params->sectorlog =
+					libxfs_highbit32(sectorsize);
+				params->lsectorlog = params->sectorlog;
+				params->lssflag = params->ssflag = 1;
+				break;
+			default:
+				unknown('s', value);
+			}
+		}
+		break;
 	default:
 		usage();
 	}
@@ -1865,6 +1897,7 @@ main(
 		case 'm':
 		case 'n':
 		case 'r':
+		case 's':
 			p = optarg;
 			parse_subopts(c, p, &params);
 			break;
@@ -1887,43 +1920,6 @@ main(
 		case 'q':
 			qflag = 1;
 			break;
-		case 's':
-			p = optarg;
-			while (*p != '\0') {
-				char	**subopts = (char **)sopts.subopts;
-				char	*value;
-
-				switch (getsubopt(&p, subopts, &value)) {
-				case S_LOG:
-				case S_SECTLOG:
-					if (params.lssflag)
-						conflict('s', subopts,
-							 S_SECTSIZE, S_SECTLOG);
-					params.sectorlog = getnum(value, &sopts,
-							   S_SECTLOG);
-					params.lsectorlog = params.sectorlog;
-					sectorsize = 1 << params.sectorlog;
-					params.lsectorsize = sectorsize;
-					params.lslflag = params.slflag = 1;
-					break;
-				case S_SIZE:
-				case S_SECTSIZE:
-					if (params.lslflag)
-						conflict('s', subopts, S_SECTLOG,
-							 S_SECTSIZE);
-					sectorsize = getnum(value, &sopts,
-							    S_SECTSIZE);
-					params.lsectorsize = sectorsize;
-					params.sectorlog =
-						libxfs_highbit32(sectorsize);
-					params.lsectorlog = params.sectorlog;
-					params.lssflag = params.ssflag = 1;
-					break;
-				default:
-					unknown('s', value);
-				}
-			}
-			break;
 		case 'V':
 			printf(_("%s version %s\n"), progname, VERSION);
 			exit(0);
-- 
2.11.0

