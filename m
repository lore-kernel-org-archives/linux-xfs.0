Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F3C6F29DF9
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 14:02:34 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id EA01C304059
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 12:02:31 -0800 (PST)
Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65]) by
	cuda.sgi.com with ESMTP id 1VVl8KhoyjmHrFDs (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 12 Jan 2016 12:02:30 -0800 (PST)
Received: from dovecot03.posteo.de (dovecot03.posteo.de [172.16.0.13])
	by mout01.posteo.de (Postfix) with ESMTPS id 4517D20A17
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 21:02:29 +0100 (CET)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by dovecot03.posteo.de (Postfix) with ESMTPSA id 3pg2r50ywDz5vNB
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 21:02:29 +0100 (CET)
Date: Tue, 12 Jan 2016 20:59:53 +0100
From: Felix Janda <felix.janda@posteo.de>
Subject: [PATCH 3/6] fsr/xfs_fsr.c: Include <paths.h> for _PATH_MOUNTED
Message-ID: <20160112195953.GD568@nyan>
References: <cover.1452627740.git.felix.janda@posteo.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <cover.1452627740.git.felix.janda@posteo.de>
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

Fixes a compilation failure with musl libc

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 fsr/xfs_fsr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fsr/xfs_fsr.c b/fsr/xfs_fsr.c
index f32aced..8957f93 100644
--- a/fsr/xfs_fsr.c
+++ b/fsr/xfs_fsr.c
@@ -31,6 +31,7 @@
 #include <sys/wait.h>
 #include <sys/statvfs.h>
 #include <sys/xattr.h>
+#include <paths.h>
 
 #ifndef XFS_XFLAG_NODEFRAG
 #define XFS_XFLAG_NODEFRAG 0x00002000 /* src dependancy, remove later */
-- 
2.4.10

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
