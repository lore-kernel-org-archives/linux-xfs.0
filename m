Return-Path: <SRS0=ODsa=5J=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A136C4332B
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 00:19:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F00C1206F9
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Mar 2020 00:19:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727485AbgCXATg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 23 Mar 2020 20:19:36 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:52379 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727478AbgCXATg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 23 Mar 2020 20:19:36 -0400
Received: from dread.disaster.area (pa49-195-202-68.pa.nsw.optusnet.com.au [49.195.202.68])
        by mail105.syd.optusnet.com.au (Postfix) with ESMTPS id 5B3DF3A3705
        for <linux-xfs@vger.kernel.org>; Tue, 24 Mar 2020 11:19:32 +1100 (AEDT)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1jGXI2-00057W-PD
        for linux-xfs@vger.kernel.org; Tue, 24 Mar 2020 11:19:30 +1100
Received: from dave by discord.disaster.area with local (Exim 4.93)
        (envelope-from <david@fromorbit.com>)
        id 1jGXI2-0004hK-Gz
        for linux-xfs@vger.kernel.org; Tue, 24 Mar 2020 11:19:30 +1100
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 4/5] xfsprogs: fix sliently borken option parsing
Date:   Tue, 24 Mar 2020 11:19:27 +1100
Message-Id: <20200324001928.17894-5-david@fromorbit.com>
X-Mailer: git-send-email 2.26.0.rc2
In-Reply-To: <20200324001928.17894-1-david@fromorbit.com>
References: <20200324001928.17894-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=W5xGqiek c=1 sm=1 tr=0
        a=mqTaRPt+QsUAtUurwE173Q==:117 a=mqTaRPt+QsUAtUurwE173Q==:17
        a=jpOVt7BSZ2e4Z31A5e1TngXxSK0=:19 a=SS2py6AdgQ4A:10 a=20KFwNOVAAAA:8
        a=xcLlE77iyJwIfimGNhQA:9
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

When getopt() is passed an option string like "-m -n" and the
parameter m is defined as "m:", getopt returns a special error
to indication that the optstring started with a "-". Any getopt()
caller that is just catching the "?" error character will not
not catch this special error, so it silently eats the parameter
following -m.

Lots of getopt loops in xfsprogs have this issue. Convert them all
to just use a "default:" to catch anything unexpected.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 copy/xfs_copy.c      | 2 +-
 db/freesp.c          | 2 +-
 db/init.c            | 7 ++-----
 growfs/xfs_growfs.c  | 1 -
 io/copy_file_range.c | 2 ++
 logprint/logprint.c  | 2 +-
 mkfs/xfs_mkfs.c      | 2 +-
 repair/xfs_repair.c  | 2 +-
 scrub/xfs_scrub.c    | 2 --
 spaceman/freesp.c    | 1 -
 spaceman/prealloc.c  | 1 -
 11 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/copy/xfs_copy.c b/copy/xfs_copy.c
index 91c2ae01683b..c4f9f34981ca 100644
--- a/copy/xfs_copy.c
+++ b/copy/xfs_copy.c
@@ -584,7 +584,7 @@ main(int argc, char **argv)
 		case 'V':
 			printf(_("%s version %s\n"), progname, VERSION);
 			exit(0);
-		case '?':
+		default:
 			usage();
 		}
 	}
diff --git a/db/freesp.c b/db/freesp.c
index 903c60d7380a..6f2346665847 100644
--- a/db/freesp.c
+++ b/db/freesp.c
@@ -177,7 +177,7 @@ init(
 		case 's':
 			summaryflag = 1;
 			break;
-		case '?':
+		default:
 			return usage();
 		}
 	}
diff --git a/db/init.c b/db/init.c
index 61eea111f017..ac649fbddbb9 100644
--- a/db/init.c
+++ b/db/init.c
@@ -84,15 +84,12 @@ init(
 		case 'V':
 			printf(_("%s version %s\n"), progname, VERSION);
 			exit(0);
-		case '?':
+		default:
 			usage();
-			/*NOTREACHED*/
 		}
 	}
-	if (optind + 1 != argc) {
+	if (optind + 1 != argc)
 		usage();
-		/*NOTREACHED*/
-	}
 
 	fsdevice = argv[optind];
 	if (!x.disfile)
diff --git a/growfs/xfs_growfs.c b/growfs/xfs_growfs.c
index d27e3b94e0c4..a68b515de40d 100644
--- a/growfs/xfs_growfs.c
+++ b/growfs/xfs_growfs.c
@@ -120,7 +120,6 @@ main(int argc, char **argv)
 		case 'V':
 			printf(_("%s version %s\n"), progname, VERSION);
 			exit(0);
-		case '?':
 		default:
 			usage();
 		}
diff --git a/io/copy_file_range.c b/io/copy_file_range.c
index fb5702e1faad..4c4332c6e5ec 100644
--- a/io/copy_file_range.c
+++ b/io/copy_file_range.c
@@ -127,6 +127,8 @@ copy_range_f(int argc, char **argv)
 			/* Expect no src_path arg */
 			src_path_arg = 0;
 			break;
+		default:
+			return command_usage(&copy_range_cmd);
 		}
 	}
 
diff --git a/logprint/logprint.c b/logprint/logprint.c
index 511a32aca726..e882c5d44397 100644
--- a/logprint/logprint.c
+++ b/logprint/logprint.c
@@ -193,7 +193,7 @@ main(int argc, char **argv)
 			case 'V':
 				printf(_("%s version %s\n"), progname, VERSION);
 				exit(0);
-			case '?':
+			default:
 				usage();
 		}
 	}
diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index f14ce8db5a74..039b1dcc5afa 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3679,7 +3679,7 @@ main(
 		case 'V':
 			printf(_("%s version %s\n"), progname, VERSION);
 			exit(0);
-		case '?':
+		default:
 			unknown(optopt, "");
 		}
 	}
diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 4d37ddc64906..e509fdeb66fe 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -326,7 +326,7 @@ process_args(int argc, char **argv)
 		case 'e':
 			report_corrected = true;
 			break;
-		case '?':
+		default:
 			usage();
 		}
 	}
diff --git a/scrub/xfs_scrub.c b/scrub/xfs_scrub.c
index 014c54dd76b2..33b876f2147a 100644
--- a/scrub/xfs_scrub.c
+++ b/scrub/xfs_scrub.c
@@ -671,8 +671,6 @@ main(
 		case 'x':
 			scrub_data = true;
 			break;
-		case '?':
-			/* fall through */
 		default:
 			usage();
 		}
diff --git a/spaceman/freesp.c b/spaceman/freesp.c
index 92cdb7439427..de301c195fb3 100644
--- a/spaceman/freesp.c
+++ b/spaceman/freesp.c
@@ -310,7 +310,6 @@ init(
 		case 's':
 			summaryflag = 1;
 			break;
-		case '?':
 		default:
 			return command_usage(&freesp_cmd);
 		}
diff --git a/spaceman/prealloc.c b/spaceman/prealloc.c
index e5d857bdd334..6fcbb461125b 100644
--- a/spaceman/prealloc.c
+++ b/spaceman/prealloc.c
@@ -56,7 +56,6 @@ prealloc_f(
 			eofb.eof_min_file_size = cvtnum(fsgeom->blocksize,
 					fsgeom->sectsize, optarg);
 			break;
-		case '?':
 		default:
 			return command_usage(&prealloc_cmd);
 		}
-- 
2.26.0.rc2

