Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 81CCB7F47
	for <xfs@oss.sgi.com>; Tue,  1 Sep 2015 03:04:40 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 610368F8033
	for <xfs@oss.sgi.com>; Tue,  1 Sep 2015 01:04:37 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id LmKURv3EanN3wNEA (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 01 Sep 2015 01:04:36 -0700 (PDT)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH v2] xfsprogs: add nftw64 translation for OS X
Date: Tue,  1 Sep 2015 10:04:32 +0200
Message-Id: <1441094672-18368-1-git-send-email-jtulak@redhat.com>
In-Reply-To: <20150831185944.GI349@infradead.org>
References: <20150831185944.GI349@infradead.org>
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

UPDATE: changed to #define

OS X has only nftw variant - not the 64 suffix used in xfs.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 include/darwin.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/darwin.h b/include/darwin.h
index 72d9c1d..f0f05b3 100644
--- a/include/darwin.h
+++ b/include/darwin.h
@@ -157,6 +157,8 @@ typedef int64_t		xfs_daddr_t;
 
 #define HAVE_FID	1
 
+#define nftw64 nftw
+
 static __inline__ int
 platform_discard_blocks(int fd, uint64_t start, uint64_t len)
 {
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
