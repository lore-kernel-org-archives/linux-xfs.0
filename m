Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7BB2A7F47
	for <xfs@oss.sgi.com>; Thu, 14 May 2015 17:18:04 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 24AA6AC001
	for <xfs@oss.sgi.com>; Thu, 14 May 2015 15:18:00 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id HrRXQfl9HbMWPSLR (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 14 May 2015 15:17:57 -0700 (PDT)
Received: from int-mx14.intmail.prod.int.phx2.redhat.com
	(int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t4EMHt0M001889
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Thu, 14 May 2015 18:17:56 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t4EMHsWi020190
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 14 May 2015 18:17:55 -0400
Message-ID: <55551F12.1070308@redhat.com>
Date: Thu, 14 May 2015 17:17:54 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfsprogs: silence unused var warnings
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
To: xfs-oss <xfs@oss.sgi.com>

This takes 2 different approaches, just following similar code
that already exists.  It'll probably make Coverity flag
the pointless assignments, unfortunately.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

Note, this is for the libxfs-4 branch

diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 1b4ac64..c871d53 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -150,9 +150,9 @@ enum ce { CE_DEBUG, CE_CONT, CE_NOTE, CE_WARN, CE_ALERT, CE_PANIC };
 #define XFS_TRANS_UNRESERVE_QUOTA_NBLKS(mp,tp,ip,nblks,ninos,fl)	0
 #define XFS_TEST_ERROR(expr,a,b,c)	( expr )
 #define XFS_WANT_CORRUPTED_GOTO(mp, expr, l)	\
-		{ if (!(expr)) { error = EFSCORRUPTED; goto l; } }
+		{ (mp) = (mp); if (!(expr)) { error = EFSCORRUPTED; goto l; } }
 #define XFS_WANT_CORRUPTED_RETURN(mp, expr)	\
-		{ if (!(expr)) { return EFSCORRUPTED; } }
+		{ (mp) = (mp); if (!(expr)) { return EFSCORRUPTED; } }
 
 #ifdef __GNUC__
 #define __return_address	__builtin_return_address(0)
@@ -344,7 +344,11 @@ roundup_64(__uint64_t x, __uint32_t y)
 
 /* space allocation */
 #define xfs_extent_busy_reuse(mp,ag,bno,len,user)	((void) 0)
-#define xfs_extent_busy_insert(tp,ag,bno,len,flags)	((void) 0)
+/* avoid unused variable warning */
+#define xfs_extent_busy_insert(tp,ag,bno,len,flags)({ 	\
+	xfs_agnumber_t __foo = ag; 			\
+	__foo = 0;					\
+})
 #define xfs_extent_busy_trim(args,fbno,flen,bno,len) \
 do { \
 	*(bno) = (fbno); \

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
