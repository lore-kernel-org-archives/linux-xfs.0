Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 18BAC7F47
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 19:32:43 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BB772AC007
	for <xfs@oss.sgi.com>; Tue, 25 Aug 2015 17:32:42 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id nY9Uwrfi0D72Hjw3 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 25 Aug 2015 17:32:41 -0700 (PDT)
Subject: [PATCH 03/11] libxfs: fix XFS_WANT_CORRUPTED_* macros to return
	negative error codes
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Date: Tue, 25 Aug 2015 17:32:39 -0700
Message-ID: <20150826003239.23973.614.stgit@birch.djwong.org>
In-Reply-To: <20150826003220.23973.59731.stgit@birch.djwong.org>
References: <20150826003220.23973.59731.stgit@birch.djwong.org>
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
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: xfs@oss.sgi.com

Since the rest of libxfs returns negative error codes, these two sanity
checking macros ought to have the same applied.  While we're at it,
fix a couple more sign errors in the same file.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 libxfs/libxfs_priv.h |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)


diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 2a8b850..22f2d53 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -148,9 +148,9 @@ enum ce { CE_DEBUG, CE_CONT, CE_NOTE, CE_WARN, CE_ALERT, CE_PANIC };
 #define XFS_TRANS_UNRESERVE_QUOTA_NBLKS(mp,tp,ip,nblks,ninos,fl)	0
 #define XFS_TEST_ERROR(expr,a,b,c)	( expr )
 #define XFS_WANT_CORRUPTED_GOTO(mp, expr, l)	\
-		{ (mp) = (mp); if (!(expr)) { error = EFSCORRUPTED; goto l; } }
+		{ (mp) = (mp); if (!(expr)) { error = -EFSCORRUPTED; goto l; } }
 #define XFS_WANT_CORRUPTED_RETURN(mp, expr)	\
-		{ (mp) = (mp); if (!(expr)) { return EFSCORRUPTED; } }
+		{ (mp) = (mp); if (!(expr)) { return -EFSCORRUPTED; } }
 
 #ifdef __GNUC__
 #define __return_address	__builtin_return_address(0)
@@ -417,8 +417,7 @@ do { \
 })
 
 #define xfs_rotorstep				1
-#define xfs_bmap_rtalloc(a)			(ENOSYS)
-#define xfs_rtpick_extent(mp,tp,len,p)		(ENOSYS)
+#define xfs_bmap_rtalloc(a)			(-ENOSYS)
 #define xfs_get_extsz_hint(ip)			(0)
 #define xfs_inode_is_filestream(ip)		(0)
 #define xfs_filestream_lookup_ag(ip)		(0)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
