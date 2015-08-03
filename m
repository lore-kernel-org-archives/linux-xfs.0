Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9F0F87F60
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 09:40:25 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7D5088F8065
	for <xfs@oss.sgi.com>; Mon,  3 Aug 2015 07:40:25 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id xa2S1snynzZihCgq (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 03 Aug 2015 07:40:25 -0700 (PDT)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH v3 03/11] xfsprogs: undefined variable fix
Date: Mon,  3 Aug 2015 16:39:41 +0200
Message-Id: <1438612789-17486-4-git-send-email-jtulak@redhat.com>
In-Reply-To: <1438612789-17486-1-git-send-email-jtulak@redhat.com>
References: <1438612789-17486-1-git-send-email-jtulak@redhat.com>
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

Typo fix, which wasn't catch earlier due to #ifdef branching.  The
'rmnttomname' does not exists anywhere and looks like a hybrid between
rmntfromname and rmntonname. And because the previous if has has
'fromname' on both arguments of realpath, I choose the same approach
when fixing it.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 libxcmd/paths.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libxcmd/paths.c b/libxcmd/paths.c
index c0b1ddb..b360617 100644
--- a/libxcmd/paths.c
+++ b/libxcmd/paths.c
@@ -364,7 +364,7 @@ fs_table_initialise_mounts(
 			continue;
 		if (!realpath(stats[i].f_mntfromname, rmntfromname))
 			continue;
-		if (!realpath(stats[i].f_mntonname, rmnttomname)))
+		if (!realpath(stats[i].f_mntonname, rmntonname))
 			continue;
 
 		if (path &&
-- 
2.4.3

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
