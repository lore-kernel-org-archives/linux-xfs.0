Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 591AFC433F5
	for <linux-xfs@archiver.kernel.org>; Fri, 28 Jan 2022 22:44:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351746AbiA1WoN (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 28 Jan 2022 17:44:13 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:45002 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346165AbiA1WoM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 28 Jan 2022 17:44:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2FB9260C82
        for <linux-xfs@vger.kernel.org>; Fri, 28 Jan 2022 22:44:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B7A5C340E7;
        Fri, 28 Jan 2022 22:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643409850;
        bh=FehMp/nigiIKICe39mLYhJdnYxRI4ditLzPyP1r2ebE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ur6E0jNTY+LjxAACgdm8NHYq/BLoyzYQqAMT3aY8lC6w8CPVsbx2l3L6FUbo3+PxW
         ECaIDVaiY+P6rn+axcIRgs6Sf2kjszS50Ct6IwcunI9mGizVy19IHrydqeRSMt3PgS
         yoOBW+Nbv5QCtM4kvCt5jWXeTc1ed8fX+GRrSyrlnLhUTyHRlbpWvKjP8u5XimnxRB
         H7MSsIjYqBk46hm5hP/HcA1KQEmjqbtrYdcdMPs6In+JYN/PN9b0F+TJsHZH3Xlbi7
         3101HBiaWuY4Hxg7nPWjbZFvmodzwfNa0vifMg/QxvqaEz+W0p/YEO1f6ZeUmjtxeH
         uNdzB/nNWpX4g==
Date:   Fri, 28 Jan 2022 14:44:10 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net
Cc:     Christoph Hellwig <hch@lst.de>, Dave Chinner <dchinner@redhat.com>,
        Theodore Ts'o <tytso@mit.edu>, linux-xfs@vger.kernel.org,
        allison.henderson@oracle.com
Subject: [PATCH 18/17] xfs_scrub: fix reporting if we can't open raw block
 devices
Message-ID: <20220128224410.GL13540@magnolia>
References: <164263809453.863810.8908193461297738491.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <164263809453.863810.8908193461297738491.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

The error checking logic for opening the data, log, and rt device is
totally broken.  Fix this.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 scrub/phase1.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/scrub/phase1.c b/scrub/phase1.c
index 4f028249..fd1050c9 100644
--- a/scrub/phase1.c
+++ b/scrub/phase1.c
@@ -170,9 +170,9 @@ _("Unable to find realtime device path."));
 
 	/* Open the raw devices. */
 	ctx->datadev = disk_open(ctx->fsinfo.fs_name);
-	if (error) {
-		str_errno(ctx, ctx->fsinfo.fs_name);
-		return error;
+	if (!ctx->datadev) {
+		str_error(ctx, ctx->mntpoint, _("Unable to open data device."));
+		return ECANCELED;
 	}
 
 	ctx->nr_io_threads = disk_heads(ctx->datadev);
@@ -184,16 +184,18 @@ _("Unable to find realtime device path."));
 
 	if (ctx->fsinfo.fs_log) {
 		ctx->logdev = disk_open(ctx->fsinfo.fs_log);
-		if (error) {
-			str_errno(ctx, ctx->fsinfo.fs_name);
-			return error;
+		if (!ctx->logdev) {
+			str_error(ctx, ctx->mntpoint,
+				_("Unable to open external log device."));
+			return ECANCELED;
 		}
 	}
 	if (ctx->fsinfo.fs_rt) {
 		ctx->rtdev = disk_open(ctx->fsinfo.fs_rt);
-		if (error) {
-			str_errno(ctx, ctx->fsinfo.fs_name);
-			return error;
+		if (!ctx->rtdev) {
+			str_error(ctx, ctx->mntpoint,
+				_("Unable to open realtime device."));
+			return ECANCELED;
 		}
 	}
 
