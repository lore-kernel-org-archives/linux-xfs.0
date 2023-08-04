Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14ABDC00528
	for <linux-xfs@archiver.kernel.org>; Fri,  4 Aug 2023 21:34:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbjHDVeX (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 4 Aug 2023 17:34:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229987AbjHDVeW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 4 Aug 2023 17:34:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E14FB2;
        Fri,  4 Aug 2023 14:34:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 991E76211B;
        Fri,  4 Aug 2023 21:34:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0466DC433C8;
        Fri,  4 Aug 2023 21:34:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691184860;
        bh=g71ZhBZRdQMC9SijAE5m465w6Ug53ks2XKwhA6iD+og=;
        h=Date:From:To:Cc:Subject:From;
        b=Beze06Ut+kZMxKDp/V7lVJD+X1k8+1nrj1I++CBhTHE1DAJZfIRWPXY18f8nawwEq
         z3NyBDH5oMRlnyaeBiQXPs5JRmGMN4rpzI8xbgAl8UPmXxryfsFmxp9t8Dm0iqIX8F
         ZlwBwntpOPxVJ1LjmO3Q7Rts6zeSO54QsqPbmlMtdpIZo0IGGUF2B3YdSB60iVNA3q
         BzgbjQm8WCinqHcCJcXJWmUwYxeELoBIGRhsAGAHhbFOCCFMJVFItqF2EfCk+OJDer
         lkFxrsxxItB9IcpS3cvEne+Ta741FYxV3QhvcQP2HNOT+zY6H67y9ZdfkvPowkCgZ+
         c1+eAMBMImseQ==
Date:   Fri, 4 Aug 2023 14:34:19 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Zorro Lang <zlang@kernel.org>
Cc:     fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: [PATCH] xfs: skip fragmentation tests when alwayscow mode is
 enabled, part 2
Message-ID: <20230804213419.GO11340@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If the always_cow debugging flag is enabled, all file writes turn into
copy writes.  This dramatically ramps up fragmentation in the filesystem
(intentionally!) so there's no point in complaining about fragmentation.

I missed these two in the original commit because readahead for md5sum
would create large folios at the start of the file.  This resulted in
the fdatatasync after the random writes issuing writeback for the whole
large folio, which reduced file fragmentation to the point where this
test started passing.

With Ritesh's patchset implementing sub-folio dirty tracking, this test
goes back to failing due to high fragmentation (as it did before large
folios) so we need to mask these off too.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/180 |    1 +
 tests/xfs/208 |    1 +
 2 files changed, 2 insertions(+)

diff --git a/tests/xfs/180 b/tests/xfs/180
index cfea2020ce..d2fac03a9e 100755
--- a/tests/xfs/180
+++ b/tests/xfs/180
@@ -23,6 +23,7 @@ _require_scratch_reflink
 _require_cp_reflink
 _require_xfs_io_command "fiemap"
 _require_xfs_io_command "cowextsize"
+_require_no_xfs_always_cow
 
 echo "Format and mount"
 _scratch_mkfs > $seqres.full 2>&1
diff --git a/tests/xfs/208 b/tests/xfs/208
index 9a71b74f6f..1e7734b822 100755
--- a/tests/xfs/208
+++ b/tests/xfs/208
@@ -26,6 +26,7 @@ _require_scratch_reflink
 _require_cp_reflink
 _require_xfs_io_command "fiemap"
 _require_xfs_io_command "cowextsize"
+_require_no_xfs_always_cow
 
 echo "Format and mount"
 _scratch_mkfs > $seqres.full 2>&1
