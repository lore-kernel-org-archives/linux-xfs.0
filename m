Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE1AFC433E0
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Feb 2021 23:00:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 91AFF64E55
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Feb 2021 23:00:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbhBKXAA (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Feb 2021 18:00:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:45900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229994AbhBKW77 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Feb 2021 17:59:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC6DA64E45;
        Thu, 11 Feb 2021 22:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613084359;
        bh=EQyv+2tV702VcR7DfyihyF5UejBebc12Ks4An41ZuP4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ijmyLI0Cc4bQMyhCr/t9PyltnAXDjL/sol7QBycIJ5OI+23C/UZN03OTC0S3eMa+v
         OV/9M+HkkTN6fysR/mwMQbujilChAJ26yezb+LdWOKpYazOVUdEGtZLFEAfXdhypnD
         ZNvUiQvRCMLqfGpPFNd19WlRTnX/y92Qxoi08CjQHy61kWbLEr4NCwrq6n4BbhnTst
         w/m5naC/gA0FR0CMOp+uxqKGxlAm2SCYjEkKKeYbSLp4v7gC1Qahfr0LWnE1KqH8Cz
         h5xjOeF77RGbD9vGiTuc6PbaFpNW5R55Ox95a1NCTDrDqnwAJPrNRU9L/lzTKmMQ3B
         G96IEjcYOlOVg==
Subject: [PATCH 03/11] xfs_db: report the needsrepair flag in check and
 version commands
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        bfoster@redhat.com
Date:   Thu, 11 Feb 2021 14:59:18 -0800
Message-ID: <161308435838.3850286.1999965170245294704.stgit@magnolia>
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
 

