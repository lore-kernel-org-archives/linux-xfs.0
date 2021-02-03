Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F5BEC433E6
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 19:44:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43D3E64F87
	for <linux-xfs@archiver.kernel.org>; Wed,  3 Feb 2021 19:44:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230437AbhBCTn7 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 3 Feb 2021 14:43:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:44684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230365AbhBCTn6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 3 Feb 2021 14:43:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18C6C64F87;
        Wed,  3 Feb 2021 19:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612381398;
        bh=R3USiJ0p8zusMsmwGd3Ib70rglrB7VgahjyMVf25bd0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Vm/1+cZJs8VGjmB/patG6V7ZYGtt6fM/CRWv5R0PBNQlc07NdDDw8xGK1NsKYM9ii
         w4oN6aNPnTFMGJUdJTRPaFmnY5Ma9xiHf7dMaSJI52oXbl+Nf8pPecwNxWjk/Cyi1E
         pXq4QgDJnRIYRXK7BBOdRdleusmssjNQX/OMQMt8PlZuF7zKnht/GwvTDeQEu6mrnM
         0Jay2ppC7mfgAfRwJm+O18pp2g10fkFlCo6W5tG9Td6eC25/9UQ1RDJwLX34NAD+xX
         2TKGHZlLg744TNlSiNrhGj+/0uA1yTwvBFwJezqfGYZkyo/DI15tWD4D4kj6qMtq5I
         j1NDOQ0lkrSYQ==
Subject: [PATCH 1/5] xfs_admin: clean up string quoting
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Wed, 03 Feb 2021 11:43:17 -0800
Message-ID: <161238139753.1278306.12571924344581175091.stgit@magnolia>
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

Clean up the string quoting in this script so that we don't trip over
users feeding us arguments like "/dev/sd ha ha ha lol".

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
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

