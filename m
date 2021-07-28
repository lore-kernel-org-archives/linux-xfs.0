Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77BDBC4338F
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 21:15:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 575A96103B
	for <linux-xfs@archiver.kernel.org>; Wed, 28 Jul 2021 21:15:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231488AbhG1VPu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 28 Jul 2021 17:15:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:34022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231521AbhG1VPu (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 28 Jul 2021 17:15:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4836B6101C;
        Wed, 28 Jul 2021 21:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627506948;
        bh=qy93MdK69eo2n95xE3CK7Kc0I2KEXFw95dmxhgWRROk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Fg5n8sG1JNcZD52JtSI6bI5Qno20ALOZwHh9JFxoPpl7QueAnbl7ZQpE1JIKVMrap
         uuURU8JyKgv9JOPNotEp67UxeWQWnIO5dN4j1o1hz72VVJfpfjma/nsfRIW+hwZOvH
         gXP7QrpgisrclcEt1zE0FNFQfArClR96t+HsqW/2IfC2CweyLJUd7c6fe3mRTjOZoD
         UXKdSO2eGCpQviYJyzQcDTsJYZIeJBEpNTNuST7Z2MntBcfN+aj4mkFjNcR5tY2JEw
         bVkY48HtEGLlNHIAyNt3OiTACMipaSr03vPc0FaJqa7mhRu2E4qqip+Xq+ddh9DOrN
         ISgZjJciUsSFQ==
Subject: [PATCH 1/2] xfs_repair: validate alignment of inherited rt extent
 hints
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com, hch@infradead.org
Date:   Wed, 28 Jul 2021 14:15:48 -0700
Message-ID: <162750694801.44422.7638736426191840754.stgit@magnolia>
In-Reply-To: <162750694254.44422.4804944030019836862.stgit@magnolia>
References: <162750694254.44422.4804944030019836862.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

If we encounter a directory that has been configured to pass on an
extent size hint to a new realtime file and the hint isn't an integer
multiple of the rt extent size, we should turn off the hint because that
is a misconfiguration.  Old kernels didn't check for this when copying
attributes into new files and would crash in the rt allocator.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 repair/dinode.c |   71 ++++++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 51 insertions(+), 20 deletions(-)


diff --git a/repair/dinode.c b/repair/dinode.c
index 291c5807..09e42ad2 100644
--- a/repair/dinode.c
+++ b/repair/dinode.c
@@ -2179,6 +2179,56 @@ _("Bad %s nsec %u on inode %" PRIu64 ", "), name, be32_to_cpu(t->t_nsec), lino);
 	}
 }
 
+static void
+validate_extsize(
+	struct xfs_mount	*mp,
+	struct xfs_dinode	*dino,
+	xfs_ino_t		lino,
+	int			*dirty)
+{
+	uint16_t		flags = be16_to_cpu(dino->di_flags);
+	unsigned int		value = be32_to_cpu(dino->di_extsize);
+	bool			misaligned = false;
+	bool			bad;
+
+	/*
+	 * XFS allows a sysadmin to change the rt extent size when adding a rt
+	 * section to a filesystem after formatting.  If there are any
+	 * directories with extszinherit and rtinherit set, the hint could
+	 * become misaligned with the new rextsize.  The verifier doesn't check
+	 * this, because we allow rtinherit directories even without an rt
+	 * device.
+	 */
+	if ((flags & XFS_DIFLAG_EXTSZINHERIT) &&
+	    (flags & XFS_DIFLAG_RTINHERIT) &&
+	    value % mp->m_sb.sb_rextsize > 0)
+		misaligned = true;
+
+	/*
+	 * Complain if the verifier fails.
+	 *
+	 * Old kernels didn't check the alignment of extsize hints when copying
+	 * them to new regular realtime files.  The inode verifier now checks
+	 * the alignment (because misaligned hints cause misbehavior in the rt
+	 * allocator), so we have to complain and fix them.
+	 */
+	bad = libxfs_inode_validate_extsize(mp, value,
+			be16_to_cpu(dino->di_mode), flags) != NULL;
+	if (bad || misaligned) {
+		do_warn(
+_("Bad extent size %u on inode %" PRIu64 ", "),
+				value, lino);
+		if (!no_modify)  {
+			do_warn(_("resetting to zero\n"));
+			dino->di_extsize = 0;
+			dino->di_flags &= ~cpu_to_be16(XFS_DIFLAG_EXTSIZE |
+						       XFS_DIFLAG_EXTSZINHERIT);
+			*dirty = 1;
+		} else
+			do_warn(_("would reset to zero\n"));
+	}
+}
+
 /*
  * returns 0 if the inode is ok, 1 if the inode is corrupt
  * check_dups can be set to 1 *only* when called by the
@@ -2690,26 +2740,7 @@ _("bad (negative) size %" PRId64 " on inode %" PRIu64 "\n"),
 	if (process_check_sb_inodes(mp, dino, lino, &type, dirty) != 0)
 		goto clear_bad_out;
 
-	/*
-	 * only regular files with REALTIME or EXTSIZE flags set can have
-	 * extsize set, or directories with EXTSZINHERIT.
-	 */
-	if (libxfs_inode_validate_extsize(mp,
-			be32_to_cpu(dino->di_extsize),
-			be16_to_cpu(dino->di_mode),
-			be16_to_cpu(dino->di_flags)) != NULL) {
-		do_warn(
-_("Bad extent size %u on inode %" PRIu64 ", "),
-				be32_to_cpu(dino->di_extsize), lino);
-		if (!no_modify)  {
-			do_warn(_("resetting to zero\n"));
-			dino->di_extsize = 0;
-			dino->di_flags &= ~cpu_to_be16(XFS_DIFLAG_EXTSIZE |
-						       XFS_DIFLAG_EXTSZINHERIT);
-			*dirty = 1;
-		} else
-			do_warn(_("would reset to zero\n"));
-	}
+	validate_extsize(mp, dino, lino, dirty);
 
 	/*
 	 * Only (regular files and directories) with COWEXTSIZE flags

