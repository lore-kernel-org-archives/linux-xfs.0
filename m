Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6424329E15
	for <xfs@oss.sgi.com>; Tue,  5 May 2015 15:17:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id E62ABAC006
	for <xfs@oss.sgi.com>; Tue,  5 May 2015 13:16:57 -0700 (PDT)
Received: from mail-ig0-f175.google.com (mail-ig0-f175.google.com
	[209.85.213.175]) by cuda.sgi.com with ESMTP id
	HGkSmkrCeDLBA1Dy (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 05 May 2015 13:16:56 -0700 (PDT)
Received: by igblo3 with SMTP id lo3so109207312igb.0
	for <xfs@oss.sgi.com>; Tue, 05 May 2015 13:16:56 -0700 (PDT)
From: Nicholas Krause <xerofoify@gmail.com>
Subject: [PATCH 06/12] xfs:Make the function,xfs_alloc_fixup_trees static
Date: Tue,  5 May 2015 16:16:33 -0400
Message-Id: <1430856999-31952-6-git-send-email-xerofoify@gmail.com>
In-Reply-To: <1430856999-31952-1-git-send-email-xerofoify@gmail.com>
References: <1430856999-31952-1-git-send-email-xerofoify@gmail.com>
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

This makes the function,xfs_alloc_fixup_trees static now due to
it having no external callers outside of the file,xfs_alloc.c.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 fs/xfs/libxfs/xfs_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/xfs/libxfs/xfs_alloc.c b/fs/xfs/libxfs/xfs_alloc.c
index fdf2877..4492311 100644
--- a/fs/xfs/libxfs/xfs_alloc.c
+++ b/fs/xfs/libxfs/xfs_alloc.c
@@ -301,7 +301,7 @@ xfs_alloc_fix_minleft(
  * Flags are passed in indicating whether the cursors are set to the
  * relevant records.
  */
-STATIC int				/* error code */
+static int				/* error code */
 xfs_alloc_fixup_trees(
 	xfs_btree_cur_t	*cnt_cur,	/* cursor for by-size btree */
 	xfs_btree_cur_t	*bno_cur,	/* cursor for by-block btree */
-- 
2.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
