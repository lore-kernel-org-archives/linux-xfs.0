Return-Path: <SRS0=0zz6=4T=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE69CC3F2D1
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Mar 2020 14:35:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9961A214DB
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Mar 2020 14:35:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eXP9Byzo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbgCBOfM (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Mar 2020 09:35:12 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:46677 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727053AbgCBOfM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 2 Mar 2020 09:35:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583159710;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=+EpSdl08PCT1XEtbgawxKlenB/gWAl8m+fvmmf3gFO8=;
        b=eXP9ByzoU+Z5Are8GDtRBfKsj/d39tYsbMXgWOEyekCCte9TYtzgqR/8wl9CnO9XTw5ted
        0QmY1L7aOk6cuyOC1v26mBtb4KgxL9tKP068aR5oi3Mmj6A2NX/77cF18CzXifcuxhUWwI
        /xbsZp1CKmTQ3WBVn4F82Kj4MJWF+5k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-23-xF_uuRElOGe2QstT6PpeLw-1; Mon, 02 Mar 2020 09:35:04 -0500
X-MC-Unique: xF_uuRElOGe2QstT6PpeLw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8258718B5FBD;
        Mon,  2 Mar 2020 14:35:03 +0000 (UTC)
Received: from [IPv6:::1] (ovpn04.gateway.prod.ext.phx2.redhat.com [10.5.9.4])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3B0B7390;
        Mon,  2 Mar 2020 14:35:03 +0000 (UTC)
Subject: [PATCH V2] xfs_admin: revert online label setting ability
From:   Eric Sandeen <sandeen@redhat.com>
To:     linux-xfs <linux-xfs@vger.kernel.org>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
References: <db83a9fb-251f-5d7f-921e-80a1c329f343@redhat.com>
Autocrypt: addr=sandeen@redhat.com; prefer-encrypt=mutual; keydata=
 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
Message-ID: <b4d2d6cf-dbae-2a2e-7580-3b6fd13aad9a@redhat.com>
Date:   Mon, 2 Mar 2020 08:35:02 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <db83a9fb-251f-5d7f-921e-80a1c329f343@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

"xfs_admin can't print both label and UUID for mounted filesystems"
https://bugzilla.kernel.org/show_bug.cgi?id=206429

alerted us to the problem that if /any/ options that use xfs_io get
specified to xfs_admin, they are the /only/ ones that get run:

                # Try making the changes online, if supported
                if [ -n "$IO_OPTS" ] && mntpt="$(find_mntpt_for_arg "$1")"
                then
                        eval xfs_io -x -p xfs_admin $IO_OPTS "$mntpt"
                        test "$?" -eq 0 && exit 0
                fi

and thanks to the exit, the xfs_db operations don't get run at all.

We could move on to the xfs_db commands after executing the xfs_io
commands, but we build them all up in parallel at this time:

        l)      DB_OPTS=$DB_OPTS" -r -c label"
                IO_OPTS=$IO_OPTS" -r -c label"
                ;;

so we'd need to keep track of these, and not re-run them in xfs_db.

Another issue is that prior to this commit, we'd run commands in
command line order.

So I experimented with building up an array of commands, invoking xfs_db
or xfs_io one command at a time as needed for each, and ... it got overly
complicated.

It's broken now, and so far a clean solution isn't evident, and I hate to
leave it broken across another release.  So revert it for now.

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


