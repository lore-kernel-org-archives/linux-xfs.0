Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C75D5C6FD19
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 19:24:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230173AbjCPTYF (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 15:24:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbjCPTYD (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 15:24:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 690AF448E
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 12:23:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 10EB4B82321
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 19:23:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C00CAC433D2;
        Thu, 16 Mar 2023 19:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678994614;
        bh=Crl3H36qvZD43/aT7we2uuUEIXd060nbKyX8wGqkcIA=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=XhI/POB+Gc37b9c2KdrLophXjjRVyP/BlQd+oztQAc1C2k4+1EnROBlskqK4yOZwq
         /+4GsndXlQJBFU7UYVIDvo9g3GtsDp/pJHlDzBMJz1ReYv2yBJcygPTrxSHT3+qnx0
         lKfa1Obs17QSwGfn+hSSOFw7vkUTegB1xptM4BWG7ISt+FSH50IG4mFsvZCMJ6wMpT
         Nox2j8zcmEigq7rO1Bw/91oa8TwvifRM1cHs7BRWXkVB81zsTDKHCNOjdVH6V/FHkX
         slrrkJbGzHvsxxjSARmB8akhz3kQniMPLwwHO8oqrcYZraGg+063C494q28RvwcQpN
         FAqTICqZiGVgA==
Date:   Thu, 16 Mar 2023 12:23:34 -0700
Subject: [PATCH 08/17] xfs: always set args->value in xfs_attri_item_recover
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167899414469.15363.18092696045484103739.stgit@frogsfrogsfrogs>
In-Reply-To: <167899414339.15363.12404998880107296432.stgit@frogsfrogsfrogs>
References: <167899414339.15363.12404998880107296432.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Always set args->value to the recovered value buffer.  This reduces the
amount of code in the switch statement, and hence the amount of thinking
that I have to do.  We validated the recovered buffers, supposedly.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_attr_item.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 054237177446..66b4c167588d 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -629,6 +629,8 @@ xfs_attri_item_recover(
 	args->new_name = nv->nname.i_addr;
 	args->new_namelen = nv->nname.i_len;
 	args->hashval = xfs_da_hashname(args->name, args->namelen);
+	args->value = nv->value.i_addr;
+	args->valuelen = nv->value.i_len;
 	args->attr_filter = attrp->alfi_attr_filter & XFS_ATTRI_FILTER_MASK;
 	args->op_flags = XFS_DA_OP_RECOVERY | XFS_DA_OP_OKNOENT |
 			 XFS_DA_OP_LOGGED;
@@ -639,8 +641,6 @@ xfs_attri_item_recover(
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
 	case XFS_ATTRI_OP_FLAGS_NVREPLACE:
-		args->value = nv->value.i_addr;
-		args->valuelen = nv->value.i_len;
 		args->total = xfs_attr_calc_size(args, &local);
 		if (xfs_inode_hasattr(args->dp))
 			attr->xattri_dela_state = xfs_attr_init_replace_state(args);

