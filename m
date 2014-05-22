Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6F0317F3F
	for <xfs@oss.sgi.com>; Thu, 22 May 2014 09:04:18 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 03439AC002
	for <xfs@oss.sgi.com>; Thu, 22 May 2014 07:04:14 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id ekAOVLUNvoV44lTL (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 22 May 2014 07:04:13 -0700 (PDT)
Date: Thu, 22 May 2014 17:04:05 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch v2] [XFS] small cleanup in xfs_lowbit64()
Message-ID: <20140522140405.GA27116@mwanda>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20140521142909.GA22281@infradead.org>
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

There are two checkpatch.pl complaints here because of the bad indenting
and because of the assignment inside the condition.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
v2: more cleanups

diff --git a/fs/xfs/xfs_bit.h b/fs/xfs/xfs_bit.h
index f1e3c90..e1649c0 100644
--- a/fs/xfs/xfs_bit.h
+++ b/fs/xfs/xfs_bit.h
@@ -66,8 +66,11 @@ static inline int xfs_lowbit64(__uint64_t v)
 		n = ffs(w);
 	} else {	/* upper bits */
 		w = (__uint32_t)(v >> 32);
-		if (w && (n = ffs(w)))
-		n += 32;
+		if (w) {
+			n = ffs(w);
+			if (n)
+				n += 32;
+		}
 	}
 	return n - 1;
 }

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
