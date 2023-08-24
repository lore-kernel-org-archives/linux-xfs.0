Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CFF0C88CB9
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Aug 2023 23:28:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229636AbjHXX2N (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Aug 2023 19:28:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236629AbjHXX1m (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Aug 2023 19:27:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F9D2A1
        for <linux-xfs@vger.kernel.org>; Thu, 24 Aug 2023 16:27:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9BD663AFB
        for <linux-xfs@vger.kernel.org>; Thu, 24 Aug 2023 23:27:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F0E1C433C7;
        Thu, 24 Aug 2023 23:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692919659;
        bh=EqVXpjLmXcu6q6nkQXB4l9cxMQnxDoAGDCj8lCUUhBo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rpHN7IlR3mS43E0TDjccXFN8zpaqI3CzS/169yiUOHYKW2TaZLMW/bbgpWJIQf5WB
         qhBI9REuKiyUUqULd0Ckn3M7xjEx4SLkCmraowrQCB39oAJiJXWvr23nA2OAe0kKn7
         sEIEwubByPei/4Kp4U70wOi4ZedGZk6uzXldg9NmZPzQkdBaVlS3KYy6KB2yW+fU5A
         RCldrSfIxR/5Xs97tzhoLKD2BXw1xCHqODKst0jXAmGqybkczrucn0vi5LTtL0tlf8
         mF9C2MWWBnQJv+anjr4uZOWXeJ6dcQRe+qNKYtIyiBOux3I9GAIfMoYGEZ++fIsKJ4
         FLbP252WNiRBg==
Date:   Thu, 24 Aug 2023 16:27:38 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     chandan.babu@gmail.com
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, sandeen@sandeen.net
Subject: [PATCH 4/3] xfs/270: actually test file readability
Message-ID: <20230824232738.GB17912@frogsfrogsfrogs>
References: <169291929524.220104.3844042018007786965.stgit@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169291929524.220104.3844042018007786965.stgit@frogsfrogsfrogs>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Make sure we can actually read files off the ro mounted filesystem that
has an unknown rocompat feature set.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/270 |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tests/xfs/270 b/tests/xfs/270
index 7447ce87be..511dfe9fcd 100755
--- a/tests/xfs/270
+++ b/tests/xfs/270
@@ -23,6 +23,9 @@ _require_scratch_nocheck
 _require_scratch_xfs_crc
 
 _scratch_mkfs_xfs >>$seqres.full 2>&1
+_scratch_mount
+echo moo > $SCRATCH_MNT/testfile
+_scratch_unmount
 
 # set the highest bit of features_ro_compat, use it as an unknown
 # feature bit. If one day this bit become known feature, please
@@ -68,6 +71,7 @@ if [ $? -ne 0 ]; then
 	_fail "ro mount test failed"
 else
 	# no hang/panic is fine
+	cat $SCRATCH_MNT/testfile > /dev/null
 	$FSSTRESS_PROG -d $SCRATCH_MNT -p 4 -n 400 >>$seqres.full 2>&1
 fi
 
