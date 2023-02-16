Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0BEFC636D6
	for <linux-xfs@archiver.kernel.org>; Thu, 16 Feb 2023 21:11:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbjBPVLt (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 16 Feb 2023 16:11:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbjBPVLt (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 16 Feb 2023 16:11:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C1805383D
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 13:11:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1863460C73
        for <linux-xfs@vger.kernel.org>; Thu, 16 Feb 2023 21:11:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E016C433D2;
        Thu, 16 Feb 2023 21:11:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676581874;
        bh=Gzgi/nYDbaEn+cSBuxfdKESxJ0kOKQIugdNrvcgbwTM=;
        h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
        b=IEyudqnRYuhB4x7NhMn/hP0NqvMkvWZ5KAOovRhZxVvSeoqsgp8mLOvt90or5sOeW
         ZQqIW4YnqcB1tK3K4qqfZQQQH+vFKNIwCotUXc160Yu+xJCHKMdb3NPP9piTzK4QQ3
         57RNt2hVhLjKDZqpwMtczBTbrwbM9Wf+oekjAglug2kSbexhaCMPxBgJ8LX33/SC8I
         IuWqkHvy51a2VhW+Jw06sn7CWPORJrM+koBps9xmFbgWcuwB8KkjuHSskFup8X6FNu
         RciguNBCl6B0Ys0j2RCmuvqribBQ1MMFJorDoXudaRbBHaIgd+6G3dGbto3/UjzWJc
         gvmhqeW+zm30Q==
Date:   Thu, 16 Feb 2023 13:11:14 -0800
Subject: [PATCH 3/6] xfs_logprint: decode parent pointers fully
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     allison.henderson@oracle.com, linux-xfs@vger.kernel.org
Message-ID: <167657882413.3478037.6487639311016256013.stgit@magnolia>
In-Reply-To: <167657882371.3478037.12485693506644718323.stgit@magnolia>
References: <167657882371.3478037.12485693506644718323.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Decode logged parent pointers fully when dumping log contents.  Between
the existing ATTRI: printouts and the new ones introduced here, we can
figure out what was stored in each log iovec, as well as the higher
level parent pointer that was logged.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 logprint/log_redo.c |   63 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 63 insertions(+)


diff --git a/logprint/log_redo.c b/logprint/log_redo.c
index 1ac0536a..ca6b2641 100644
--- a/logprint/log_redo.c
+++ b/logprint/log_redo.c
@@ -699,6 +699,24 @@ xfs_attri_copy_name_format(
 	return 1;
 }
 
+static void
+dump_pptr(
+	const char			*tag,
+	const void			*name,
+	unsigned int			namelen,
+	const void			*value,
+	unsigned int			valuelen)
+{
+	struct xfs_parent_name_irec	irec;
+
+	libxfs_parent_irec_from_disk(&irec, name, value, valuelen);
+
+	printf("PPTR: %s attr_namelen %u value_namelen %u\n", tag, namelen, valuelen);
+	printf("PPTR: %s parent_ino %llu parent_gen %u namelen %u name '%.*s'\n",
+			tag, (unsigned long long)irec.p_ino, irec.p_gen,
+			irec.p_namelen, irec.p_namelen, irec.p_name);
+}
+
 int
 xlog_print_trans_attri(
 	char				**ptr,
@@ -707,6 +725,9 @@ xlog_print_trans_attri(
 {
 	struct xfs_attri_log_format	*src_f = NULL;
 	xlog_op_header_t		*head = NULL;
+	void				*name_ptr = NULL, *nname_ptr = NULL;
+	void				*value_ptr = (void *)1;
+	int				name_len = 0, nname_len = 0, value_len = 0;
 	uint				dst_len;
 	int				error = 0;
 
@@ -739,6 +760,8 @@ xlog_print_trans_attri(
 		(*i)++;
 		head = (xlog_op_header_t *)*ptr;
 		xlog_print_op_header(head, *i, ptr);
+		name_ptr = *ptr;
+		name_len = src_f->alfi_name_len;
 		error = xlog_print_trans_attri_name(ptr, be32_to_cpu(head->oh_len),
 						    src_f->alfi_attr_filter);
 		if (error)
@@ -750,6 +773,8 @@ xlog_print_trans_attri(
 		(*i)++;
 		head = (xlog_op_header_t *)*ptr;
 		xlog_print_op_header(head, *i, ptr);
+		nname_ptr = *ptr;
+		nname_len = src_f->alfi_nname_len;
 		error = xlog_print_trans_attri_name(ptr, be32_to_cpu(head->oh_len),
 						    src_f->alfi_attr_filter);
 		if (error)
@@ -761,9 +786,23 @@ xlog_print_trans_attri(
 		(*i)++;
 		head = (xlog_op_header_t *)*ptr;
 		xlog_print_op_header(head, *i, ptr);
+		value_ptr = *ptr;
+		value_len = src_f->alfi_value_len;
 		error = xlog_print_trans_attri_value(ptr, be32_to_cpu(head->oh_len),
 				src_f->alfi_value_len, src_f->alfi_attr_filter);
 	}
+
+	if (src_f->alfi_attr_filter & XFS_ATTR_PARENT) {
+		if (nname_ptr && name_ptr) {
+			dump_pptr("OLDNAME", name_ptr, name_len, (void *)1, 0);
+			dump_pptr("NEWNAME", nname_ptr, nname_len, value_ptr, value_len);
+			name_ptr = nname_ptr = NULL;
+		}
+		if (name_ptr)
+			dump_pptr("NAME", name_ptr, name_len, value_ptr, value_len);
+		if (nname_ptr)
+			dump_pptr("NNAME", nname_ptr, nname_len, (void *)1, 0);
+	}
 error:
 	free(src_f);
 
@@ -853,6 +892,9 @@ xlog_recover_print_attri(
 {
 	struct xfs_attri_log_format	*f, *src_f = NULL;
 	uint				src_len, dst_len;
+	void				*name_ptr = NULL, *nname_ptr = NULL;
+	void				*value_ptr = (void *)1;
+	int				name_len = 0, nname_len = 0, value_len = 0;
 
 	struct xfs_parent_name_rec 	*rec, *src_rec = NULL;
 	char				*value, *src_value = NULL;
@@ -897,6 +939,9 @@ xlog_recover_print_attri(
 				goto out;
 			}
 
+			name_ptr = src_rec;
+			name_len = src_len;
+
 			printf(_("ATTRI:  #inode: %llu     gen: %u\n"),
 				be64_to_cpu(rec->p_ino), be32_to_cpu(rec->p_gen));
 
@@ -927,6 +972,9 @@ xlog_recover_print_attri(
 				goto out;
 			}
 
+			nname_ptr = src_rec;
+			nname_len = src_len;
+
 			printf(_("ATTRI:  new #inode: %llu     gen: %u\n"),
 				be64_to_cpu(rec->p_ino), be32_to_cpu(rec->p_gen));
 
@@ -951,6 +999,9 @@ xlog_recover_print_attri(
 				exit(1);
 			}
 
+			value_ptr = src_value;
+			value_len = f->alfi_value_len;
+
 			memcpy((char *)value, (char *)src_value, f->alfi_value_len);
 			printf("ATTRI:  value: %.*s\n", f->alfi_value_len, value);
 
@@ -968,6 +1019,18 @@ xlog_recover_print_attri(
 		}
 	}
 
+	if (src_f->alfi_attr_filter & XFS_ATTR_PARENT) {
+		if (nname_ptr && name_ptr) {
+			dump_pptr("OLDNAME", name_ptr, name_len, (void *)1, 0);
+			dump_pptr("NEWNAME", nname_ptr, nname_len, value_ptr, value_len);
+			name_ptr = nname_ptr = NULL;
+		}
+		if (name_ptr)
+			dump_pptr("NAME", name_ptr, name_len, value_ptr, value_len);
+		if (nname_ptr)
+			dump_pptr("NNAME", nname_ptr, nname_len, (void *)1, 0);
+	}
+
 out:
 	free(f);
 

