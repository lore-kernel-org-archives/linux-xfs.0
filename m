Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A04A57CBF
	for <linux-xfs@oss.sgi.com>; Wed, 31 Jul 2013 20:33:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 6AC7F8F8033
	for <linux-xfs@oss.sgi.com>; Wed, 31 Jul 2013 18:33:49 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id GCPUR9rRdCZHA2A0 for
	<linux-xfs@oss.sgi.com>; Wed, 31 Jul 2013 18:33:48 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r711Xm6c018399
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-xfs@oss.sgi.com>; Wed, 31 Jul 2013 21:33:48 -0400
Received: from Liberator.local (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id r711XlRP021810
	(version=TLSv1/SSLv3 cipher=DHE-RSA-CAMELLIA256-SHA bits=256 verify=NO)
	for <linux-xfs@oss.sgi.com>; Wed, 31 Jul 2013 21:33:47 -0400
Message-ID: <51F9BAFB.9000808@redhat.com>
Date: Wed, 31 Jul 2013 20:33:47 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfs:free bp in xlog_find_tail() error path
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
To: "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>

xlog_find_tail() currently leaks a bp on one error path.

There is no error target, so manually free the bp before
returning the error.

Found by Coverity.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

p.s. this can be merged to userspace as well.

diff --git a/fs/xfs/xfs_log_recover.c b/fs/xfs/xfs_log_recover.c
index 2e10742..05c9fab 100644
--- a/fs/xfs/xfs_log_recover.c
+++ b/fs/xfs/xfs_log_recover.c
@@ -963,6 +963,7 @@ xlog_find_tail(
 	}
 	if (!found) {
 		xfs_warn(log->l_mp, "%s: couldn't find sync record", __func__);
+		xlog_put_bp(bp);
 		ASSERT(0);
 		return XFS_ERROR(EIO);
 	}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
