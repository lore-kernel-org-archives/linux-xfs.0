Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id B8E107FFA
	for <xfs@oss.sgi.com>; Sun,  8 Dec 2013 08:14:49 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7EC108F8064
	for <xfs@oss.sgi.com>; Sun,  8 Dec 2013 06:14:49 -0800 (PST)
Received: from mail-pb0-f46.google.com (mail-pb0-f46.google.com
	[209.85.160.46]) by cuda.sgi.com with ESMTP id nuuNyW2th7BmNlhE
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 08 Dec 2013 06:14:48 -0800 (PST)
Received: by mail-pb0-f46.google.com with SMTP id md12so3758146pbc.5
	for <xfs@oss.sgi.com>; Sun, 08 Dec 2013 06:14:48 -0800 (PST)
From: Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH v4 10/10] manpage: update FALLOC_FL_COLLAPSE_RANGE flag in
	fallocate
Date: Sun,  8 Dec 2013 23:14:39 +0900
Message-Id: <1386512079-4099-1-git-send-email-linkinjeon@gmail.com>
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
To: viro@zeniv.linux.org.uk, david@fromorbit.com, bpm@sgi.com, tytso@mit.edu, adilger.kernel@dilger.ca, jack@suse.cz, mtk.manpages@gmail.com
Cc: Namjae Jeon <linkinjeon@gmail.com>, Namjae Jeon <namjae.jeon@samsung.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, Ashish Sangwan <a.sangwan@samsung.com>, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Update FALLOC_FL_COLLAPSE_RANGE flag in fallocate.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
---
 man2/fallocate.2 |   21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/man2/fallocate.2 b/man2/fallocate.2
index ec9011c..69a4dbd 100644
--- a/man2/fallocate.2
+++ b/man2/fallocate.2
@@ -1,5 +1,6 @@
 .\" Copyright (c) 2007 Silicon Graphics, Inc. All Rights Reserved
 .\" Written by Dave Chinner <dgc@sgi.com>
+.\" Updated by Namjae Jeon <namjae.jeon@samsung.com>
 .\"
 .\" %%%LICENSE_START(GPLv2_ONELINE)
 .\" May be distributed as per GNU General Public License version 2.
@@ -7,6 +8,7 @@
 .\"
 .\" 2011-09-19: Added FALLOC_FL_PUNCH_HOLE
 .\" 2011-09-19: Substantial restructuring of the page
+.\" 2013-11-10: Added FALLOC_FL_COLLAPSE_RANGE
 .\"
 .TH FALLOCATE 2 2013-11-08 "Linux" "Linux Programmer's Manual"
 .SH NAME
@@ -113,6 +115,25 @@ does not change.
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
+bytes. Within the specified range, it first de-allocates blocks and eliminates
+the hole created in this process by shifting data blocks into the hole.
+
+Different filesystem may implement different limitatios on the granularity of
+the operation. Most filesystem will limit operations to filesystem block size
+boundaries, but this boundary may be larger or smaller depending
+on the filesystem and/or the configuration of the filesystem or file.
+
+If filesystem has such limitation on granularity, It will return error(EINVAL).
+
 .SH RETURN VALUE
 On success,
 .BR fallocate ()
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
