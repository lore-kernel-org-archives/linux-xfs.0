Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4457EC433DB
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 04:19:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 065EE64EB9
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 04:19:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbhBIESv (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Feb 2021 23:18:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:48558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230239AbhBIEPq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Feb 2021 23:15:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3DA5964EBD;
        Tue,  9 Feb 2021 04:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612843810;
        bh=8afJyPp9xTxAEmiZ0k/3umEdYcDe0sowGQQ76U+dY4Y=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=kcu3uJJtIkqoKk80DRQPRfKfdOEcbjVVvgP+zQnCgeA5dg5Hb8z0lkltJJqedC+83
         7XfAf5L6ZdaawdZz7+mAK8LyLH1a5K/Ts7jS33J7hn/Nq1UF2wYlh1ChI9iXHO5qK+
         QxC9Yp1mNLqA6JSk9UAXMF/9xZgy+9qn6x22IYFTCmXfKZDCMdLIbgzIXSaaBWmpfO
         +DgMuCVocmN6pMpwdN2tsySwXIiFO7cE+6eTpvVVkaKVyKP9zMPQFZbjgeQfcyv/L3
         xbMWDWMnXLNB/2QJfp3Nlj7B8MKdLSnn6ddktJDd93ZEmVExQMH7V0CKTErcWDFBu6
         Ii7ecsoELT9JQ==
Subject: [PATCH 01/10] xfs_admin: clean up string quoting
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Brian Foster <bfoster@redhat.com>, linux-xfs@vger.kernel.org,
        bfoster@redhat.com
Date:   Mon, 08 Feb 2021 20:10:09 -0800
Message-ID: <161284380981.3057868.13051897080577307586.stgit@magnolia>
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

Clean up the string quoting in this script so that we don't trip over
users feeding us arguments like "/dev/sd ha ha ha lol".

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Brian Foster <bfoster@redhat.com>
---
 db/xfs_admin.sh |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)


diff --git a/db/xfs_admin.sh b/db/xfs_admin.sh
index bd325da2..71a9aa98 100755
--- a/db/xfs_admin.sh
+++ b/db/xfs_admin.sh
@@ -43,7 +43,7 @@ case $# in
 
 		if [ -n "$DB_OPTS" ]
 		then
-			eval xfs_db -x -p xfs_admin $DB_OPTS $1
+			eval xfs_db -x -p xfs_admin $DB_OPTS "$1"
 			status=$?
 		fi
 		if [ -n "$REPAIR_OPTS" ]
@@ -53,7 +53,7 @@ case $# in
 			# running xfs_admin.
 			# Ideally, we need to improve the output behaviour
 			# of repair for this purpose (say a "quiet" mode).
-			eval xfs_repair $REPAIR_OPTS $1 2> /dev/null
+			eval xfs_repair $REPAIR_OPTS "$1" 2> /dev/null
 			status=`expr $? + $status`
 			if [ $status -ne 0 ]
 			then

