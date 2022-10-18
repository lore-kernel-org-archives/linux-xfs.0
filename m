Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 733F0C4332F
	for <linux-xfs@archiver.kernel.org>; Tue, 18 Oct 2022 22:45:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbiJRWpQ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 18 Oct 2022 18:45:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbiJRWpM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 18 Oct 2022 18:45:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B36D50065;
        Tue, 18 Oct 2022 15:45:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0771561716;
        Tue, 18 Oct 2022 22:45:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 681EAC433D6;
        Tue, 18 Oct 2022 22:45:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666133110;
        bh=jiqLYYwwH2fjuIdNmz0yDNJrsu7sMSd3cbP80PlJR5Q=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=uw97E31fIpmkZ6sHThA18v8XFhDbuZCyswJQ383ZQOPaE3lTjbLxiexFQ27CO4VM2
         HLsx9oILdYjFYybVVnuX/AD2Dno8jOidOb8+kpo6KzBhPAC4wXOijw+wVga8Th+Xan
         b80SvbA13Vt9ZjxqY4/ezSoUkTAXl7rSfgxQYYc3K75FuQEVhv/l4dfrWPDAz2YMOF
         rfJCv6M4I6kPn5VmeQ+F5o+eKwq9UCqNTMS/2daT8d4ul12a8kbFOBlrPq+0Bcujpi
         FWr5rp8szRbGUr+3P9ffVYDR30FdPNMlVUC6SQANifcR78GFWApJsflKIlvZivJJVQ
         jC8fwFJg7dsfg==
Subject: [PATCH 1/1] populate: unexport the metadump description text
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 18 Oct 2022 15:45:10 -0700
Message-ID: <166613311003.868003.9672066347833155217.stgit@magnolia>
In-Reply-To: <166613310432.868003.6099082434184908563.stgit@magnolia>
References: <166613310432.868003.6099082434184908563.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Make the variable that holds the contents of the metadump description
file a local variable since we don't need it outside of that function.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Zorro Lang <zlang@redhat.com>
---
 common/populate |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)


diff --git a/common/populate b/common/populate
index b2d37b47d8..58b07e33be 100644
--- a/common/populate
+++ b/common/populate
@@ -901,15 +901,15 @@ _scratch_populate_cached() {
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
@@ -918,7 +918,7 @@ _scratch_populate_cached() {
 
 	# Oh well, just create one from scratch
 	_scratch_mkfs
-	echo "${meta_descr}" > "${POPULATE_METADUMP_DESCR}"
+	echo "${meta_descr}" > "${populate_metadump_descr}"
 	case "${FSTYP}" in
 	"xfs")
 		_scratch_xfs_populate $@

