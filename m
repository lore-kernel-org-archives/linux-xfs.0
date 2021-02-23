Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68161C433E0
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 03:01:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1994D64E5B
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 03:01:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231262AbhBWDBc (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Feb 2021 22:01:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:47518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230053AbhBWDB3 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 22 Feb 2021 22:01:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14D6764E57;
        Tue, 23 Feb 2021 03:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614049236;
        bh=EQyv+2tV702VcR7DfyihyF5UejBebc12Ks4An41ZuP4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=MIzJ9GhfqX/x8s7PRRD3FYeuwAz7LZRff+JA1yRlgazfIrC18tZuMxnlINysOaqKE
         hUzlJcI9nMr4rDyN4JULKqmwu/vqZ9zRTN9BweNOeAyQaxDkAm7YkoUNKJKL4JjgYs
         tQE05xWg+d7p3N/ebMtjYpK/VK7/+JNlkBKOY2f35r9qiEm555E7u+2Cof7iASHfMK
         E2O7Wza0/D0qgI3RkPtAMQ9DihdABfNkK+UdzHXmQIg/CRyNcslJw1ji+ooUxuxsdz
         COPfe/vhKONb7rEJoV6N58sXfyU0HrM1zNMbCHg5Lyf6hJFAgxb69arU+ZGOozUaKR
         4wuc/0dUMkm6Q==
Subject: [PATCH 3/7] xfs_db: report the needsrepair flag in check and version
 commands
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        bfoster@redhat.com
Date:   Mon, 22 Feb 2021 19:00:35 -0800
Message-ID: <161404923555.425352.13688646688421406378.stgit@magnolia>
In-Reply-To: <161404921827.425352.18151735716678009691.stgit@magnolia>
References: <161404921827.425352.18151735716678009691.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Teach the version and check commands to report the presence of the
NEEDSREPAIR flag.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 db/check.c |    5 +++++
 db/sb.c    |    2 ++
 2 files changed, 7 insertions(+)


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
index d09f653d..d7111e92 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -691,6 +691,8 @@ version_string(
 		strcat(s, ",INOBTCNT");
 	if (xfs_sb_version_hasbigtime(sbp))
 		strcat(s, ",BIGTIME");
+	if (xfs_sb_version_needsrepair(sbp))
+		strcat(s, ",NEEDSREPAIR");
 	return s;
 }
 

