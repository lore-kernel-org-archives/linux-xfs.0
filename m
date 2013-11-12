Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 302317F5D
	for <xfs@oss.sgi.com>; Mon, 11 Nov 2013 22:17:52 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 0E31D8F8039
	for <xfs@oss.sgi.com>; Mon, 11 Nov 2013 20:17:48 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id ev7qPxrhmVNNyzXE for
	<xfs@oss.sgi.com>; Mon, 11 Nov 2013 20:17:47 -0800 (PST)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id rAC4HkgD029788
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 11 Nov 2013 23:17:46 -0500
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH RESEND] xfstests: fix compile error of src/fssum.c on
	bigendian host
Date: Tue, 12 Nov 2013 12:16:53 +0800
Message-Id: <1384229813-30532-1-git-send-email-eguan@redhat.com>
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
Cc: Eryu Guan <eguan@redhat.com>

Definition of htonll() is needed on bigendian host too, otherwise
src/fssum.c won't compile on ppc64/s390x hosts.

Acked-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 src/fssum.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/src/fssum.c b/src/fssum.c
index c75ff8b..c26d32b 100644
--- a/src/fssum.c
+++ b/src/fssum.c
@@ -50,6 +50,8 @@
 
 #if __BYTE_ORDER == __LITTLE_ENDIAN
 #define htonll(x)     __bswap_64 (x)
+#else
+#define htonll(x)     (x)
 #endif
 #endif
 
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
