Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26CEBC433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Feb 2021 22:59:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D601264E58
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Feb 2021 22:59:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229997AbhBKW7u (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Feb 2021 17:59:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:45860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229994AbhBKW7t (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Feb 2021 17:59:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8DE064E3D;
        Thu, 11 Feb 2021 22:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613084347;
        bh=2nYHqGMPl3YRJRiNgor3zNMGRLLt0XUwPh3DeanmAgs=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=poPDdEyC59fd/oPu8voVeyI/eZvyyAyMwiAPS5xxVqQ7gikr7Vlt67IaCMAkkvesk
         1T8iF+LoXpPY3tBmcCGcnnwsdWZ//d6udAo4/Wue2tfS+ZNHB27DRE8DFK/AhzbK8U
         Kums+DXxq92g1QwoXK7MFqBy1TMrClaZXg4lkQ92/58QJLZjLX01cKMuukEox1htw6
         e/y00spOWFXH+Ti3c0a3ouco6veykscTmL33ChVy0c0ldhAhb1Dgt2iSNzi18XJHdB
         MuRrWxy9sXOVmV2oSxNCSyUn5QnijWMWPqq+hUBMSxb0pVZpQFlOpjA5r6h27wcnkE
         wp1OnETNSfreg==
Subject: [PATCH 01/11] xfs_admin: clean up string quoting
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Brian Foster <bfoster@redhat.com>, Christoph Hellwig <hch@lst.de>,
        linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Thu, 11 Feb 2021 14:59:07 -0800
Message-ID: <161308434707.3850286.16561299406740612589.stgit@magnolia>
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

Clean up the string quoting in this script so that we don't trip over
users feeding us arguments like "/dev/sd ha ha ha lol".

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
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

