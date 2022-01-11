Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 518D1C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 11 Jan 2022 21:50:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245498AbiAKVuP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 11 Jan 2022 16:50:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233245AbiAKVuP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 11 Jan 2022 16:50:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48240C06173F;
        Tue, 11 Jan 2022 13:50:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DADFC617C5;
        Tue, 11 Jan 2022 21:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35332C36AE3;
        Tue, 11 Jan 2022 21:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641937814;
        bh=JJilv0j9LQsWoe/KuvIuYqDhKTom8r3NCMLWk0MTs44=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Mu+m18PTJO9qHmeXZnbg5SoZ+a7J+ZOFXkY6VPY+ZPb+sdzDi30c4uihjtu3RFfr2
         PtMUjAf8xY+1nl4Gl27mnXpduAKfmwyY6t0N47bdNB5YU/1XqgL9E/CPkOTKA4IzR9
         7I/k/l+zpTFOK+hioxTZcWgPDGUZnH/9mT/8wGJcO1F0CZ/EwcE9i40mWFtJWgEpeu
         Y3Sql7aSvDgDveovg0aKkmZZkzsJQcYmLvb6G5XKWYq9nQTFj01HttYpCA8ZRx6JOE
         yMl4ClnfNSSBvl+fbQhmQC6e7xf1/SK7VzghBC6SLW8CQfvAo4IgjB1Hv41j+E5HF4
         5Euor71y5HzYA==
Subject: [PATCH 1/8] common/rc: fix _check_xfs_scrub_does_unicode on newer
 versions of libc-bin
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, guaneryu@gmail.com
Cc:     Theodore Ts'o <tytso@mit.edu>, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me
Date:   Tue, 11 Jan 2022 13:50:13 -0800
Message-ID: <164193781391.3008286.6648313005474441186.stgit@magnolia>
In-Reply-To: <164193780808.3008286.598879710489501860.stgit@magnolia>
References: <164193780808.3008286.598879710489501860.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Theodore Ts'o <tytso@mit.edu>

Debian 10 uses ldd from glibc 2.28, where as Debian 11 uses ldd from
glibc 2.31.  Sometime between glibc 2.28 and 2.31, ldd has been
changed so that the message "not a dynamic executable" is sent stderr,
where before it was sent to stdout.  As a result, it caused
regressions for tests such as generic/453 which uses
_check_xfs_scurb_does_unicode:

generic/453 5s ... 	[22:42:03] [22:42:08]- output mismatch (see /results/xfs/results-4k/generic/453.out.bad)
    --- tests/generic/453.out	2022-01-08 15:15:15.000000000 -0500
    +++ /results/xfs/results-4k/generic/453.out.bad	2022-01-08 22:42:08.596982251 -0500
    @@ -4,3 +4,4 @@
     Test files
     Uniqueness of inodes?
     Test XFS online scrub, if applicable
    +	not a dynamic executable
    ...

Fix this by sending stderr from ldd to /dev/null.  This is not a
perfect solution, since it means that even if xfs_scrub was compiled
with libicui18n, we will skip the online scrub portion of generic/453.
However, this fixes the regression when runtime OS is changed from
Debian Buster to Debian Bullseye when xfsprogs is built statically.

In the long run, it would be nice if we could determine whether
xfs_scrub has unicode support without using ldd --- perhaps by
signally this in the output of xfs_scrub -V --- but we'll need to
discuss this with the xfsprogs maintainers.

Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/rc |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/common/rc b/common/rc
index c087875a..c63add75 100644
--- a/common/rc
+++ b/common/rc
@@ -4728,7 +4728,7 @@ _check_xfs_scrub_does_unicode() {
 
 	# We only care if xfs_scrub has unicode string support...
 	if ! type ldd > /dev/null 2>&1 || \
-	   ! ldd "${XFS_SCRUB_PROG}" | grep -q libicui18n; then
+	   ! ldd "${XFS_SCRUB_PROG}" 2> /dev/null | grep -q libicui18n; then
 		return 1
 	fi
 

