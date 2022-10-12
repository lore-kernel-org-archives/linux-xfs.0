Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9BA4C4167E
	for <linux-xfs@archiver.kernel.org>; Wed, 12 Oct 2022 01:45:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229471AbiJLBpr (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Oct 2022 21:45:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiJLBpq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Oct 2022 21:45:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 604EE5FF73;
        Tue, 11 Oct 2022 18:45:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C18F061346;
        Wed, 12 Oct 2022 01:45:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A565C433D6;
        Wed, 12 Oct 2022 01:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665539145;
        bh=7z58jSLBT0qppYNDh65jQNRgSf+0c0QRv3bYjf7LyTw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ORpg5xDAh0vsmJ47dhCYBtFAxJrsKtGCq2TdK4UZnLVDUDhFQKTDbDuytoyQvpnfU
         +PUn7EAREd6e857X2QxXUXdN6z8b2gCNEo2QOkiS38X/SN/lWW5ZKDbi6AX0Odo0U+
         Ovk5rzh5NIDGeauQGkvEMmn8rAP8RXNZdz+aReuLbaZ3sSh1GctkdsdTIkk/U70h3w
         jDy/u5xhngeP/n0Vsd8B/yLsAAnoV0ZPVD2f7S/2jmAfUWi1z+uudVETxqMnaKpPLW
         VPwUgtDxmM0z7YTOZ1XSwp/PtO2+VWrS5yy6Jr6URSucwBLwvvrKcXUYtLruMzJFz+
         Q9jufdtGrWvbQ==
Subject: [PATCH 4/5] populate: require e2image before populating
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 11 Oct 2022 18:45:44 -0700
Message-ID: <166553914474.422450.8871747567060992809.stgit@magnolia>
In-Reply-To: <166553912229.422450.15473762183660906876.stgit@magnolia>
References: <166553912229.422450.15473762183660906876.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Use $E2IMAGE_PROG, not e2image, and check that it exists before
proceeding.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/populate |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)


diff --git a/common/populate b/common/populate
index 66c55b682f..05bdfe33c5 100644
--- a/common/populate
+++ b/common/populate
@@ -18,6 +18,7 @@ _require_populate_commands() {
 		;;
 	ext*)
 		_require_command "$DUMPE2FS_PROG" "dumpe2fs"
+		_require_command "$E2IMAGE_PROG" "e2image"
 		;;
 	esac
 }
@@ -874,7 +875,7 @@ _scratch_populate_restore_cached() {
 		return $res
 		;;
 	"ext2"|"ext3"|"ext4")
-		e2image -r "${metadump}" "${SCRATCH_DEV}"
+		$E2IMAGE_PROG -r "${metadump}" "${SCRATCH_DEV}"
 		ret=$?
 		test $ret -ne 0 && return $ret
 

