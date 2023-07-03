Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01286C001B0
	for <linux-xfs@archiver.kernel.org>; Mon,  3 Jul 2023 17:03:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbjGCRD7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 3 Jul 2023 13:03:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230232AbjGCRD6 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 3 Jul 2023 13:03:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2555FE58;
        Mon,  3 Jul 2023 10:03:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B1EB160CB9;
        Mon,  3 Jul 2023 17:03:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19C33C433C8;
        Mon,  3 Jul 2023 17:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688403836;
        bh=7vF9Ykyz8sEPqJVEUDNK2N3A9YJcJw+ETv1uuPxF8qY=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=PX0fs+cs0tmKftHi0upJeM98OfaPUQXw/GKQoTdJt4RaiEtIijy4nSURSIolEijPh
         g3UUe+NVrznEYZqSsgBqCFVvuGPtVS1WTgUTzUaAVOnuza+VnNi6V/YJ0/fb88g5Mi
         5U6L6kGPl4WS13DZqyfG4nJnKv4HJoK3K3hub8RSyEOFA13YIVkDIZhcHKrxnw54BJ
         uoCGhptDEBXDv5WNCT++D+g8tU46O9kDq2+qwxSPMZqOZRNRJq33v2X/gjrcpqwqM+
         snRawFRI/0wvsl3ZF3WAA7O0Ra/faSy57tjYI17EvUOqPB8QmhtWcO+nHR+f0wFG9K
         vIt6Su/heiMXQ==
Subject: [PATCH 4/5] xfs/041: force create files on the data device
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Mon, 03 Jul 2023 10:03:55 -0700
Message-ID: <168840383563.1317961.17059869339313726876.stgit@frogsfrogsfrogs>
In-Reply-To: <168840381298.1317961.1436890061506567407.stgit@frogsfrogsfrogs>
References: <168840381298.1317961.1436890061506567407.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Since we're testing growfs of the data device, we should create the
files there, even if the mkfs configuration enables rtinherit on the
root dir.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/041 |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/tests/xfs/041 b/tests/xfs/041
index 05de5578ff..21b3afe7ce 100755
--- a/tests/xfs/041
+++ b/tests/xfs/041
@@ -46,6 +46,9 @@ bsize=`_scratch_mkfs_xfs -dsize=${agsize}m,agcount=1 2>&1 | _filter_mkfs 2>&1 \
 onemeginblocks=`expr 1048576 / $bsize`
 _scratch_mount
 
+# We're growing the data device, so force new file creation there
+_xfs_force_bdev data $SCRATCH_MNT
+
 echo "done"
 
 # full allocation group -> partial; partial -> expand partial + new partial;

