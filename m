Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53F46C433F5
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Sep 2021 02:41:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 308DC61108
	for <linux-xfs@archiver.kernel.org>; Tue, 14 Sep 2021 02:41:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235706AbhINCnL (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 13 Sep 2021 22:43:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:53506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234374AbhINCnL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 Sep 2021 22:43:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F04CC610CC;
        Tue, 14 Sep 2021 02:41:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631587315;
        bh=KlnbJlF9e8iNH4QQKPKmX92PVOKJqFA0JHLGC3Zbt50=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Xya67BbbDxp1jmIBlU/6tGDKndHMif5nCz9E3uBKru9joxKcVCOv+AE6N6eC0REkd
         oEjxQUMucgM7Dp/epRV9FgzEQ2Rrw0UzEQK1ewR51fnP34cvKoFET2vtIGxaJK+luw
         jFclHadQXWmUe2fP+tEIWtBhhawv6M5hJGynHgumiKik2OoXsXL8KpXRJQgJEnm4Z5
         TmoD/2jyIkD0rXN0OTb4X2D6DqxHAs8ilsFc+Hp2ivFRsJR7jWOIb3Y1ls38ecv3VV
         CF0JbBI0G7YnJY9oyur4WKUr7HvQZ6NhtYPIoK4jIGNmtTbE6sz61qcmqRW5wWm+wB
         5ZQvr+hMqo19w==
Subject: [PATCH 21/43] xfs: rename xfs_has_attr()
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Mon, 13 Sep 2021 19:41:54 -0700
Message-ID: <163158731471.1604118.2196733648224977803.stgit@magnolia>
In-Reply-To: <163158719952.1604118.14415288328687941574.stgit@magnolia>
References: <163158719952.1604118.14415288328687941574.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

Source kernel commit: 51b495eba84dee8c1df4abfc26fc134ea190e28f

xfs_has_attr() is poorly named. It has global scope as it is defined
in a header file, but it has no namespace scope that tells us what
it is checking has attributes. It's not even clear what "has_attr"
means, because what it is actually doing is an attribute fork lookup
to see if the attribute exists.

Upcoming patches use this "xfs_has_<foo>" namespace for global
filesystem features, which conflicts with this function.

Rename xfs_has_attr() to xfs_attr_lookup() and make it a static
function, freeing up the "xfs_has_" namespace for global scope
usage.

Signed-off-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_attr.c |    7 +++----
 libxfs/xfs_attr.h |    1 -
 2 files changed, 3 insertions(+), 5 deletions(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 2957fd03..07b19652 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -642,8 +642,8 @@ xfs_attr_set_iter(
 /*
  * Return EEXIST if attr is found, or ENOATTR if not
  */
-int
-xfs_has_attr(
+static int
+xfs_attr_lookup(
 	struct xfs_da_args	*args)
 {
 	struct xfs_inode	*dp = args->dp;
@@ -780,8 +780,8 @@ xfs_attr_set(
 			goto out_trans_cancel;
 	}
 
+	error = xfs_attr_lookup(args);
 	if (args->value) {
-		error = xfs_has_attr(args);
 		if (error == -EEXIST && (args->attr_flags & XATTR_CREATE))
 			goto out_trans_cancel;
 		if (error == -ENOATTR && (args->attr_flags & XATTR_REPLACE))
@@ -796,7 +796,6 @@ xfs_attr_set(
 		if (!args->trans)
 			goto out_unlock;
 	} else {
-		error = xfs_has_attr(args);
 		if (error != -EEXIST)
 			goto out_trans_cancel;
 
diff --git a/libxfs/xfs_attr.h b/libxfs/xfs_attr.h
index 8de5d1d2..5e71f719 100644
--- a/libxfs/xfs_attr.h
+++ b/libxfs/xfs_attr.h
@@ -490,7 +490,6 @@ int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_args(struct xfs_da_args *args);
-int xfs_has_attr(struct xfs_da_args *args);
 int xfs_attr_remove_args(struct xfs_da_args *args);
 int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
 bool xfs_attr_namecheck(const void *name, size_t length);

