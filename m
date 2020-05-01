Return-Path: <SRS0=3WhG=6P=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C3A3C4724C
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 08:26:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7664D2166E
	for <linux-xfs@archiver.kernel.org>; Fri,  1 May 2020 08:26:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fYrnyHOD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728412AbgEAI0D (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 1 May 2020 04:26:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728411AbgEAI0C (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 1 May 2020 04:26:02 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43120C035494
        for <linux-xfs@vger.kernel.org>; Fri,  1 May 2020 01:26:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=Qc3C8X7Pmy2xqXQmoGjUaxWQ7BhRFWmRnC+xBHWmbMk=; b=fYrnyHODtCH2TJkEPRDJ6nhwwK
        P7ZcWM2GvxHpf8EVRjOZhych7Z3jAYNnci5c2X5czjH/pam8xcuZhvPydZrdLUqZZwFpn1AZNAKPD
        ZV4dTbqyx/Orj99DcuFXmXkp9WJlqo32fLPwlrcuKeMLUEx+HLYvmDjvF5wGPXaQ6ITRUKEra1HO8
        klda/2oVfhcfH45qjCeyDo9kNwLPMBtjSZvUscgJadzXxHVgSq251e+Aiiuc/eSCZJoEx75KSICKy
        CFOK37RJnZvmgVuDChvo15sq73A0sZxASOE8AaEkuOT3ZVezbknazzQsn8J5KuRKfO+Zrhtlpaq7d
        479EgQBw==;
Received: from 089144205116.atnat0014.highway.webapn.at ([89.144.205.116] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jUQzh-0003ly-DR; Fri, 01 May 2020 08:26:01 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     sandeen@redhat.com
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH] xfsprogs: remove xfs_dir_ops
Date:   Fri,  1 May 2020 10:23:47 +0200
Message-Id: <20200501082347.2605743-1-hch@lst.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The xfs_dir_ops infrastructure has been removed a while ago.  Remove
a few always empty members in xfsprogs to finish the cleanup.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 include/xfs_inode.h | 2 --
 include/xfs_mount.h | 3 ---
 libxcmd/input.c     | 2 ++
 libxfs/rdwr.c       | 8 --------
 libxfs/util.c       | 8 --------
 repair/phase6.c     | 1 -
 6 files changed, 2 insertions(+), 22 deletions(-)

diff --git a/include/xfs_inode.h b/include/xfs_inode.h
index e95a4959..676960d1 100644
--- a/include/xfs_inode.h
+++ b/include/xfs_inode.h
@@ -14,7 +14,6 @@
 struct xfs_trans;
 struct xfs_mount;
 struct xfs_inode_log_item;
-struct xfs_dir_ops;
 
 /*
  * These are not actually used, they are only for userspace build
@@ -60,7 +59,6 @@ typedef struct xfs_inode {
 	unsigned int		i_cformat;	/* format of cow fork */
 
 	xfs_fsize_t		i_size;		/* in-memory size */
-	const struct xfs_dir_ops *d_ops;	/* directory ops vector */
 	struct xfs_ifork_ops	*i_fork_ops;	/* fork verifiers */
 	struct inode		i_vnode;
 } xfs_inode_t;
diff --git a/include/xfs_mount.h b/include/xfs_mount.h
index 7bd23fbb..20c8bfaf 100644
--- a/include/xfs_mount.h
+++ b/include/xfs_mount.h
@@ -9,7 +9,6 @@
 
 struct xfs_inode;
 struct xfs_buftarg;
-struct xfs_dir_ops;
 struct xfs_da_geometry;
 
 /*
@@ -87,8 +86,6 @@ typedef struct xfs_mount {
 
 	struct xfs_da_geometry	*m_dir_geo;	/* directory block geometry */
 	struct xfs_da_geometry	*m_attr_geo;	/* attribute block geometry */
-	const struct xfs_dir_ops *m_dir_inode_ops; /* vector of dir inode ops */
-	const struct xfs_dir_ops *m_nondir_inode_ops; /* !dir inode ops */
 
 	/*
 	 * anonymous struct to allow xfs_dquot_buf.c to compile.
diff --git a/libxcmd/input.c b/libxcmd/input.c
index 203110df..84760784 100644
--- a/libxcmd/input.c
+++ b/libxcmd/input.c
@@ -26,6 +26,7 @@ get_prompt(void)
 }
 
 #ifdef ENABLE_EDITLINE
+#warning "Using editline"
 static char *el_get_prompt(EditLine *e) { return get_prompt(); }
 char *
 fetchline(void)
@@ -55,6 +56,7 @@ fetchline(void)
 	return line;
 }
 #else
+#warning "Not using editline"
 # define MAXREADLINESZ	1024
 char *
 fetchline(void)
diff --git a/libxfs/rdwr.c b/libxfs/rdwr.c
index fd656512..8c48e256 100644
--- a/libxfs/rdwr.c
+++ b/libxfs/rdwr.c
@@ -1287,14 +1287,6 @@ libxfs_iget(
 		return -EFSCORRUPTED;
 	}
 
-	/*
-	 * set up the inode ops structure that the libxfs code relies on
-	 */
-	if (XFS_ISDIR(ip))
-		ip->d_ops = mp->m_dir_inode_ops;
-	else
-		ip->d_ops = mp->m_nondir_inode_ops;
-
 	*ipp = ip;
 	return 0;
 }
diff --git a/libxfs/util.c b/libxfs/util.c
index 2e2ade24..de0bfece 100644
--- a/libxfs/util.c
+++ b/libxfs/util.c
@@ -351,14 +351,6 @@ libxfs_ialloc(
 	ip->i_d.di_aformat = XFS_DINODE_FMT_EXTENTS;
 	ip->i_d.di_anextents = 0;
 
-	/*
-	 * set up the inode ops structure that the libxfs code relies on
-	 */
-	if (XFS_ISDIR(ip))
-		ip->d_ops = ip->i_mount->m_dir_inode_ops;
-	else
-		ip->d_ops = ip->i_mount->m_nondir_inode_ops;
-
 	/*
 	 * Log the new values stuffed into the inode.
 	 */
diff --git a/repair/phase6.c b/repair/phase6.c
index beceea9a..de8c744b 100644
--- a/repair/phase6.c
+++ b/repair/phase6.c
@@ -917,7 +917,6 @@ mk_root_dir(xfs_mount_t *mp)
 	/*
 	 * initialize the directory
 	 */
-	ip->d_ops = mp->m_dir_inode_ops;
 	libxfs_dir_init(tp, ip, ip);
 
 	error = -libxfs_trans_commit(tp);
-- 
2.26.2

