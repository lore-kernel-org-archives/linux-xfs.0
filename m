Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4A1EC00140
	for <linux-xfs@archiver.kernel.org>; Tue, 26 Jul 2022 19:57:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232119AbiGZT5k (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 26 Jul 2022 15:57:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231599AbiGZT5j (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 26 Jul 2022 15:57:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B783357E6
        for <linux-xfs@vger.kernel.org>; Tue, 26 Jul 2022 12:57:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B00B3615E8
        for <linux-xfs@vger.kernel.org>; Tue, 26 Jul 2022 19:57:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 189D6C433C1;
        Tue, 26 Jul 2022 19:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658865458;
        bh=PN8fVpga1EE5rGMhOrveS6R6WcFjC7nFXZxG4LknRCM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=EQ5OO20nxRW/6BOEUmHsE+F8QxRy8qp9HOB2AazecY44ECZDAqDnDFCcijufZ3BgR
         VEC/Kb9wQjcU77Qp4Do0jhu4K72dzogAHeqzE0yZvMy8LeWzGQlMadUyeZw1pBakg1
         bb+XnYDOaZQQ3/yAqS5wIxTLRDnVIc1o6T0lUpOAXfFrFNNtfou1Kh27x+3ENEP/18
         fGjZat4Bbjh1AYBeSUzGN2+m/hpIp6pa2YRdRESz1LTnDfP7B0rAuivHrOw3hjWMos
         W3dNBlISgNlM3zLX/wDmFvXMVNGzMx9nW4egtd75sUlIIKAze6Ho5XPJ5uODNO5Wv8
         7TffX8FFrVF5w==
Subject: [PATCH 1/2] mkfs: ignore data blockdev stripe geometry for small
 filesystems
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Carlos Maiolino <cmaiolino@redhat.com>, linux-xfs@vger.kernel.org
Date:   Tue, 26 Jul 2022 12:57:37 -0700
Message-ID: <165886545768.1604534.94237209457616925.stgit@magnolia>
In-Reply-To: <165886545204.1604534.17138015950772754915.stgit@magnolia>
References: <165886545204.1604534.17138015950772754915.stgit@magnolia>
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
Reviewed-by: Carlos Maiolino <cmaiolino@redhat.com>
---
 man/man8/mkfs.xfs.8.in |    6 +++---
 mkfs/xfs_mkfs.c        |   14 ++++++++++++++
 2 files changed, 17 insertions(+), 3 deletions(-)


diff --git a/man/man8/mkfs.xfs.8.in b/man/man8/mkfs.xfs.8.in
index c9e9a9a6..b961bc30 100644
--- a/man/man8/mkfs.xfs.8.in
+++ b/man/man8/mkfs.xfs.8.in
@@ -456,13 +456,13 @@ is expressed as a multiplier of the stripe unit,
 usually the same as the number of stripe members in the logical
 volume configuration, or data disks in a RAID device.
 .IP
-When a filesystem is created on a logical volume device,
+When a filesystem is created on a block device,
 .B mkfs.xfs
-will automatically query the logical volume for appropriate
+will automatically query the block device for appropriate
 .B sunit
 and
 .B swidth
-values.
+values if the block device and the filesystem size would be larger than 1GB.
 .TP
 .BI noalign
 This option disables automatic geometry detection and creates the filesystem
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

