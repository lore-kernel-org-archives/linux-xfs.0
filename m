Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE690C6FD1F
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 19:32:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbjCPTch (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 15:32:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbjCPTch (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 15:32:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69E62E5012
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 12:32:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16E1CB82282
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 19:32:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA597C433EF;
        Thu, 16 Mar 2023 19:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678995144;
        bh=mlTRfPKMHv/Zsb/KsydfPf27LtQyM8AFNP3ijxLHc7U=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=hV7XMIGeiIUmdNB1s31xaQh8IHxZ5BJ6apNgXD+51+3fXNSX4Vp4KYGv2aWB0SQ74
         v8lUluDuRN54qjwL260VJpAlC2zzjlz45CP2WLVX+Bbd53IvsjSwt7CY+opVJLZIxc
         0Yj9ay3EPxzpGImeUPXQFdIWy6VVJgLb9lYQ51EdS+EMduqGqlZYFhT9zSG6Arm2BX
         UVSoP3gk217W1QBGxRhIF1pc1lv7LK4GmuKZTk2RY+RCzhhczaPS86gw5aoaJP/9bA
         xFz7pG5uI7JTajUgjt36eUFcC1f5DRqk4r9JlAe6Ji8KgLwvZn+GbQjTobfDngQV/P
         iImNYbXw1IHHw==
Date:   Thu, 16 Mar 2023 12:32:24 -0700
Subject: [PATCH 2/4] xfs_logprint: print missing attri header fields
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167899416819.17000.15788664674920600947.stgit@frogsfrogsfrogs>
In-Reply-To: <167899416793.17000.8105050564560343480.stgit@frogsfrogsfrogs>
References: <167899416793.17000.8105050564560343480.stgit@frogsfrogsfrogs>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Not sure why logprint doesn't print the op flags, inode, or attr filter
fields.  Make it do that.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 logprint/log_redo.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)


diff --git a/logprint/log_redo.c b/logprint/log_redo.c
index b596af02c..a90abc2d8 100644
--- a/logprint/log_redo.c
+++ b/logprint/log_redo.c
@@ -705,9 +705,15 @@ xlog_print_trans_attri(
 	memmove((char*)src_f, *ptr, src_len);
 	*ptr += src_len;
 
-	printf(_("ATTRI:  #regs: %d	name_len: %d, nname_len: %d value_len: %d  id: 0x%llx\n"),
-		src_f->alfi_size, src_f->alfi_name_len, src_f->alfi_nname_len,
-		src_f->alfi_value_len, (unsigned long long)src_f->alfi_id);
+	printf(_("ATTRI:  #regs: %d	f: 0x%x, ino: 0x%llx, attr_filter: 0x%x, name_len: %d, newname_len: %d, value_len: %d  id: 0x%llx\n"),
+			src_f->alfi_size,
+			src_f->alfi_op_flags,
+			(unsigned long long)src_f->alfi_ino,
+			src_f->alfi_attr_filter,
+			src_f->alfi_name_len,
+			src_f->alfi_nname_len,
+			src_f->alfi_value_len,
+			(unsigned long long)src_f->alfi_id);
 
 	if (src_f->alfi_name_len > 0) {
 		printf(_("\n"));
@@ -798,8 +804,15 @@ xlog_recover_print_attri(
 	if (xfs_attri_copy_log_format((char*)src_f, src_len, f))
 		goto out;
 
-	printf(_("ATTRI:  #regs: %d	name_len: %d, nname_len:%d, value_len: %d  id: 0x%llx\n"),
-		f->alfi_size, f->alfi_name_len, f->alfi_nname_len, f->alfi_value_len, (unsigned long long)f->alfi_id);
+	printf(_("ATTRI:  #regs: %d	f: 0x%x, ino: 0x%llx, attr_filter: 0x%x, name_len: %d, newname_len:%d, value_len: %d  id: 0x%llx\n"),
+			f->alfi_size,
+			f->alfi_op_flags,
+			(unsigned long long)f->alfi_ino,
+			f->alfi_attr_filter,
+			f->alfi_name_len,
+			f->alfi_nname_len,
+			f->alfi_value_len,
+			(unsigned long long)f->alfi_id);
 
 	if (f->alfi_name_len > 0) {
 		region++;

