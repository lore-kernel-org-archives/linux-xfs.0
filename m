Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 349AD7F60
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 07:02:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id B1E0EAC003
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 05:02:50 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id AwDVSD0np1nmZzA7 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 26 Aug 2015 05:02:49 -0700 (PDT)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 06/11] xfsprogs: Remove conflicting define for OS X
Date: Wed, 26 Aug 2015 14:02:30 +0200
Message-Id: <1440590555-20463-6-git-send-email-jtulak@redhat.com>
In-Reply-To: <1440590555-20463-1-git-send-email-jtulak@redhat.com>
References: <1440590449-20372-1-git-send-email-jtulak@redhat.com>
	<1440590555-20463-1-git-send-email-jtulak@redhat.com>
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
Cc: hch@infradead.org, Jan Tulak <jtulak@redhat.com>

ENOATTR already exists in OS X.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 include/darwin.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/darwin.h b/include/darwin.h
index 82ccf04..72d9c1d 100644
--- a/include/darwin.h
+++ b/include/darwin.h
@@ -151,7 +151,6 @@ typedef int64_t		xfs_daddr_t;
 #define O_SYNC          0
 #endif
 
-#define ENOATTR		989     /* Attribute not found */
 #define EFSCORRUPTED	990	/* Filesystem is corrupted */
 #define EFSBADCRC	991	/* Bad CRC detected */
 #define constpp		char * const *
-- 
2.4.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
