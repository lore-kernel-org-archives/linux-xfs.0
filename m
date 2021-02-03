Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC5F8C433DB
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 19:44:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E92D64F60
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 19:44:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230365AbhBCToV (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Feb 2021 14:44:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:44750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229661AbhBCToU (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Feb 2021 14:44:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E7F6264F5F;
        Wed,  3 Feb 2021 19:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612381404;
        bh=cNMT4MOktT8if5Wmc1bDifJm//LbEKUzTP1w6rRyQS4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=q15/q/9SFrIVEqsYrfgNXYTVqKjbRerD8q+Wnv0hPfkDkAQ26NKBXRH2aGh77ThQg
         9Z54CpPLzLhYSVJHZkCMlJ71G0SerCdkWRqUJMAV9UqmPOS9Y8Wtl3a/fh15SM1rPP
         IlA58AxE7D/Noode1te7sh+kSLDpC45h6T25qij9vBWDitWyQmtMu3uPTRtNbpo2o9
         fEOT3+cu/osyFSR5naE3g4qAsAX433QcQ6r8fnnU1f3TH86LOn7P0lAABsrHLhW48y
         PdkjB6STqbQxUNvzG+GMEld6szFfPEsJEmBBXHwFih/nb5rsV63Fe2hyyj+E7yBYih
         x4aQ0ggIlyFdw==
Subject: [PATCH 2/5] xfs_db: define some exit codes for fs feature upgrades
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Wed, 03 Feb 2021 11:43:23 -0800
Message-ID: <161238140340.1278306.5965981519425605413.stgit@magnolia>
In-Reply-To: <161238139177.1278306.5915396345874239435.stgit@magnolia>
References: <161238139177.1278306.5915396345874239435.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Define some exit codes that xfs_db will return when a sysadmin uses it
(or more likely xfs_admin) to add a feature to the filesystem.  At the
moment we return zero for successful upgrades and 1 for fs errors,
though we also allow for returning 2 if the upgrade cannot be applied
because the fs cannot handle it.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/sb.c           |    6 +++++-
 db/xfs_admin.sh   |    3 +++
 man/man8/xfs_db.8 |    8 ++++++++
 3 files changed, 16 insertions(+), 1 deletion(-)


diff --git a/db/sb.c b/db/sb.c
index d09f653d..f306e939 100644
--- a/db/sb.c
+++ b/db/sb.c
@@ -617,6 +617,9 @@ do_version(xfs_agnumber_t agno, uint16_t version, uint32_t features)
 	tsb.sb_bad_features2 = features;
 	libxfs_sb_to_disk(iocur_top->data, &tsb);
 	write_cur();
+	if (!iocur_top->bp || iocur_top->bp->b_error)
+		return 0;
+
 	return 1;
 }
 
@@ -804,7 +807,8 @@ version_f(
 				if (!do_version(ag, version, features)) {
 					dbprintf(_("failed to set versionnum "
 						 "in AG %d\n"), ag);
-					break;
+					exitcode = 1;
+					return 1;
 				}
 			mp->m_sb.sb_versionnum = version;
 			mp->m_sb.sb_features2 = features;
diff --git a/db/xfs_admin.sh b/db/xfs_admin.sh
index 71a9aa98..5c57b461 100755
--- a/db/xfs_admin.sh
+++ b/db/xfs_admin.sh
@@ -46,6 +46,9 @@ case $# in
 			eval xfs_db -x -p xfs_admin $DB_OPTS "$1"
 			status=$?
 		fi
+		if [ $status -eq 1 ]; then
+			echo "Conversion failed due to filesystem errors; run xfs_repair."
+		fi
 		if [ -n "$REPAIR_OPTS" ]
 		then
 			# Hide normal repair output which is sent to stderr
diff --git a/man/man8/xfs_db.8 b/man/man8/xfs_db.8
index 58727495..ee57b03a 100644
--- a/man/man8/xfs_db.8
+++ b/man/man8/xfs_db.8
@@ -981,6 +981,14 @@ and
 .I features2
 bits respectively, and their string equivalent reported
 (but no modifications are made).
+.IP
+If the feature upgrade succeeds, the program will return 0.
+If the requested upgrade has already been applied to the filesystem, the
+program will also return 0.
+If the upgrade fails due to corruption or IO errors, the program will return
+1.
+If the requested upgrade is not appropriate for this filesystem, the program
+will return 2.
 .TP
 .BI "write [\-c|\-d] [" "field value" "] ..."
 Write a value to disk.

