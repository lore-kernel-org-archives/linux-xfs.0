Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10971C7EE2F
	for <linux-xfs@archiver.kernel.org>; Fri, 26 May 2023 02:22:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235273AbjEZCWB (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 25 May 2023 22:22:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234501AbjEZCV4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 25 May 2023 22:21:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85C90F7
        for <linux-xfs@vger.kernel.org>; Thu, 25 May 2023 19:21:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06B2664C49
        for <linux-xfs@vger.kernel.org>; Fri, 26 May 2023 02:21:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 675A8C433D2;
        Fri, 26 May 2023 02:21:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685067711;
        bh=Q8Raf/qaui75K0YXpRdV+CyGxv1OvElKBNrmPljuyqY=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=u3xcKW5yYL594K3PnaQQonqi8IrXlXEGxbsDsvnx0BQcSaI3/95ZVe8tX9Muo2dKg
         ZiqHHw41nk3wxGuBHm2z0R1jVGXRZrcQ4x2wKZtDkTnr+N9XHwv7NEctgIitIE9OVt
         jWTBuS50QKk2qBO5rHpNpcPK5l/FdOKI+TDOXhkyx+xckOQpduJSxGbPY7KjHBFL5C
         /UrZ2n0GfKwyqO5iTNw/2ywdFFyu23AbFi11u9flen0h95JsK3imsz6tBCSOKAHr5L
         0URhP5lTKZniKsGeJzTVX0rzAmPuptLssFhKgUvr3io9M11t3eJiWfw3cMrEEN+PL8
         VCuIwwzUaUErw==
Date:   Thu, 25 May 2023 19:21:51 -0700
Subject: [PATCH 10/10] xfs_logprint: print missing attri header fields
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org, cem@kernel.org
Cc:     linux-xfs@vger.kernel.org, allison.henderson@oracle.com,
        catherine.hoang@oracle.com
Message-ID: <168506077570.3749126.10426446233502380332.stgit@frogsfrogsfrogs>
In-Reply-To: <168506077431.3749126.3177791326683307311.stgit@frogsfrogsfrogs>
References: <168506077431.3749126.3177791326683307311.stgit@frogsfrogsfrogs>
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
 logprint/log_redo.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)


diff --git a/logprint/log_redo.c b/logprint/log_redo.c
index 7531c6117bd..e6401bb293e 100644
--- a/logprint/log_redo.c
+++ b/logprint/log_redo.c
@@ -725,8 +725,11 @@ xlog_print_trans_attri(
 		value_len     = src_f->alfi_value_len;
 	}
 
-	printf(_("ATTRI:  #regs: %d	name_len: %u, new_name_len: %u, value_len: %u, new_value_len: %u  id: 0x%llx\n"),
+	printf(_("ATTRI:  #regs: %d	f: 0x%x, ino: 0x%llx, attr_filter: 0x%x, name_len: %u, new_name_len: %u, value_len: %u, new_value_len: %u  id: 0x%llx\n"),
 			src_f->alfi_size,
+			src_f->alfi_op_flags,
+			(unsigned long long)src_f->alfi_ino,
+			src_f->alfi_attr_filter,
 			name_len,
 			new_name_len,
 			value_len,
@@ -853,8 +856,11 @@ xlog_recover_print_attri(
 		value_len     = f->alfi_value_len;
 	}
 
-	printf(_("ATTRI:  #regs: %d	name_len: %u, new_name_len: %u, value_len: %d, new_value_len: %u  id: 0x%llx\n"),
+	printf(_("ATTRI:  #regs: %d	f: 0x%x, ino: 0x%llx, attr_filter: 0x%x, name_len: %u, new_name_len: %u, value_len: %u, new_value_len: %u  id: 0x%llx\n"),
 			f->alfi_size,
+			f->alfi_op_flags,
+			(unsigned long long)f->alfi_ino,
+			f->alfi_attr_filter,
 			name_len,
 			new_name_len,
 			value_len,

