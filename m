Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17779C38142
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Jan 2023 00:56:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbjARA4H (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 17 Jan 2023 19:56:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbjARAzu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 17 Jan 2023 19:55:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B11F53578;
        Tue, 17 Jan 2023 16:43:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1823761598;
        Wed, 18 Jan 2023 00:43:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79A5DC433D2;
        Wed, 18 Jan 2023 00:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674002596;
        bh=xFx4DwWNh6w9yII6olWGnSqQcMNQe19xFRRYflB13OU=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=r4EMxF3FOJG/vvy36skErNHFtFT86xAo0kELe5cqhKrP4w92bzj9CE7Gz6f+Z9RWJ
         HqMoMmMcNh18rHPz8e0i86izYKx+NNVq9QllhdtmLDn0XYcmdttz3s9O57SHX/rFPe
         DNJgmTxrgcYsofc3J5yoeIeHZkUd/mt7q1LtcpqHS8ilUJvO+EAOIEkPvpI0Km0hSM
         kO+SEckVeQGzJO2MDulY/aSuO5a5cucpzXDcmVE+3QujqOxgt7z+jO0Dqbr9pnJ9rT
         M4ZJ5YY0F9A2lU12DuuvioibhZCK3c7K8mXzNvvqj9P9InifIam5Um2KlICnSFZ5uW
         M+cpFb14SKN6w==
Date:   Tue, 17 Jan 2023 16:43:16 -0800
Subject: [PATCH 2/3] xfs/{080,329,434,436}: add missing check for fallocate
 support
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Message-ID: <167400102773.1914975.13189675469601933878.stgit@magnolia>
In-Reply-To: <167400102747.1914975.6709564559821901777.stgit@magnolia>
References: <167400102747.1914975.6709564559821901777.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Don't run this test if the filesystem doesn't support fallocate.  This
is only ever the case if always_cow is enabled.

The same logic applies to xfs/329, though it's more subtle because the
test itself does not explicitly invoke fallocate; rather, it is xfs_fsr
that requires fallocate.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/080 |    1 +
 tests/xfs/329 |    1 +
 tests/xfs/434 |    1 +
 tests/xfs/436 |    1 +
 4 files changed, 4 insertions(+)


diff --git a/tests/xfs/080 b/tests/xfs/080
index 20b20a08eb..abcfa004b5 100755
--- a/tests/xfs/080
+++ b/tests/xfs/080
@@ -21,6 +21,7 @@ _cleanup()
 
 _supported_fs xfs
 _require_test
+_require_xfs_io_command falloc	# iogen requires falloc
 
 quiet=-q
 clean=-c
diff --git a/tests/xfs/329 b/tests/xfs/329
index 4cad686c17..15dc3c242f 100755
--- a/tests/xfs/329
+++ b/tests/xfs/329
@@ -22,6 +22,7 @@ _require_cp_reflink
 _require_command "$XFS_FSR_PROG" "xfs_fsr"
 _require_xfs_io_error_injection "bmap_finish_one"
 _require_xfs_scratch_rmapbt
+_require_xfs_io_command falloc	# fsr requires support for preallocation
 
 rm -f "$seqres.full"
 
diff --git a/tests/xfs/434 b/tests/xfs/434
index 576f1b0e1e..de52531053 100755
--- a/tests/xfs/434
+++ b/tests/xfs/434
@@ -35,6 +35,7 @@ _require_quota
 _require_scratch_reflink
 _require_cp_reflink
 _require_command "$XFS_FSR_PROG" "xfs_fsr"
+_require_xfs_io_command falloc # fsr requires support for preallocation
 _require_xfs_io_error_injection "bmap_finish_one"
 _require_xfs_scratch_rmapbt
 
diff --git a/tests/xfs/436 b/tests/xfs/436
index 9e6ec9372d..b95da8abf4 100755
--- a/tests/xfs/436
+++ b/tests/xfs/436
@@ -30,6 +30,7 @@ _supported_fs xfs
 _require_loadable_fs_module "xfs"
 _require_scratch_reflink
 _require_cp_reflink
+_require_xfs_io_command falloc # fsr requires support for preallocation
 _require_command "$XFS_FSR_PROG" "xfs_fsr"
 _require_xfs_io_error_injection "bmap_finish_one"
 _require_xfs_scratch_rmapbt

