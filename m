Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12010C6FD19
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 19:22:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbjCPTWP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 15:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbjCPTWP (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 15:22:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7D856700B
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 12:21:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 404C5620C9
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 19:21:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C2BEC433EF;
        Thu, 16 Mar 2023 19:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678994505;
        bh=jfMjQUnEnf51E5lw9tUAAi14Fqk2akO4edQv/JZvmMI=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=UA9w6SAon20BTKhQCLfZJDBPR8UwxWtp0IsRhBCqwyKZjt/JkmpG3N9KpS+ndie6r
         DVNDzpEbIFKWBnPsR2rlRfm4AiwihLqzVduJaY0AfDyiq71bSbqwZmqxNoRfvv8xR9
         QormsOCCpUh02qhajbmNWbwm4Q1eL3W105KdskibwnTdSk7bZlhjZuvsCWW1vNDYbn
         +u5ZLS5OjKkghId99qEF1spH2XgSM5HQDHCmIzLba4e7qpfbTyNu46eDpLr3An1bje
         EPUWYveWHZv+6HAEbTQqMRW2N9kw/lsEucssCfzzBeEIqhAYALIIABI9+6V0T3bS4y
         +WzAPhsE9+gBw==
Date:   Thu, 16 Mar 2023 12:21:45 -0700
Subject: [PATCH 01/17] xfs: document the ri_total validation in
 xlog_recover_attri_commit_pass2
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167899414371.15363.10228100545681436326.stgit@frogsfrogsfrogs>
In-Reply-To: <167899414339.15363.12404998880107296432.stgit@frogsfrogsfrogs>
References: <167899414339.15363.12404998880107296432.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Leave comments explaining why log recovery wants the log item buffer
counts to be what they are.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_attr_item.c |    3 +++
 1 file changed, 3 insertions(+)


diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index da807f286a09..dac5d9cfc804 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -769,6 +769,7 @@ xlog_recover_attri_commit_pass2(
 	switch (op) {
 	case XFS_ATTRI_OP_FLAGS_SET:
 	case XFS_ATTRI_OP_FLAGS_REPLACE:
+		/* Log item, attr name, attr value */
 		if (item->ri_total != 3) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 					     attri_formatp, len);
@@ -776,6 +777,7 @@ xlog_recover_attri_commit_pass2(
 		}
 		break;
 	case XFS_ATTRI_OP_FLAGS_REMOVE:
+		/* Log item, attr name */
 		if (item->ri_total != 2) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 					     attri_formatp, len);
@@ -783,6 +785,7 @@ xlog_recover_attri_commit_pass2(
 		}
 		break;
 	case XFS_ATTRI_OP_FLAGS_NVREPLACE:
+		/* Log item, attr name, new attr name, attr value */
 		if (item->ri_total != 4) {
 			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
 					     attri_formatp, len);

