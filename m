Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DF02C433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 03:01:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E211064E57
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 03:01:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbhBWDBM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Feb 2021 22:01:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:47414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230053AbhBWDBL (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 22 Feb 2021 22:01:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F68464E4D;
        Tue, 23 Feb 2021 03:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614049230;
        bh=k9P4KOh8zz2ktBf96z1sxGWEzdv4kabmpDP+Ki/oidE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=pZ0vKmP4g8+CRmC0JcSYeoRsbitAjmD06caEiwF3DLDxis5LzqBl/ECMcyByLzG+u
         a2DtCO6z/o11lKGznsUrM6qDalGACwdKd1wo3ClpgrCnDXkviqEE7GaTF4DmY+898F
         qTcPm+EoDm6NWcFRn62O5qG5HLiwmd4TgtSpOiowHsv+xifW11KFNcRj8xKydBO0r7
         E+t7vWFuWkexAFB+JnfsT57BHgNdmGTHRZ1SSzc4PmeJwVLJ5T9uU995GwrfKPOP3O
         8uF2ccrweJF+3UhcgyVCQvaBfbuZc7RQjcTS/Yph9MdeGHF8LbySXadpPhOu/Fm2O2
         HT5Qf8OMDTu8Q==
Subject: [PATCH 2/7] xfs_admin: support filesystems with realtime devices
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Mon, 22 Feb 2021 19:00:29 -0800
Message-ID: <161404922974.425352.3747623410781587574.stgit@magnolia>
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

Add a -r option to xfs_admin so that we can pass the name of the
realtime device to xfs_repair.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
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

