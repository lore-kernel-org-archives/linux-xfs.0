Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 303A47F37
	for <xfs@oss.sgi.com>; Wed, 18 Nov 2015 07:09:54 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 142CE304032
	for <xfs@oss.sgi.com>; Wed, 18 Nov 2015 05:09:51 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id S178HONJZOThCanF (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 18 Nov 2015 05:09:50 -0800 (PST)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: Re: [PATCH] xfs_repair: Check for invalid ACL types
Date: Wed, 18 Nov 2015 14:09:45 +0100
Message-Id: <1447852185-6309-1-git-send-email-agruenba@redhat.com>
References: <1445627828-14661-1-git-send-email-agruenba@redhat.com>
	<1445627828-14661-5-git-send-email-agruenba@redhat.com>
	<20151026225520.GK8773@dastard>
	<1445909032-10974-1-git-send-email-agruenba@redhat.com>
In-Reply-To: <1445909032-10974-1-git-send-email-agruenba@redhat.com>
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
To: david@fromorbit.com, xfs@oss.sgi.com
Cc: Andreas Gruenbacher <agruenba@redhat.com>

Here's a follow-up patch to test a filesystem for richacl support.

--

Subject: xfs_db: Report when richacls are supported

When the richacl incompatible filesystem feature is set, include the
word RICHACL in the output of "xfs_db [-r] -c version".

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 db/sb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/db/sb.c b/db/sb.c
index 17d446c..ff6c1f8 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -690,6 +690,8 @@ version_string(
 		strcat(s, ",FTYPE");
 	if (xfs_sb_version_hasfinobt(sbp))
 		strcat(s, ",FINOBT");
+	if (xfs_sb_has_incompat_feature(sbp, XFS_SB_FEAT_INCOMPAT_RICHACL))
+		strcat(s, ",RICHACL");
 	if (xfs_sb_version_hassparseinodes(sbp))
 		strcat(s, ",SPARSE_INODES");
 	if (xfs_sb_version_hasmetauuid(sbp))
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
