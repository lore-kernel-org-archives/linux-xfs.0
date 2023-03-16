Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F845C6FD1F
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Mar 2023 19:32:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229826AbjCPTcp (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Mar 2023 15:32:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230167AbjCPTco (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Mar 2023 15:32:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 724EEDCA56
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 12:32:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 07C1A620FD
        for <linux-xfs@vger.kernel.org>; Thu, 16 Mar 2023 19:32:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61C21C433D2;
        Thu, 16 Mar 2023 19:32:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678995160;
        bh=PPFpq2UuGqY65EWq2TO4ayWCGW1uu3jd9gUCGmqCH1U=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=lsc/ReRW06Epq1WhfMv/Mdcic5PRvoJKuQAUkTT9yG5TKri3P/2cUpnR3IHiY7ao8
         L6Cy8aZBZY0fI3qar+VVkkFJVwTKBrtwP4C8HOOjW7vBwKtXiuw0ytcOQRm14LBPTD
         MEYpW+ZlcR+rKgThJGxnRQvt6ft9khuEp2EUajDEh755cP46Ov4DdJF8M1IQhc2lZ+
         642FeKLeiarr/LmPySj0anUHGqUAdKLKTh6ljDuXoVotXtlBegiYlXR95S8GmgnfYP
         7xZstswAbgwQvzqwsp//sot5S3RYtIvaX5vCyLGtxGwgMQPXu02N/srJenQ0PyeASp
         MVDw/tpzTnNAQ==
Date:   Thu, 16 Mar 2023 12:32:40 -0700
Subject: [PATCH 3/4] xfs: make logprint note attr names and newnames
 consistently
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167899416832.17000.18438320386846754812.stgit@frogsfrogsfrogs>
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

Fix logprint to print "ATTRI: name" and "ATTRI: newname" consistently.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 logprint/log_redo.c |   15 +++++++++------
 logprint/logprint.h |    2 +-
 2 files changed, 10 insertions(+), 7 deletions(-)


diff --git a/logprint/log_redo.c b/logprint/log_redo.c
index a90abc2d8..f0d64ae9f 100644
--- a/logprint/log_redo.c
+++ b/logprint/log_redo.c
@@ -720,7 +720,8 @@ xlog_print_trans_attri(
 		(*i)++;
 		head = (xlog_op_header_t *)*ptr;
 		xlog_print_op_header(head, *i, ptr);
-		error = xlog_print_trans_attri_name(ptr, be32_to_cpu(head->oh_len));
+		error = xlog_print_trans_attri_name(ptr,
+				be32_to_cpu(head->oh_len), "name");
 		if (error)
 			goto error;
 	}
@@ -730,7 +731,8 @@ xlog_print_trans_attri(
 		(*i)++;
 		head = (xlog_op_header_t *)*ptr;
 		xlog_print_op_header(head, *i, ptr);
-		error = xlog_print_trans_attri_name(ptr, be32_to_cpu(head->oh_len));
+		error = xlog_print_trans_attri_name(ptr,
+				be32_to_cpu(head->oh_len), "newname");
 		if (error)
 			goto error;
 	}
@@ -752,15 +754,16 @@ xlog_print_trans_attri(
 int
 xlog_print_trans_attri_name(
 	char				**ptr,
-	uint				src_len)
+	uint				src_len,
+	const char			*tag)
 {
-	printf(_("ATTRI:  name len:%u\n"), src_len);
+	printf(_("ATTRI:  %s len:%u\n"), tag, src_len);
 	print_or_dump(*ptr, src_len);
 
 	*ptr += src_len;
 
 	return 0;
-}	/* xlog_print_trans_attri */
+}
 
 int
 xlog_print_trans_attri_value(
@@ -823,7 +826,7 @@ xlog_recover_print_attri(
 
 	if (f->alfi_nname_len > 0) {
 		region++;
-		printf(_("ATTRI:  nname len:%u\n"), f->alfi_nname_len);
+		printf(_("ATTRI:  newname len:%u\n"), f->alfi_nname_len);
 		print_or_dump((char *)item->ri_buf[region].i_addr,
 			       f->alfi_nname_len);
 	}
diff --git a/logprint/logprint.h b/logprint/logprint.h
index b4479c240..067226ffb 100644
--- a/logprint/logprint.h
+++ b/logprint/logprint.h
@@ -59,7 +59,7 @@ extern void xlog_recover_print_bud(struct xlog_recover_item *item);
 #define MAX_ATTR_VAL_PRINT	128
 
 extern int xlog_print_trans_attri(char **ptr, uint src_len, int *i);
-extern int xlog_print_trans_attri_name(char **ptr, uint src_len);
+extern int xlog_print_trans_attri_name(char **ptr, uint src_len, const char *tag);
 extern int xlog_print_trans_attri_value(char **ptr, uint src_len, int value_len);
 extern void xlog_recover_print_attri(struct xlog_recover_item *item);
 extern int xlog_print_trans_attrd(char **ptr, uint len);

