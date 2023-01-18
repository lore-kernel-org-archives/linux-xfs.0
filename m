Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 708FCC38142
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 00:54:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbjARAyZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Jan 2023 19:54:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbjARAyC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Jan 2023 19:54:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B1C74DBC7;
        Tue, 17 Jan 2023 16:42:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B223B81A87;
        Wed, 18 Jan 2023 00:42:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 425F0C433D2;
        Wed, 18 Jan 2023 00:42:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674002534;
        bh=C/j8KnWAl6qPB7dLOaPsaGU+qM2DpDK0XBE285WozP4=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=TlydLeXZA8Jn0rutovsA6tK3rqCak6u0Ml2A8gtZB0vCNJ0gaaj2GRQoNJfD1AAqX
         bJw6fASRJW2OttHAIzo61wrCpsHWGHlvz6L7SG0hEAQIq6yN8LAX2NmM6M1Kp99C6S
         Gbz6JaWkT5Zas5DXc6lNCNoIvU7oDoIFi9V6e5QjHOgqgsvdHcEPRpsPEIJicUbds7
         To9Gs5WAtrFSm/HoZOiUbjDT+36x6cJR/0LkM88g0z0HfYBTLATRv2dmrYQJi+gtMV
         PrftW+Qsu5XN33nyUL8gXxtJglsVyvhuV8usxc+anxgfiXmmTHgSaZzdWU+vd8xZ4y
         SvBfb/yUUTbpg==
Date:   Tue, 17 Jan 2023 16:42:13 -0800
Subject: [PATCH 1/3] xfs: fix dax inode flag test failures
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        yangx.jy@fujitsu.com
Message-ID: <167400102458.1914858.6889539595788984119.stgit@magnolia>
In-Reply-To: <167400102444.1914858.13132645140135239531.stgit@magnolia>
References: <167400102444.1914858.13132645140135239531.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Filter out the DAX inode flag because it's causing problems with this
test.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/128 |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/tests/xfs/128 b/tests/xfs/128
index 5591342d41..8c1663c6c5 100755
--- a/tests/xfs/128
+++ b/tests/xfs/128
@@ -81,7 +81,7 @@ c13=$(_md5_checksum $testdir/file3)
 c14=$(_md5_checksum $testdir/file4)
 
 echo "Defragment"
-lsattr -l $testdir/ | _filter_scratch | _filter_spaces
+lsattr -l $testdir/ | _filter_scratch | _filter_spaces | sed -e 's/DAX/---/g'
 $XFS_FSR_PROG -v -d $testdir/file1 >> $seqres.full
 $XFS_FSR_PROG -v -d $testdir/file2 >> $seqres.full # fsr probably breaks the link
 $XFS_FSR_PROG -v -d $testdir/file3 >> $seqres.full # fsr probably breaks the link

