Return-Path: <SRS0=7G1E=ZY=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAC9EC432C0
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Dec 2019 17:37:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ADED020881
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Dec 2019 17:37:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XnPXRHGA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727845AbfLBRha (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Dec 2019 12:37:30 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:48882 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727771AbfLBRh3 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Dec 2019 12:37:29 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB2HZHbY044400;
        Mon, 2 Dec 2019 17:37:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2019-08-05;
 bh=/65uLMPkaUvDpDn7ql0L1V1u9b4Jm4NnSB3vIoBIuSg=;
 b=XnPXRHGATFH4GSk+D8VLO125BYAT04nG/shY7utWzgz+XDasRQW2KL0ihojBlQWcgaRm
 7eTZVwFyVFwpIhQaq+CVeCN7ZhK7NWYUxlkQyp25xKzDciT5AgeLofukam8n+PMd4uuI
 EP7LhfiMNksteo9sddpgA+X3GhrkbmEDXFTYBIAXAXe2GY4irbkAN8q33/eN0nOR6uON
 Oavfsm5sjNooio5291jPlO3dkxeKuYFjU78RxGB/J9ApKPxTDEs+000Dya6puH3b/DQ/
 9I/a+fm8lOMj/JWF/ywegFfp5XHtXlxT+8REqcEIQas0bykrXtr1fio+g75fvyD7UA9b QQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 2wkfuu1qsp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Dec 2019 17:37:27 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.27/8.16.0.27) with SMTP id xB2HYJVk190803;
        Mon, 2 Dec 2019 17:37:26 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3020.oracle.com with ESMTP id 2wn4qn2jey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 02 Dec 2019 17:37:26 +0000
Received: from abhmp0008.oracle.com (abhmp0008.oracle.com [141.146.116.14])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id xB2HbQfH017274;
        Mon, 2 Dec 2019 17:37:26 GMT
Received: from localhost (/67.169.218.210)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Mon, 02 Dec 2019 09:37:25 -0800
Subject: [PATCH 2/2] xfs_admin: enable online label getting and setting
From:   "Darrick J. Wong" <darrick.wong@oracle.com>
To:     sandeen@sandeen.net, darrick.wong@oracle.com
Cc:     linux-xfs@vger.kernel.org
Date:   Mon, 02 Dec 2019 09:37:24 -0800
Message-ID: <157530824483.128859.9805424152601641362.stgit@magnolia>
In-Reply-To: <157530823239.128859.15834274920423410063.stgit@magnolia>
References: <157530823239.128859.15834274920423410063.stgit@magnolia>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9459 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1912020148
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9459 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1912020149
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Connect xfs_admin -L to the xfs_io label command so that we can get and
set the label for a live filesystem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
---
 db/xfs_admin.sh |   42 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 40 insertions(+), 2 deletions(-)


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

