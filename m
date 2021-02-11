Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E051EC433E9
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Feb 2021 23:00:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4BF464E42
	for <linux-xfs@archiver.kernel.org>; Thu, 11 Feb 2021 23:00:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbhBKXAo (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 11 Feb 2021 18:00:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:46260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230158AbhBKXAj (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 11 Feb 2021 18:00:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0129A64E3D;
        Thu, 11 Feb 2021 22:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613084399;
        bh=0ikUNpWOhr8TgUcd+BFDwk+S5osJ1K5XlekiDPZ7Xt0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=OWGLup7TA8qU3ebXIfpTs8Zcapn3DjKIr6ExZjGc6c1LFkqNzJG2K59liZxzCj/Al
         J+1RTC9ODDJC/wkCDl4ndht3GHamhTgJQQBeBXfp40MM3tIgIcvuHQLXUGt05pNIVl
         n3oyjzIF4SRfMyojhJKRH3AwO65z45esDGD7hQ+os8ws6SfKhAa6zvd+7Wzxi/HrV3
         Br1is+k331LuqimfIW3ZHjg0WoWMsmc7nPF6KDEC7/kXL/LRJklyfBlmDBZZBkKDsT
         h7infSf+KCuoUb1SbCDnDKwaUdkw+TlWk3N/+ZvDt8nbfAjrhsrkH0YjLtmqRwP0wk
         5bM8GlHJTPjlw==
Subject: [PATCH 10/11] xfs_admin: support adding features to V5 filesystems
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        bfoster@redhat.com
Date:   Thu, 11 Feb 2021 14:59:58 -0800
Message-ID: <161308439838.3850286.2084912955688223044.stgit@magnolia>
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

Teach the xfs_admin script how to add features to V5 filesystems.
Technically speaking we could add lazycount to the list, but that option
is only useful for the V4 format which is deprecated.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 db/xfs_admin.sh      |    6 ++++--
 man/man8/xfs_admin.8 |   22 ++++++++++++++++++++++
 2 files changed, 26 insertions(+), 2 deletions(-)


diff --git a/db/xfs_admin.sh b/db/xfs_admin.sh
index 430872ef..7a467dbe 100755
--- a/db/xfs_admin.sh
+++ b/db/xfs_admin.sh
@@ -8,9 +8,10 @@ status=0
 DB_OPTS=""
 REPAIR_OPTS=""
 REPAIR_DEV_OPTS=""
-USAGE="Usage: xfs_admin [-efjlpuV] [-c 0|1] [-L label] [-r rtdev] [-U uuid] device [logdev]"
+DB_LOG_OPTS=""
+USAGE="Usage: xfs_admin [-efjlpuV] [-c 0|1] [-L label] [-O v5_feature] [-r rtdev] [-U uuid] device [logdev]"
 
-while getopts "c:efjlL:pr:uU:V" c
+while getopts "c:efjlL:O:pr:uU:V" c
 do
 	case $c in
 	c)	REPAIR_OPTS=$REPAIR_OPTS" -c lazycount="$OPTARG;;
@@ -19,6 +20,7 @@ do
 	j)	DB_OPTS=$DB_OPTS" -c 'version log2'";;
 	l)	DB_OPTS=$DB_OPTS" -r -c label";;
 	L)	DB_OPTS=$DB_OPTS" -c 'label "$OPTARG"'";;
+	O)	REPAIR_OPTS=$REPAIR_OPTS" -c $OPTARG=1";;
 	p)	DB_OPTS=$DB_OPTS" -c 'version projid32bit'";;
 	r)	REPAIR_DEV_OPTS=" -r '$OPTARG'";;
 	u)	DB_OPTS=$DB_OPTS" -r -c uuid";;
diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
index cccbb224..055a502a 100644
--- a/man/man8/xfs_admin.8
+++ b/man/man8/xfs_admin.8
@@ -6,6 +6,8 @@ xfs_admin \- change parameters of an XFS filesystem
 [
 .B \-eflpu
 ] [
+.BI \-O " featurelist"
+] [
 .BR "\-c 0" | 1
 ] [
 .B \-L
@@ -106,6 +108,26 @@ The filesystem label can be cleared using the special "\c
 " value for
 .IR label .
 .TP
+.BI \-O " feature1" = "status" , "feature2" = "status..."
+Add or remove features on an existing V5 filesystem.
+The features should be specified as a comma-separated list.
+.I status
+should be either 0 to disable the feature or 1 to enable the feature.
+Note, however, that most features cannot be disabled.
+.IP
+.B NOTE:
+Administrators must ensure the filesystem is clean by running
+.B xfs_repair -n
+to inspect the filesystem before performing the upgrade.
+If corruption is found, recovery procedures (e.g. reformat followed by
+restoration from backup; or running
+.B xfs_repair
+without the
+.BR -n )
+must be followed to clean the filesystem.
+.IP
+There are currently no feature options.
+.TP
 .BI \-U " uuid"
 Set the UUID of the filesystem to
 .IR uuid .

