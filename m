Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B6CFC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 16 Mar 2022 03:30:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353460AbiCPDb3 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 15 Mar 2022 23:31:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353459AbiCPDb3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 15 Mar 2022 23:31:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D2995EDD6;
        Tue, 15 Mar 2022 20:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD03E615F3;
        Wed, 16 Mar 2022 03:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ACFBC340E8;
        Wed, 16 Mar 2022 03:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647401415;
        bh=OLz1A+9iUlvgF7/IP6e6LLOIuhUOIh0OWEXptIGid1g=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=gt9Mwx2uAfFXrpL0oGQJ+iaEyeOY2jrD0o20vK0ByLXRst5m3WQys1SELbCmZ7vGa
         zzw4nhbVBwH10n6ojI6ANAFge9y/hcSKqmzldlMm0vbq0C3DCsx+CQWatMeRV/l212
         pU9471iMsQMzj78uAYG9ce3oBvM9Rs5iBhgxH/2FSJIXt/E3m+J1FMSfV36hfP3Jh+
         d6EZxQUTXKV7mxSVGclG/BPHM1r2F92h3eLOliCkLBW9fdp2edczkc5/XQer+VExpq
         hbqMCUHYxzPoHWKheasOdocQ6bcEtzcmipxGpgvf8vZvmO2joeFLoEOk1EKwOVPAel
         towUyp2jM5lyQ==
Subject: [PATCH 2/4] common/xfs: fix broken code in _check_xfs_filesystem
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 15 Mar 2022 20:30:14 -0700
Message-ID: <164740141477.3371628.6804259397500636490.stgit@magnolia>
In-Reply-To: <164740140348.3371628.12967562090320741592.stgit@magnolia>
References: <164740140348.3371628.12967562090320741592.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Fix some problems with undefined variables in the scrub control code.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/xfs |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)


diff --git a/common/xfs b/common/xfs
index 053b6189..ac1d021e 100644
--- a/common/xfs
+++ b/common/xfs
@@ -568,12 +568,12 @@ _check_xfs_filesystem()
 		# before executing a scrub operation.
 		$XFS_IO_PROG -c syncfs $mntpt >> $seqres.full 2>&1
 
-		"$XFS_SCRUB_PROG" $scrubflag -v -d -n $mntpt > $tmp.scrub 2>&1
+		"$XFS_SCRUB_PROG" -v -d -n $mntpt > $tmp.scrub 2>&1
 		if [ $? -ne 0 ]; then
 			_log_err "_check_xfs_filesystem: filesystem on $device failed scrub"
-			echo "*** xfs_scrub $scrubflag -v -d -n output ***" >> $seqres.full
+			echo "*** xfs_scrub -v -d -n output ***" >> $seqres.full
 			cat $tmp.scrub >> $seqres.full
-			echo "*** end xfs_scrub output" >> $serqres.full
+			echo "*** end xfs_scrub output" >> $seqres.full
 			ok=0
 		fi
 		rm -f $tmp.scrub

