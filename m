Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4E3AC433DB
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Feb 2021 22:59:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82E7F64E55
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Feb 2021 22:59:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230002AbhBKW7z (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Feb 2021 17:59:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:45880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229994AbhBKW7y (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Feb 2021 17:59:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E86064E42;
        Thu, 11 Feb 2021 22:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613084353;
        bh=UqEngCFltsVVc4Sg7u8+2+Q2wxmZlRz6PjZa8I4EEik=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=M03sF4AxMt02JXuc9ezL5uqg6UPC+wz3V3Jp405VWFuCsfyqy9UYvVu66Gn0C0623
         +eL6BWNz3TMYsf48WGb5kuNSI6UrjShBOGrKZKVfeYy6Jyd/RdF+Au0qXbed/Y40Qn
         /njso1Tg6wZMJoS1+syvliMlb2UwEwQOO34Bu6H35H9lCYQjw24kPwJGBftZXx1Sgk
         pLu/1b46MVzsdGhLiOH94rJWIaADVM466XlNBC4+5OtUZFBneYaCNIfPTg8TLGsGeV
         NS6s7uYatCVylkTgA6ab7Pyv7GJkJv6MX0+KMImhNKGfDfwmZ6x/vyV2nFUxLCIspG
         99GuD3n0bFDew==
Subject: [PATCH 02/11] xfs_admin: support filesystems with realtime devices
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, Brian Foster <bfoster@redhat.com>,
        linux-xfs@vger.kernel.org, bfoster@redhat.com
Date:   Thu, 11 Feb 2021 14:59:12 -0800
Message-ID: <161308435277.3850286.13874179572153084568.stgit@magnolia>
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

Add a -r option to xfs_admin so that we can pass the name of the
realtime device to xfs_repair.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Brian Foster <bfoster@redhat.com>
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

