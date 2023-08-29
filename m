Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADFE6C83F12
	for <linux-xfs@archiver.kernel.org>; Tue, 29 Aug 2023 23:10:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239389AbjH2XJ7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 29 Aug 2023 19:09:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239625AbjH2XJ5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 29 Aug 2023 19:09:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55AACDB;
        Tue, 29 Aug 2023 16:09:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DFAEB61014;
        Tue, 29 Aug 2023 23:09:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4872EC433C8;
        Tue, 29 Aug 2023 23:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1693350594;
        bh=AfNZ/oSuvjD3CbD6WRm7awj8lyEv3FwW6lXbQSp0qjE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=G83Jheld00+SSjXDV0qVEIRxxuK0V56JNO9T9aa8vkXYcEt0/5O+daH58WQzld8M+
         6hLZ5PwBFRWy2/MNNviQPq821IAAZyE27TZTxGgkWYHHCoGTYGMfXbjFIbA1tpo94F
         kdwHWiiEek4sUPhVZ9ffbJHH8ZowHqFdUN9CYdM/upoBz6kr+eBQOPAiigN1wS9RzX
         D5jjTvf79fNnkNkh/yZOfxTey3po0lH4A/4GQzO4UTrmoH2aQsGPoj0IRu1OW5mgs0
         yhM1GO8/2hMpwiWjiXZxfoEbAjZzuSLXCrX04EwU4Ey8OVRDZurRm04YN7R031X6IM
         fRCqVx5ACmrzg==
Subject: [PATCH 1/2] xfs/270: actually test file readability
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me,
        david@fromorbit.com, sandeen@sandeen.net
Date:   Tue, 29 Aug 2023 16:09:53 -0700
Message-ID: <169335059383.3526409.15894917295629170268.stgit@frogsfrogsfrogs>
In-Reply-To: <169335058807.3526409.15604604578540143202.stgit@frogsfrogsfrogs>
References: <169335058807.3526409.15604604578540143202.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
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
 

