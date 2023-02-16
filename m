Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C8F5C636D6
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:18:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbjBPVSF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:18:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbjBPVSE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:18:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39C532727;
        Thu, 16 Feb 2023 13:18:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7B49B82922;
        Thu, 16 Feb 2023 21:18:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9471C433D2;
        Thu, 16 Feb 2023 21:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676582280;
        bh=XooRrfKYY8n5zjVefIFGfHMziObRmtfKZ6kNPvr55/U=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=BK45vI0iJuBP/nBQhrrJufzZVO/rhxGrLMYvxMBwryrmmfocD01cTYqiCpOXNESWr
         xxX7n7rT1NQqKPIBnD7zVyKXBVgZjSNJJ2wHZS3Od0VcMfl9B0MtkwXRNHRrqhMVCf
         Iim4MSV1XlSk0E5fpREFvunpYMoeauMwbWX894HOwdaW1pndzumbn6hXybeo7PWSFF
         E33f+Lsq07amFYBzt4veXErIUKU4IGQ8/xABFSQG1NuORKUFjJDjdVuDLMG04VysCm
         2bYk5a02nO/bNUHSXZSonnzo5BfmjIceU1IvyOyou3RYqY+iqy+kireDBIcpL9zH+q
         6UzFqUOWCASRw==
Date:   Thu, 16 Feb 2023 13:18:00 -0800
Subject: [PATCH 3/4] xfs/242: fix _filter_bmap for xfs_io bmap that does rt
 file properly
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Message-ID: <167657885018.3481738.12498949635668558816.stgit@magnolia>
In-Reply-To: <167657884979.3481738.5353655058338554587.stgit@magnolia>
References: <167657884979.3481738.5353655058338554587.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

xfsprogs commit XXXXX ("xfs_io: fix bmap command not detecting realtime
files with xattrs") fixed the xfs_io bmap output to display realtime
file columns for realtime files with xattrs.  As a result, the data and
unwritten flags are in column 5 and not column 7.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/punch |    8 ++++++++
 1 file changed, 8 insertions(+)


diff --git a/common/punch b/common/punch
index 3b8be21a2a..9e730404e2 100644
--- a/common/punch
+++ b/common/punch
@@ -188,6 +188,7 @@ _filter_hole_fiemap()
 	_coalesce_extents
 }
 
+# Column 7 for datadev files and column 5 for rtdev files
 #     10000 Unwritten preallocated extent
 #     01000 Doesn't begin on stripe unit
 #     00100 Doesn't end   on stripe unit
@@ -200,6 +201,13 @@ _filter_bmap()
 			print $1, $2, $3;
 			next;
 		}
+		$5 ~ /1[01][01][01][01]/ {
+			print $1, $2, "unwritten";
+			next;
+		}
+		$5 ~ /0[01][01][01][01]/ {
+			print $1, $2, "data"
+		}
 		$7 ~ /1[01][01][01][01]/ {
 			print $1, $2, "unwritten";
 			next;

