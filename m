Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 54F927F4E
	for <xfs@oss.sgi.com>; Thu, 31 Jan 2013 14:13:29 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D783EAC001
	for <xfs@oss.sgi.com>; Thu, 31 Jan 2013 12:13:25 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id khl0gh5cellxW0a4 for
	<xfs@oss.sgi.com>; Thu, 31 Jan 2013 12:13:25 -0800 (PST)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r0VKDOAq028481
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Thu, 31 Jan 2013 15:13:24 -0500
Received: from andromeda.usersys.redhat.com.com (ovpn-113-133.phx2.redhat.com
	[10.3.113.133])
	by int-mx02.intmail.prod.int.phx2.redhat.com (8.13.8/8.13.8) with ESMTP
	id r0VKDNn4005330
	for <xfs@oss.sgi.com>; Thu, 31 Jan 2013 15:13:23 -0500
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: [PATCH] xfsdump: properly set Parent's PID
Date: Thu, 31 Jan 2013 15:13:17 -0500
Message-Id: <1359663197-30473-1-git-send-email-cmaiolino@redhat.com>
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

Set parentpid variable to the correct Parent's ID using getppid() instead of
getpid()

Signed-off-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 common/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/common/main.c b/common/main.c
index 980d2d4..848a887 100644
--- a/common/main.c
+++ b/common/main.c
@@ -198,7 +198,7 @@ main( int argc, char *argv[] )
 	/* Get the parent's pid. will be used in signal handling
 	 * to differentiate parent from children.
 	 */
-	parentpid = getpid( );
+	parentpid = getppid( );
 	rval = atexit(mlog_exit_flush);
 	assert(rval == 0);
 
-- 
1.8.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
