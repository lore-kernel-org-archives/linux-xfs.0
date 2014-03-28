Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 10A0A7F3F
	for <xfs@oss.sgi.com>; Fri, 28 Mar 2014 03:03:38 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DF6488F8059
	for <xfs@oss.sgi.com>; Fri, 28 Mar 2014 01:03:37 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id uM1XHHhtVENrG5mj (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 28 Mar 2014 01:03:31 -0700 (PDT)
Date: Fri, 28 Mar 2014 11:03:13 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] xfs: extra semi-colon breaks a condition
Message-ID: <20140328080313.GA25192@mwanda>
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
Cc: kernel-janitors@vger.kernel.org, xfs@oss.sgi.com

There were some extra semi-colons here which mean that we return true
unintentionally.

Fixes: a49935f200e2 ('xfs: xfs_check_page_type buffer checks need help')
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 98016b3..75df77d 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -659,10 +659,10 @@ xfs_check_page_type(
 			if (type == XFS_IO_UNWRITTEN)
 				return true;
 		} else if (buffer_delay(bh)) {
-			if (type == XFS_IO_DELALLOC);
+			if (type == XFS_IO_DELALLOC)
 				return true;
 		} else if (buffer_dirty(bh) && buffer_mapped(bh)) {
-			if (type == XFS_IO_OVERWRITE);
+			if (type == XFS_IO_OVERWRITE)
 				return true;
 		}
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
