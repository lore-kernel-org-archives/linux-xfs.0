Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A1BCC433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:07:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00A03610A6
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:07:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232733AbhIOXJA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:09:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:60684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231579AbhIOXJA (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:09:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 78F80600D4;
        Wed, 15 Sep 2021 23:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631747260;
        bh=jzN3g1CowRu0tzUsfrAsuoBeFTvjUCBTVlzkwW+zty0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Zc+lgwMN70HCXaDX6x8XYcWMIIdf94tlDAtNqDNGfb/WNVjmY6phpgGbbu3cJbUOQ
         J2QCn9x2vDB8t0ch1FcqiTOE7MlCqTmmJ/9ChP8S8OxbzbCZVYgPXps8dzhs53KFoW
         ojBzI9qtgUsWv7q1bYEVxDifdL7Kx+sBrJ5A6d4f5BtbbVMy1FEi56NqoT6IBaCFr5
         XBDeILgaY0WqtNGVtL4Fq70/Mcnz0XqBWm+dZ193W4vh6MJNmm3ZQZ0hqUnHV7w9Of
         7pu6s8jGbR8WfGfnZwJ5LnO48atQV4SweoVZ335vDwqGCj46foqLxzQK7SYlctOpwl
         /3pa3fsoV8DBA==
Subject: [PATCH 12/61] xfs: Separate xfs_attr_node_addname and
 xfs_attr_node_addname_clear_incomplete
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org
Date:   Wed, 15 Sep 2021 16:07:40 -0700
Message-ID: <163174726022.350433.12590140251272123669.stgit@magnolia>
In-Reply-To: <163174719429.350433.8562606396437219220.stgit@magnolia>
References: <163174719429.350433.8562606396437219220.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Allison Henderson <allison.henderson@oracle.com>

Source kernel commit: f0f7c502c728d0c6947219739631bad101f8737b

This patch separate xfs_attr_node_addname into two functions.  This will
help to make it easier to hoist parts of xfs_attr_node_addname that need
state management

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_attr.c |   23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index b181777d..158149af 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -54,6 +54,7 @@ STATIC int xfs_attr_leaf_hasname(struct xfs_da_args *args, struct xfs_buf **bp);
 STATIC int xfs_attr_node_get(xfs_da_args_t *args);
 STATIC int xfs_attr_node_addname(xfs_da_args_t *args);
 STATIC int xfs_attr_node_removename(xfs_da_args_t *args);
+STATIC int xfs_attr_node_addname_clear_incomplete(struct xfs_da_args *args);
 STATIC int xfs_attr_node_hasname(xfs_da_args_t *args,
 				 struct xfs_da_state **state);
 STATIC int xfs_attr_fillstate(xfs_da_state_t *state);
@@ -1073,6 +1074,28 @@ xfs_attr_node_addname(
 			return error;
 	}
 
+	error = xfs_attr_node_addname_clear_incomplete(args);
+	if (error)
+		goto out;
+	retval = 0;
+out:
+	if (state)
+		xfs_da_state_free(state);
+	if (error)
+		return error;
+	return retval;
+}
+
+
+STATIC int
+xfs_attr_node_addname_clear_incomplete(
+	struct xfs_da_args		*args)
+{
+	struct xfs_da_state		*state = NULL;
+	struct xfs_da_state_blk		*blk;
+	int				retval = 0;
+	int				error = 0;
+
 	/*
 	 * Re-find the "old" attribute entry after any split ops. The INCOMPLETE
 	 * flag means that we will find the "old" attr, not the "new" one.

