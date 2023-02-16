Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EE18C61DA4
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 20:50:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbjBPUu5 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 15:50:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbjBPUu5 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 15:50:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 467274BEA8
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 12:50:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D604060AB9
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 20:50:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 421D3C433EF;
        Thu, 16 Feb 2023 20:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676580655;
        bh=M/jcate+ykMWA8iEGMzxUmOJgBRQfnJXSXVwUl2MfNE=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=R987CzPBGWxS7vUO2ZLXdipz3DSjKeoXx/3ARiYNBkvbKvjBOYBAAoWd25SHPvDel
         RBtpjUEgDQCYLu9IxlW6huAX+WvsHS5wm7N3pWxBQGfaQe/lBJXbPwRyNfes0oNr9B
         47Aql56lXcfHHm0XEuWl1IugdhlbBBcBL5jR8auvhkTLnmoG4X+GIqIrnBmybmxtjt
         WMTtlJI+FgqWsJxuJ3jHjTP+dE4E9Owz4sv/8jIaygq9ksYCzTSGfii7YdxSIZ0U0B
         dYpTVGSGB7nNKMrrcgW4apUfnNFQVuLc63gh3EagX1kIn9ddpfwZv6QsAahkalXvs9
         bp4kwSd0+HGZQ==
Date:   Thu, 16 Feb 2023 12:50:54 -0800
Subject: [PATCH 3/3] xfs: compare generated and existing parent pointers
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657875240.3475204.3772512849479773946.stgit@magnolia>
In-Reply-To: <167657875195.3475204.16384027586557102765.stgit@magnolia>
References: <167657875195.3475204.16384027586557102765.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Check our work to make sure we found all the parent pointers that the
original file had.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/parent_repair.c |   52 ++++++++++++++++++++++++++++++++++++++++--
 fs/xfs/scrub/trace.h         |    1 +
 2 files changed, 50 insertions(+), 3 deletions(-)


diff --git a/fs/xfs/scrub/parent_repair.c b/fs/xfs/scrub/parent_repair.c
index 4aec32081c6d..56b47bf2807b 100644
--- a/fs/xfs/scrub/parent_repair.c
+++ b/fs/xfs/scrub/parent_repair.c
@@ -127,6 +127,9 @@ struct xrep_pptrs {
 
 	/* Parent pointer names. */
 	struct xfblob		*pptr_names;
+
+	/* Buffer for validation. */
+	unsigned char		namebuf[MAXNAMELEN];
 };
 
 /* Tear down all the incore stuff we created. */
@@ -490,7 +493,10 @@ xrep_pptr_scan_dirtree(
 	return 0;
 }
 
-/* Dump a parent pointer from the temporary file. */
+/*
+ * Dump a parent pointer from the temporary file and check it against the file
+ * we're rebuilding.  We are not committing any of this.
+ */
 STATIC int
 xrep_pptr_dump_tempptr(
 	struct xfs_scrub	*sc,
@@ -504,13 +510,45 @@ xrep_pptr_dump_tempptr(
 {
 	struct xrep_pptrs	*rp = priv;
 	const struct xfs_parent_name_rec *rec = (const void *)name;
+	struct xfs_inode	*other_ip;
+	int			pptr_namelen;
 
 	if (!(attr_flags & XFS_ATTR_PARENT))
 		return 0;
 
+	if (ip == sc->ip)
+		other_ip = sc->tempip;
+	else if (ip == sc->tempip)
+		other_ip = sc->ip;
+	else
+		return -EFSCORRUPTED;
+
 	xfs_parent_irec_from_disk(&rp->pptr, rec, value, valuelen);
 
 	trace_xrep_pptr_dumpname(sc->tempip, &rp->pptr);
+
+	pptr_namelen = xfs_parent_lookup(sc->tp, other_ip, &rp->pptr,
+			rp->namebuf, MAXNAMELEN, &rp->pptr_scratch);
+	if (pptr_namelen == -ENOATTR) {
+		trace_xrep_pptr_checkname(other_ip, &rp->pptr);
+		ASSERT(pptr_namelen != -ENOATTR);
+		return -EFSCORRUPTED;
+	}
+	if (pptr_namelen < 0)
+		return pptr_namelen;
+
+	if (pptr_namelen != rp->pptr.p_namelen) {
+		trace_xrep_pptr_checkname(other_ip, &rp->pptr);
+		ASSERT(pptr_namelen == rp->pptr.p_namelen);
+		return -EFSCORRUPTED;
+	}
+
+	if (memcmp(rp->namebuf, rp->pptr.p_name, rp->pptr.p_namelen)) {
+		trace_xrep_pptr_checkname(other_ip, &rp->pptr);
+		ASSERT(0);
+		return -EFSCORRUPTED;
+	}
+
 	return 0;
 }
 
@@ -566,8 +604,16 @@ xrep_pptr_rebuild_tree(
 
 	trace_xrep_pptr_rebuild_tree(sc->ip, 0);
 
-	xrep_tempfile_ilock(sc);
-	return xchk_xattr_walk(sc, sc->tempip, xrep_pptr_dump_tempptr, rp);
+	xchk_ilock(sc, XFS_ILOCK_EXCL);
+	error = xrep_tempfile_ilock_polled(sc);
+	if (error)
+		return error;
+
+	error = xchk_xattr_walk(sc, sc->tempip, xrep_pptr_dump_tempptr, rp);
+	if (error)
+		return error;
+
+	return xchk_xattr_walk(sc, sc->ip, xrep_pptr_dump_tempptr, rp);
 }
 
 /*
diff --git a/fs/xfs/scrub/trace.h b/fs/xfs/scrub/trace.h
index 283a1cedf368..e536d070f9c7 100644
--- a/fs/xfs/scrub/trace.h
+++ b/fs/xfs/scrub/trace.h
@@ -1356,6 +1356,7 @@ DEFINE_EVENT(xrep_pptr_class, name, \
 DEFINE_XREP_PPTR_CLASS(xrep_pptr_createname);
 DEFINE_XREP_PPTR_CLASS(xrep_pptr_removename);
 DEFINE_XREP_PPTR_CLASS(xrep_pptr_dumpname);
+DEFINE_XREP_PPTR_CLASS(xrep_pptr_checkname);
 
 DECLARE_EVENT_CLASS(xrep_pptr_scan_class,
 	TP_PROTO(struct xfs_inode *ip, const struct xfs_inode *dp,

