Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DA13C77B7E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:13:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbjEZCNE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbjEZCND (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:13:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CAEF13A
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:13:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 00DD161A33
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:13:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6329DC433D2;
        Fri, 26 May 2023 02:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685067181;
        bh=okWNqF9xRusBS/kRLSd+/wsAjTeqX2sUXu4aiXKky8Y=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=mFmpQlfyyjTSYt76x+pYV4RaM1ZK0W9mHGMKPjpL0qaD/CAPBOa3w5wm7Mkh7zd9o
         Xp/ji4VIZsIzbv9h0yvdZNZRrS2klKAiWyA4FDIbbStAaqtp67vh4ZBy31hkvfKlye
         BMp1sK7QRaWrajTC9gQl5/bJv7/yzJDkfGbpdFknKNyCe6ZEIrFld+IgRes/Bjctl4
         F70sGorugwOt7BsJ0J/YKu+n4n9+Oo0iG4v/dZaxF5ZSVunT8fxK+dzh7WbLE0lGI/
         nXKDSurXhFAaCcXW+y9b8rjsm+I0oQdrkTrQSx2pyLgs9So8h5emcaarQPKhV6rSvO
         0cFs883E9ozbQ==
Date:   Thu, 25 May 2023 19:13:00 -0700
Subject: [PATCH 12/18] xfs: Filter XFS_ATTR_PARENT for getfattr
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506072870.3744191.10179194999559499457.stgit@frogsfrogsfrogs>
In-Reply-To: <168506072673.3744191.16402822066993932505.stgit@frogsfrogsfrogs>
References: <168506072673.3744191.16402822066993932505.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Parent pointers returned to the get_fattr tool cause errors since
the tool cannot parse parent pointers.  Fix this by filtering parent
parent pointers from xfs_xattr_put_listent.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_xattr.c |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index b4fa2663f8b6..7b8460091da8 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -237,6 +237,9 @@ xfs_xattr_put_listent(
 
 	ASSERT(context->count >= 0);
 
+	if (flags & XFS_ATTR_PARENT)
+		return;
+
 	if (flags & XFS_ATTR_ROOT) {
 #ifdef CONFIG_XFS_POSIX_ACL
 		if (namelen == SGI_ACL_FILE_SIZE &&

