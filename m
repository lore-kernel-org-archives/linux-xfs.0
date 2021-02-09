Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9577FC433E0
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 04:14:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4644564EB8
	for <linux-xfs@archiver.kernel.org>; Tue,  9 Feb 2021 04:14:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbhBIEOM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 8 Feb 2021 23:14:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:48452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230202AbhBIENF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 8 Feb 2021 23:13:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DFD2064EBC;
        Tue,  9 Feb 2021 04:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612843816;
        bh=yQTbNdRFGWEXudNzBgFNRDCB1wpwNeJZIvGXZ/tCFvA=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=ckIRpLxPLtze3ho/pC5YVhM0weroqPMAmlmVcPjlbQFS9vmsogrjut7mFK9mYvWlu
         esk5wg87RDsOluwH8+gTJe56d3yFPTIvnmPiIPRWtBWHo/G/Broma/QjXur5ixhlIU
         3jBcxgInjhiq81CyXb3DCMbx1fu+FbBNC9+0B8EzzdbKOXOfSQtVY+5qLK9fdqyBDh
         nTBxVfKPAtkcFE6whLFpNHrjnh4mUzFPBe+jBfL7Nlr+yBPgisG5z+MctA7StyN0H3
         khqH1a3d/x6XQw6WELDwVvoFy8bvL9MIHsPk4Pot9+8oBoZif9BSx8Y0GN4uJW0f7k
         n7T/onFqg0AJg==
Subject: [PATCH 02/10] xfs_admin: support filesystems with realtime devices
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Mon, 08 Feb 2021 20:10:15 -0800
Message-ID: <161284381548.3057868.17951198536217853244.stgit@magnolia>
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

Add a -r option to xfs_admin so that we can pass the name of the
realtime device to xfs_repair.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/xfs_admin.sh      |   11 ++++++-----
 man/man8/xfs_admin.8 |    8 ++++++++
 2 files changed, 14 insertions(+), 5 deletions(-)


diff --git a/db/xfs_admin.sh b/db/xfs_admin.sh
index 71a9aa98..430872ef 100755
--- a/db/xfs_admin.sh
+++ b/db/xfs_admin.sh
@@ -7,9 +7,10 @@
 status=0
 DB_OPTS=""
 REPAIR_OPTS=""
-USAGE="Usage: xfs_admin [-efjlpuV] [-c 0|1] [-L label] [-U uuid] device [logdev]"
+REPAIR_DEV_OPTS=""
+USAGE="Usage: xfs_admin [-efjlpuV] [-c 0|1] [-L label] [-r rtdev] [-U uuid] device [logdev]"
 
-while getopts "efjlpuc:L:U:V" c
+while getopts "c:efjlL:pr:uU:V" c
 do
 	case $c in
 	c)	REPAIR_OPTS=$REPAIR_OPTS" -c lazycount="$OPTARG;;
@@ -19,6 +20,7 @@ do
 	l)	DB_OPTS=$DB_OPTS" -r -c label";;
 	L)	DB_OPTS=$DB_OPTS" -c 'label "$OPTARG"'";;
 	p)	DB_OPTS=$DB_OPTS" -c 'version projid32bit'";;
+	r)	REPAIR_DEV_OPTS=" -r '$OPTARG'";;
 	u)	DB_OPTS=$DB_OPTS" -r -c uuid";;
 	U)	DB_OPTS=$DB_OPTS" -c 'uuid "$OPTARG"'";;
 	V)	xfs_db -p xfs_admin -V
@@ -37,8 +39,7 @@ case $# in
 		# Pick up the log device, if present
 		if [ -n "$2" ]; then
 			DB_OPTS=$DB_OPTS" -l '$2'"
-			test -n "$REPAIR_OPTS" && \
-				REPAIR_OPTS=$REPAIR_OPTS" -l '$2'"
+			REPAIR_DEV_OPTS=$REPAIR_DEV_OPTS" -l '$2'"
 		fi
 
 		if [ -n "$DB_OPTS" ]
@@ -53,7 +54,7 @@ case $# in
 			# running xfs_admin.
 			# Ideally, we need to improve the output behaviour
 			# of repair for this purpose (say a "quiet" mode).
-			eval xfs_repair $REPAIR_OPTS "$1" 2> /dev/null
+			eval xfs_repair $REPAIR_DEV_OPTS $REPAIR_OPTS "$1" 2> /dev/null
 			status=`expr $? + $status`
 			if [ $status -ne 0 ]
 			then
diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
index 8afc873f..cccbb224 100644
--- a/man/man8/xfs_admin.8
+++ b/man/man8/xfs_admin.8
@@ -13,6 +13,9 @@ xfs_admin \- change parameters of an XFS filesystem
 ] [
 .B \-U
 .I uuid
+] [
+.B \-r
+.I rtdev
 ]
 .I device
 [
@@ -123,6 +126,11 @@ not be able to mount the filesystem.  To remove this incompatible flag, use
 which will restore the original UUID and remove the incompatible
 feature flag as needed.
 .TP
+.BI \-r " rtdev"
+Specifies the device special file where the filesystem's realtime section
+resides.
+Only for those filesystems which use a realtime section.
+.TP
 .B \-V
 Prints the version number and exits.
 .PP

