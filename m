Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BD3247F3F
	for <xfs@oss.sgi.com>; Tue, 15 Sep 2015 04:59:47 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 9FE6C304048
	for <xfs@oss.sgi.com>; Tue, 15 Sep 2015 02:59:47 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id XiyWikxMquLMtPRB (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 15 Sep 2015 02:59:46 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id E91443B3C7
	for <xfs@oss.sgi.com>; Tue, 15 Sep 2015 09:59:45 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 07/14] xfsprogs: uuid changes for OS X
Date: Tue, 15 Sep 2015 11:59:17 +0200
Message-Id: <1442311164-12921-8-git-send-email-jtulak@redhat.com>
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

UUID API changed in OS X in last few years, so fix the platform_ calls.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 include/darwin.h | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/include/darwin.h b/include/darwin.h
index fe489a6..78f7df3 100644
--- a/include/darwin.h
+++ b/include/darwin.h
@@ -81,45 +81,37 @@ static __inline__ void platform_getoptreset(void)
 
 static __inline__ int platform_uuid_compare(uuid_t *uu1, uuid_t *uu2)
 {
-	return uuid_compare(uu1, uu2, NULL);
+	return uuid_compare(*uu1, *uu2);
 }
 
 static __inline__ void platform_uuid_unparse(uuid_t *uu, char *buffer)
 {
-	uint32_t status;
-	char *s;
-	uuid_to_string(uu, &s, &status);
-	if (status == uuid_s_ok)
-		strcpy(buffer, s);
-	else buffer[0] = '\0';
-	free(s);
+	uuid_unparse(*uu, buffer);
 }
 
 static __inline__ int platform_uuid_parse(char *buffer, uuid_t *uu)
 {
-	uint32_t status;
-	uuid_from_string(buffer, uu, &status);
-	return (status == uuid_s_ok);
+	return uuid_parse(buffer, *uu);
 }
 
 static __inline__ int platform_uuid_is_null(uuid_t *uu)
 {
-	return uuid_is_nil(uu, NULL);
+	return uuid_is_null(*uu);
 }
 
 static __inline__ void platform_uuid_generate(uuid_t *uu)
 {
-	uuid_create(uu, NULL);
+	uuid_generate(*uu);
 }
 
 static __inline__ void platform_uuid_clear(uuid_t *uu)
 {
-	uuid_create_nil(uu, NULL);
+	uuid_clear(*uu);
 }
 
 static __inline__ void platform_uuid_copy(uuid_t *dst, uuid_t *src)
 {
-	memcpy(dst, src, sizeof(uuid_t));
+	uuid_copy(*dst, *src);
 }
 
 typedef unsigned char		__u8;
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
