Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 409B17CA0
	for <xfs@oss.sgi.com>; Thu, 28 Jul 2016 13:35:45 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 05023304039
	for <xfs@oss.sgi.com>; Thu, 28 Jul 2016 11:35:41 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id vjzDtajFjLnPELSa (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 28 Jul 2016 11:35:40 -0700 (PDT)
Date: Thu, 28 Jul 2016 11:35:34 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] vfs: cap dedupe request structure size at PAGE_SIZE
Message-ID: <20160728183534.GB15753@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-api@vger.kernel.org, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, "Kirill A. Shutemov" <kirill@shutemov.name>, Vlastimil Babka <vbabka@suse.cz>

Kirill A. Shutemov reports that the kernel doesn't try to cap dest_count
in any way, and uses the number to allocate kernel memory.  This causes
high order allocation warnings in the kernel log if someone passes in a
big enough value.  We should clamp the allocation at PAGE_SIZE to avoid
stressing the VM.

The two existing users of the dedupe ioctl never send more than 120
requests, so we can safely clamp dest_range at PAGE_SIZE, because with
4k pages we can handle up to 127 dedupe candidates.  Given the max
extent length of 16MB, we can end up doing 2GB of IO which is plenty.

Reported-by: "Kirill A. Shutemov" <kirill@shutemov.name>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ioctl.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ioctl.c b/fs/ioctl.c
index db3d033..57409a7 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -582,6 +582,10 @@ static int ioctl_file_dedupe_range(struct file *file, void __user *arg)
 	}
 
 	size = offsetof(struct file_dedupe_range __user, info[count]);
+	if (size > PAGE_SIZE) {
+		ret = -ENOMEM;
+		goto out;
+	}
 
 	same = memdup_user(argp, size);
 	if (IS_ERR(same)) {

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
