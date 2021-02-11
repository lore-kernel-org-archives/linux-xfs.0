Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE4A2C433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Feb 2021 23:00:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CCB964E4B
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Feb 2021 23:00:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230001AbhBKXAP (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Feb 2021 18:00:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:45996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229989AbhBKXAO (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Feb 2021 18:00:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A47C364E4A;
        Thu, 11 Feb 2021 22:59:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613084364;
        bh=eYTE8MxWR0l0+sBxedArH65I5fhuR0B+OsSJpCSB5iU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=lx1ZipNtFdnn8QHS1gLN797aeyKB2Y+HKrg2mqrjYrvMmgOS6gzKwGk9D6TbgVIEA
         n5EUQey2JNqZx457RxxQKK7yHwIE3kz9Xxj0+kpYxm4mmedIhweHEkoXDMOYZdMXeR
         ZhMgORnLUxYAdj0gP3c4WKwOof1x2YGPifYRe2YloLNV6oWmGXIydKQOL50av8bA3w
         RFamkzJrkALxPCYPXKF47x6xNdFGdT5A//8p2z73jfQI2kvqVICFpnP6Bd17luwelG
         Wr1hIitjfMU1Ax2qm5/Gte+wzSrKpohPXUjs2Wbn89+tCm7gFXyZ1EPx/aIwvVh1PH
         b6VvHEnb7hM8w==
Subject: [PATCH 04/11] xfs_db: don't allow label/uuid setting if the
 needsrepair flag is set
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        bfoster@redhat.com
Date:   Thu, 11 Feb 2021 14:59:24 -0800
Message-ID: <161308436401.3850286.10329324186479058348.stgit@magnolia>
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

The NEEDSREPAIR flag can be set on filesystems where we /know/ that
there's something wrong with the metadata and want to force the sysadmin
to run xfs_repair before the next mount.  The goal here is to prevent
non-repair changes to a filesystem when we are confident of its
instability.  Normally we wouldn't bother with such safety checks for
the debugger, but the label and uuid functions can be called from
xfs_admin, so we should prevent these administrative tasks until the
filesystem can be repaired.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 db/sb.c |   11 +++++++++++
 1 file changed, 11 insertions(+)


diff --git a/db/sb.c b/db/sb.c
index d7111e92..cec7dce9 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -379,6 +379,11 @@ uuid_f(
 				progname);
 			return 0;
 		}
+		if (xfs_sb_version_needsrepair(&mp->m_sb)) {
+			dbprintf(_("%s: filesystem needs xfs_repair\n"),
+				progname);
+			return 0;
+		}
 
 		if (!strcasecmp(argv[1], "generate")) {
 			platform_uuid_generate(&uu);
@@ -543,6 +548,12 @@ label_f(
 			return 0;
 		}
 
+		if (xfs_sb_version_needsrepair(&mp->m_sb)) {
+			dbprintf(_("%s: filesystem needs xfs_repair\n"),
+				progname);
+			return 0;
+		}
+
 		dbprintf(_("writing all SBs\n"));
 		for (ag = 0; ag < mp->m_sb.sb_agcount; ag++)
 			if ((p = do_label(ag, argv[1])) == NULL) {

