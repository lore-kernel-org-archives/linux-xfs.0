Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AEF1C77B6C
	for <linux-xfs@archiver.kernel.org>; Thu,  6 Apr 2023 19:31:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbjDFTbj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 6 Apr 2023 15:31:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbjDFTbg (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 6 Apr 2023 15:31:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AC2E40DC
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 12:31:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD5FF64B8E
        for <linux-xfs@vger.kernel.org>; Thu,  6 Apr 2023 19:31:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 255B4C4339E;
        Thu,  6 Apr 2023 19:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680809495;
        bh=Iv+KQltjEHRuGprrtcSi6sRNHtwO84ehNXxozH3HKkQ=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=giP709UxXBVVeRpisICjAo4guJzonj0TQdGKlFzUkgwJtpuc6PyBctYlU41FabOhp
         muQwMMOPMUIx1+mDbIHrUD8z/Rd0wYd4+4nL+AYcUq+mL9t8PuvHLzUvNFx/gAvmmR
         SsTnnRyHDwQ3kmo4gx2mkzAvWijMbILc57KrrIcDCgcYRGk10fzS9a9R0QKF833ZTH
         LfjEf0yGd8WWHPXHu/6SbUn7/MAnJCqghroxiwuQ+rBB7N32pV4meVUYXCuz/hxSWa
         AfMpxuky4PrKPVh66JVKUi0wIvNqK44r9bbMFEWxTAJdRnuqvuTtRqiIvzl0RhKLXv
         t4j6qSnjJTL6w==
Date:   Thu, 06 Apr 2023 12:31:34 -0700
Subject: [PATCH 10/10] xfs_logprint: print missing attri header fields
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <168080827246.616519.15352617723076593191.stgit@frogsfrogsfrogs>
In-Reply-To: <168080827114.616519.13224581752144055912.stgit@frogsfrogsfrogs>
References: <168080827114.616519.13224581752144055912.stgit@frogsfrogsfrogs>
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
index 2eaf58918..8b6aa9279 100644
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

