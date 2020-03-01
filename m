Return-Path: <SRS0=l9EO=4S=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACF35C3F2CD
	for <linux-xfs@archiver.kernel.org>; Sun,  1 Mar 2020 17:50:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 67F9C24699
	for <linux-xfs@archiver.kernel.org>; Sun,  1 Mar 2020 17:50:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XlPGL5dV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbgCARuW (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 1 Mar 2020 12:50:22 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27730 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726602AbgCARuV (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 1 Mar 2020 12:50:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583085020;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Nv7XvTnh9qTxxyKSU3cTV3Z3xG95Bi/aQcwJU+bUbWk=;
        b=XlPGL5dVY1ueySRCLC7TusXguQj2axBCA/GrkAVv/eDIT45t/QuXhfa4gr5FQlOVYzg106
        g1StYkx+uVR92mCWaoOqOnZV0JaHLCySuDZXk4jP4Q8DhPE6goWDPlqEmRgoAjZ7LdHOhh
        +GD1+32Z80lc1y+UGs6+fN8EdBzAmeU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-198-vWAHlcQIOOaC5dDDzsEWJA-1; Sun, 01 Mar 2020 12:50:18 -0500
X-MC-Unique: vWAHlcQIOOaC5dDDzsEWJA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0998C13E2;
        Sun,  1 Mar 2020 17:50:18 +0000 (UTC)
Received: from Liberator.local (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6555248;
        Sun,  1 Mar 2020 17:50:14 +0000 (UTC)
To:     linux-xfs <linux-xfs@vger.kernel.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
From:   Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] xfs_admin: revert online label setting ability
Message-ID: <db83a9fb-251f-5d7f-921e-80a1c329f343@redhat.com>
Date:   Sun, 1 Mar 2020 09:50:03 -0800
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

The changes to xfs_admin which allowed online label setting via
ioctl had some unintended consequences in terms of changing command
order and processing.  It's going to be somewhat tricky to fix, so
back it out for now.

Reverts: 3f153e051a ("xfs_admin: enable online label getting and setting")

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

diff --git a/db/xfs_admin.sh b/db/xfs_admin.sh
index d18959bf..bd325da2 100755
--- a/db/xfs_admin.sh
+++ b/db/xfs_admin.sh
@@ -7,30 +7,8 @@
 status=0
 DB_OPTS=""
 REPAIR_OPTS=""
-IO_OPTS=""
 USAGE="Usage: xfs_admin [-efjlpuV] [-c 0|1] [-L label] [-U uuid] device [logdev]"
 
-# Try to find a loop device associated with a file.  We only want to return
-# one loopdev (multiple loop devices can attach to a single file) so we grab
-# the last line and return it if it's actually a block device.
-try_find_loop_dev_for_file() {
-	local x="$(losetup -O NAME -j "$1" 2> /dev/null | tail -n 1)"
-	test -b "$x" && echo "$x"
-}
-
-# See if we can find a mount point for the argument.
-find_mntpt_for_arg() {
-	local arg="$1"
-
-	# See if we can map the arg to a loop device
-	local loopdev="$(try_find_loop_dev_for_file "${arg}")"
-	test -n "$loopdev" && arg="$loopdev"
-
-	# If we find a mountpoint for the device, do a live query;
-	# otherwise try reading the fs with xfs_db.
-	findmnt -t xfs -f -n -o TARGET "${arg}" 2> /dev/null
-}
-
 while getopts "efjlpuc:L:U:V" c
 do
 	case $c in
@@ -38,16 +16,8 @@ do
 	e)	DB_OPTS=$DB_OPTS" -c 'version extflg'";;
 	f)	DB_OPTS=$DB_OPTS" -f";;
 	j)	DB_OPTS=$DB_OPTS" -c 'version log2'";;
-	l)	DB_OPTS=$DB_OPTS" -r -c label"
-		IO_OPTS=$IO_OPTS" -r -c label"
-		;;
-	L)	DB_OPTS=$DB_OPTS" -c 'label "$OPTARG"'"
-		if [ "$OPTARG" = "--" ]; then
-			IO_OPTS=$IO_OPTS" -c 'label -c'"
-		else
-			IO_OPTS=$IO_OPTS" -c 'label -s "$OPTARG"'"
-		fi
-		;;
+	l)	DB_OPTS=$DB_OPTS" -r -c label";;
+	L)	DB_OPTS=$DB_OPTS" -c 'label "$OPTARG"'";;
 	p)	DB_OPTS=$DB_OPTS" -c 'version projid32bit'";;
 	u)	DB_OPTS=$DB_OPTS" -r -c uuid";;
 	U)	DB_OPTS=$DB_OPTS" -c 'uuid "$OPTARG"'";;
@@ -71,14 +41,6 @@ case $# in
 				REPAIR_OPTS=$REPAIR_OPTS" -l '$2'"
 		fi
 
-		# Try making the changes online, if supported
-		if [ -n "$IO_OPTS" ] && mntpt="$(find_mntpt_for_arg "$1")"
-		then
-			eval xfs_io -x -p xfs_admin $IO_OPTS "$mntpt"
-			test "$?" -eq 0 && exit 0
-		fi
-
-		# Otherwise try offline changing
 		if [ -n "$DB_OPTS" ]
 		then
 			eval xfs_db -x -p xfs_admin $DB_OPTS $1
diff --git a/man/man8/xfs_admin.8 b/man/man8/xfs_admin.8
index 220dd803..8afc873f 100644
--- a/man/man8/xfs_admin.8
+++ b/man/man8/xfs_admin.8
@@ -26,7 +26,7 @@ uses the
 .BR xfs_db (8)
 command to modify various parameters of a filesystem.
 .PP
-Devices that are mounted cannot be modified, except as noted below.
+Devices that are mounted cannot be modified.
 Administrators must unmount filesystems before
 .BR xfs_admin " or " xfs_db (8)
 can convert parameters.
@@ -67,7 +67,6 @@ log buffers).
 .TP
 .B \-l
 Print the current filesystem label.
-This command can be run if the filesystem is mounted.
 .TP
 .B \-p
 Enable 32bit project identifier support (PROJID32BIT feature).
@@ -103,7 +102,6 @@ The filesystem label can be cleared using the special "\c
 .B \-\-\c
 " value for
 .IR label .
-This command can be run if the filesystem is mounted.
 .TP
 .BI \-U " uuid"
 Set the UUID of the filesystem to

