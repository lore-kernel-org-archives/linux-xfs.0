Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E7EEC4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:50:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236255AbiLaCug (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:50:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236250AbiLaCuf (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:50:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAD1812AD7
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:50:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8E589B81E70
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 02:50:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41D57C433D2;
        Sat, 31 Dec 2022 02:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672455032;
        bh=0Fr09BsBKu9AeXBxFajFZ7UNJ8D+3LzSZIfhr6/hjpA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=npm876GNkd5yGXOj23Hr7FI7JVncW085DV8QtuR6X15Fw4QPds5StY0ni7fnc0Lkp
         oRsdeqRT9y8A0NNwSDBqFJYqnDFiwlzcSbiwqqrerL+8qR4oMoIjNLoUucl2fDCimd
         LZ53kU7nGCpFW0Vp+kJmXYeJFfT8tRIMwHAQ2h4olXPkmNP2B8X60WAQYXXaLVPW8Z
         QQ1h5kTsvEN9ncTXULKtsOH+Fbaj3oULKEHwAidzAEJsS0liHO7xmiPIrSL2Tnbl/N
         eYIZO+K8MM+5iUsxbaqy7AXIpp/AECT14TJYA6qL3rigu/Qi7L0GHMnfbOzDdbYWpL
         zLvNWGe/HcdXg==
Subject: [PATCH 31/41] xfs_repair: collect relatime reverse-mapping data for
 refcount/rmap tree rebuilding
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:20:00 -0800
Message-ID: <167243880005.732820.8724817650297086753.stgit@magnolia>
In-Reply-To: <167243879574.732820.4725863402652761218.stgit@magnolia>
References: <167243879574.732820.4725863402652761218.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Collect reverse-mapping data for realtime files so that we can later
check and rebuild the reference count tree and the reverse mapping
tree.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/dinode.c |    4 ++++
 1 file changed, 4 insertions(+)


diff --git a/repair/dinode.c b/repair/dinode.c
index 6f44261907e..28eb639bbb8 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -350,6 +350,10 @@ _("inode %" PRIu64 " - bad rt extent overflows - start %" PRIu64 ", "
 	 */
 	*tot += irec->br_blockcount;
 
+	/* Record mapping data for the realtime rmap. */
+	if (collect_rmaps && !zap_metadata && !check_dups)
+		rmap_add_rec(mp, ino, XFS_DATA_FORK, irec, true);
+
 	return 0;
 }
 

