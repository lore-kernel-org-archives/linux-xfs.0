Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 480E6C6FD1D
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Mar 2023 01:02:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbjCOBCC (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 14 Mar 2023 21:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230281AbjCOBCA (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 14 Mar 2023 21:02:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFD5A5AB74
        for <linux-xfs@vger.kernel.org>; Tue, 14 Mar 2023 18:01:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C126A6187A
        for <linux-xfs@vger.kernel.org>; Wed, 15 Mar 2023 01:01:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29B08C433D2;
        Wed, 15 Mar 2023 01:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678842116;
        bh=qh7ajGKnKBEQvqAbDlj1KdRFLStOZWkOhtaMorhxI70=;
        h=Date:From:To:Cc:Subject:From;
        b=OFCjuLGmNVl0hDtMDTnvZFw+GWCGUWvpY3kJ0wvUWP7EhVdCMSf6RPaQEoQXbFzyM
         jq1K63cP9wZjdBqYi3413r4z5RVC0uFv2UnwKQfEPKD1S1T9Z5noMZJsNkBuw2caTo
         1YqogkPdR9WUhFzLZqLhRmgGYLeiGx7XlvWnfIf0A8+Bm7Z3R8mMhHezO/mCLJJFcM
         mzAI9P1szZ65kVVd3MdtvsvPY8gVY9BTj6135oA1tAQ1UOqvNPNKWZRBj7wItYNidc
         /5jBWZ0lSTdIzLQtNcisJOJneyzUEg8sIEi99xLePTxUj/EXCVhxy9p17GNWqPfc7b
         uawbOeW5P7U8w==
Date:   Tue, 14 Mar 2023 18:01:55 -0700
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfs_repair: fix incorrect dabtree hashval comparison
Message-ID: <20230315010155.GE11376@frogsfrogsfrogs>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If an xattr structure contains enough names with the same hash value to
fill multiple xattr leaf blocks with names all hashing to the same
value, then the dabtree nodes will contain consecutive entries with the
same hash value.

This causes false corruption reports in xfs_repair because it's not
expecting such a huge same-hashing structure.  Fix that.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/da_util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/repair/da_util.c b/repair/da_util.c
index 7239c2e2c64..b229422c81e 100644
--- a/repair/da_util.c
+++ b/repair/da_util.c
@@ -330,7 +330,7 @@ _("%s block used/count inconsistency - %d/%hu\n"),
 	/*
 	 * hash values monotonically increasing ???
 	 */
-	if (cursor->level[this_level].hashval >=
+	if (cursor->level[this_level].hashval >
 				be32_to_cpu(nodehdr.btree[entry].hashval)) {
 		do_warn(
 _("%s block hashvalue inconsistency, expected > %u / saw %u\n"),
