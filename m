Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01463C433F5
	for <linux-xfs@archiver.kernel.org>; Tue,  4 Jan 2022 23:43:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236557AbiADXn0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 4 Jan 2022 18:43:26 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57142 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236541AbiADXn0 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 4 Jan 2022 18:43:26 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E2ECB614B6
        for <linux-xfs@vger.kernel.org>; Tue,  4 Jan 2022 23:43:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A648C36AEB
        for <linux-xfs@vger.kernel.org>; Tue,  4 Jan 2022 23:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641339805;
        bh=aevQb+fPNY+ovHGUMLo+K7mwqqRWZfHjqvVhUTUdxyQ=;
        h=Date:From:To:Subject:From;
        b=c5O9ZWAXAZm2z+ZNuENniNHmqIX3deliW4RDNaf3sDtLbN/e4Ys2rz5xjANbwpEba
         XoOxfDf1KeLQ1J8kfu9YgT3LrVy+mB1CnOOYYlqe9JiRw9gjd9FEZu2aM8kOAn7H0Z
         WEdjvJBJLmFBJV6aULiut0KS4RKxtOn2cDfh79RaVTs9XAcE8Mnnz3glNLPoKPnWLp
         uDWCYwaADDAtgC50m6jpPCnPpa02rtlET/gUU0ghhcxN3oTed61bNHn1wXyCHqKZrO
         jrHZhDjyDFgae6cRHqrfcltuW5zYs+gbA+pUHfssHa+iGGB4VM8wlMpUwwiM30xto3
         KEJm14rPcL5qQ==
Date:   Tue, 4 Jan 2022 15:43:25 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH] xfs: warn about inodes with project id of -1
Message-ID: <20220104234325.GJ31583@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Inodes aren't supposed to have a project id of -1U (aka 4294967295) but
the kernel hasn't always validated FSSETXATTR correctly.  Flag this as
something for the sysadmin to check out.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/scrub/inode.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/fs/xfs/scrub/inode.c b/fs/xfs/scrub/inode.c
index 2405b09d03d0..eac15af7b08c 100644
--- a/fs/xfs/scrub/inode.c
+++ b/fs/xfs/scrub/inode.c
@@ -233,6 +233,7 @@ xchk_dinode(
 	unsigned long long	isize;
 	uint64_t		flags2;
 	uint32_t		nextents;
+	prid_t			prid;
 	uint16_t		flags;
 	uint16_t		mode;
 
@@ -267,6 +268,7 @@ xchk_dinode(
 		 * so just mark this inode for preening.
 		 */
 		xchk_ino_set_preen(sc, ino);
+		prid = 0;
 		break;
 	case 2:
 	case 3:
@@ -279,12 +281,17 @@ xchk_dinode(
 		if (dip->di_projid_hi != 0 &&
 		    !xfs_has_projid32(mp))
 			xchk_ino_set_corrupt(sc, ino);
+
+		prid = be16_to_cpu(dip->di_projid_lo);
 		break;
 	default:
 		xchk_ino_set_corrupt(sc, ino);
 		return;
 	}
 
+	if (xfs_has_projid32(mp))
+		prid |= (prid_t)be16_to_cpu(dip->di_projid_hi) << 16;
+
 	/*
 	 * di_uid/di_gid -- -1 isn't invalid, but there's no way that
 	 * userspace could have created that.
@@ -293,6 +300,13 @@ xchk_dinode(
 	    dip->di_gid == cpu_to_be32(-1U))
 		xchk_ino_set_warning(sc, ino);
 
+	/*
+	 * project id of -1 isn't supposed to be valid, but the kernel didn't
+	 * always validate that.
+	 */
+	if (prid == -1U)
+		xchk_ino_set_warning(sc, ino);
+
 	/* di_format */
 	switch (dip->di_format) {
 	case XFS_DINODE_FMT_DEV:
