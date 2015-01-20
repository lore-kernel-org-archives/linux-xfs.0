Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A29497F3F
	for <xfs@oss.sgi.com>; Tue, 20 Jan 2015 09:15:13 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 914FF30405F
	for <xfs@oss.sgi.com>; Tue, 20 Jan 2015 07:15:10 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id QJ1BaVmrYGRdCY3k (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 20 Jan 2015 07:15:09 -0800 (PST)
Received: from int-mx13.intmail.prod.int.phx2.redhat.com
	(int-mx13.intmail.prod.int.phx2.redhat.com [10.5.11.26])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id t0KFF7Xx006509
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Tue, 20 Jan 2015 10:15:08 -0500
Received: from bfoster.bfoster ([10.18.41.237])
	by int-mx13.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id t0KFF7Zf022026
	for <xfs@oss.sgi.com>; Tue, 20 Jan 2015 10:15:07 -0500
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH] xfs: remove incorrect error negation in attr_multi ioctl
Date: Tue, 20 Jan 2015 10:15:06 -0500
Message-Id: <1421766906-55011-1-git-send-email-bfoster@redhat.com>
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

xfs_compat_attrmulti_by_handle() calls memdup_user() which returns a
negative error code. The error code is negated by the caller and thus
incorrectly converted to a positive error code.

Remove the error negation such that the negative error is passed
correctly back up to userspace.

Signed-off-by: Brian Foster <bfoster@redhat.com>
---
 fs/xfs/xfs_ioctl32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/xfs_ioctl32.c b/fs/xfs/xfs_ioctl32.c
index ec67728..bfc7c7c 100644
--- a/fs/xfs/xfs_ioctl32.c
+++ b/fs/xfs/xfs_ioctl32.c
@@ -423,7 +423,7 @@ xfs_compat_attrmulti_by_handle(
 
 	ops = memdup_user(compat_ptr(am_hreq.ops), size);
 	if (IS_ERR(ops)) {
-		error = -PTR_ERR(ops);
+		error = PTR_ERR(ops);
 		goto out_dput;
 	}
 
-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
