Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 414B6EB64DD
	for <linux-xfs@archiver.kernel.org>; Wed, 26 Jul 2023 01:57:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbjGZB5V (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 25 Jul 2023 21:57:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbjGZB5T (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 25 Jul 2023 21:57:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CFDE2D7B;
        Tue, 25 Jul 2023 18:57:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A83761170;
        Wed, 26 Jul 2023 01:57:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAEC9C433C7;
        Wed, 26 Jul 2023 01:57:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690336621;
        bh=IdSWZ29snYuxb3CQ7ZKEVbRLpW09dE89f6Tp2YBIATw=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=XsRBBXQvqJ/vYoRaRqcw3yEYamqeuV5nn2rzKmhIxNxAnSB19sDQj504GDHWVjjhk
         iDaD9c1ZofQgvXYXqV5i9ixTufce0AaWCnuBmpp32W2BjAx/BA43iWuvLPJHzEN+tj
         9OK8eAnQHTP1lT0A989SisNtZVRKikcqwSK1np1ps5Fg+e8BJxMv+EmFQGVF8rXZ7L
         3SOLSL8Ix3Q3/bQ588ypVF0jGM9Yp6BDzoAXg/zoshq8EBrz5C/Ig5hUXDHNM+wmH0
         +uwgZvY+wThtlkzAC49YIRdkpw9gse/kwhlFbVCFNbfA6BcIZalj6PXSZT5gojjFBI
         KOqZVbnNAKXYQ==
Subject: [PATCH 1/1] xfs/122: adjust test for flexarray conversions in 6.5
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, zlang@redhat.com
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 25 Jul 2023 18:57:00 -0700
Message-ID: <169033662042.3222297.14047592154027443561.stgit@frogsfrogsfrogs>
In-Reply-To: <169033661482.3222297.18190312289773544342.stgit@frogsfrogsfrogs>
References: <169033661482.3222297.18190312289773544342.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Adjust the output of this test to handle the conversion of flexarray
declaration conversions in 6.5.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 tests/xfs/122 |    8 ++++++++
 1 file changed, 8 insertions(+)


diff --git a/tests/xfs/122 b/tests/xfs/122
index e616f1987d..ba927c77c4 100755
--- a/tests/xfs/122
+++ b/tests/xfs/122
@@ -26,13 +26,21 @@ _wants_kernel_commit 03a7485cd701 \
 _type_size_filter()
 {
 	# lazy SB adds __be32 agf_btreeblks - pv960372
+	# flexarray conversion of the attr structures in Linux 6.5 changed
+	# the sizeof output
 	if [ "$($MKFS_XFS_PROG 2>&1 | grep -c lazy-count )" == "0" ]; then
 		perl -ne '
 s/sizeof\( xfs_agf_t \) = 60/sizeof( xfs_agf_t ) = <SIZE>/;
+s/sizeof\(struct xfs_attr3_leafblock\) = 80/sizeof(struct xfs_attr3_leafblock) = 88/;
+s/sizeof\(struct xfs_attr_shortform\) = 4/sizeof(struct xfs_attr_shortform) = 8/;
+s/sizeof\(xfs_attr_leafblock_t\) = 32/sizeof(xfs_attr_leafblock_t) = 40/;
 		print;'
 	else
 		perl -ne '
 s/sizeof\( xfs_agf_t \) = 64/sizeof( xfs_agf_t ) = <SIZE>/;
+s/sizeof\(struct xfs_attr3_leafblock\) = 80/sizeof(struct xfs_attr3_leafblock) = 88/;
+s/sizeof\(struct xfs_attr_shortform\) = 4/sizeof(struct xfs_attr_shortform) = 8/;
+s/sizeof\(xfs_attr_leafblock_t\) = 32/sizeof(xfs_attr_leafblock_t) = 40/;
 		print;'
 	fi
 }

