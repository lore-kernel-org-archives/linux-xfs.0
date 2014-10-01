Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CA31B7F5A
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 10:22:23 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 61E52AC009
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 08:22:19 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id TzQaPn3Ryn66R7Fu for <xfs@oss.sgi.com>;
	Wed, 01 Oct 2014 08:22:18 -0700 (PDT)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 389B265B63AA
	for <xfs@oss.sgi.com>; Wed,  1 Oct 2014 10:22:18 -0500 (CDT)
Message-ID: <542C1C2B.5020803@sandeen.net>
Date: Wed, 01 Oct 2014 10:22:19 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: [PATCH 1/2] xfs: don't send null bp to xfs_trans_brelse()
References: <542C1B36.5080804@redhat.com>
In-Reply-To: <542C1B36.5080804@redhat.com>
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
To: xfs-oss <xfs@oss.sgi.com>

In this case, if bp is NULL, error is set, and we send a
NULL bp to xfs_trans_brelse, which will try to dereference it.

Test whether we actually have a buffer before we try to
free it.

Coverity spotted this.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/fs/xfs/libxfs/xfs_da_btree.c b/fs/xfs/libxfs/xfs_da_btree.c
index 2c42ae2..fd82753 100644
--- a/fs/xfs/libxfs/xfs_da_btree.c
+++ b/fs/xfs/libxfs/xfs_da_btree.c
@@ -2563,7 +2563,8 @@ xfs_da_get_buf(
 				    mapp, nmap, 0);
 	error = bp ? bp->b_error : -EIO;
 	if (error) {
-		xfs_trans_brelse(trans, bp);
+		if (bp)
+			xfs_trans_brelse(trans, bp);
 		goto out_free;
 	}
 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
