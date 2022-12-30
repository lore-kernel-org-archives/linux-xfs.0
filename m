Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1CC2C3DA7C
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 00:44:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235875AbiLaAoM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 19:44:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235868AbiLaAoL (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 19:44:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D11F1D0C8;
        Fri, 30 Dec 2022 16:44:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2AAB0B81E6B;
        Sat, 31 Dec 2022 00:44:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA2ADC433EF;
        Sat, 31 Dec 2022 00:44:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672447447;
        bh=dZhfbp+phhoyX7txuSa+hOgPomovWB9S2tdsHbB+U9M=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=awZIIxin5xYgTwIOUkRIQdPzzyaNIrnJdPLRw8827/8Y7iX5/icd1G8PsH+9q9H7e
         9i/sgS5oLigL+vgPKX1qlaeUKiE9UdaR0AMpOyYcVJTlQKtS+zswXIux0vmGHmM8LB
         aSnetbDjk+pWxmOJNaqWryGnK/j3g7SFs6iAxUtN7vPPL5kNztkqA8eWdBMG7gigr/
         QQ7B6MsgN9OQNV6KjNn4R0565tMQhau88U8ZYYaV8gkyCOMXZMZbyB8cY9ylgUK2oI
         0E7VkMCLTyJhg7qsI/OtKjdZ8dzsDB5yN5HbX5v9x7/xsyVHT44s8Rh88csj42/spD
         BNDAwVw+epvGQ==
Subject: [PATCH 2/2] populate: fix some weirdness in
 __populate_check_xfs_agbtree_height
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:19:36 -0800
Message-ID: <167243877638.728350.6533315172129762467.stgit@magnolia>
In-Reply-To: <167243877612.728350.1799909806305296744.stgit@magnolia>
References: <167243877612.728350.1799909806305296744.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Use a for loop to scan the AGs, and make all the variables local like
you'd expect them to be.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/populate |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)


diff --git a/common/populate b/common/populate
index e4090a29d3..29ea637ecb 100644
--- a/common/populate
+++ b/common/populate
@@ -599,8 +599,8 @@ __populate_check_xfs_attr() {
 
 # Check that there's at least one per-AG btree with multiple levels
 __populate_check_xfs_agbtree_height() {
-	bt_type="$1"
-	nr_ags=$(_scratch_xfs_db -c 'sb 0' -c 'p agcount' | awk '{print $3}')
+	local bt_type="$1"
+	local agcount=$(_scratch_xfs_db -c 'sb 0' -c 'p agcount' | awk '{print $3}')
 
 	case "${bt_type}" in
 	"bno"|"cnt"|"rmap"|"refcnt")
@@ -620,13 +620,14 @@ __populate_check_xfs_agbtree_height() {
 		;;
 	esac
 
-	seq 0 $((nr_ags - 1)) | while read ag; do
-		bt_level=$(_scratch_xfs_db -c "${hdr} ${ag}" -c "p ${bt_prefix}level" | awk '{print $3}')
+	for ((agno = 0; agno < agcount; agno++)); do
+		bt_level=$(_scratch_xfs_db -c "${hdr} ${agno}" -c "p ${bt_prefix}level" | awk '{print $3}')
+		# "level" is really the btree height
 		if [ "${bt_level}" -gt 1 ]; then
-			return 100
+			return 0
 		fi
 	done
-	test $? -eq 100 || __populate_fail "Failed to create ${bt_type} of sufficient height!"
+	__populate_fail "Failed to create ${bt_type} of sufficient height!"
 	return 1
 }
 

