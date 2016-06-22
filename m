Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6DA037CA3
	for <xfs@oss.sgi.com>; Tue, 21 Jun 2016 21:50:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id D2596AC001
	for <xfs@oss.sgi.com>; Tue, 21 Jun 2016 19:50:54 -0700 (PDT)
Received: from mail-pf0-f195.google.com (mail-pf0-f195.google.com
	[209.85.192.195]) by cuda.sgi.com with ESMTP id
	QykmijlWdM90JXWR (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 21 Jun 2016 19:50:52 -0700 (PDT)
Received: by mail-pf0-f195.google.com with SMTP id i123so2688153pfg.3
	for <xfs@oss.sgi.com>; Tue, 21 Jun 2016 19:50:52 -0700 (PDT)
MIME-Version: 1.0
From: Kaho Ng <ngkaho1234@gmail.com>
Date: Wed, 22 Jun 2016 10:50:51 +0800
Message-ID: <CAGeO4WOjZazyNsD2McZV6=neGqpMV=7TznX+fhE4wAXHQBGOew@mail.gmail.com>
Subject: [PATCH] xfs: indentation fix in xfs_btree_get_iroot()
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
To: xfs@oss.sgi.com

Spacebars are converted to tabs

Signed-off-by: Kaho Ng <ngkaho1234@gmail.com>
---
 fs/xfs/libxfs/xfs_btree.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index 1f88e1c..41724be 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -543,12 +543,12 @@ xfs_btree_ptr_addr(
  */
 STATIC struct xfs_btree_block *
 xfs_btree_get_iroot(
-       struct xfs_btree_cur    *cur)
+ struct xfs_btree_cur    *cur)
 {
-       struct xfs_ifork        *ifp;
+ struct xfs_ifork *ifp;

-       ifp = XFS_IFORK_PTR(cur->bc_private.b.ip, cur->bc_private.b.whichfork);
-       return (struct xfs_btree_block *)ifp->if_broot;
+ ifp = XFS_IFORK_PTR(cur->bc_private.b.ip, cur->bc_private.b.whichfork);
+ return (struct xfs_btree_block *)ifp->if_broot;
 }

 /*
-- 
2.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
