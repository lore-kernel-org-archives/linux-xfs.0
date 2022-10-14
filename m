Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 996DAC4332F
	for <linux-xfs@archiver.kernel.org>; Fri, 14 Oct 2022 18:22:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbiJNSWB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 14 Oct 2022 14:22:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230221AbiJNSWB (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 14 Oct 2022 14:22:01 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74D82152039;
        Fri, 14 Oct 2022 11:21:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9F949CE24DC;
        Fri, 14 Oct 2022 18:21:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0707C433D6;
        Fri, 14 Oct 2022 18:21:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665771715;
        bh=8ayK2Bi/QX1rIds048FD2m+3STf7G+2V6IhvBGkysuE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nZ0ZuotJ8vEI0DpKHFpMXizIpwEPWrCk2RnwtLunv7nTGaYrZ6mWXF6Y6NywLUq9p
         DEAG8b99pozjc+0blgY2NRQBsDPGwO0e2fP60fNhivaaMQvYPZgmNhwMn6lxwOIwHG
         a63uqkIPhUqnQpj7tbg8/gcaI76SZ7+77yWA9FXfcsq3rdBT/2l+C//tF3ORgMGSDh
         C2VJzh4W7FnLkyUK5j96XbNCwaq+crbcounadD0Ic1Ml5LbSSm7tvnWW6c+OLJ6rqR
         95KQUygWQxJA2c4IKnHnb1Gp5MZm5XuxT+Lud9QZxe00yFxmQ/Y9ZPnfplYRiDh/Ko
         NXaPVCtTeNSvQ==
Date:   Fri, 14 Oct 2022 11:21:55 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Subject: [PATCH v1.1 1/5] populate: export the metadump description name
Message-ID: <Y0mowyuRHSivs3ho@magnolia>
References: <166553912229.422450.15473762183660906876.stgit@magnolia>
 <166553912788.422450.6797363004980943410.stgit@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <166553912788.422450.6797363004980943410.stgit@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Make the variable that holds the contents of the metadump description
file a local variable since we don't need it outside of that function.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Zorro Lang <zlang@redhat.com>
---
v1.1: dont export POPULATE_METADUMP; change the description a bit
---
 common/populate |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/common/populate b/common/populate
index cfdaf766f0..ba34ca5844 100644
--- a/common/populate
+++ b/common/populate
@@ -868,15 +868,15 @@ _scratch_populate_cached() {
 	local meta_tag="$(echo "${meta_descr}" | md5sum - | cut -d ' ' -f 1)"
 	local metadump_stem="${TEST_DIR}/__populate.${FSTYP}.${meta_tag}"
 
-	# These variables are shared outside this function
+	# This variable is shared outside this function
 	POPULATE_METADUMP="${metadump_stem}.metadump"
-	POPULATE_METADUMP_DESCR="${metadump_stem}.txt"
+	local populate_metadump_descr="${metadump_stem}.txt"
 
 	# Don't keep metadata images cached for more 48 hours...
 	rm -rf "$(find "${POPULATE_METADUMP}" -mtime +2 2>/dev/null)"
 
 	# Throw away cached image if it doesn't match our spec.
-	cmp -s "${POPULATE_METADUMP_DESCR}" <(echo "${meta_descr}") || \
+	cmp -s "${populate_metadump_descr}" <(echo "${meta_descr}") || \
 		rm -rf "${POPULATE_METADUMP}"
 
 	# Try to restore from the metadump
@@ -885,7 +885,7 @@ _scratch_populate_cached() {
 
 	# Oh well, just create one from scratch
 	_scratch_mkfs
-	echo "${meta_descr}" > "${POPULATE_METADUMP_DESCR}"
+	echo "${meta_descr}" > "${populate_metadump_descr}"
 	case "${FSTYP}" in
 	"xfs")
 		_scratch_xfs_populate $@
