Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EEF6C432BE
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Aug 2021 23:59:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 56E3761051
	for <linux-xfs@archiver.kernel.org>; Wed, 18 Aug 2021 23:59:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235433AbhHSAAW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 18 Aug 2021 20:00:22 -0400
Received: from mail109.syd.optusnet.com.au ([211.29.132.80]:56480 "EHLO
        mail109.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235343AbhHSAAW (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 18 Aug 2021 20:00:22 -0400
Received: from dread.disaster.area (pa49-195-182-146.pa.nsw.optusnet.com.au [49.195.182.146])
        by mail109.syd.optusnet.com.au (Postfix) with ESMTPS id 6C72985617
        for <linux-xfs@vger.kernel.org>; Thu, 19 Aug 2021 09:59:45 +1000 (AEST)
Received: from discord.disaster.area ([192.168.253.110])
        by dread.disaster.area with esmtp (Exim 4.92.3)
        (envelope-from <david@fromorbit.com>)
        id 1mGVT8-002JPP-7O
        for linux-xfs@vger.kernel.org; Thu, 19 Aug 2021 09:59:38 +1000
Received: from dave by discord.disaster.area with local (Exim 4.94)
        (envelope-from <david@fromorbit.com>)
        id 1mGVT7-000cw5-Vj
        for linux-xfs@vger.kernel.org; Thu, 19 Aug 2021 09:59:37 +1000
From:   Dave Chinner <david@fromorbit.com>
To:     linux-xfs@vger.kernel.org
Subject: [PATCH 02/16] xfs: rename xfs_has_attr()
Date:   Thu, 19 Aug 2021 09:59:21 +1000
Message-Id: <20210818235935.149431-3-david@fromorbit.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210818235935.149431-1-david@fromorbit.com>
References: <20210818235935.149431-1-david@fromorbit.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.3 cv=Tu+Yewfh c=1 sm=1 tr=0
        a=QpfB3wCSrn/dqEBSktpwZQ==:117 a=QpfB3wCSrn/dqEBSktpwZQ==:17
        a=MhDmnRu9jo8A:10 a=20KFwNOVAAAA:8 a=VwQbUJbxAAAA:8
        a=ck9BDHnC6AwfIP5OPlUA:9 a=AjGcO6oz07-iQ99wixmX:22
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Dave Chinner <dchinner@redhat.com>

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
---
 fs/xfs/libxfs/xfs_attr.c | 7 +++----
 fs/xfs/libxfs/xfs_attr.h | 1 -
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/fs/xfs/libxfs/xfs_attr.c b/fs/xfs/libxfs/xfs_attr.c
index 010d499b237c..d8a66470e236 100644
--- a/fs/xfs/libxfs/xfs_attr.c
+++ b/fs/xfs/libxfs/xfs_attr.c
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
 
diff --git a/fs/xfs/libxfs/xfs_attr.h b/fs/xfs/libxfs/xfs_attr.h
index 8de5d1d2733e..5e71f719bdd5 100644
--- a/fs/xfs/libxfs/xfs_attr.h
+++ b/fs/xfs/libxfs/xfs_attr.h
@@ -490,7 +490,6 @@ int xfs_attr_get_ilocked(struct xfs_da_args *args);
 int xfs_attr_get(struct xfs_da_args *args);
 int xfs_attr_set(struct xfs_da_args *args);
 int xfs_attr_set_args(struct xfs_da_args *args);
-int xfs_has_attr(struct xfs_da_args *args);
 int xfs_attr_remove_args(struct xfs_da_args *args);
 int xfs_attr_remove_iter(struct xfs_delattr_context *dac);
 bool xfs_attr_namecheck(const void *name, size_t length);
-- 
2.31.1

