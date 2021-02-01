Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21575C433E0
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 02:08:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6C6764E0F
	for <linux-xfs@archiver.kernel.org>; Mon,  1 Feb 2021 02:08:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231265AbhBACIY (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 31 Jan 2021 21:08:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:34668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231328AbhBACHP (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 31 Jan 2021 21:07:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A041764E2B;
        Mon,  1 Feb 2021 02:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612145194;
        bh=es9bsTYfZrQddHHUiVEFIk48BDPhtquqFjNNEJIqLmA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Jli//BZYr8RTZQWQjYSXRKjpXx6qqWsk+IxXeYYcLN1Gv6lDkVZsnVG+UifeWy3J6
         vtV7Cm+8RARSXNaFIFFCZ5PrTeZu07yw58KbwKn7wVskhwX8fx3bkRzMcEsGa4KEg9
         B6yo5NAV8QD5113MoM+wHcQ3XVaFpKVzsk3NoViucyVnpgP8d8mA2ATH9MSv4zWPQg
         lAtPI7MUxt2b8n6E1+xtt58oDjAjvweThZNcmTeAfdx3Yh+sJGoGIHUbfDFsbOKXin
         UWwizCEdIeDZXnNIb2SY2sgGEbhncMdqYpR+GNxK2wL0DP6K0kxcCk4d5IkHazun/4
         qgc15RsJKpQiQ==
Subject: [PATCH 12/12] xfs: flush speculative space allocations when we run
 out of space
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org, david@fromorbit.com, bfoster@redhat.com
Date:   Sun, 31 Jan 2021 18:06:34 -0800
Message-ID: <161214519414.140945.335722903527111632.stgit@magnolia>
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

If a fs modification (creation, file write, reflink, etc.) is unable to
reserve enough space to handle the modification, try clearing whatever
space the filesystem might have been hanging onto in the hopes of
speeding up the filesystem.  The flushing behavior will become
particularly important when we add deferred inode inactivation because
that will increase the amount of space that isn't actively tied to user
data.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_trans.c |   11 +++++++++++
 1 file changed, 11 insertions(+)


diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index 3203841ab19b..973354647298 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -289,6 +289,17 @@ xfs_trans_alloc(
 	tp->t_firstblock = NULLFSBLOCK;
 
 	error = xfs_trans_reserve(tp, resp, blocks, rtextents);
+	if (error == -ENOSPC) {
+		/*
+		 * We weren't able to reserve enough space for the transaction.
+		 * Flush the other speculative space allocations to free space.
+		 * Do not perform a synchronous scan because callers can hold
+		 * other locks.
+		 */
+		error = xfs_blockgc_free_space(mp, NULL);
+		if (!error)
+			error = xfs_trans_reserve(tp, resp, blocks, rtextents);
+	}
 	if (error) {
 		xfs_trans_cancel(tp);
 		return error;

