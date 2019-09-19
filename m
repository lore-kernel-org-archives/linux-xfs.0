Return-Path: <SRS0=IJtx=XO=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FA02C49ED7
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Sep 2019 15:00:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73C1F21924
	for <linux-xfs@archiver.kernel.org>; Thu, 19 Sep 2019 15:00:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389362AbfISPAb (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 19 Sep 2019 11:00:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58606 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388350AbfISPAb (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 19 Sep 2019 11:00:31 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 86CCCA26660;
        Thu, 19 Sep 2019 15:00:31 +0000 (UTC)
Received: from localhost.localdomain.com (ovpn-12-76.pek2.redhat.com [10.72.12.76])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D4DAC5D713;
        Thu, 19 Sep 2019 15:00:29 +0000 (UTC)
From:   Zorro Lang <zlang@redhat.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH] common/xfs: wipe the XFS superblock of each AGs
Date:   Thu, 19 Sep 2019 23:00:24 +0800
Message-Id: <20190919150024.8346-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.6.2 (mx1.redhat.com [10.5.110.68]); Thu, 19 Sep 2019 15:00:31 +0000 (UTC)
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

Signed-off-by: Zorro Lang <zlang@redhat.com>
---
 common/rc  |  4 ++++
 common/xfs | 23 +++++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/common/rc b/common/rc
index 66c7fd4d..fe13f659 100644
--- a/common/rc
+++ b/common/rc
@@ -4048,6 +4048,10 @@ _try_wipe_scratch_devs()
 	for dev in $SCRATCH_DEV_POOL $SCRATCH_DEV $SCRATCH_LOGDEV $SCRATCH_RTDEV; do
 		test -b $dev && $WIPEFS_PROG -a $dev
 	done
+
+	if [ "$FSTYP" = "xfs" ];then
+		try_wipe_scratch_xfs
+	fi
 }
 
 # Only run this on xfs if xfs_scrub is available and has the unicode checker
diff --git a/common/xfs b/common/xfs
index 1bce3c18..34516f82 100644
--- a/common/xfs
+++ b/common/xfs
@@ -884,3 +884,26 @@ _xfs_mount_agcount()
 {
 	$XFS_INFO_PROG "$1" | grep agcount= | sed -e 's/^.*agcount=\([0-9]*\),.*$/\1/g'
 }
+
+# wipe the superblock of each XFS AGs
+try_wipe_scratch_xfs()
+{
+	local tmp=`mktemp -u`
+
+	_scratch_mkfs_xfs -N 2>/dev/null | perl -ne '
+		if (/^meta-data=.*\s+agcount=(\d+), agsize=(\d+) blks/) {
+			print STDOUT "agcount=$1\nagsize=$2\n";
+		}
+		if (/^data\s+=\s+bsize=(\d+)\s/) {
+			print STDOUT "dbsize=$1\n";
+		}' > $tmp.mkfs
+
+	. $tmp.mkfs
+	if [ -n "$agcount" -a -n "$agsize" -a -n "$dbsize" ];then
+		for ((i = 0; i < agcount; i++)); do
+			$XFS_IO_PROG -c "pwrite $((i * dbsize * agsize)) $dbsize" \
+				$SCRATCH_DEV >/dev/null;
+		done
+       fi
+       rm -f $tmp.mkfs
+}
-- 
2.20.1

