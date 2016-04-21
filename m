Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 93B4E7CD5
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2016 04:40:11 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 58EE630406A
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2016 02:40:11 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id cd9a1FIy7Adch8Ye (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 21 Apr 2016 02:40:10 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 3ED93C056819
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2016 09:40:10 +0000 (UTC)
Received: from jtulak.brq.redhat.com (jtulak.brq.redhat.com [10.34.26.85])
	by int-mx09.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u3L9ds0U007155
	for <xfs@oss.sgi.com>; Thu, 21 Apr 2016 05:40:09 -0400
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 17/19] mkfs: unit conversions are case insensitive
Date: Thu, 21 Apr 2016 11:39:51 +0200
Message-Id: <1461231593-31294-18-git-send-email-jtulak@redhat.com>
In-Reply-To: <1461231593-31294-1-git-send-email-jtulak@redhat.com>
References: <1461231593-31294-1-git-send-email-jtulak@redhat.com>
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

Solves the question "Should I use 10g or 10G?"

Signed-off-by: Jan Tulak <jtulak@redhat.com>

---
CHANGES:
* use tolower instead of == 'p' || == 'P'
---
 mkfs/xfs_mkfs.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index a6334bc..a35c4a5 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -3594,8 +3594,10 @@ cvtnum(
 {
 	long long	i;
 	char		*sp;
+	int		c;
 
 	i = strtoll(s, &sp, 0);
+	c = tolower(*sp);
 	if (i == 0 && sp == s)
 		return -1LL;
 	if (*sp == '\0')
@@ -3606,17 +3608,17 @@ cvtnum(
 	if (*sp == 's' && sp[1] == '\0')
 		return i * sectsize;
 
-	if (*sp == 'k' && sp[1] == '\0')
+	if (c == 'k' && sp[1] == '\0')
 		return 1024LL * i;
-	if (*sp == 'm' && sp[1] == '\0')
+	if (c == 'm' && sp[1] == '\0')
 		return 1024LL * 1024LL * i;
-	if (*sp == 'g' && sp[1] == '\0')
+	if (c == 'g' && sp[1] == '\0')
 		return 1024LL * 1024LL * 1024LL * i;
-	if (*sp == 't' && sp[1] == '\0')
+	if (c == 't' && sp[1] == '\0')
 		return 1024LL * 1024LL * 1024LL * 1024LL * i;
-	if (*sp == 'p' && sp[1] == '\0')
+	if (c == 'p' && sp[1] == '\0')
 		return 1024LL * 1024LL * 1024LL * 1024LL * 1024LL * i;
-	if (*sp == 'e' && sp[1] == '\0')
+	if (c == 'e' && sp[1] == '\0')
 		return 1024LL * 1024LL * 1024LL * 1024LL * 1024LL * 1024LL * i;
 	return -1LL;
 }
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
