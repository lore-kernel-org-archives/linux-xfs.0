Return-Path: <SRS0=+mcJ=XP=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DB83C49ED7
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Sep 2019 06:23:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41D5220882
	for <linux-xfs@archiver.kernel.org>; Fri, 20 Sep 2019 06:23:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394772AbfITGXe (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 20 Sep 2019 02:23:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47474 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389222AbfITGXe (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Fri, 20 Sep 2019 02:23:34 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 637048A1C85;
        Fri, 20 Sep 2019 06:23:34 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-12-228.pek2.redhat.com [10.72.12.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 32F5C5D6B2;
        Fri, 20 Sep 2019 06:23:32 +0000 (UTC)
From:   Zorro Lang <zlang@redhat.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH v2] common/xfs: wipe the XFS superblock of each AGs
Date:   Fri, 20 Sep 2019 14:23:27 +0800
Message-Id: <20190920062327.14747-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.69]); Fri, 20 Sep 2019 06:23:34 +0000 (UTC)
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

xfs/030 always fails after d0e484ac699f ("check: wipe scratch devices
between tests") get merged.

Due to xfs/030 does a sized(100m) mkfs. Before we merge above commit,
mkfs.xfs detects an old primary superblock, it will write zeroes to
all superblocks before formatting the new filesystem. But this won't
be done if we wipe the first superblock(by merging above commit).

That means if we make a (smaller) sized xfs after wipefs, those *old*
superblocks which created by last time mkfs.xfs will be left on disk.
Then when we do xfs_repair, if xfs_repair can't find the first SB, it
will go to find those *old* SB at first. When it finds them,
everyting goes wrong.

So I try to get XFS AG geometry(by default) and then try to erase all
superblocks. Thanks Darrick J. Wong helped to analyze this issue.

Reported-by: Yang Xu <xuyang2018.jy@cn.fujitsu.com>
Signed-off-by: Zorro Lang <zlang@redhat.com>
---

Hi,

V2 did below changes:
1) Use xfs_db to detect the real xfs geometry
2) Do a $FSTYP specified wipe before trying to wipefs all scratch devices

Thanks,
Zorro

 common/rc  |  8 ++++++++
 common/xfs | 20 ++++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/common/rc b/common/rc
index 66c7fd4d..56329747 100644
--- a/common/rc
+++ b/common/rc
@@ -4045,6 +4045,14 @@ _try_wipe_scratch_devs()
 {
 	test -x "$WIPEFS_PROG" || return 0
 
+	# Do specified filesystem wipe at first
+	case "$FSTYP" in
+	"xfs")
+		_try_wipe_scratch_xfs
+		;;
+	esac
+
+	# Then do wipefs on all scratch devices
 	for dev in $SCRATCH_DEV_POOL $SCRATCH_DEV $SCRATCH_LOGDEV $SCRATCH_RTDEV; do
 		test -b $dev && $WIPEFS_PROG -a $dev
 	done
diff --git a/common/xfs b/common/xfs
index 1bce3c18..082a1744 100644
--- a/common/xfs
+++ b/common/xfs
@@ -884,3 +884,23 @@ _xfs_mount_agcount()
 {
 	$XFS_INFO_PROG "$1" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g'
 }
+
+# Wipe the superblock of each XFS AGs
+_try_wipe_scratch_xfs()
+{
+	local num='^[0-9]+$'
+	local agcount
+	local agsize
+	local dbsize
+
+	agcount=`_scratch_xfs_get_sb_field agcount 2>/dev/null`
+	agsize=`_scratch_xfs_get_sb_field agblocks 2>/dev/null`
+	dbsize=`_scratch_xfs_get_sb_field blocksize 2>/dev/null`
+
+	if [[ $agcount =~ $num && $agsize =~ $num && $dbsize =~ $num ]];then
+		for ((i = 0; i < agcount; i++)); do
+			$XFS_IO_PROG -c "pwrite $((i * dbsize * agsize)) $dbsize" \
+				$SCRATCH_DEV >/dev/null;
+		done
+	fi
+}
-- 
2.20.1

