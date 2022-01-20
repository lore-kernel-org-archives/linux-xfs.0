Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21AEDC433EF
	for <linux-xfs@archiver.kernel.org>; Thu, 20 Jan 2022 00:19:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345115AbiATATZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 19 Jan 2022 19:19:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345061AbiATATZ (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 19 Jan 2022 19:19:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36EEAC061574
        for <linux-xfs@vger.kernel.org>; Wed, 19 Jan 2022 16:19:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CAEE261514
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jan 2022 00:19:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EE69C004E1;
        Thu, 20 Jan 2022 00:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642637964;
        bh=KlnbJlF9e8iNH4QQKPKmX92PVOKJqFA0JHLGC3Zbt50=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=H5oRYvmkMgBHI6WXBDKKlW01ViuZ6Dc9DI3rA9tjggQLfzYbt5vAxope0o4BKKQMt
         es4MqYr3t8EZMD3/Eyb0Qcp8O4bjWPdY4wg4ajXpn2i7gRo7H05HFrGxsJwYOQAhgE
         3CxfTBrkb7Lkj16sOgP8BTj/C4XV9SSIZ8t1eMOQUMTP6jmZbkYduZ6lXXQ7v87OWa
         vYoeWGlfzXAelbUPO4gzbLulLtcabceTTgmYh408fnskv55HpsS2RqeK6sgXRCS2SQ
         Jfih5DkrhA7ExGgmnDrqu8/iv7rNoXI3zuxpJcVmX9/tnMIenbStvb5wnu5YIjREXZ
         i55VHpnWGjTkw==
Subject: [PATCH 22/45] xfs: rename xfs_has_attr()
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Dave Chinner <dchinner@redhat.com>, linux-xfs@vger.kernel.org
Date:   Wed, 19 Jan 2022 16:19:23 -0800
Message-ID: <164263796391.860211.14668915079764565213.stgit@magnolia>
In-Reply-To: <164263784199.860211.7509808171577819673.stgit@magnolia>
References: <164263784199.860211.7509808171577819673.stgit@magnolia>
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

