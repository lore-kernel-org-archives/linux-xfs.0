Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4680BC433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 02:08:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1250964E27
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 02:08:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231316AbhBACIE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 31 Jan 2021 21:08:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:34538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231319AbhBACG6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 31 Jan 2021 21:06:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8C78E64E09;
        Mon,  1 Feb 2021 02:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612145177;
        bh=lefU/8s11eLfALhUfR22YHPp16sYJCHlp6MOZpN83Jk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=QNY5tn6pXox7xdbSJ5U7z+SwpZIc2VcNGC9kas8amzapzBRxQdwvTl13MQofrjtX4
         BCz9BBGeY0eTrliGVmWgqQWxV6wiJuFBFcfmEDvecnWGiuAchX99MSgX9wm2gzmDgj
         TuvzZV05LxCHNyO1qQ8oW1IuA0pALXby8M29CzRPoNiWBaA+hWixV5a+Qgf6ZKdkV5
         ZgtfPLZ2j5whKj31Fay94WZLxKYi63c9xIaYl0OMetPb6g3lR6aNEF4LQGHYKhjOqh
         yhmpiYdPXIIMnzaJuCkaZoT5+uIqLJWk4dgDvrb+AZ2nir1pkCe3BctccsMMnJhGbJ
         cx/8CWDOZwe6w==
Subject: [PATCH 09/12] xfs: flush eof/cowblocks if we can't reserve quota for
 chown
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, hch@infradead.org, david@fromorbit.com,
        bfoster@redhat.com
Date:   Sun, 31 Jan 2021 18:06:17 -0800
Message-ID: <161214517714.140945.1957722027452288290.stgit@magnolia>
In-Reply-To: <161214512641.140945.11651856181122264773.stgit@magnolia>
References: <161214512641.140945.11651856181122264773.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If a file user, group, or project change is unable to reserve enough
quota to handle the modification, try clearing whatever space the
filesystem might have been hanging onto in the hopes of speeding up the
filesystem.  The flushing behavior will become particularly important
when we add deferred inode inactivation because that will increase the
amount of space that isn't actively tied to user data.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_trans.c |    9 +++++++++
 1 file changed, 9 insertions(+)


diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index ee3cb916c5c9..3203841ab19b 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -1149,8 +1149,10 @@ xfs_trans_alloc_ichange(
 	struct xfs_dquot	*new_udqp;
 	struct xfs_dquot	*new_gdqp;
 	struct xfs_dquot	*new_pdqp;
+	bool			retried = false;
 	int			error;
 
+retry:
 	error = xfs_trans_alloc(mp, &M_RES(mp)->tr_ichange, 0, 0, 0, &tp);
 	if (error)
 		return error;
@@ -1175,6 +1177,13 @@ xfs_trans_alloc_ichange(
 	if (new_udqp || new_gdqp || new_pdqp) {
 		error = xfs_trans_reserve_quota_chown(tp, ip, new_udqp,
 				new_gdqp, new_pdqp, force);
+		if (!retried && (error == -EDQUOT || error == -ENOSPC)) {
+			xfs_trans_cancel(tp);
+			xfs_blockgc_free_dquots(new_udqp, new_gdqp, new_pdqp,
+					0);
+			retried = true;
+			goto retry;
+		}
 		if (error)
 			goto out_cancel;
 	}

