Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 070F729DF9
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 15:10:58 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EEF48304059
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 13:10:57 -0800 (PST)
Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65]) by
	cuda.sgi.com with ESMTP id sLtZv48GmEk3AR4Z (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 12 Jan 2016 13:10:56 -0800 (PST)
Received: from dovecot03.posteo.de (dovecot03.posteo.de [172.16.0.13])
	by mout01.posteo.de (Postfix) with ESMTPS id 8D624209AB
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 22:10:55 +0100 (CET)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by dovecot03.posteo.de (Postfix) with ESMTPSA id 3pg4M336V1z5vN2
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 22:10:55 +0100 (CET)
Date: Tue, 12 Jan 2016 22:08:20 +0100
From: Felix Janda <felix.janda@posteo.de>
Subject: [PATCH 2/6] dump/content.c: Include <linux/limits.h> for
	XATTR_LIST_MAX
Message-ID: <20160112210820.GC10044@nyan>
References: <cover.1452632647.git.felix.janda@posteo.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <cover.1452632647.git.felix.janda@posteo.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 dump/content.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/dump/content.c b/dump/content.c
index 1e86292..97e42ab 100644
--- a/dump/content.c
+++ b/dump/content.c
@@ -36,6 +36,7 @@
 #include <xfs/xfs.h>
 #include <xfs/jdm.h>
 #ifdef linux
+#include <linux/limits.h>
 #include <xfs/xqm.h>
 #endif
 
-- 
2.4.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
