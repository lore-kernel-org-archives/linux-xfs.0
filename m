Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8B0807F37
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 07:02:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 66598304051
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 05:02:46 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id KHjpA7za2p5qDTnc (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 26 Aug 2015 05:02:45 -0700 (PDT)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 03/11] xfsprogs: Add includes required for OS X builds (delta)
Date: Wed, 26 Aug 2015 14:02:27 +0200
Message-Id: <1440590555-20463-3-git-send-email-jtulak@redhat.com>
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

Delta patch, an older version missing 3 includes was merged
into 4.2.0-rc2.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 include/darwin.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/darwin.h b/include/darwin.h
index b904898..8b5a661 100644
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
2.4.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
