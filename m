Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23713 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752059AbdFPRzn (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 16 Jun 2017 13:55:43 -0400
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 3CF28659A1
        for <linux-xfs@vger.kernel.org>; Fri, 16 Jun 2017 17:55:38 +0000 (UTC)
From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] mkfs.xfs: allow specification of 0 data stripe width & unit
Message-ID: <4159086b-9bbc-1bf6-5b04-e8f647a01ef2@redhat.com>
Date: Fri, 16 Jun 2017 12:55:37 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs <linux-xfs@vger.kernel.org>
Cc: Jan Tulak <jtulak@redhat.com>

The "noalign" option works for this too, but it seems reasonable
to allow explicit specification of stripe unit and stripe width
to 0; today, doing so today makes the code think it's unspecified,
and so it goes ahead and detects stripe geometry and sets it in the
superblock.  That's unexpected and surprising.

Create a new flag that tracks whtether a geometry option has been
specified, and if it's set along with 0 values, treat it the
same as if "noalign" had been specified.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

I suppose another option would be to disallow 0 values; that
would eliminate the flag and the extra logic and could be handled
in all of the value-checking code that exists.  I'm ok either
way, although 0 has been accepted up until now, so it might
be best to not change that.

diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index 930f3d2..874033e 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -1422,6 +1422,7 @@ main(
 	int			dsw;
 	int			dsunit;
 	int			dswidth;
+	int			dsflag;
 	int			force_overwrite;
 	struct fsxattr		fsx;
 	int			ilflag;
@@ -1524,7 +1525,7 @@ main(
 	dfile = logfile = rtfile = NULL;
 	dsize = logsize = rtsize = rtextsize = protofile = NULL;
 	dsu = dsw = dsunit = dswidth = lalign = lsu = lsunit = 0;
-	nodsflag = norsflag = 0;
+	dsflag = nodsflag = norsflag = 0;
 	force_overwrite = 0;
 	worst_freelist = 0;
 	memset(&fsx, 0, sizeof(fsx));
@@ -1590,16 +1591,20 @@ main(
 					break;
 				case D_SUNIT:
 					dsunit = getnum(value, &dopts, D_SUNIT);
+					dsflag = 1;
 					break;
 				case D_SWIDTH:
 					dswidth = getnum(value, &dopts,
 							 D_SWIDTH);
+					dsflag = 1;
 					break;
 				case D_SU:
 					dsu = getnum(value, &dopts, D_SU);
+					dsflag = 1;
 					break;
 				case D_SW:
 					dsw = getnum(value, &dopts, D_SW);
+					dsflag = 1;
 					break;
 				case D_NOALIGN:
 					nodsflag = getnum(value, &dopts,
@@ -2306,6 +2311,10 @@ _("rmapbt not supported with realtime devices\n"));
 	calc_stripe_factors(dsu, dsw, sectorsize, lsu, lsectorsize,
 				&dsunit, &dswidth, &lsunit);
 
+	/* If sunit & swidth were manually specified as 0, same as noalign */
+	if (dsflag && !dsunit && !dswidth)
+		nodsflag = 1;
+
 	xi.setblksize = sectorsize;
 
 	/*

