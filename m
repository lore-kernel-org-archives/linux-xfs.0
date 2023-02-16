Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75256C636CC
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:01:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbjBPVB1 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:01:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbjBPVBZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:01:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AF52505F0
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 13:01:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 072CBB82958
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 21:01:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1AD1C433D2;
        Thu, 16 Feb 2023 21:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676581279;
        bh=A2CowVBKySxkoJxcmUA7Fp0Aba7G137bR+CHi+Cbymk=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=hoAIHXdjFq0d/rYNJ8g6YCy9WLvb80M+6gmdOt1eMY2A351C3fS6fLAmCm1ANONBO
         G2EBFqHSSigaYq6apZ3aa407g4edV4v4wZ2dRJ+dZnsfHvD6g6Kr7UuXR5OAbznGle
         doS4outbwV0vjavinHmp/i6l2Nl0bqEPixK1LP9K9ZQWHdLQEWBL+oaYk0KTKi82dF
         OHAo9Mxk3zlUnwAJiId2gb5OAsD0TldtmGPBlWtdy1EHLp4cm+al7o2U59Zl0wrKz7
         aEKeCaKptqwM429vbhDvEynK+arH2VXzOUuoZzsD3JgI4KMN26THreblgd8IobQ2R2
         lmV+SppgJH43w==
Date:   Thu, 16 Feb 2023 13:01:19 -0800
Subject: [PATCH 5/6] xfs: pass the attr value to put_listent when possible
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657879600.3476725.10228582144058673841.stgit@magnolia>
In-Reply-To: <167657879533.3476725.4672667573997149436.stgit@magnolia>
References: <167657879533.3476725.4672667573997149436.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Pass the attr value to put_listent when we have local xattrs or
shortform xattrs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_attr.h    |    5 +++--
 libxfs/xfs_attr_sf.h |    1 +
 2 files changed, 4 insertions(+), 2 deletions(-)


diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index d6d23cf1..02a20b94 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -47,8 +47,9 @@ struct xfs_attrlist_cursor_kern {
 
 
 /* void; state communicated via *context */
-typedef void (*put_listent_func_t)(struct xfs_attr_list_context *, int,
-			      unsigned char *, int, int);
+typedef void (*put_listent_func_t)(struct xfs_attr_list_context *context,
+		int flags, unsigned char *name, int namelen, void *value,
+		int valuelen);
 
 struct xfs_attr_list_context {
 	struct xfs_trans	*tp;
diff --git a/libxfs/xfs_attr_sf.h b/libxfs/xfs_attr_sf.h
index 37578b36..c6e25979 100644
--- a/libxfs/xfs_attr_sf.h
+++ b/libxfs/xfs_attr_sf.h
@@ -24,6 +24,7 @@ typedef struct xfs_attr_sf_sort {
 	uint8_t		flags;		/* flags bits (see xfs_attr_leaf.h) */
 	xfs_dahash_t	hash;		/* this entry's hash value */
 	unsigned char	*name;		/* name value, pointer into buffer */
+	void		*value;
 } xfs_attr_sf_sort_t;
 
 #define XFS_ATTR_SF_ENTSIZE_MAX			/* max space for name&value */ \

