Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CD1EC47096
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Jun 2021 17:54:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22F62613DF
	for <linux-xfs@archiver.kernel.org>; Sun,  6 Jun 2021 17:54:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbhFFR4H (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 6 Jun 2021 13:56:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:57014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229738AbhFFR4H (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Sun, 6 Jun 2021 13:56:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 443446139A;
        Sun,  6 Jun 2021 17:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623002057;
        bh=mgdpANE44ZASUDIqz3yrXfeXgzVmUTiq0/P6SQSEY0g=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=TwFjLj8J6quS6KSYENjem+SWrNibmZLTae44ufoTFYuNXlplRlQAHa1vcF3th5LgB
         sYsVKMBTyCtuoL//choTdfuWLtxQP3S0cBMuBTeMmEjO0ZMiZdSNgU8zEDauUXN1QJ
         5CruNrtldNND9ydJWjZYtFvuqt6IDusrHcQs1KNJAMLl0HbCRkUrtCcXJ0l2nbdYlX
         L2+2NxruGvxP272EiwmdGOGKJxutoQLi+uLAbxEi83FpvEETtu1bo3B74rgrCQ4wJv
         2lCVi/BZpt+JSok/4KGUWEHxkhQR+vtFWrzUBW2mHJQXJ3pzjXbpIocZyzAwcdcSS2
         +deIYXc4XkAHw==
Subject: [PATCH 2/3] xfs: drop IDONTCACHE on inodes when we mark them sick
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, david@fromorbit.com, bfoster@redhat.com
Date:   Sun, 06 Jun 2021 10:54:17 -0700
Message-ID: <162300205695.1202529.8468586379242468573.stgit@locust>
In-Reply-To: <162300204472.1202529.17352653046483745148.stgit@locust>
References: <162300204472.1202529.17352653046483745148.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

When we decide to mark an inode sick, clear the DONTCACHE flag so that
the incore inode will be kept around until memory pressure forces it out
of memory.  This increases the chances that the sick status will be
caught by someone compiling a health report later on.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 fs/xfs/xfs_health.c |    9 +++++++++
 1 file changed, 9 insertions(+)


diff --git a/fs/xfs/xfs_health.c b/fs/xfs/xfs_health.c
index 8e0cb05a7142..806be8a93ea3 100644
--- a/fs/xfs/xfs_health.c
+++ b/fs/xfs/xfs_health.c
@@ -231,6 +231,15 @@ xfs_inode_mark_sick(
 	ip->i_sick |= mask;
 	ip->i_checked |= mask;
 	spin_unlock(&ip->i_flags_lock);
+
+	/*
+	 * Keep this inode around so we don't lose the sickness report.  Scrub
+	 * grabs inodes with DONTCACHE assuming that most inode are ok, which
+	 * is not the case here.
+	 */
+	spin_lock(&VFS_I(ip)->i_lock);
+	VFS_I(ip)->i_state &= ~I_DONTCACHE;
+	spin_unlock(&VFS_I(ip)->i_lock);
 }
 
 /* Mark parts of an inode healed. */

