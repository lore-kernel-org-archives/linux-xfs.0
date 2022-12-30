Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF833C4332F
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 02:00:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236118AbiLaCAD (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 21:00:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236043AbiLaCAC (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 21:00:02 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 657461C430
        for <linux-xfs@vger.kernel.org>; Fri, 30 Dec 2022 18:00:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B4AFBCE19E6
        for <linux-xfs@vger.kernel.org>; Sat, 31 Dec 2022 01:59:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04CC9C433EF;
        Sat, 31 Dec 2022 01:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672451998;
        bh=bdZVzcx7TM743pMqModRBCcFr8EA8SWIYJEWReq1mSM=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=aTlDfDsO8BxcFs2s2fJI5u79y5qzvGmR/zDDhx9NQYdZAp9pm6xxQQrb/EOMxXm64
         SyqFUpSEJJbYfvQyXJoiSA+/cEGPkn8H8nfPKGsmYBm+epYi+7jdLQwvn8vVywQjKV
         DLFwJzuCTiE8G0A3BtqyXqL94hGG/AG1fFb2G6gaijaoivmI/SvdW++0H3sMJv60VI
         loiXDT+ksc/N3eXFGOuHukkuekOAAZ+NZ0XTkTvMjgWq9CdzSD3q/opC+4KpXIdh7E
         aEyLdEbAkPmk11ZoUMzKCNjwJPMc+Oy4x9ElN+Qj3XdGpEdxkSRD7o7k80U3dQgi3l
         1mNlK10Cl+eoQ==
Subject: [PATCH 4/9] xfs: forcibly convert unwritten blocks within an rt
 extent before sharing
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 30 Dec 2022 14:18:38 -0800
Message-ID: <167243871861.718512.15989906047218636590.stgit@magnolia>
In-Reply-To: <167243871792.718512.13170681692847163098.stgit@magnolia>
References: <167243871792.718512.13170681692847163098.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

As noted in the previous patch, XFS can only unmap and map full rt
extents.  This means that we cannot stop mid-extent for any reason,
including stepping around unwritten/written extents.  Second, the
reflink and CoW mechanisms were not designed to handle shared unwritten
extents, so we have to do something to get rid of them.

If the user asks us to remap two files, we must scan both ranges
beforehand to convert any unwritten extents that are not aligned to rt
extent boundaries into zeroed written extents before sharing.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_reflink.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 8690017beb9b..b9f47bdbe383 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1689,6 +1689,25 @@ xfs_reflink_remap_prep(
 	if (ret)
 		goto out_unlock;
 
+	/*
+	 * Now that we've marked both inodes for reflink, make sure that all
+	 * possible rt extents in both files' ranges are either wholly written,
+	 * wholly unwritten, or holes.  The bmap code requires that we align
+	 * all unmap and remap requests to a rt extent boundary.  We've already
+	 * flushed the page cache and finished directio for the range that's
+	 * being remapped, so we can convert the extents directly.
+	 */
+	if (xfs_inode_has_bigrtextents(src)) {
+		ret = xfs_rtfile_convert_unwritten(src, pos_in, *len);
+		if (ret)
+			goto out_unlock;
+	}
+	if (xfs_inode_has_bigrtextents(dest)) {
+		ret = xfs_rtfile_convert_unwritten(dest, pos_out, *len);
+		if (ret)
+			goto out_unlock;
+	}
+
 	/*
 	 * If pos_out > EOF, we may have dirtied blocks between EOF and
 	 * pos_out. In that case, we need to extend the flush and unmap to cover

