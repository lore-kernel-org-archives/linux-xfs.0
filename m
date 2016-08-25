Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id B567D7CD7
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 18:31:02 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6205A304039
	for <xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:31:02 -0700 (PDT)
Received: from userp1040.oracle.com (userp1040.oracle.com [156.151.31.81]) by
	cuda.sgi.com with ESMTP id KeEDscmfOJI6Eg3F (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 25 Aug 2016 16:31:00 -0700 (PDT)
Subject: [PATCH 2/6] vfs: cap dedupe request structure size at PAGE_SIZE
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Thu, 25 Aug 2016 16:30:54 -0700
Message-ID: <147216785429.525.1965983896010934181.stgit@birch.djwong.org>
In-Reply-To: <147216784041.525.7722906502172299465.stgit@birch.djwong.org>
References: <147216784041.525.7722906502172299465.stgit@birch.djwong.org>
MIME-Version: 1.0
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
To: david@fromorbit.com, viro@ZenIV.linux.org.uk, darrick.wong@oracle.com
Cc: linux-xfs@vger.kernel.org, "Kirill A. Shutemov" <kirill@shutemov.name>, xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org

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
index 26aba09..c415668 100644
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
