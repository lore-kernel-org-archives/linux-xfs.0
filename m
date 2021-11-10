Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D9EEC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Nov 2021 02:34:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54DF461179
	for <linux-xfs@archiver.kernel.org>; Wed, 10 Nov 2021 02:34:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbhKJCgx (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 9 Nov 2021 21:36:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:39884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229717AbhKJCgw (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 9 Nov 2021 21:36:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BB0C61105;
        Wed, 10 Nov 2021 02:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636511646;
        bh=MUOA9gepVpfNC+mFC/yB5BIOZnz/fKJ6crBI8Su77ZI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ncf2oMlyBcY2KSRjq3Fu6I1gkzI8jABQ/sAZk7OJARpOzodymCvjn6rzpmJBZ0QlW
         vPRRCjmW81yfAQlQqj4L/jPTGMP1UqPsCvEornk8+l1ObAD2SLkokDY7DyMs1AiZeS
         B7Rklq+cp3Mh6vQwAm0oYdJy74IZybRdLJTFv428rJMe8ECVKAT/9ABegpOozDnnuZ
         ghOdWeIcswzAOcqOjlDFVRvwYjC/2pRw/+VPJzd/dj4gYpJj4PQMEtMy2SH93KIORq
         VbC37beHhb+xIYAaYVD1w98DayTTF/29xOVyf3QEHrUjGXmMNhBBz2emOAmPoAieTL
         yIzwMHeBYlD/w==
Date:   Tue, 9 Nov 2021 18:34:05 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     Eric Sandeen <esandeen@redhat.com>
Cc:     xfs <linux-xfs@vger.kernel.org>
Subject: [PATCH 4/3] xfs: sync xfs_btree_split macros with userspace libxfs
Message-ID: <20211110023405.GY24307@magnolia>
References: <a98ed48b-7297-34af-2a2a-795b15b35f12@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a98ed48b-7297-34af-2a2a-795b15b35f12@redhat.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Sync this one last bit of discrepancy between kernel and userspace
libxfs.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/libxfs/xfs_btree.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/xfs/libxfs/xfs_btree.c b/fs/xfs/libxfs/xfs_btree.c
index b4e19aacb9de..d8a859bc797a 100644
--- a/fs/xfs/libxfs/xfs_btree.c
+++ b/fs/xfs/libxfs/xfs_btree.c
@@ -2785,6 +2785,7 @@ __xfs_btree_split(
 	return error;
 }
 
+#ifdef __KERNEL__
 struct xfs_btree_split_args {
 	struct xfs_btree_cur	*cur;
 	int			level;
@@ -2870,6 +2871,9 @@ xfs_btree_split(
 	destroy_work_on_stack(&args.work);
 	return args.result;
 }
+#else /* !KERNEL */
+#define xfs_btree_split		__xfs_btree_split
+#endif
 
 
 /*
