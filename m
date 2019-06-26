Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:33598 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727830AbfFZOvP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 26 Jun 2019 10:51:15 -0400
Subject: [PATCH] xfs_io: reorganize source file handling in copy_range
References: <20190626061711.27690-1-amir73il@gmail.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <fe818d07-f539-4b2c-fe26-dbc18003e3e2@sandeen.net>
Date: Wed, 26 Jun 2019 09:51:13 -0500
MIME-Version: 1.0
In-Reply-To: <20190626061711.27690-1-amir73il@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Amir Goldstein <amir73il@gmail.com>
Cc: "Darrick J . Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org, fstests@vger.kernel.org

rename and rearrange some of the vars related to using an open
file number as the source file, so that we don't temporarily
store a non-fd number in a var called "fd," and do the fd
assignment in a consistent code location.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Amir, what do you think about this tweak, just for maintainability
I'd prefer to only assign an actual fd to "fd," and handle that
assignment in the same code location for both invocation options.
Thoughts?  Not a big deal either way.

diff --git a/io/copy_file_range.c b/io/copy_file_range.c
index 4a0e7a77..90e1452c 100644
--- a/io/copy_file_range.c
+++ b/io/copy_file_range.c
@@ -84,7 +84,8 @@ copy_range_f(int argc, char **argv)
 	int opt;
 	int ret;
 	int fd;
-	int src_file_arg = 1;
+	int src_path_arg = 1;
+	int src_file_nr = 0;
 	size_t fsblocksize, fssectsize;
 
 	init_cvtnum(&fsblocksize, &fssectsize);
@@ -113,27 +114,27 @@ copy_range_f(int argc, char **argv)
 			}
 			break;
 		case 'f':
-			fd = atoi(argv[1]);
-			if (fd < 0 || fd >= filecount) {
+			src_file_nr = atoi(argv[1]);
+			if (src_file_nr < 0 || src_file_nr >= filecount) {
 				printf(_("value %d is out of range (0-%d)\n"),
-					fd, filecount-1);
+					src_file_nr, filecount-1);
 				return 0;
 			}
-			fd = filetable[fd].fd;
-			/* Expect no src_file arg */
-			src_file_arg = 0;
+			/* Expect no src_path arg */
+			src_path_arg = 0;
 			break;
 		}
 	}
 
-	if (optind != argc - src_file_arg)
+	if (optind != argc - src_path_arg)
 		return command_usage(&copy_range_cmd);
 
-	if (src_file_arg) {
+	if (src_path_arg) {
 		fd = openfile(argv[optind], NULL, IO_READONLY, 0, NULL);
 		if (fd < 0)
 			return 0;
-	}
+	} else
+		fd = filetable[src_file_nr].fd;
 
 	if (src == 0 && dst == 0 && len == 0) {
 		off64_t	sz;
