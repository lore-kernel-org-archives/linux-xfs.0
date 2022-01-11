Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 684F7C433EF
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Jan 2022 21:50:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245500AbiAKVuV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Jan 2022 16:50:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233245AbiAKVuU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Jan 2022 16:50:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD991C06173F;
        Tue, 11 Jan 2022 13:50:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E0B7617BB;
        Tue, 11 Jan 2022 21:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2521C36AE3;
        Tue, 11 Jan 2022 21:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641937819;
        bh=kNh3r/rPOV3v/Yg2Yk09/uq3MZPOA5Q/UDRWEBp7GQg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=RMoX59BprpY4Bh/SLChT4WE99LX3ClGkoRZJZ91tqCbPBbFnHARkfTXBd5xJWZd7i
         Ae8sN/bVqxsDTe1xTQNhF5HKYcs/Xg9BnbJGW30lReUyv4M6pPhnIyLlmbiu9xS39Y
         4hlHKg9n1TNHBzrUzulwsXhE8iMhB1QHkHVfQ+lHk5abponlkJ1Bq+8zg/3gdTyYEo
         fSptQKEHgcpBoCEzyljnMV4nk4ZbaPQJK6MuGdZ5qENd6zfFT8ktxDXJgWyAXbDgvA
         tQUrfLLihIVuIR0ShiKQpq5Xbz40KjjAZzhkT0FPCg+UhWaXGIjAXP4EGLloERUdTP
         7s5M2XcKp7k9Q==
Subject: [PATCH 2/8] common/rc: fix unicode checker detection in xfs_scrub
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     Theodore Ts'o <tytso@mit.edu>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 11 Jan 2022 13:50:19 -0800
Message-ID: <164193781942.3008286.2671348202718115059.stgit@magnolia>
In-Reply-To: <164193780808.3008286.598879710489501860.stgit@magnolia>
References: <164193780808.3008286.598879710489501860.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

_check_xfs_scrub_does_unicode is still less than adequate -- if running
ldd to report the xfs_scrub binary's dynamic library dependencies
doesn't work, we could still detect support by grepping for strings that
only appear when the unicode checker is built.

Note that this isn't the final word on all of this; I will make this
easier to discover in a future xfs_scrub release.

Cc: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/rc |   19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)


diff --git a/common/rc b/common/rc
index c63add75..b3289de9 100644
--- a/common/rc
+++ b/common/rc
@@ -4726,13 +4726,22 @@ _check_xfs_scrub_does_unicode() {
 
 	_supports_xfs_scrub "${mount}" "${dev}" || return 1
 
-	# We only care if xfs_scrub has unicode string support...
-	if ! type ldd > /dev/null 2>&1 || \
-	   ! ldd "${XFS_SCRUB_PROG}" 2> /dev/null | grep -q libicui18n; then
-		return 1
+	# If the xfs_scrub binary contains the string "Unicode name.*%s", then
+	# we know that it has the ability to complain about improper Unicode
+	# names.
+	if strings "${XFS_SCRUB_PROG}" | grep -q 'Unicode name.*%s'; then
+		return 0
 	fi
 
-	return 0
+	# If the xfs_scrub binary is linked against the libicui18n Unicode
+	# library, then we surmise that it contains the Unicode name checker.
+	if type ldd > /dev/null 2>&1 && \
+	   ldd "${XFS_SCRUB_PROG}" 2> /dev/null | grep -q libicui18n; then
+		return 0
+	fi
+
+	# We could not establish that xfs_scrub supports unicode names.
+	return 1
 }
 
 # exfat timestamps start at 1980 and cannot be prior to epoch

