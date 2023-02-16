Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30961C636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:47:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbjBPUrf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:47:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbjBPUre (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:47:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED44E4ECEF
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:47:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 039FC60C1A
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:47:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6382EC433EF;
        Thu, 16 Feb 2023 20:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676580452;
        bh=9Q8eqe8649jyuuJUksexyKA5wzMbLXc8DASXXVCjFeM=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=AekK+1QN96h8g0yxs43MTUw/viNQS+S3igqNe5Wqk+351dC48lPcmtMe15COOJi01
         04r04nHrWzyUMSBK73mgl9Cog+upz00Rmb4ZggNiBZVSLtQeQ8zRNlnfXwAi0eXvGm
         lcCkYxobJYtqyopsDYwS+fzJ9kli7Q8zH1MWLNPLVsTYAmqIydBNbiDEc9L8OlgPJe
         udZQ2bFl4d1MB/76ANrAmmwVJa9S50Jod0zR07b30KBct3k3mLToOKgFDQaGzjca6e
         KPwKxFI7buvxyUBnylXKutxsn8pOvCcjfbr5PTXkZxCn8hESa0JHbVZaCs3gaFImzb
         aVQ6+D9xSzGNA==
Date:   Thu, 16 Feb 2023 12:47:31 -0800
Subject: [PATCH 22/23] xfs: online repair of directories
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657874149.3474338.16720636979922274112.stgit@magnolia>
In-Reply-To: <167657873813.3474338.3118516275923112371.stgit@magnolia>
References: <167657873813.3474338.3118516275923112371.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If a directory looks like it's in bad shape, try to sift through the
rubble to find whatever directory entries we can, scan the directory
tree for the parent (if needed), stage the new directory contents in a
temporary file and use the atomic extent swapping mechanism to commit
the results in bulk.  As a side effect of this patch, directory
inactivation will be able to purge any leftover dir blocks.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/tempfile.c |   13 +++++++++++++
 fs/xfs/scrub/tempfile.h |    2 ++
 2 files changed, 15 insertions(+)


diff --git a/fs/xfs/scrub/tempfile.c b/fs/xfs/scrub/tempfile.c
index 8f80f1c2555c..91875d4bb67f 100644
--- a/fs/xfs/scrub/tempfile.c
+++ b/fs/xfs/scrub/tempfile.c
@@ -228,3 +228,16 @@ xrep_tempfile_rele(
 	xchk_irele(sc, sc->tempip);
 	sc->tempip = NULL;
 }
+
+/* Decide if a given XFS inode is a temporary file for a repair. */
+bool
+xrep_is_tempfile(
+	const struct xfs_inode	*ip)
+{
+	const struct inode	*inode = &ip->i_vnode;
+
+	if (IS_PRIVATE(inode) && !(inode->i_opflags & IOP_XATTR))
+		return true;
+
+	return false;
+}
diff --git a/fs/xfs/scrub/tempfile.h b/fs/xfs/scrub/tempfile.h
index f00a9ce43a32..e2f493b5d3d9 100644
--- a/fs/xfs/scrub/tempfile.h
+++ b/fs/xfs/scrub/tempfile.h
@@ -16,11 +16,13 @@ void xrep_tempfile_iounlock(struct xfs_scrub *sc);
 void xrep_tempfile_ilock(struct xfs_scrub *sc);
 bool xrep_tempfile_ilock_nowait(struct xfs_scrub *sc);
 void xrep_tempfile_iunlock(struct xfs_scrub *sc);
+bool xrep_is_tempfile(const struct xfs_inode *ip);
 #else
 static inline void xrep_tempfile_iolock_both(struct xfs_scrub *sc)
 {
 	xchk_ilock(sc, XFS_IOLOCK_EXCL);
 }
+# define xrep_is_tempfile(ip)		(false)
 # define xrep_tempfile_rele(sc)
 #endif /* CONFIG_XFS_ONLINE_REPAIR */
 

