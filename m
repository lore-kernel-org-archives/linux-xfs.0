Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A28A9C07E95
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Jul 2021 02:58:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 90EA461429
	for <linux-xfs@archiver.kernel.org>; Sat,  3 Jul 2021 02:58:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbhGCDBH (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 2 Jul 2021 23:01:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:59958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230490AbhGCDBH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 2 Jul 2021 23:01:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B8F30613EB;
        Sat,  3 Jul 2021 02:58:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625281114;
        bh=2EQ+1N9UWbQEZM6sHzp4UWp/pvznZJ6nmRuK1jg7X3o=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=FOqq6mTFYIjtWYNMupjiuDMT5M2K1o9GD9LVSdOzP2OY4WWtOTjDKBfFXntboL1kb
         RPaxklder8c7xvdzPmfPIY5FRqjIi2gFafH3lWYwkmw7/jbsiQmasA4z20Kcx9fpod
         +miNS7KtLlvGxIOhia83S+ePUzT89GB+5FOVhXd8Z7TjCz+1lJRj02JOrTKMTwOCGV
         S3hjAqtwOjYapOhLXE0YCD1jJuCk9cYBeBCZKH1g6JTElF6zZW1q4MxIo2/mZX7YVg
         Hq8QCFCPDEyNUBcGsRy38EGFDMRsLJQXbfleY1zcUp3RrJmwHfklPWMKTiEMXaLjHy
         ipvBMIZa/zzmg==
Subject: [PATCH 1/1] xfs_admin: support label queries for mounted filesystems
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     sandeen@sandeen.net, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org
Date:   Fri, 02 Jul 2021 19:58:34 -0700
Message-ID: <162528111450.38981.8857321675621059098.stgit@locust>
In-Reply-To: <162528110904.38981.1853961990457189123.stgit@locust>
References: <162528110904.38981.1853961990457189123.stgit@locust>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Adapt this tool to call xfs_io if the block device in question is
mounted.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 db/xfs_admin.sh |   41 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 39 insertions(+), 2 deletions(-)


diff --git a/db/xfs_admin.sh b/db/xfs_admin.sh
index 409975b2..21c9d71b 100755
--- a/db/xfs_admin.sh
+++ b/db/xfs_admin.sh
@@ -8,9 +8,34 @@ status=0
 DB_OPTS=""
 REPAIR_OPTS=""
 REPAIR_DEV_OPTS=""
+IO_OPTS=""
 LOG_OPTS=""
 USAGE="Usage: xfs_admin [-efjlpuV] [-c 0|1] [-L label] [-O v5_feature] [-r rtdev] [-U uuid] device [logdev]"
 
+# Try to find a loop device associated with a file.  We only want to return
+# one loopdev (multiple loop devices can attach to a single file) so we grab
+# the last line and return it if it's actually a block device.
+try_find_loop_dev_for_file() {
+	local x="$(losetup -O NAME -j "$1" 2> /dev/null | tail -n 1)"
+	test -b "$x" && echo "$x"
+}
+
+try_find_mount_point_for_bdev() {
+	local arg="$1"
+
+	# See if we can map the arg to a loop device
+	loopdev="$(try_find_loop_dev_for_file "${arg}")"
+	test -n "${loopdev}" && arg="${loopdev}"
+
+	if [ ! -b "${arg}" ]; then
+		return 1
+	fi
+
+	# If we find a mountpoint for the device, do a live query;
+	# otherwise try reading the fs with xfs_db.
+	findmnt -t xfs -f -n -o TARGET "${arg}" 2> /dev/null
+}
+
 while getopts "c:efjlL:O:pr:uU:V" c
 do
 	case $c in
@@ -18,8 +43,10 @@ do
 	e)	DB_OPTS=$DB_OPTS" -c 'version extflg'";;
 	f)	DB_OPTS=$DB_OPTS" -f";;
 	j)	DB_OPTS=$DB_OPTS" -c 'version log2'";;
-	l)	DB_OPTS=$DB_OPTS" -r -c label";;
-	L)	DB_OPTS=$DB_OPTS" -c 'label "$OPTARG"'";;
+	l)	DB_OPTS=$DB_OPTS" -r -c label";
+		IO_OPTS=$IO_OPTS" -r -c label";;
+	L)	DB_OPTS=$DB_OPTS" -c 'label "$OPTARG"'";
+		IO_OPTS=$IO_OPTS" -c 'label -s "$OPTARG"'";;
 	O)	REPAIR_OPTS=$REPAIR_OPTS" -c $OPTARG";;
 	p)	DB_OPTS=$DB_OPTS" -c 'version projid32bit'";;
 	r)	REPAIR_DEV_OPTS=" -r '$OPTARG'";;
@@ -43,6 +70,16 @@ case $# in
 			LOG_OPTS=" -l '$2'"
 		fi
 
+		if [ -n "$IO_OPTS" ]; then
+			mntpt="$(try_find_mount_point_for_bdev "$1")"
+			if [ $? -eq 0 ]; then
+				eval xfs_io -x -p xfs_admin $IO_OPTS "$mntpt"
+				status=$?
+				DB_OPTS=""
+				REPAIR_OPTS=""
+			fi
+		fi
+
 		if [ -n "$DB_OPTS" ]
 		then
 			eval xfs_db -x -p xfs_admin $LOG_OPTS $DB_OPTS "$1"

