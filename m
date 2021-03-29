Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDC13C433EB
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Mar 2021 05:41:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B8BFE6196B
	for <linux-xfs@archiver.kernel.org>; Mon, 29 Mar 2021 05:41:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229971AbhC2Fke (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 29 Mar 2021 01:40:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230243AbhC2FkX (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 29 Mar 2021 01:40:23 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78D56C061574
        for <linux-xfs@vger.kernel.org>; Sun, 28 Mar 2021 22:40:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:To:From:Sender:
        Reply-To:Cc:Content-Type:Content-ID:Content-Description;
        bh=jElanRXnhPIkig7oORJB8XWz1dudSZJLyhdJ2OoStP8=; b=Jeff4u0/OaevJaAOr5f4s7Z4Y6
        r0yVviCV8wnogficVRweIxYwwie66+6s7ivBxBVvP0hCw16RjDpVawyx6M6DgO0lj3UJaqugsqg/j
        VcZUNV8XNVxgV6ELtrhPS1VeI/RA1StVW9uvN/EkhrpDhPXAVZGUdyZVyam3MKW0Q49VjvQ6lGwIQ
        nDHtjeQTbZen0sANqTeD9tBJGcXkvdEFeEAkni3Ptx/QAb6PHGl6jHpDTKv2ajXyatMd4ikTVbTLG
        GSWj87DjgGRzcm0UEjtmMehSAm4PAQ3UD45A4Vs990xt4RvG2Rr3008YoBuySRlgzBLTW7q7WCirB
        qnGXHWfA==;
Received: from 173.40.253.84.static.wline.lns.sme.cust.swisscom.ch ([84.253.40.173] helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lQkcR-006oQV-1C
        for linux-xfs@vger.kernel.org; Mon, 29 Mar 2021 05:39:19 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 20/20] xfs: merge _xfs_dic2xflags into xfs_ip2xflags
Date:   Mon, 29 Mar 2021 07:38:29 +0200
Message-Id: <20210329053829.1851318-21-hch@lst.de>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210329053829.1851318-1-hch@lst.de>
References: <20210329053829.1851318-1-hch@lst.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Merge _xfs_dic2xflags into its only caller.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_inode.c | 54 +++++++++++++++++++---------------------------
 1 file changed, 22 insertions(+), 32 deletions(-)

diff --git a/fs/xfs/xfs_inode.c b/fs/xfs/xfs_inode.c
index 3006cfbd072617..9100a9b7aa80cb 100644
--- a/fs/xfs/xfs_inode.c
+++ b/fs/xfs/xfs_inode.c
@@ -598,65 +598,55 @@ xfs_lock_two_inodes(
 	}
 }
 
-STATIC uint
-_xfs_dic2xflags(
-	uint16_t		di_flags,
-	uint64_t		di_flags2,
-	bool			has_attr)
+uint
+xfs_ip2xflags(
+	struct xfs_inode	*ip)
 {
 	uint			flags = 0;
 
-	if (di_flags & XFS_DIFLAG_ANY) {
-		if (di_flags & XFS_DIFLAG_REALTIME)
+	if (ip->i_diflags & XFS_DIFLAG_ANY) {
+		if (ip->i_diflags & XFS_DIFLAG_REALTIME)
 			flags |= FS_XFLAG_REALTIME;
-		if (di_flags & XFS_DIFLAG_PREALLOC)
+		if (ip->i_diflags & XFS_DIFLAG_PREALLOC)
 			flags |= FS_XFLAG_PREALLOC;
-		if (di_flags & XFS_DIFLAG_IMMUTABLE)
+		if (ip->i_diflags & XFS_DIFLAG_IMMUTABLE)
 			flags |= FS_XFLAG_IMMUTABLE;
-		if (di_flags & XFS_DIFLAG_APPEND)
+		if (ip->i_diflags & XFS_DIFLAG_APPEND)
 			flags |= FS_XFLAG_APPEND;
-		if (di_flags & XFS_DIFLAG_SYNC)
+		if (ip->i_diflags & XFS_DIFLAG_SYNC)
 			flags |= FS_XFLAG_SYNC;
-		if (di_flags & XFS_DIFLAG_NOATIME)
+		if (ip->i_diflags & XFS_DIFLAG_NOATIME)
 			flags |= FS_XFLAG_NOATIME;
-		if (di_flags & XFS_DIFLAG_NODUMP)
+		if (ip->i_diflags & XFS_DIFLAG_NODUMP)
 			flags |= FS_XFLAG_NODUMP;
-		if (di_flags & XFS_DIFLAG_RTINHERIT)
+		if (ip->i_diflags & XFS_DIFLAG_RTINHERIT)
 			flags |= FS_XFLAG_RTINHERIT;
-		if (di_flags & XFS_DIFLAG_PROJINHERIT)
+		if (ip->i_diflags & XFS_DIFLAG_PROJINHERIT)
 			flags |= FS_XFLAG_PROJINHERIT;
-		if (di_flags & XFS_DIFLAG_NOSYMLINKS)
+		if (ip->i_diflags & XFS_DIFLAG_NOSYMLINKS)
 			flags |= FS_XFLAG_NOSYMLINKS;
-		if (di_flags & XFS_DIFLAG_EXTSIZE)
+		if (ip->i_diflags & XFS_DIFLAG_EXTSIZE)
 			flags |= FS_XFLAG_EXTSIZE;
-		if (di_flags & XFS_DIFLAG_EXTSZINHERIT)
+		if (ip->i_diflags & XFS_DIFLAG_EXTSZINHERIT)
 			flags |= FS_XFLAG_EXTSZINHERIT;
-		if (di_flags & XFS_DIFLAG_NODEFRAG)
+		if (ip->i_diflags & XFS_DIFLAG_NODEFRAG)
 			flags |= FS_XFLAG_NODEFRAG;
-		if (di_flags & XFS_DIFLAG_FILESTREAM)
+		if (ip->i_diflags & XFS_DIFLAG_FILESTREAM)
 			flags |= FS_XFLAG_FILESTREAM;
 	}
 
-	if (di_flags2 & XFS_DIFLAG2_ANY) {
-		if (di_flags2 & XFS_DIFLAG2_DAX)
+	if (ip->i_diflags2 & XFS_DIFLAG2_ANY) {
+		if (ip->i_diflags2 & XFS_DIFLAG2_DAX)
 			flags |= FS_XFLAG_DAX;
-		if (di_flags2 & XFS_DIFLAG2_COWEXTSIZE)
+		if (ip->i_diflags2 & XFS_DIFLAG2_COWEXTSIZE)
 			flags |= FS_XFLAG_COWEXTSIZE;
 	}
 
-	if (has_attr)
+	if (XFS_IFORK_Q(ip))
 		flags |= FS_XFLAG_HASATTR;
-
 	return flags;
 }
 
-uint
-xfs_ip2xflags(
-	struct xfs_inode	*ip)
-{
-	return _xfs_dic2xflags(ip->i_diflags, ip->i_diflags2, XFS_IFORK_Q(ip));
-}
-
 /*
  * Lookups up an inode from "name". If ci_name is not NULL, then a CI match
  * is allowed, otherwise it has to be an exact match. If a CI match is found,
-- 
2.30.1

