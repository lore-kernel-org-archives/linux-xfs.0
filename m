Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 8FA557F67
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2014 18:31:59 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7027E304039
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2014 16:31:56 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id hnghjfjfm3bzIn8S (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 23 Oct 2014 16:31:55 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s9NNVtN9010601
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=FAIL) for <xfs@oss.sgi.com>; Thu, 23 Oct 2014 19:31:55 -0400
Received: from liberator.sandeen.net (ovpn01.gateway.prod.ext.rdu2.redhat.com
	[10.11.146.1])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id s9NNVrhJ014794
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES128-SHA bits=128 verify=NO)
	for <xfs@oss.sgi.com>; Thu, 23 Oct 2014 19:31:54 -0400
Message-ID: <54498FE9.4000103@redhat.com>
Date: Thu, 23 Oct 2014 18:31:53 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: [PATCH] xfsprogs: fix endian mishap in xfs_dialloc_ag()
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

Fixes a regression introduced by:

88fc730 xfs: use and update the finobt on inode allocation

which passed the non-swapped version of agi->agi_newino to
xfs_inobt_lookup()

Caught by make C=2, ftw!

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/libxfs/xfs_ialloc.c b/libxfs/xfs_ialloc.c
index 5462c54..b20a9ec 100644
--- a/libxfs/xfs_ialloc.c
+++ b/libxfs/xfs_ialloc.c
@@ -1057,7 +1057,8 @@ xfs_dialloc_ag(
 		 * most recently allocated inode.
 		 */
 		if (agi->agi_newino != cpu_to_be32(NULLAGINO)) {
-			error = xfs_inobt_lookup(cur, agi->agi_newino,
+			error = xfs_inobt_lookup(cur,
+						 be32_to_cpu(agi->agi_newino),
 						 XFS_LOOKUP_EQ, &i);
 			if (error)
 				goto error_cur;

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
