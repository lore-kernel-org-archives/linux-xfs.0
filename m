Return-Path: <SRS0=2geO=ZZ=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,PDS_BTC_ID,PDS_BTC_MSGID,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83CE1C432C0
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Dec 2019 06:53:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B55B206E0
	for <linux-xfs@archiver.kernel.org>; Tue,  3 Dec 2019 06:53:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SXrgT0U2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727325AbfLCGxU (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 3 Dec 2019 01:53:20 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:52360 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727192AbfLCGxU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 3 Dec 2019 01:53:20 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB32i85R093426;
        Tue, 3 Dec 2019 02:47:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=iIJQ694t39Rn5sZi9SVKkEap7EE0pZUrlHIqTrbSiww=;
 b=SXrgT0U2thfT8DTF5QqeaQ4FyGuCQXBc2QvSOctn/7Mkrx/aj7ycp5WPg77RxQn7F8W8
 ysieMCe3QCe7IaesG2YJCFdOx1KQ55a31XQLQ+a/ce9C1PiK7hgY4qY6rUBPwiMVx5d7
 Zpis6CUbmNYQfshRooBO1GLrjkFdy1n6beWBb7jlGbt1XpnlgBzHVZySG2C95onuXg8T
 jT35QbcY1LN7kGwpkblW5bw8YajT4NqT19pQ338at5hjgsPlu6CEEZKVz3Udh9+Mk1v0
 ifo/kPdQPgDvBZyRUcKGXhrNCtkxfibiclY+HWs4kz3oAckWZ5gQE/spxUa28lJtvM8V Fg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 2wkfuu4duw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Dec 2019 02:47:57 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB32iCEO166131;
        Tue, 3 Dec 2019 02:47:57 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by aserp3030.oracle.com with ESMTP id 2wn8k1hbgw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 03 Dec 2019 02:47:56 +0000
Received: from abhmp0010.oracle.com (abhmp0010.oracle.com [141.146.116.16])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xB32luEo018528;
        Tue, 3 Dec 2019 02:47:56 GMT
Received: from localhost (/10.159.148.223)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 03 Dec 2019 02:47:56 +0000
Subject: [PATCH 2/2] xfs_admin: enable online label getting and setting
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 02 Dec 2019 18:47:55 -0800
Message-ID: <157534127538.396264.18160137569276022475.stgit@magnolia>
In-Reply-To: <157534126287.396264.13869948892885966217.stgit@magnolia>
References: <157534126287.396264.13869948892885966217.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9459 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912030024
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9459 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912030024
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Connect xfs_admin -L to the xfs_io label command so that we can get and
set the label for a live filesystem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/xfs_admin.sh      |   42 ++++++++++++++++++++++++++++++++++++++++--
 man/man8/xfs_admin.8 |    4 +++-
 2 files changed, 43 insertions(+), 3 deletions(-)


diff --git a/db/xfs_admin.sh b/db/xfs_admin.sh
index bd325da2..d18959bf 100755
--- a/db/xfs_admin.sh
+++ b/db/xfs_admin.sh
@@ -7,8 +7,30 @@
 status=0
 DB_OPTS=""
 REPAIR_OPTS=""
+IO_OPTS=""
 USAGE="Usage: xfs_admin [-efjlpuV] [-c 0|1] [-L label] [-U uuid] device [logdev]"
 
+# Try to find a loop device associated with a file.  We only want to return
+# one loopdev (multiple loop devices can attach to a single file) so we grab
+# the last line and return it if it's actually a block device.
+try_find_loop_dev_for_file() {
+	local x="$(losetup -O NAME -j "$1" 2> /dev/null | tail -n 1)"
+	test -b "$x" && echo "$x"
+}
+
+# See if we can find a mount point for the argument.
+find_mntpt_for_arg() {
+	local arg="$1"
+
+	# See if we can map the arg to a loop device
+	local loopdev="$(try_find_loop_dev_for_file "${arg}")"
+	test -n "$loopdev" && arg="$loopdev"
+
+	# If we find a mountpoint for the device, do a live query;
+	# otherwise try reading the fs with xfs_db.
+	findmnt -t xfs -f -n -o TARGET "${arg}" 2> /dev/null
+}
+
 while getopts "efjlpuc:L:U:V" c
 do
 	case $c in
@@ -16,8 +38,16 @@ do
 	e)	DB_OPTS=$DB_OPTS" -c 'version extflg'";;
 	f)	DB_OPTS=$DB_OPTS" -f";;
 	j)	DB_OPTS=$DB_OPTS" -c 'version log2'";;
-	l)	DB_OPTS=$DB_OPTS" -r -c label";;
-	L)	DB_OPTS=$DB_OPTS" -c 'label "$OPTARG"'";;
+	l)	DB_OPTS=$DB_OPTS" -r -c label"
+		IO_OPTS=$IO_OPTS" -r -c label"
+		;;
+	L)	DB_OPTS=$DB_OPTS" -c 'label "$OPTARG"'"
+		if [ "$OPTARG" = "--" ]; then
+			IO_OPTS=$IO_OPTS" -c 'label -c'"
+		else
+			IO_OPTS=$IO_OPTS" -c 'label -s "$OPTARG"'"
+		fi
+		;;
 	p)	DB_OPTS=$DB_OPTS" -c 'version projid32bit'";;
 	u)	DB_OPTS=$DB_OPTS" -r -c uuid";;
 	U)	DB_OPTS=$DB_OPTS" -c 'uuid "$OPTARG"'";;
@@ -41,6 +71,14 @@ case $# in
 				REPAIR_OPTS=$REPAIR_OPTS" -l '$2'"
 		fi
 
+		# Try making the changes online, if supported
+		if [ -n "$IO_OPTS" ] && mntpt="$(find_mntpt_for_arg "$1")"
+		then
+			eval xfs_io -x -p xfs_admin $IO_OPTS "$mntpt"
+			test "$?" -eq 0 && exit 0
+		fi
+
+		# Otherwise try offline changing
 		if [ -n "$DB_OPTS" ]
 		then
 			eval xfs_db -x -p xfs_admin $DB_OPTS $1
diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
index 8afc873f..220dd803 100644
--- a/man/man8/xfs_admin.8
+++ b/man/man8/xfs_admin.8
@@ -26,7 +26,7 @@ uses the
 .BR xfs_db (8)
 command to modify various parameters of a filesystem.
 .PP
-Devices that are mounted cannot be modified.
+Devices that are mounted cannot be modified, except as noted below.
 Administrators must unmount filesystems before
 .BR xfs_admin " or " xfs_db (8)
 can convert parameters.
@@ -67,6 +67,7 @@ log buffers).
 .TP
 .B \-l
 Print the current filesystem label.
+This command can be run if the filesystem is mounted.
 .TP
 .B \-p
 Enable 32bit project identifier support (PROJID32BIT feature).
@@ -102,6 +103,7 @@ The filesystem label can be cleared using the special "\c
 .B \-\-\c
 " value for
 .IR label .
+This command can be run if the filesystem is mounted.
 .TP
 .BI \-U " uuid"
 Set the UUID of the filesystem to

