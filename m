Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1E25B7FA3
	for <xfs@oss.sgi.com>; Wed,  6 Aug 2014 09:13:52 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F179F8F804B
	for <xfs@oss.sgi.com>; Wed,  6 Aug 2014 07:13:48 -0700 (PDT)
Received: from mail-pa0-f43.google.com (mail-pa0-f43.google.com
	[209.85.220.43]) by cuda.sgi.com with ESMTP id T5yyNpmw2tWKaL26
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 06 Aug 2014 07:13:47 -0700 (PDT)
Received: by mail-pa0-f43.google.com with SMTP id lf10so3523897pab.16
	for <xfs@oss.sgi.com>; Wed, 06 Aug 2014 07:13:46 -0700 (PDT)
Date: Wed, 6 Aug 2014 19:43:43 +0530
From: Himangi Saraogi <himangi774@gmail.com>
Subject: [PATCH] xfs: Remove typedef xfs_uu_t
Message-ID: <20140806141343.GA15659@himangi-Dell>
MIME-Version: 1.0
Content-Disposition: inline
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
To: Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Cc: Julia Lawall <julia.lawall@lip6.fr>

The Linux kernel coding style guidelines suggest not using typedefs
for structure types. This patch gets rid of the typedef for xfs_uu_t.
Also the names of the struct is changed to drop the _t, to make the
name look less typedef-like.

The following Coccinelle semantic patch detects the case.

@tn1@
type td;
@@

typedef struct { ... } td;

@script:python tf@
td << tn1.td;
tdres;
@@

coccinelle.tdres = td;

@@
type tn1.td;
identifier tf.tdres;
@@

-typedef
 struct 
+  tdres
   { ... }
-td
 ;

@@
type tn1.td;
identifier tf.tdres;
@@

(
-td
+ struct tdres
|
 const
- td
+ struct tdres
)

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 fs/xfs/uuid.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/uuid.c b/fs/xfs/uuid.c
index b83f76b..1f21d8f 100644
--- a/fs/xfs/uuid.c
+++ b/fs/xfs/uuid.c
@@ -18,13 +18,13 @@
 #include <xfs.h>
 
 /* IRIX interpretation of an uuid_t */
-typedef struct {
+struct xfs_uu {
 	__be32	uu_timelow;
 	__be16	uu_timemid;
 	__be16	uu_timehi;
 	__be16	uu_clockseq;
 	__be16	uu_node[3];
-} xfs_uu_t;
+};
 
 /*
  * uuid_getnodeuniq - obtain the node unique fields of a UUID.
@@ -35,7 +35,7 @@ typedef struct {
 void
 uuid_getnodeuniq(uuid_t *uuid, int fsid [2])
 {
-	xfs_uu_t *uup = (xfs_uu_t *)uuid;
+	struct xfs_uu *uup = (struct xfs_uu *)uuid;
 
 	fsid[0] = (be16_to_cpu(uup->uu_clockseq) << 16) |
 		   be16_to_cpu(uup->uu_timemid);
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
