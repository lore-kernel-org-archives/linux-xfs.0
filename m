Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 960D3C7EE2E
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:08:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbjEZCHf (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:07:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230091AbjEZCHF (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:07:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B160E7
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:07:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C35964C49
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:07:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFDA1C433D2;
        Fri, 26 May 2023 02:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685066823;
        bh=6JW+e2bS8Gt6nRuVPzcFsf33D45O2z/WNWI0Q+hBPco=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=fXruE3WWQa2D9G5HBOs+BGfubM1Z6pZxnPawlpwxXo0eFh5rxphQTbw4W5IJfIWot
         6e0VWERkyoDOrSJvXSgdniGRu/MaM0Uhx22JlgDqIGZ/BtcEYGq4Jkz/gmeEqmBSfd
         KJjk9odzuN58lCki6w2vhJM0xlHa3gZcDjXgpsTyK5OTpU1VwRWZpMYfcPt245pMaG
         QMPYU2/2X4V/k5wae/N6Uk921O/9s/GebTppk8GYyp67XfdxtKSQvssZaj6SCylawV
         HeSWrh2+hXWm1CFCM0Zc2SbNfMH+zMl0iGZNnVXd4W1ptl8PETnrwA6VaOm3CPGwHa
         tmpCjVKB4+lSg==
Date:   Thu, 25 May 2023 19:07:02 -0700
Subject: [PATCH 01/12] xfs: check opcode and iovec count match in
 xlog_recover_attri_commit_pass2
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506072196.3743652.12252845506159015907.stgit@frogsfrogsfrogs>
In-Reply-To: <168506072168.3743652.12378764451724622618.stgit@frogsfrogsfrogs>
References: <168506072168.3743652.12378764451724622618.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Check that the number of recovered log iovecs is what is expected for
the xattri opcode is expecting.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_attr_item.c |   27 +++++++++++++++++++++++++++
 1 file changed, 27 insertions(+)


diff --git a/fs/xfs/xfs_attr_item.c b/fs/xfs/xfs_attr_item.c
index 0891d739666e..35d67bf38186 100644
--- a/fs/xfs/xfs_attr_item.c
+++ b/fs/xfs/xfs_attr_item.c
@@ -711,6 +711,7 @@ xlog_recover_attri_commit_pass2(
 	const void			*attr_value = NULL;
 	const void			*attr_name;
 	size_t				len;
+	unsigned int			op;
 
 	attri_formatp = item->ri_buf[0].i_addr;
 	attr_name = item->ri_buf[1].i_addr;
@@ -729,6 +730,32 @@ xlog_recover_attri_commit_pass2(
 		return -EFSCORRUPTED;
 	}
 
+	/* Check the number of log iovecs makes sense for the op code. */
+	op = attri_formatp->alfi_op_flags & XFS_ATTRI_OP_FLAGS_TYPE_MASK;
+	switch (op) {
+	case XFS_ATTRI_OP_FLAGS_SET:
+	case XFS_ATTRI_OP_FLAGS_REPLACE:
+		/* Log item, attr name, attr value */
+		if (item->ri_total != 3) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					     attri_formatp, len);
+			return -EFSCORRUPTED;
+		}
+		break;
+	case XFS_ATTRI_OP_FLAGS_REMOVE:
+		/* Log item, attr name */
+		if (item->ri_total != 2) {
+			XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+					     attri_formatp, len);
+			return -EFSCORRUPTED;
+		}
+		break;
+	default:
+		XFS_CORRUPTION_ERROR(__func__, XFS_ERRLEVEL_LOW, mp,
+				     attri_formatp, len);
+		return -EFSCORRUPTED;
+	}
+
 	/* Validate the attr name */
 	if (item->ri_buf[1].i_len !=
 			xlog_calc_iovec_len(attri_formatp->alfi_name_len)) {

