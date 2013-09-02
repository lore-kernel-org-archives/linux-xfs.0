Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 96BFE7F55
	for <xfs@oss.sgi.com>; Mon,  2 Sep 2013 09:30:34 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 35E15AC004
	for <xfs@oss.sgi.com>; Mon,  2 Sep 2013 07:30:34 -0700 (PDT)
Received: from mail-pd0-f179.google.com (mail-pd0-f179.google.com
	[209.85.192.179]) by cuda.sgi.com with ESMTP id
	5H4Fjq54vIRhWTlH (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Sep 2013 07:30:33 -0700 (PDT)
Received: by mail-pd0-f179.google.com with SMTP id v10so4802600pde.24
	for <xfs@oss.sgi.com>; Mon, 02 Sep 2013 07:30:33 -0700 (PDT)
From: Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH v2 7/7] manpage: update FALLOC_FL_COLLAPSE_RANGE flag in
	fallocate
Date: Mon,  2 Sep 2013 23:30:20 +0900
Message-Id: <1378132220-2855-1-git-send-email-linkinjeon@gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: viro@zeniv.linux.org.uk, mtk.manpages@gmail.com, tytso@mit.edu, adilger.kernel@dilger.ca, bpm@sgi.com, elder@kernel.org, hch@infradead.org, david@fromorbit.com
Cc: Namjae Jeon <linkinjeon@gmail.com>, Namjae Jeon <namjae.jeon@samsung.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, a.sangwan@samsung.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Update FALLOC_FL_COLLAPSE_RANGE flag in fallocate.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 man2/fallocate.2 |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/man2/fallocate.2 b/man2/fallocate.2
index f5c395d..b042c59 100644
--- a/man2/fallocate.2
+++ b/man2/fallocate.2
@@ -7,6 +7,7 @@
 .\"
 .\" 2011-09-19: Added FALLOC_FL_PUNCH_HOLE
 .\" 2011-09-19: Substantial restructuring of the page
+.\" 2013-09-01: Added FALLOC_FL_COLLAPSE_RANGE
 .\"
 .TH FALLOCATE 2 2013-06-10 "Linux" "Linux Programmer's Manual"
 .SH NAME
@@ -109,6 +110,19 @@ does not change.
 Not all filesystems support
 .BR FALLOC_FL_PUNCH_HOLE ;
 if a filesystem doesn't support the operation, an error is returned.
+.SS Collapsing file space
+Specifiying the
+.BR FALLOC_FL_COLLAPSE_RANGE
+flag in
+.I mode
+collpse space in the byte range starting at
+.I offset
+and continuing for
+.I len
+bytes, where the offset and len are aligned with block size of filesystem.
+Within the specified range, it first de-allocates blocks and eliminates
+the hole created in this process by shifting data blocks into the hole.
+
 .SH RETURN VALUE
 On success,
 .BR fallocate ()
@@ -139,7 +153,8 @@ was less than 0, or
 .\" See "Re: [PATCH] fallocate.2: add FALLOC_FL_PUNCH_HOLE flag definition"
 .\" 21 Sep 2012
 .\" http://thread.gmane.org/gmane.linux.file-systems/48331/focus=1193526
-was less than or equal to 0.
+was less than or equal to 0 or in case of FALLOC_FL_COLLAPSE_RANGE
+offset and len are not aligned with file system's block size.
 .TP
 .B EIO
 An I/O error occurred while reading from or writing to a filesystem.
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
