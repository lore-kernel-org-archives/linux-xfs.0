Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3AF81C433FE
	for <linux-xfs@archiver.kernel.org>; Thu, 24 Nov 2022 16:59:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbiKXQ7c (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 24 Nov 2022 11:59:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiKXQ7b (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 24 Nov 2022 11:59:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34DBE7C036
        for <linux-xfs@vger.kernel.org>; Thu, 24 Nov 2022 08:59:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B5FB1621AA
        for <linux-xfs@vger.kernel.org>; Thu, 24 Nov 2022 16:59:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E50BC433C1;
        Thu, 24 Nov 2022 16:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669309170;
        bh=EAyYS4iwINg9EfiQ4+s56XcTxK7HXRkbS2b/udMknR0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MOf63xjRkCWzKNSAo9+h4dt48C01c8HingzPqjAgzDSYswCuU06Kvvl6RMrFV9DRH
         /0KYfEzIuu03AWJd9iTx0Hj+5ms115hKilfc1Gn9c6X892inAIi64RhrZRZjavnNxE
         stvJmWoMGQT/w7oFhEA/+6xYeI63k7HpNeasSbajWU1k4LLoAslAyih0NFN40dkIEV
         n7+wNJeBJFgYBEEz3rMzYj6ETO5Mbk6b4YbK9ZxTqB5PD7YsHdfcz8A2aU9MsCC1FV
         kgH5Bdf+cttTs0HGa83Bevf5C4mySyUjTQrsciOqat+PvbAJNkFFbu7G/mDbrtZBTP
         k+I49R1h0FCCQ==
Subject: [PATCH 2/3] xfs: use memcpy, not strncpy,
 to format the attr prefix during listxattr
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Thu, 24 Nov 2022 08:59:29 -0800
Message-ID: <166930916972.2061853.5449429916617568478.stgit@magnolia>
In-Reply-To: <166930915825.2061853.2470510849612284907.stgit@magnolia>
References: <166930915825.2061853.2470510849612284907.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

When -Wstringop-truncation is enabled, the compiler complains about
truncation of the null byte at the end of the xattr name prefix.  This
is intentional, since we're concatenating the two strings together and
do _not_ want a null byte in the middle of the name.

We've already ensured that the name buffer is long enough to handle
prefix and name, and the prefix_len is supposed to be the length of the
prefix string without the null byte, so use memcpy here instead.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_xattr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index c325a28b89a8..10aa1fd39d2b 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -210,7 +210,7 @@ __xfs_xattr_put_listent(
 		return;
 	}
 	offset = context->buffer + context->count;
-	strncpy(offset, prefix, prefix_len);
+	memcpy(offset, prefix, prefix_len);
 	offset += prefix_len;
 	strncpy(offset, (char *)name, namelen);			/* real name */
 	offset += namelen;

