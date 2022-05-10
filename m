Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7965C433FE
	for <linux-xfs@archiver.kernel.org>; Tue, 10 May 2022 21:30:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229830AbiEJVaq (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 10 May 2022 17:30:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230113AbiEJVap (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 10 May 2022 17:30:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E0784553C
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 14:30:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B45661796
        for <linux-xfs@vger.kernel.org>; Tue, 10 May 2022 21:30:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE7F2C385CD;
        Tue, 10 May 2022 21:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652218242;
        bh=aH5M9xPa75MTJ/LrTXYhVBzxwLslBzNdIPREenzOhlQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jtFHUNh/6XFHWc8bDL/7T4rW/VwRaRRhMDHzBqkeKo/YheCgBS/GgVvM5kdenEEtr
         gRZLRxGyJ/rN7SzkYsQG+l47nH39AapFEHiw5VeanOZTqYIG/eY2Uyw4i76h82JCa0
         pUlJM2qVw0XYidFAcHXao6H6pVYWR5BMhc65KXZkBuk2nN72t/9HdXygd6LtiTVEif
         PEKULsitMieFOCtkvQ9ftaOKT0dzKNdcATw+GJSrOLRSSIwkYKk44/M5c18pGIszlZ
         Gjrm7/syVN2y6gTHzuAxhOvZM+DMdxl44glwKsoiHV/Rh7RkBbaVVEQCCjJa8+Yf65
         rBaX9HCzCXQeQ==
Date:   Tue, 10 May 2022 14:30:42 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH 3/2] xfs: note the removal of XFS_IOC_FSSETDM in the
 documentation
Message-ID: <20220510213042.GF27195@magnolia>
References: <165176663972.246897.5479033385952013770.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <165176663972.246897.5479033385952013770.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Update the documentation to note the removal of this ioctl.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 man/man3/handle.3 |    1 +
 man/man3/xfsctl.3 |    2 ++
 2 files changed, 3 insertions(+)

diff --git a/man/man3/handle.3 b/man/man3/handle.3
index 154c0f29..2eb2bbcd 100644
--- a/man/man3/handle.3
+++ b/man/man3/handle.3
@@ -124,6 +124,7 @@ and
 fields in an XFS on-disk inode. It is analogous to the
 .BR "XFS_IOC_FSSETDM xfsctl" (3)
 command, except that a handle is specified instead of a file.
+This function is not supported on Linux.
 .PP
 The
 .BR free_handle ()
diff --git a/man/man3/xfsctl.3 b/man/man3/xfsctl.3
index a591e61a..4a0d4d08 100644
--- a/man/man3/xfsctl.3
+++ b/man/man3/xfsctl.3
@@ -104,6 +104,7 @@ This command is restricted to root or to processes with device
 management capabilities.
 Its sole purpose is to allow backup and restore programs to restore the
 aforementioned critical on-disk inode fields.
+This ioctl is not supported as of Linux 5.5.
 
 .TP
 .B XFS_IOC_DIOINFO
@@ -318,6 +319,7 @@ functions (see
 .BR open_by_handle (3)).
 They are all subject to change and should not be called directly
 by applications.
+XFS_IOC_FSSETDM_BY_HANDLE is not supported as of Linux 5.5.
 
 .SS Filesystem Operations
 In order to effect one of the following operations, the pathname
