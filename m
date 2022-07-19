Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4186DC43334
	for <linux-xfs@archiver.kernel.org>; Tue, 19 Jul 2022 21:45:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235209AbiGSVpH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 19 Jul 2022 17:45:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231751AbiGSVpG (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 19 Jul 2022 17:45:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 210E0C0C
        for <linux-xfs@vger.kernel.org>; Tue, 19 Jul 2022 14:45:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9B9F861A77
        for <linux-xfs@vger.kernel.org>; Tue, 19 Jul 2022 21:45:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04D83C341CA;
        Tue, 19 Jul 2022 21:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658267104;
        bh=zrHuUrkVXhXyEQlglbjIkxyxkOkLBmcyO0Oc4CY8v0A=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=pN+hkYwLj4uUDQ1g+0nGmrv1gGbZfIZ9VW/fTv4VgV3dZtNvgXRqsVnaq+UCbpFAE
         QYnBeZBmSTPl4On2MfpeQjYRTXYyOiy4dGB1kvc0oOwyDfwN0XjtJeAQIe+JRrjGEr
         f/e/XxLH9TLECvKp2lk3ETEgCugK9Z9lHgXCTB+6iF3MnrARo+D+vvvLVp2UvPthNB
         sJ39YfxI+KJoY73NGrDC3+U0LBs+gYM2Qwb+HCqG5EighkOKgqxmLpTLu0LUSjT/C5
         uII5NoWK3A6x7nbhAk+dE/zBpj59VZmb/vsuP95laj63GDtHF6nvgLdYIO7A6Wq22G
         5n/z5wi2UwpHw==
Subject: [PATCH 1/2] mkfs: ignore data blockdev stripe geometry for small
 filesystems
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Tue, 19 Jul 2022 14:45:03 -0700
Message-ID: <165826710360.3268874.3266999101684853751.stgit@magnolia>
In-Reply-To: <165826709801.3268874.7256134380224140720.stgit@magnolia>
References: <165826709801.3268874.7256134380224140720.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

As part of the process of removing support for tiny filesystems (defined
in the next patch to be anything under 300MB or 64M log size), we are
trying to eliminate all the edge case regressions for small filesystems
that the maintainer can find.

Eric pointed out that the use case of formatting a 510M on a RAID device
regresses once we start enforcing the 64M log size limit:

# modprobe scsi_debug opt_blks=256 opt_xferlen_exp=6 dev_size_mb=510
# mkfs.xfs /dev/sdg
Log size must be at least 64MB.

<hapless user reads manpage, adjusts log size>

# mkfs.xfs -l size=64m /dev/sdg
internal log size 16384 too large, must be less than 16301

Because the device reports a stripe geometry, mkfs tries to create 8 AGs
(instead of the usual 4) which are then very nearly 64M in size.  The
log itself cannot consume the entire AG, so its size is decreased, so
its size is rounded down to allow the creation of AG headers and btrees,
and then the log size is rounded down again to match the stripe unit.
This results in a log that is less than 64MB in size, causing the format
to fail.

There's not much point in formatting tiny AGs on a small filesystem,
even if it is on a RAID.  Doubling the AG count from 4 to 8 doubles the
metadata overhead, conflicts with our attempts to boost the log size,
and on 2022-era storage hardware gains us very little extra performance
since we're not limited by storage access times.

Therefore, disable automatic detection of stripe unit and width if the
data device is less than 1GB.  We would like to format with 128M AGs to
avoid constraining the size of the internal log, and since RAIDs smaller
than 8GB are formatted with 8 AGs by default, 128*8=1G was chosen as the
cutoff.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 mkfs/xfs_mkfs.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)


diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
index a5e2df76..68d6bd18 100644
--- a/mkfs/xfs_mkfs.c
+++ b/mkfs/xfs_mkfs.c
@@ -2583,6 +2583,20 @@ _("%s: Volume reports invalid stripe unit (%d) and stripe width (%d), ignoring.\
 				progname, BBTOB(ft->dsunit), BBTOB(ft->dswidth));
 			ft->dsunit = 0;
 			ft->dswidth = 0;
+		} else if (cfg->dblocks < GIGABYTES(1, cfg->blocklog)) {
+			/*
+			 * Don't use automatic stripe detection if the device
+			 * size is less than 1GB because the performance gains
+			 * on such a small system are not worth the risk that
+			 * we'll end up with an undersized log.
+			 */
+			if (ft->dsunit || ft->dswidth)
+				fprintf(stderr,
+_("%s: small data volume, ignoring data volume stripe unit %d and stripe width %d\n"),
+						progname, ft->dsunit,
+						ft->dswidth);
+			ft->dsunit = 0;
+			ft->dswidth = 0;
 		} else {
 			dsunit = ft->dsunit;
 			dswidth = ft->dswidth;

