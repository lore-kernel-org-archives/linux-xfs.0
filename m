Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BFE827F5A
	for <xfs@oss.sgi.com>; Tue, 15 Sep 2015 04:59:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id A0C59304048
	for <xfs@oss.sgi.com>; Tue, 15 Sep 2015 02:59:44 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id dAzxC93VdvsigETi (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 15 Sep 2015 02:59:43 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id 4872BC0B9190
	for <xfs@oss.sgi.com>; Tue, 15 Sep 2015 09:59:43 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 05/14] xfsprogs: Add includes required for OS X builds (delta)
Date: Tue, 15 Sep 2015 11:59:15 +0200
Message-Id: <1442311164-12921-6-git-send-email-jtulak@redhat.com>
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

Delta patch, an older version missing 3 includes was merged
into 4.2.0-rc2.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/darwin.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/darwin.h b/include/darwin.h
index 4b7ba3a..fe489a6 100644
--- a/include/darwin.h
+++ b/include/darwin.h
@@ -18,6 +18,9 @@
 #ifndef __XFS_DARWIN_H__
 #define __XFS_DARWIN_H__
 
+#include <unistd.h>
+#include <sys/types.h>
+#include <string.h>
 #include <uuid/uuid.h>
 #include <libgen.h>
 #include <sys/vm.h>
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
