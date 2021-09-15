Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 960AEC433EF
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:11:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7837660E94
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:11:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232133AbhIOXMz (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:12:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:38760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231782AbhIOXMy (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:12:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 51B4A60E05;
        Wed, 15 Sep 2021 23:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631747495;
        bh=rYIYIlWao75NX0cY9mDh9EAmNgw9GscJXJUGOHNtjWk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=byGFc6//FWK+aGTzY9R56bLzZ3S9/o5QrAKgUdv5rxvky9ShnLxE0KHr1uoThlk7l
         YTmqVZ8t6l1dIzsV1lu6g34KWhQ22b4by7AcJ8NBSa+Q5QwXA8aczuxBv5oS9OT/oh
         9hWzD+1jfgSSp98BQwDWHVmf3xq6sB3vJ02g/QloIfV+iwNUALO2P+9OVYXNT5VtBC
         5rdeIqra0vAbvokeMdWfPPEu386l7KyHhSVeo6/l/UHz/bXkk6TTLRzJZXfpc1Prax
         EVfNXDlfZcY0H6PSy+faPG8L/6QuEqX57WbMsoDZNk0oLmLXZuxWCz7mVBsZ6Axuf4
         GRJJHCF/sRJRA==
Subject: [PATCH 55/61] xfs: Initialize error in xfs_attr_remove_iter
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Brian Foster <bfoster@redhat.com>,
        Bill O'Donnell <bodonnel@redhat.com>, linux-xfs@vger.kernel.org
Date:   Wed, 15 Sep 2021 16:11:35 -0700
Message-ID: <163174749507.350433.5122244776306993089.stgit@magnolia>
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

Source kernel commit: d3a3340b6af28ab79a66687973fb0287d976d490

A recent bug report generated a warning that a code path in
xfs_attr_remove_iter could potentially return error uninitialized in the
case of XFS_DAS_RM_SHRINK state.  Fix this by initializing error.

Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Bill O'Donnell <bodonnel@redhat.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_attr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index 8f6f1754..d6195789 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -1375,7 +1375,7 @@ xfs_attr_remove_iter(
 {
 	struct xfs_da_args		*args = dac->da_args;
 	struct xfs_da_state		*state = dac->da_state;
-	int				retval, error;
+	int				retval, error = 0;
 	struct xfs_inode		*dp = args->dp;
 
 	trace_xfs_attr_node_removename(args);

