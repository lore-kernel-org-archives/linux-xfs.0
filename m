Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1725A29DFD
	for <xfs@oss.sgi.com>; Sat, 21 Feb 2015 09:49:17 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EAE97304059
	for <xfs@oss.sgi.com>; Sat, 21 Feb 2015 07:49:13 -0800 (PST)
Received: from mail-pd0-f178.google.com (mail-pd0-f178.google.com
	[209.85.192.178]) by cuda.sgi.com with ESMTP id
	lT5b3Csb3KJjpzd9 (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Sat, 21 Feb 2015 07:49:12 -0800 (PST)
Received: by pdbfl12 with SMTP id fl12so14674683pdb.2
	for <xfs@oss.sgi.com>; Sat, 21 Feb 2015 07:49:12 -0800 (PST)
From: Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH v10 4/12] xfsprog: xfsio: update xfs_io manpage for
	FALLOC_FL_INSERT_RANGE
Date: Sun, 22 Feb 2015 00:45:46 +0900
Message-Id: <1424533554-28024-5-git-send-email-linkinjeon@gmail.com>
In-Reply-To: <1424533554-28024-1-git-send-email-linkinjeon@gmail.com>
References: <1424533554-28024-1-git-send-email-linkinjeon@gmail.com>
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
To: david@fromorbit.com, tytso@mit.edu
Cc: linux-man@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>, Namjae Jeon <namjae.jeon@samsung.com>, linux-api@vger.kernel.org, bfoster@redhat.com, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, mtk.manpages@gmail.com, a.sangwan@samsung.com, linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Update xfs_io manpage for FALLOC_FL_INSERT_RANGE.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ashish Sangwan <a.sangwan@samsung.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
---
 man/man8/xfs_io.8 |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/man/man8/xfs_io.8 b/man/man8/xfs_io.8
index cf27b99..416206f 100644
--- a/man/man8/xfs_io.8
+++ b/man/man8/xfs_io.8
@@ -404,6 +404,11 @@ Call fallocate with FALLOC_FL_COLLAPSE_RANGE flag as described in the
 manual page to de-allocates blocks and eliminates the hole created in this process
 by shifting data blocks into the hole.
 .TP
+.BI finsert " offset length"
+Call fallocate with FALLOC_FL_INSERT_RANGE flag as described in the
+.BR fallocate (2)
+manual page to create the hole by shifting data blocks.
+.TP
 .BI fpunch " offset length"
 Punches (de-allocates) blocks in the file by calling fallocate with 
 the FALLOC_FL_PUNCH_HOLE flag as described in the
-- 
1.7.9.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
