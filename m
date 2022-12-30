Return-Path: <linux-xfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0772C4167B
	for <linux-xfs@archiver.kernel.org>; Sat, 31 Dec 2022 03:10:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236265AbiLaDKd (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 30 Dec 2022 22:10:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236259AbiLaDKc (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 30 Dec 2022 22:10:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D6EB10540;
        Fri, 30 Dec 2022 19:10:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A32A61D07;
        Sat, 31 Dec 2022 03:10:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92A08C433D2;
        Sat, 31 Dec 2022 03:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672456230;
        bh=iazQdORJNTiNeT1Bp91lybOGz7rdHR5iUv8jJ2e1ZXQ=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=nRYM/XcVDr6we5jjicMUgSpay9hmf42UCTss4c8FXdx9lYOQeQVaFkr73YcO1vlv/
         2YbJh98r8aSy53O0kz6tlytP8WQtWIq1sksN6Uu/faw3aq1OkkTowbB7KhqCeKNLok
         4vX5O9aveiCu3C5e97n6zFXjpJwK5ohW9QLbrpSlrrTGmLb7UWMGuyIQSnCuhkGj8d
         nXmLjckhchJd5tSgZ5CEMyJEDrG3W223DM+vddeymz/iSkyJbhvqjvN10DwKuzxAX8
         tbQECYLWXAp04K8P3XvdoNaN+rUznlgCL4jp2BpiayiAs1D7KxfvmSi+DIZgSAIDtY
         vfylIq3OWTi1w==
Subject: [PATCH 04/12] common: pass the realtime device to xfs_db when
 possible
From:   "Darrick J. Wong" <djwong@kernel.org>
To:     zlang@redhat.com, djwong@kernel.org
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org, guan@eryu.me
Date:   Fri, 30 Dec 2022 14:20:40 -0800
Message-ID: <167243883999.739029.2059552910043982016.stgit@magnolia>
In-Reply-To: <167243883943.739029.3041109696120604285.stgit@magnolia>
References: <167243883943.739029.3041109696120604285.stgit@magnolia>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

From: Darrick J. Wong <djwong@kernel.org>

Teach xfstests to pass the realtime device to xfs_db when it supports
that option.

Signed-off-by: Darrick J. Wong <djwong@kernel.org>
---
 common/xfs |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)


diff --git a/common/xfs b/common/xfs
index 36e02413db..0d1e0ec4bc 100644
--- a/common/xfs
+++ b/common/xfs
@@ -281,10 +281,10 @@ _xfs_check()
 {
 	OPTS=" "
 	DBOPTS=" "
-	USAGE="Usage: xfs_check [-fsvV] [-l logdev] [-i ino]... [-b bno]... special"
+	USAGE="Usage: xfs_check [-fsvV] [-l logdev] [-R rtdev] [-i ino]... [-b bno]... special"
 
 	OPTIND=1
-	while getopts "b:fi:l:stvV" c; do
+	while getopts "b:fi:l:stvVR:" c; do
 		case $c in
 			s) OPTS=$OPTS"-s ";;
 			t) OPTS=$OPTS"-t ";;
@@ -296,12 +296,14 @@ _xfs_check()
 			V) $XFS_DB_PROG -p xfs_check -V
 			   return $?
 			   ;;
+			R) DBOPTS="$DBOPTS -R $OPTARG";;
 		esac
 	done
 	set -- extra $@
 	shift $OPTIND
 	case $# in
-		1) ${XFS_DB_PROG}${DBOPTS} -F -i -p xfs_check -c "check$OPTS" $1
+		1) echo "${XFS_DB_PROG}${DBOPTS} -F -i -p xfs_check -c check$OPTS $1" >> /dev/ttyprintk
+		   ${XFS_DB_PROG}${DBOPTS} -F -i -p xfs_check -c "check$OPTS" $1
 		   status=$?
 		   ;;
 		2) echo $USAGE 1>&1
@@ -339,6 +341,11 @@ _scratch_xfs_db_options()
 	SCRATCH_OPTIONS=""
 	[ "$USE_EXTERNAL" = yes -a ! -z "$SCRATCH_LOGDEV" ] && \
 		SCRATCH_OPTIONS="-l$SCRATCH_LOGDEV"
+	if [ "$USE_EXTERNAL" = yes ] && [ ! -z "$SCRATCH_RTDEV" ]; then
+		$XFS_DB_PROG --help 2>&1 | grep -q -- '-R rtdev' || \
+			_notrun 'xfs_db does not support rt devices'
+		SCRATCH_OPTIONS="$SCRATCH_OPTIONS -R$SCRATCH_RTDEV"
+	fi
 	echo $SCRATCH_OPTIONS $* $SCRATCH_DEV
 }
 
@@ -403,6 +410,11 @@ _scratch_xfs_check()
 		SCRATCH_OPTIONS="-l $SCRATCH_LOGDEV"
 	[ "$LARGE_SCRATCH_DEV" = yes ] && \
 		SCRATCH_OPTIONS=$SCRATCH_OPTIONS" -t"
+	if [ "$USE_EXTERNAL" = yes ] && [ ! -z "$SCRATCH_RTDEV" ]; then
+		$XFS_DB_PROG --help 2>&1 | grep -q -- '-R rtdev' || \
+			_notrun 'xfs_db does not support rt devices'
+		SCRATCH_OPTIONS="$SCRATCH_OPTIONS -R$SCRATCH_RTDEV"
+	fi
 	_xfs_check $SCRATCH_OPTIONS $* $SCRATCH_DEV
 }
 

