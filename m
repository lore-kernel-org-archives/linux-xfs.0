Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 449D47F53
	for <xfs@oss.sgi.com>; Wed,  4 Sep 2013 01:37:27 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 327BB8F8040
	for <xfs@oss.sgi.com>; Tue,  3 Sep 2013 23:37:27 -0700 (PDT)
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id mfCS0LAJsve9rr3q for
	<xfs@oss.sgi.com>; Tue, 03 Sep 2013 23:37:26 -0700 (PDT)
From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: [PATCH 3/4] xfs: allow un-init user namespace to change file's
	project id
Date: Wed, 4 Sep 2013 14:38:36 +0800
Message-Id: <1378276717-9663-4-git-send-email-gaofeng@cn.fujitsu.com>
In-Reply-To: <1378276717-9663-1-git-send-email-gaofeng@cn.fujitsu.com>
References: <1378276717-9663-1-git-send-email-gaofeng@cn.fujitsu.com>
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
Cc: bfoster@redhat.com, dwight.engen@oracle.com, ebiederm@xmission.com, Gao feng <gaofeng@cn.fujitsu.com>

We already make sure un-init user namespace can only change
project id to the ids we allowd. changing project id of files
in un-init user namespace is under control. it's safe to allow
un-init user namespace to change files' project id.

Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
---
 fs/xfs/xfs_ioctl.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/xfs/xfs_ioctl.c b/fs/xfs/xfs_ioctl.c
index 8db622f..b4e1741 100644
--- a/fs/xfs/xfs_ioctl.c
+++ b/fs/xfs/xfs_ioctl.c
@@ -1026,14 +1026,8 @@ xfs_ioctl_setattr(
 
 	/*
 	 * Do a quota reservation only if projid is actually going to change.
-	 * Only allow changing of projid from init_user_ns since it is a
-	 * non user namespace aware identifier.
 	 */
 	if (mask & FSX_PROJID) {
-		if (current_user_ns() != &init_user_ns) {
-			code = XFS_ERROR(EINVAL);
-			goto error_return;
-		}
 
 		if (XFS_IS_QUOTA_RUNNING(mp) &&
 		    XFS_IS_PQUOTA_ON(mp) &&
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
