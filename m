Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A2A4C433E9
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 19:41:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34EE064F4D
	for <linux-xfs@archiver.kernel.org>; Tue,  2 Feb 2021 19:41:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232740AbhBBTkj (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 2 Feb 2021 14:40:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:52518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238455AbhBBTk2 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 2 Feb 2021 14:40:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 324F264E08;
        Tue,  2 Feb 2021 19:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612294786;
        bh=/JgFLIMu9HP9DJJQ/5lbw4wJG2ANWcRUcTjCut8fgTE=;
        h=Date:From:To:Cc:Subject:From;
        b=OzEceWpSi6J2/XXz+Uo2v7XJ7VNld0XoZvqfJOXo8xRVD/eFEr/V6blUux667pwse
         mp3lA1sTm9NDWF9DxgtwlYoU4VLFyyvxtqn7LITYr0jOt0JeWF39pSJu5e7YC2TnfQ
         8dW3T9ONGqd5Mmwua8EtuUsYBnBDOhvArUrVT40I3KG6NufXFuTGZklkqEKB06mTjX
         7MgGtJvCTb0EtmZBhTnjZkiq8IigXgYzQxp2wYV3rTbT02ftsHXwwU2DoyWpbJopkQ
         kUk0d6W+j8pV4IWq441Akze+Yw9QGmuNXMlgqJDtEcGMH4GZs0towf0D7PbbJOyrDn
         wOWq8997/mwHw==
Date:   Tue, 2 Feb 2021 11:39:45 -0800
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     xfs <linux-xfs@vger.kernel.org>
Cc:     Brian Foster <bfoster@redhat.com>,
        Christoph Hellwig <hch@infradead.org>, chandanrlinux@gmail.com
Subject: [PATCH] xfs: fix incorrect root dquot corruption error when
 switching group/project quota types
Message-ID: <20210202193945.GP7193@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

While writing up a regression test for broken behavior when a chprojid
request fails, I noticed that we were logging corruption notices about
the root dquot of the group/project quota file at mount time when
testing V4 filesystems.

In commit afeda6000b0c, I was trying to improve ondisk dquot validation
by making sure that when we load an ondisk dquot into memory on behalf
of an incore dquot, the dquot id and type matches.  Unfortunately, I
forgot that V4 filesystems only have two quota files, and can switch
that file between group and project quota types at mount time.  When we
perform that switch, we'll try to load the default quota limits from the
root dquot prior to running quotacheck and log a corruption error when
the types don't match.

This is inconsequential because quotacheck will reset the second quota
file as part of doing the switch, but we shouldn't leave scary messages
in the kernel log.

Fixes: afeda6000b0c ("xfs: validate ondisk/incore dquot flags")
Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_dquot.c |   39 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 37 insertions(+), 2 deletions(-)

diff --git a/fs/xfs/xfs_dquot.c b/fs/xfs/xfs_dquot.c
index 175f544f7c45..bd8379b98374 100644
--- a/fs/xfs/xfs_dquot.c
+++ b/fs/xfs/xfs_dquot.c
@@ -506,6 +506,42 @@ xfs_dquot_alloc(
 	return dqp;
 }
 
+/* Check the ondisk dquot's id and type match what the incore dquot expects. */
+static bool
+xfs_dquot_check_type(
+	struct xfs_dquot	*dqp,
+	struct xfs_disk_dquot	*ddqp)
+{
+	uint8_t			ddqp_type;
+	uint8_t			dqp_type;
+
+	ddqp_type = ddqp->d_type & XFS_DQTYPE_REC_MASK;
+	dqp_type = xfs_dquot_type(dqp);
+
+	if (be32_to_cpu(ddqp->d_id) != dqp->q_id)
+		return false;
+
+	/*
+	 * V5 filesystems always expect an exact type match.  V4 filesystems
+	 * expect an exact match for user dquots and for non-root group and
+	 * project dquots.
+	 */
+	if (xfs_sb_version_hascrc(&dqp->q_mount->m_sb) ||
+	    dqp_type == XFS_DQTYPE_USER || dqp->q_id != 0)
+		return ddqp_type == dqp_type;
+
+	/*
+	 * V4 filesystems support either group or project quotas, but not both
+	 * at the same time.  The non-user quota file can be switched between
+	 * group and project quota uses depending on the mount options, which
+	 * means that we can encounter the other type when we try to load quota
+	 * defaults.  Quotacheck will soon reset the the entire quota file
+	 * (including the root dquot) anyway, but don't log scary corruption
+	 * reports to dmesg.
+	 */
+	return ddqp_type == XFS_DQTYPE_GROUP || ddqp_type == XFS_DQTYPE_PROJ;
+}
+
 /* Copy the in-core quota fields in from the on-disk buffer. */
 STATIC int
 xfs_dquot_from_disk(
@@ -518,8 +554,7 @@ xfs_dquot_from_disk(
 	 * Ensure that we got the type and ID we were looking for.
 	 * Everything else was checked by the dquot buffer verifier.
 	 */
-	if ((ddqp->d_type & XFS_DQTYPE_REC_MASK) != xfs_dquot_type(dqp) ||
-	    be32_to_cpu(ddqp->d_id) != dqp->q_id) {
+	if (!xfs_dquot_check_type(dqp, ddqp)) {
 		xfs_alert_tag(bp->b_mount, XFS_PTAG_VERIFIER_ERROR,
 			  "Metadata corruption detected at %pS, quota %u",
 			  __this_address, dqp->q_id);
