Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A49E97F47
	for <xfs@oss.sgi.com>; Tue,  5 May 2015 15:16:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7D63B8F8084
	for <xfs@oss.sgi.com>; Tue,  5 May 2015 13:16:49 -0700 (PDT)
Received: from mail-ig0-f171.google.com (mail-ig0-f171.google.com
	[209.85.213.171]) by cuda.sgi.com with ESMTP id
	nQ80KVFHHmFFv0YK (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 05 May 2015 13:16:48 -0700 (PDT)
Received: by iget9 with SMTP id t9so85660800ige.1
	for <xfs@oss.sgi.com>; Tue, 05 May 2015 13:16:47 -0700 (PDT)
From: Nicholas Krause <xerofoify@gmail.com>
Subject: [PATCH 01/12] xfs:Make the function,xfs_alloc_lookup_eq static
Date: Tue,  5 May 2015 16:16:28 -0400
Message-Id: <1430856999-31952-1-git-send-email-xerofoify@gmail.com>
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
To: david@fromorbit.com
Cc: jack@suse.cz, bfoster@redhat.com, sandeen@sandeen.net, linux-kernel@vger.kernel.org, xfs@oss.sgi.com, hch@lst.de

This makes the function,xfs_alloc_lookup_eq static as there are no
calls to this function outside the definition file for this function,
xfs_alloc.c.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index 516162b..48de3f0 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -52,7 +52,7 @@ STATIC int xfs_alloc_ag_vextent_small(xfs_alloc_arg_t *,
 /*
  * Lookup the record equal to [bno, len] in the btree given by cur.
  */
-STATIC int				/* error */
+static int				/* error */
 xfs_alloc_lookup_eq(
 	struct xfs_btree_cur	*cur,	/* btree cursor */
 	xfs_agblock_t		bno,	/* starting block of extent */
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
