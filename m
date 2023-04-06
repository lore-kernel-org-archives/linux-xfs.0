Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E62AC7618D
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:24:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbjDFTYh (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:24:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229795AbjDFTYg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:24:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A25D61AC
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:24:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 05FB164ADF
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:24:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63E3CC433D2;
        Thu,  6 Apr 2023 19:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680809074;
        bh=miCAxDzp9Qp7Id/1qnSsxiiDGjPmNuR286eQ1rmdmNQ=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=LUDJDSRzk64OxFw/mEryQxo5NL6Kfi9Z6CmDPQjaCMT2U4pzDePd14GwJXpjiJPiw
         V6VzvrhU3y34gtnz+4O4v3T2cX8CHluZxQKlr4b3DCb7PrU7vR/7vFV/7sQ35x+OUh
         eblBKbigsBSIeO1cgUfJ5CxmHSQHDNChRGdjwp2dNxz5lgxw13GP/fScOQeSFOAy+e
         DFv05aHjptLpIH4dGXeGOVhKDsFvtSy8rsQtQmZhOf+8z2/qHk/9SlM4oa4Pgjo+0O
         CGrUTAihaOh3kTqiX1BtKkwvAUVmwhXDr41N72gkUThKp7lj/43Sl4dI6Vh0+2m2li
         5tbd6vNTkLAmA==
Date:   Thu, 06 Apr 2023 12:24:34 -0700
Subject: [PATCH 16/23] xfs: Filter XFS_ATTR_PARENT for getfattr
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080824886.615225.3222037053842648091.stgit@frogsfrogsfrogs>
In-Reply-To: <168080824634.615225.17234363585853846885.stgit@frogsfrogsfrogs>
References: <168080824634.615225.17234363585853846885.stgit@frogsfrogsfrogs>
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
---
 fs/xfs/xfs_xattr.c |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/fs/xfs/xfs_xattr.c b/fs/xfs/xfs_xattr.c
index ef5a635238e5..c0c27c0edb33 100644
--- a/fs/xfs/xfs_xattr.c
+++ b/fs/xfs/xfs_xattr.c
@@ -239,6 +239,9 @@ xfs_xattr_put_listent(
 
 	ASSERT(context->count >= 0);
 
+	if (flags & XFS_ATTR_PARENT)
+		return;
+
 	if (flags & XFS_ATTR_ROOT) {
 #ifdef CONFIG_XFS_POSIX_ACL
 		if (namelen == SGI_ACL_FILE_SIZE &&

