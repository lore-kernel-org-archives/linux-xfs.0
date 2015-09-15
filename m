Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5B7027F72
	for <xfs@oss.sgi.com>; Tue, 15 Sep 2015 04:59:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 398CA8F8037
	for <xfs@oss.sgi.com>; Tue, 15 Sep 2015 02:59:48 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 7mDRTsd85B2MIWyD (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 15 Sep 2015 02:59:47 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id CFA44A89
	for <xfs@oss.sgi.com>; Tue, 15 Sep 2015 09:59:46 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 08/14] xfsprogs: Remove conflicting define for OS X
Date: Tue, 15 Sep 2015 11:59:18 +0200
Message-Id: <1442311164-12921-9-git-send-email-jtulak@redhat.com>
In-Reply-To: <1442311164-12921-1-git-send-email-jtulak@redhat.com>
References: <1442311164-12921-1-git-send-email-jtulak@redhat.com>
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
Cc: Jan Tulak <jtulak@redhat.com>

ENOATTR already exists in OS X.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/darwin.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/darwin.h b/include/darwin.h
index 78f7df3..1409c91 100644
--- a/include/darwin.h
+++ b/include/darwin.h
@@ -156,7 +156,6 @@ typedef int64_t		xfs_daddr_t;
 #define O_SYNC          0
 #endif
 
-#define ENOATTR		989     /* Attribute not found */
 #define EFSCORRUPTED	990	/* Filesystem is corrupted */
 #define EFSBADCRC	991	/* Bad CRC detected */
 #define constpp		char * const *
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
