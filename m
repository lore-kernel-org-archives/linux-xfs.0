Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D34B9C433E0
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Jan 2021 02:19:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A799C64E00
	for <linux-xfs@archiver.kernel.org>; Fri, 29 Jan 2021 02:19:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231513AbhA2CTg (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 28 Jan 2021 21:19:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:58362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229757AbhA2CTf (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 28 Jan 2021 21:19:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4040264E02;
        Fri, 29 Jan 2021 02:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611886735;
        bh=SbGdaTAygv4nC81vT/tXM+peDBYFSDsdyv/zW6Qi8h0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=M0OUxHQeIjFNBbxuOseQcHUJEPNKwRG4RII9Ff//rPkCqTV14KJ1xgBshdVAG6ro3
         fomLg5SOoYG82n4Wml4RwER0OJhpYDYSgIuHKPwm+XBhdmgrk8jA1h7AUvOFXy/aZm
         7GLQ3lg7gomfK0SNFtUbsjEjkKv7fqHpqRJbCE5uQ8XpLcBU9c+jomp8xVaCCBXDhe
         x0IwHM4NvxqdTyj4EUwUOCJ1nUnSdbpS8Jsv2Skxo8zANMPGJP3HDqmHeWO7VKDZJY
         +A5z0iBOEXo9XMF1kV6j16xwLT10tfPHSXIJuwxETWgeT7of9RURp5jx0WbIWSTrhW
         6l2j6WIV4ZmBg==
Subject: [PATCH 12/12] xfs: flush speculative space allocations when we run
 out of space
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@infradead.org, david@fromorbit.com, bfoster@redhat.com
Date:   Thu, 28 Jan 2021 18:18:54 -0800
Message-ID: <161188673444.1943978.15159087396736987395.stgit@magnolia>
In-Reply-To: <161188666613.1943978.971196931920996596.stgit@magnolia>
References: <161188666613.1943978.971196931920996596.stgit@magnolia>
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
 fs/xfs/xfs_trans.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)


diff --git a/fs/xfs/xfs_trans.c b/fs/xfs/xfs_trans.c
index b08bb5a8fb60..3c2b26a21c6d 100644
--- a/fs/xfs/xfs_trans.c
+++ b/fs/xfs/xfs_trans.c
@@ -289,6 +289,18 @@ xfs_trans_alloc(
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
+		if (error)
+			return error;
+		error = xfs_trans_reserve(tp, resp, blocks, rtextents);
+	}
 	if (error) {
 		xfs_trans_cancel(tp);
 		return error;

