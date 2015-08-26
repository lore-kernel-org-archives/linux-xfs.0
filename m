Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CE6F97F59
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 07:02:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6965EAC001
	for <xfs@oss.sgi.com>; Wed, 26 Aug 2015 05:02:49 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id U4h0Pghgh8tMHR4i (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 26 Aug 2015 05:02:48 -0700 (PDT)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 05/11] xfsprogs: uuid changes for OS X
Date: Wed, 26 Aug 2015 14:02:29 +0200
Message-Id: <1440590555-20463-5-git-send-email-jtulak@redhat.com>
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

UUID API changed in OS X in last few years, so fix the platform_ calls.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 include/darwin.h | 22 +++++++---------------
 1 file changed, 7 insertions(+), 15 deletions(-)

diff --git a/include/darwin.h b/include/darwin.h
index 8b5a661..82ccf04 100644
--- a/include/darwin.h
+++ b/include/darwin.h
@@ -76,45 +76,37 @@ static __inline__ void platform_getoptreset(void)
 
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
2.4.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
