Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 491DE7F5A
	for <xfs@oss.sgi.com>; Thu, 15 Oct 2015 20:45:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 17FE48F8049
	for <xfs@oss.sgi.com>; Thu, 15 Oct 2015 18:45:21 -0700 (PDT)
Received: from ipmail07.adl2.internode.on.net (ipmail07.adl2.internode.on.net
	[150.101.137.131]) by cuda.sgi.com with ESMTP id
	bwpMLVUQlv1FbKjE for <xfs@oss.sgi.com>;
	Thu, 15 Oct 2015 18:45:19 -0700 (PDT)
Received: from disappointment.disaster.area ([192.168.1.110]
	helo=disappointment) by dastard with esmtp (Exim 4.80)
	(envelope-from <dave@fromorbit.com>) id 1Zmu4u-00019u-Tx
	for xfs@oss.sgi.com; Fri, 16 Oct 2015 12:45:05 +1100
Received: from dave by disappointment with local (Exim 4.86)
	(envelope-from <dave@disappointment.disaster>) id 1Zmu4u-00006A-TH
	for xfs@oss.sgi.com; Fri, 16 Oct 2015 12:45:04 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: [PATCH 5/8] cleanup: define a local xfs_ino_t
Date: Fri, 16 Oct 2015 12:44:58 +1100
Message-Id: <1444959901-31319-6-git-send-email-david@fromorbit.com>
In-Reply-To: <1444959901-31319-1-git-send-email-david@fromorbit.com>
References: <1444959901-31319-1-git-send-email-david@fromorbit.com>
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
To: xfs@oss.sgi.com

From: Dave Chinner <dchinner@redhat.com>

The xfs inode number size is never going to change - it's a
uint64_t. We currently inherit this from xfsprogs headers, but it
goes away in xfsprogs v4.2.0 as it's part of the platform
definitions. Add our own local definition for this type.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
---
 common/types.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/common/types.h b/common/types.h
index 235f52a..0923897 100644
--- a/common/types.h
+++ b/common/types.h
@@ -49,6 +49,8 @@ typedef unsigned long u_long_t;
 typedef size_t ix_t;
 typedef int32_t time32_t;
 
+typedef uint64_t xfs_ino_t;
+
 /* limits
  */
 #define	MKMAX( t, s )	( ( t )						\
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
