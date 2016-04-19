Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 333E77CA0
	for <xfs@oss.sgi.com>; Tue, 19 Apr 2016 15:29:28 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id A6485AC002
	for <xfs@oss.sgi.com>; Tue, 19 Apr 2016 13:29:27 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id 6WNL00FMBocWs0jD (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 19 Apr 2016 13:29:26 -0700 (PDT)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mx1.redhat.com (Postfix) with ESMTPS id 9C6BB7F359
	for <xfs@oss.sgi.com>; Tue, 19 Apr 2016 20:29:25 +0000 (UTC)
Received: from Liberator.local (ovpn01.gateway.prod.ext.phx2.redhat.com
	[10.5.9.1])
	by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP
	id u3JKTOae011824
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <xfs@oss.sgi.com>; Tue, 19 Apr 2016 16:29:25 -0400
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs_repair: fix agf limit error messages
Message-ID: <57169524.30307@redhat.com>
Date: Tue, 19 Apr 2016 16:29:24 -0400
MIME-Version: 1.0
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

Today we see errors like
"fllast 118 in agf 94 too large (max = 118)"
which makes no sense.

If we are erroring on X >= Y, Y is clearly not the
maximum allowable value.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/repair/agheader.c b/repair/agheader.c
index bd11ac2..b95cedd 100644
--- a/repair/agheader.c
+++ b/repair/agheader.c
@@ -94,7 +94,7 @@ verify_set_agf(xfs_mount_t *mp, xfs_agf_t *agf, xfs_agnumber_t i)
 	if (be32_to_cpu(agf->agf_flfirst) >= XFS_AGFL_SIZE(mp))  {
 		do_warn(_("flfirst %d in agf %d too large (max = %zu)\n"),
 			be32_to_cpu(agf->agf_flfirst),
-			i, XFS_AGFL_SIZE(mp));
+			i, XFS_AGFL_SIZE(mp) - 1);
 		if (!no_modify)
 			agf->agf_flfirst = cpu_to_be32(0);
 	}
@@ -102,7 +102,7 @@ verify_set_agf(xfs_mount_t *mp, xfs_agf_t *agf, xfs_agnumber_t i)
 	if (be32_to_cpu(agf->agf_fllast) >= XFS_AGFL_SIZE(mp))  {
 		do_warn(_("fllast %d in agf %d too large (max = %zu)\n"),
 			be32_to_cpu(agf->agf_fllast),
-			i, XFS_AGFL_SIZE(mp));
+			i, XFS_AGFL_SIZE(mp) - 1);
 		if (!no_modify)
 			agf->agf_fllast = cpu_to_be32(0);
 	}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
