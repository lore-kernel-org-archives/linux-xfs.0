Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F0E0929E03
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 11:23:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id E2CEF8F8033
	for <xfs@oss.sgi.com>; Mon, 17 Aug 2015 09:23:48 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id PvexGJ7DlcLhcVyN (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 17 Aug 2015 09:23:48 -0700 (PDT)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 01/11] xfsprogs: undefined variable fix
Date: Mon, 17 Aug 2015 18:23:16 +0200
Message-Id: <1439828606-7886-2-git-send-email-jtulak@redhat.com>
In-Reply-To: <1439828606-7886-1-git-send-email-jtulak@redhat.com>
References: <1439828606-7886-1-git-send-email-jtulak@redhat.com>
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

Typo fix, which wasn't caught earlier due to #ifdef branching.  The
'rmnttomname' does not exists anywhere and looks like a hybrid between
rmntfromname and rmntonname. And because the previous 'if' has
'fromname' on both arguments of realpath, I choosed the same approach
when fixing it.

Signed-off-by: Jan Tulak <jtulak@redhat.com>
---
 libxcmd/paths.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/libxcmd/paths.c b/libxcmd/paths.c
index c56b06b..5c65737 100644
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
2.4.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
