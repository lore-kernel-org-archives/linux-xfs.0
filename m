Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8D8DB7F5F
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 07:02:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2ADBFAC001
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 05:02:51 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id kuXMhajznIPVHejt (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 26 Aug 2015 05:02:50 -0700 (PDT)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 07/11] xfsprogs: add nftw64 translation for OS X
Date: Wed, 26 Aug 2015 14:02:31 +0200
Message-Id: <1440590555-20463-7-git-send-email-jtulak@redhat.com>
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

OS X has only nftw variant - not the 64 suffix used in xfs.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 include/darwin.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/darwin.h b/include/darwin.h
index 72d9c1d..94e7551 100644
--- a/include/darwin.h
+++ b/include/darwin.h
@@ -163,4 +163,10 @@ platform_discard_blocks(int fd, uint64_t start, uint64_t len)
 	return 0;
 }
 
+static inline int nftw64(const char *path, int (*fn)(const char *, const struct stat *ptr, int flag, struct FTW *), int depth,
+         int flags)
+{
+	return nftw(path, fn, depth, flags);
+}
+
 #endif	/* __XFS_DARWIN_H__ */
-- 
2.4.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
