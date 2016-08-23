Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 34A707CA0
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2016 10:54:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 06944304048
	for <xfs@oss.sgi.com>; Tue, 23 Aug 2016 08:54:54 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 8oKlvWWyUVYifO0X (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 23 Aug 2016 08:54:53 -0700 (PDT)
From: Artem Savkov <asavkov@redhat.com>
Subject: [PATCH] Make __xfs_xattr_put_listen preperly report errors.
Date: Tue, 23 Aug 2016 17:54:13 +0200
Message-Id: <1471967653-2561-1-git-send-email-asavkov@redhat.com>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Artem Savkov <asavkov@redhat.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

Commit "xfs: only return -errno or success from attr ->put_listent" changes the
returnvalue of __xfs_xattr_put_listen to 0 in case when there is insufficient
space in the buffer assuming that setting context->count to -1 would be enough,
but all of the ->put_listent callers only check seen_enough. This results in
a failed assertion:
XFS: Assertion failed: context->count >= 0, file: fs/xfs/xfs_xattr.c, line: 175
in insufficient buffer size case.

Signed-off-by: Artem Savkov <asavkov@redhat.com>
---
 fs/xfs/xfs_xattr.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index ea62245..6290093 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -147,6 +147,7 @@ __xfs_xattr_put_listent(
 	arraytop = context->count + prefix_len + namelen + 1;
 	if (arraytop > context->firstu) {
 		context->count = -1;	/* insufficient space */
+		context->seen_enough = 1;
 		return 0;
 	}
 	offset = (char *)context->alist + context->count;
-- 
2.7.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
