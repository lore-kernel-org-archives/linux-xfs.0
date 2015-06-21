Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 98B4C29E08
	for <xfs@oss.sgi.com>; Sun, 21 Jun 2015 04:24:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 23D4DAC004
	for <xfs@oss.sgi.com>; Sun, 21 Jun 2015 02:24:22 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 3nOKy9W9hAfpMh36 (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 21 Jun 2015 02:24:20 -0700 (PDT)
Received: from smtpout2.drei.com ([109.126.64.2] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.80.1 #2 (Red Hat Linux))
	id 1Z6bUB-0001zl-SH
	for xfs@oss.sgi.com; Sun, 21 Jun 2015 09:24:20 +0000
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 4/8] xfsprogs: remove the uint_t typedef
Date: Sun, 21 Jun 2015 11:22:00 +0200
Message-Id: <1434878524-18176-5-git-send-email-hch@lst.de>
In-Reply-To: <1434878524-18176-1-git-send-email-hch@lst.de>
References: <1434878524-18176-1-git-send-email-hch@lst.de>
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

This was only used in a few IRIX platform helpers that can use __uint32_t
instead.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/irix.h       | 10 +++++-----
 libxfs/libxfs_priv.h |  2 --
 2 files changed, 5 insertions(+), 7 deletions(-)

diff --git a/include/irix.h b/include/irix.h
index 5040451..ad6dbfe 100644
--- a/include/irix.h
+++ b/include/irix.h
@@ -294,13 +294,13 @@ static __inline__ void platform_getoptreset(void)
 
 static __inline__ int platform_uuid_compare(uuid_t *uu1, uuid_t *uu2)
 {
-	uint_t status;
+	__uint32_t status;
 	return uuid_compare(uu1, uu2, &status);
 }
 
 static __inline__ void platform_uuid_unparse(uuid_t *uu, char *buffer)
 {
-	uint_t status;
+	__uint32_t status;
 	char *s;
 	uuid_to_string(uu, &s, &status);
 	if (status == uuid_s_ok)
@@ -311,7 +311,7 @@ static __inline__ void platform_uuid_unparse(uuid_t *uu, char *buffer)
 
 static __inline__ int platform_uuid_parse(char *buffer, uuid_t *uu)
 {
-	uint_t status;
+	__uint32_t status;
 	uuid_from_string(buffer, uu, &status);
 	return (status == uuid_s_ok);
 }
@@ -324,13 +324,13 @@ static __inline__ int platform_uuid_is_null(uuid_t *uu)
 
 static __inline__ void platform_uuid_generate(uuid_t *uu)
 {
-	uint_t status;
+	__uint32_t status;
 	uuid_create(uu, &status);
 }
 
 static __inline__ void platform_uuid_clear(uuid_t *uu)
 {
-	uint_t status;
+	__uint32_t status;
 	uuid_create_nil(uu, &status);
 }
 
diff --git a/libxfs/libxfs_priv.h b/libxfs/libxfs_priv.h
index 37a86aa..fd3494a 100644
--- a/libxfs/libxfs_priv.h
+++ b/libxfs/libxfs_priv.h
@@ -95,8 +95,6 @@ extern char    *progname;
 #undef ASSERT
 #define ASSERT(ex) assert(ex)
 
-typedef __uint32_t		uint_t;
-
 #ifndef EWRONGFS
 #define EWRONGFS	EINVAL
 #endif
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
