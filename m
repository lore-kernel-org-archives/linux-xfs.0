Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail01.adl2.internode.on.net ([150.101.137.133]:49545 "EHLO
        ipmail01.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725785AbeLCAUm (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 2 Dec 2018 19:20:42 -0500
Received: from dave by dastard with local (Exim 4.80)
        (envelope-from <david@fromorbit.com>)
        id 1gTbyW-0002tt-Td
        for linux-xfs@vger.kernel.org; Mon, 03 Dec 2018 11:20:37 +1100
Date: Mon, 3 Dec 2018 11:20:36 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 3/2] xfs_io: copy_file_range length is a size_t
Message-ID: <20181203002036.GB6311@dastard>
References: <20181202205343.7104-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181202205343.7104-1-david@fromorbit.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

copy_file_range() takes a size_t as it's length, not a "long long".
Therefore we need to be able to pass sizes larger than 8EB to it
to be able to test the interface fully and that requires copy_range
to accept all values except an explicit error value of "-1LL".

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 io/copy_file_range.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/io/copy_file_range.c b/io/copy_file_range.c
index f118a3bfd506..4e2969c9ca47 100644
--- a/io/copy_file_range.c
+++ b/io/copy_file_range.c
@@ -34,7 +34,7 @@ copy_range_help(void)
  * glibc buffered copy fallback.
  */
 static loff_t
-copy_file_range_cmd(int fd, long long *src, long long *dst, long long len)
+copy_file_range_cmd(int fd, long long *src, long long *dst, size_t len)
 {
 	loff_t ret;
 
@@ -78,7 +78,7 @@ copy_range_f(int argc, char **argv)
 {
 	long long src = 0;
 	long long dst = 0;
-	long long len = 0;
+	size_t len = 0;
 	int opt;
 	int ret;
 	int fd;
@@ -104,7 +104,7 @@ copy_range_f(int argc, char **argv)
 			break;
 		case 'l':
 			len = cvtnum(fsblocksize, fssectsize, optarg);
-			if (len < 0) {
+			if (len == -1LL) {
 				printf(_("invalid length -- %s\n"), optarg);
 				return 0;
 			}
