Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 91E8B7F6A
	for <xfs@oss.sgi.com>; Mon, 16 Feb 2015 09:49:05 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7085530405F
	for <xfs@oss.sgi.com>; Mon, 16 Feb 2015 07:49:05 -0800 (PST)
Received: from mail-pd0-f180.google.com (mail-pd0-f180.google.com
	[209.85.192.180]) by cuda.sgi.com with ESMTP id
	xtqAc9dqkP44J2CY (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Mon, 16 Feb 2015 07:49:04 -0800 (PST)
Received: by pdjy10 with SMTP id y10so36669981pdj.6
	for <xfs@oss.sgi.com>; Mon, 16 Feb 2015 07:49:03 -0800 (PST)
From: Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH RESEND 4/12] xfsprog: xfsio: update xfs_io manpage for
	FALLOC_FL_INSERT_RANGE
Date: Tue, 17 Feb 2015 00:47:51 +0900
Message-Id: <1424101680-3301-5-git-send-email-linkinjeon@gmail.com>
In-Reply-To: <1424101680-3301-1-git-send-email-linkinjeon@gmail.com>
References: <1424101680-3301-1-git-send-email-linkinjeon@gmail.com>
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
