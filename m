Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41481C433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Feb 2021 23:00:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EB7E764E4D
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Feb 2021 23:00:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbhBKXA2 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Feb 2021 18:00:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:46060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229946AbhBKXAZ (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Feb 2021 18:00:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0F6A664E44;
        Thu, 11 Feb 2021 22:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613084376;
        bh=E+nr4GUSFhrROrwtzLXtQkq0fOas518cxwYs4EPNyX8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=YMtMfYBIBh2NZxoDio4s5NfzjZMx2vMjfzF8dlBtvvUUKtjWYRwrWGk1q+fsxFwlm
         u/2NZuxbiZ4CAS+aMl0TCs3Sio6dLxUb5qDMMdWoTe7821PMFuVkSTAFkyUPHS9J1j
         lPhB1Q2kOeT7E8pIAtcwsO2ZcGAj1zMfYhuGZ4h4s7pFCK8d0l3kUFpWbwHhb9UG74
         3WwtfC4uw1n9j7SK8XH+wMyfQC2aCViNKbSmP32jKL1K70GnhGXgB1KKbB5nJomxtx
         CTxgAAQyTe8/os2R9vghG81gZgHnhHORIwxwH34fEXAVbzrqsUUkmpnWiavPztDXbL
         vvdBkTOKOXqnQ==
Subject: [PATCH 06/11] xfs_repair: clear quota CHKD flags on the incore
 superblock too
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Thu, 11 Feb 2021 14:59:35 -0800
Message-ID: <161308437536.3850286.2827497981728883408.stgit@magnolia>
In-Reply-To: <161308434132.3850286.13801623440532587184.stgit@magnolia>
References: <161308434132.3850286.13801623440532587184.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

At the end of a repair run, xfs_repair clears the superblock's quota
checked flags if it found mistakes in the quota accounting to force a
quotacheck at the next mount.  This is currently the last time repair
modifies the primary superblock, so it is sufficient to update the
ondisk buffer and not the incore mount structure.

However, we're about to introduce code to clear the needsrepair feature
at the very end of repair, after all metadata blocks have been written
to disk and all disk caches flush.  Since the convention everywhere else
in xfs is to update the incore superblock, call libxfs_sb_to_disk to
translate that into the ondisk buffer, and then write the buffer to
disk, switch the quota CHKD code to use this mechanism too.

(Get rid of dsb too, since the incore super should be in sync with the
ondisk super.)

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 repair/xfs_repair.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)


diff --git a/repair/xfs_repair.c b/repair/xfs_repair.c
index 9409f0d8..40352458 100644
--- a/repair/xfs_repair.c
+++ b/repair/xfs_repair.c
@@ -717,7 +717,6 @@ main(int argc, char **argv)
 {
 	xfs_mount_t	*temp_mp;
 	xfs_mount_t	*mp;
-	xfs_dsb_t	*dsb;
 	struct xfs_buf	*sbp;
 	xfs_mount_t	xfs_m;
 	struct xlog	log = {0};
@@ -1103,22 +1102,19 @@ _("Warning:  project quota information would be cleared.\n"
 	if (!sbp)
 		do_error(_("couldn't get superblock\n"));
 
-	dsb = sbp->b_addr;
-
 	if ((mp->m_sb.sb_qflags & XFS_ALL_QUOTA_CHKD) != quotacheck_results()) {
 		do_warn(_("Note - quota info will be regenerated on next "
 			"quota mount.\n"));
-		dsb->sb_qflags &= cpu_to_be16(~(XFS_UQUOTA_CHKD |
-						XFS_GQUOTA_CHKD |
-						XFS_PQUOTA_CHKD |
-						XFS_OQUOTA_CHKD));
+		mp->m_sb.sb_qflags &= ~(XFS_UQUOTA_CHKD | XFS_GQUOTA_CHKD |
+					XFS_PQUOTA_CHKD | XFS_OQUOTA_CHKD);
+		libxfs_sb_to_disk(sbp->b_addr, &mp->m_sb);
 	}
 
 	if (copied_sunit) {
 		do_warn(
 _("Note - stripe unit (%d) and width (%d) were copied from a backup superblock.\n"
   "Please reset with mount -o sunit=<value>,swidth=<value> if necessary\n"),
-			be32_to_cpu(dsb->sb_unit), be32_to_cpu(dsb->sb_width));
+			mp->m_sb.sb_unit, mp->m_sb.sb_width);
 	}
 
 	libxfs_buf_mark_dirty(sbp);

