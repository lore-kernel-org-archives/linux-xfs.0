Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1D9277CA3
	for <xfs@oss.sgi.com>; Thu, 31 Mar 2016 04:13:50 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id DFCC48F8049
	for <xfs@oss.sgi.com>; Thu, 31 Mar 2016 02:13:46 -0700 (PDT)
Received: from mail-pf0-f193.google.com (mail-pf0-f193.google.com
	[209.85.192.193]) by cuda.sgi.com with ESMTP id
	T7Q9tC2EyvK22TxX (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 31 Mar 2016 02:13:45 -0700 (PDT)
Received: by mail-pf0-f193.google.com with SMTP id x3so10428365pfb.0
	for <xfs@oss.sgi.com>; Thu, 31 Mar 2016 02:13:45 -0700 (PDT)
From: Eryu Guan <guaneryu@gmail.com>
Subject: [PATCH] xfs: add missing break in xfs_parseargs()
Date: Thu, 31 Mar 2016 17:13:03 +0800
Message-Id: <1459415583-26981-1-git-send-email-guaneryu@gmail.com>
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
Cc: Eryu Guan <guaneryu@gmail.com>, esandeen@redhat.com

Commit 2e74af0e1189 ("xfs: convert mount option parsing to tokens")
missed a 'break;' in xfs_parseargs() which causes mount to fail with
"-o pqnoenforce" option. xfs/050 catches this failure.

XFS (vda6): Super block does not support project and group quota together

Fixes: 2e74af0e1189 ("xfs: convert mount option parsing to tokens")
Signed-off-by: Eryu Guan <guaneryu@gmail.com>
---
 fs/xfs/xfs_super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/xfs/xfs_super.c b/fs/xfs/xfs_super.c
index d760934..361564e 100644
--- a/fs/xfs/xfs_super.c
+++ b/fs/xfs/xfs_super.c
@@ -350,6 +350,7 @@ xfs_parseargs(
 		case Opt_pqnoenforce:
 			mp->m_qflags |= (XFS_PQUOTA_ACCT | XFS_PQUOTA_ACTIVE);
 			mp->m_qflags &= ~XFS_PQUOTA_ENFD;
+			break;
 		case Opt_gquota:
 		case Opt_grpquota:
 			mp->m_qflags |= (XFS_GQUOTA_ACCT | XFS_GQUOTA_ACTIVE |
-- 
2.5.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
