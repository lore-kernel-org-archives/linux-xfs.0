Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 04FB47F3F
	for <xfs@oss.sgi.com>; Mon, 16 Jun 2014 18:14:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EC8D88F8033
	for <xfs@oss.sgi.com>; Mon, 16 Jun 2014 16:14:25 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id z6m3UqXEP8bV7Jxw for <xfs@oss.sgi.com>;
	Mon, 16 Jun 2014 16:14:24 -0700 (PDT)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH 1/2] libxfs: don't send null bp to xfs_trans_brelse()
Date: Mon, 16 Jun 2014 18:14:20 -0500
Message-Id: <1402960461-27881-2-git-send-email-sandeen@redhat.com>
In-Reply-To: <1402960461-27881-1-git-send-email-sandeen@redhat.com>
References: <1402960461-27881-1-git-send-email-sandeen@redhat.com>
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

In this case, if bp is null, error is set, and we send
bp to xfs_trans_brelse, which will try to dereference it.

Test whether we actualy have a buffer before we try to
free it.

Same fix as was sent for kernelspace.

Coverity spotted this.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---
 libxfs/xfs_da_btree.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/libxfs/xfs_da_btree.c b/libxfs/xfs_da_btree.c
index b70454e..b731b54 100644
--- a/libxfs/xfs_da_btree.c
+++ b/libxfs/xfs_da_btree.c
@@ -2582,7 +2582,8 @@ xfs_da_get_buf(
 				    mapp, nmap, 0);
 	error = bp ? bp->b_error : XFS_ERROR(EIO);
 	if (error) {
-		xfs_trans_brelse(trans, bp);
+		if (bp)
+			xfs_trans_brelse(trans, bp);
 		goto out_free;
 	}
 
-- 
1.7.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
