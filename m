Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D6B5C433DB
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 04:15:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0C85864EB8
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 04:15:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230043AbhBIEPa (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Feb 2021 23:15:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:48454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230209AbhBIEN0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Feb 2021 23:13:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1A4464EBE;
        Tue,  9 Feb 2021 04:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612843821;
        bh=HxErr6O2CBXeEaKjbw8yiGnWJn+VmI0G+Hu9dn9eriQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Tu7HNwXENF4EU0zN++dUSfoYQ3z5V4d8LTV/mK8hT4cJJuX6vpVZXts28nVWyeh1B
         WkTjeTXn89iCjF7kUGB0tqLUsk2XmU5RQOC38Tdu5u6kYAmQRXNhT2TeO8V6jZBwQ3
         8OPpiDcVTDLLq6eeW7G0YhXLGV6TlbhgQtPyYiJQNxM06M9a2iCSiAeTlE7JdaLje4
         FMKrHw8Ho9HyVnPxCRAqWYeHcDWT4Fn3xs0VBD9tuxf+PWFnhmsSomW9mMkMYhUN6a
         9LfSd/pREp0rt6e1rRu1tF0G/TNuVXzyg/5CRT2ly3ZMEisEf3xzXSgay3cIFoFMvk
         0Oo5GX/zylZ7Q==
Subject: [PATCH 03/10] xfs_db: support the needsrepair feature flag in the
 version command
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Mon, 08 Feb 2021 20:10:21 -0800
Message-ID: <161284382116.3057868.4021834592988203500.stgit@magnolia>
In-Reply-To: <161284380403.3057868.11153586180065627226.stgit@magnolia>
References: <161284380403.3057868.11153586180065627226.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Teach the xfs_db version command about the 'needsrepair' flag, which can
be used to force the system administrator to repair the filesystem with
xfs_repair.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/check.c |    5 +++++
 db/sb.c    |   13 +++++++++++++
 2 files changed, 18 insertions(+)


diff --git a/db/check.c b/db/check.c
index 33736e33..485e855e 100644
--- a/db/check.c
+++ b/db/check.c
@@ -3970,6 +3970,11 @@ scan_ag(
 			dbprintf(_("mkfs not completed successfully\n"));
 		error++;
 	}
+	if (xfs_sb_version_needsrepair(sb)) {
+		if (!sflag)
+			dbprintf(_("filesystem needs xfs_repair\n"));
+		error++;
+	}
 	set_dbmap(agno, XFS_SB_BLOCK(mp), 1, DBM_SB, agno, XFS_SB_BLOCK(mp));
 	if (sb->sb_logstart && XFS_FSB_TO_AGNO(mp, sb->sb_logstart) == agno)
 		set_dbmap(agno, XFS_FSB_TO_AGBNO(mp, sb->sb_logstart),
diff --git a/db/sb.c b/db/sb.c
index d09f653d..cec7dce9 100644
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
@@ -691,6 +702,8 @@ version_string(
 		strcat(s, ",INOBTCNT");
 	if (xfs_sb_version_hasbigtime(sbp))
 		strcat(s, ",BIGTIME");
+	if (xfs_sb_version_needsrepair(sbp))
+		strcat(s, ",NEEDSREPAIR");
 	return s;
 }
 

