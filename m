Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FEEBC433DB
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 03:02:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E898364E02
	for <linux-xfs@archiver.kernel.org>; Tue, 23 Feb 2021 03:02:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbhBWDCS (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 22 Feb 2021 22:02:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:47618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230400AbhBWDB6 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 22 Feb 2021 22:01:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD20F64E02;
        Tue, 23 Feb 2021 03:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614049302;
        bh=ob7Pm07fS8v/Xgevnx8Fzacgh+AxqJ9PGNz6d6P9v9c=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=cA9twMdwuAyWUinX4sH1e86ARSucC8p/SkkjCQQS+i7MulmlMq/DBgltcCgUb9yKq
         vZGYF0ybtgL/oWj/cFvf+wAGOhjVMTlRCoFV+jzwT6q3Zp0aldp6Q40gzNalg/chKq
         Gijoevqov4ANjsjawMI6ct0j0I/tsyvj6HEXTbHDNPIStxIBHA9UGPIb3iwARATjDS
         +n/eHiwQfckg2CE3ec2BPGGciQL4DNQi997CbM16lGY68WqutOeUczCa/PwZIy56VH
         FZ+da/3udZzBLGu87j+WvHnuU7IaAY3WKrcXqp2Rf+kqPN4BTai4lRav9ayIAg3Ear
         YS4JzMYGwPjQQ==
Subject: [PATCH 3/5] xfs_admin: support adding features to V5 filesystems
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     Christoph Hellwig <hch@lst.de>, linux-xfs@vger.kernel.org,
        hch@lst.de, bfoster@redhat.com
Date:   Mon, 22 Feb 2021 19:01:42 -0800
Message-ID: <161404930230.425731.17349113846789217272.stgit@magnolia>
In-Reply-To: <161404928523.425731.7157248967184496592.stgit@magnolia>
References: <161404928523.425731.7157248967184496592.stgit@magnolia>
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
index 5ef99316..ae661648 100644
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
@@ -116,6 +118,26 @@ The filesystem label can be cleared using the special "\c
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
+There are no feature options currently.
+.TP
 .BI \-U " uuid"
 Set the UUID of the filesystem to
 .IR uuid .

