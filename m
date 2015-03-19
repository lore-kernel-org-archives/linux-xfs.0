Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id ADCE77F37
	for <xfs@oss.sgi.com>; Thu, 19 Mar 2015 18:55:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 39454AC002
	for <xfs@oss.sgi.com>; Thu, 19 Mar 2015 16:55:28 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id IOyx0CGYDM6S2Tcl (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 19 Mar 2015 16:55:26 -0700 (PDT)
Date: Thu, 19 Mar 2015 16:55:20 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH v2] libxfs: don't write uninitialized heap contents into new
	directory blocks
Message-ID: <20150319235520.GG24608@birch.djwong.org>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Brian Foster <bfoster@redhat.com>, xfs@oss.sgi.com

Clear the contents of the xfs buffer when we're initializing it to avoid
writing random heap contents (and CRC thereof) to disk.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/rdwr.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index 7d73477..35fb366 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -411,6 +411,7 @@ __initbuf(xfs_buf_t *bp, struct xfs_buftarg *btp, xfs_daddr_t bno,
 			strerror(errno));
 		exit(1);
 	}
+	memset(bp->b_addr, 0, bytes);
 #ifdef XFS_BUF_TRACING
 	list_head_init(&bp->b_lock_list);
 #endif

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
