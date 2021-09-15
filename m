Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBB19C433F5
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:11:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2FBD610A6
	for <linux-xfs@archiver.kernel.org>; Wed, 15 Sep 2021 23:11:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232868AbhIOXMZ (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 15 Sep 2021 19:12:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:37858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232910AbhIOXMW (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 15 Sep 2021 19:12:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9D4F9600D4;
        Wed, 15 Sep 2021 23:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631747462;
        bh=X3/1URINYi1Bgdx6m6WssJ+OfMhV335W0FxBoAH7pSg=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=b9hsdzcq5gB6qlSHRDxlqruGDD3U1nEmtTMsfqV8q0WH4jWXDnVJzQmwmd3B++gTG
         cj7JOnatYc9B1nUXFb76DNfk7vR/e86EbPmVm3ANhyFJe+wXGHGDeKjp4j/xBTk0B6
         zyki5leDdIk4kWTA84jKMd6m22gCr4xehbapiw+XFaQHG4HXxjh43/IOUEbO0t50Bb
         65s8IsCELDSg4j1pRlO7FAzqTR82q4RfXkzwuBxclbV4QD2wE52xBNgjMyn0ocvUsZ
         TqH02K98i9S31Xc9xOW38lXepAXcRt0bpbZxc62G6XFJJNQZ5IKs6d87tI/Jc897Q3
         FGAvbwPYXVXRA==
Subject: [PATCH 49/61] xfs: Fix default ASSERT in xfs_attr_set_iter
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Allison Henderson <allison.henderson@oracle.com>,
        Chandan Babu R <chandanrlinux@gmail.com>,
        linux-xfs@vger.kernel.org
Date:   Wed, 15 Sep 2021 16:11:02 -0700
Message-ID: <163174746237.350433.15993311695685928917.stgit@magnolia>
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

Source kernel commit: 4a4957c16dc674d1306a3b43d6b07ed93a7b7a14

This ASSERT checks for the state value of RM_SHRINK in the set path
which should never happen.  Change to ASSERT(0);

Suggested-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>
Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 libxfs/xfs_attr.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)


diff --git a/libxfs/xfs_attr.c b/libxfs/xfs_attr.c
index edc19de6..cbac7612 100644
--- a/libxfs/xfs_attr.c
+++ b/libxfs/xfs_attr.c
@@ -612,7 +612,7 @@ xfs_attr_set_iter(
 		error = xfs_attr_node_addname_clear_incomplete(dac);
 		break;
 	default:
-		ASSERT(dac->dela_state != XFS_DAS_RM_SHRINK);
+		ASSERT(0);
 		break;
 	}
 out:

