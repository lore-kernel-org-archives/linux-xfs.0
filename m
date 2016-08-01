Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 35C3C7D1F
	for <xfs@oss.sgi.com>; Mon,  1 Aug 2016 12:14:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EB722304048
	for <xfs@oss.sgi.com>; Mon,  1 Aug 2016 10:14:26 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 7hPKnSIPyam6JYou (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 01 Aug 2016 10:14:25 -0700 (PDT)
Date: Mon, 1 Aug 2016 10:13:39 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH] vfs: fix return type of ioctl_file_dedupe_range
Message-ID: <20160801171339.GB8590@birch.djwong.org>
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
To: Al Viro <viro@ZenIV.linux.org.uk>, Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

All the VFS functions in the dedupe ioctl path return int status, so
the ioctl handler ought to as well.

Found by Coverity, CID 1350952.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 fs/ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ioctl.c b/fs/ioctl.c
index 116a333..db3d033 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -568,7 +568,7 @@ static int ioctl_fsthaw(struct file *filp)
 	return thaw_super(sb);
 }
 
-static long ioctl_file_dedupe_range(struct file *file, void __user *arg)
+static int ioctl_file_dedupe_range(struct file *file, void __user *arg)
 {
 	struct file_dedupe_range __user *argp = arg;
 	struct file_dedupe_range *same = NULL;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
