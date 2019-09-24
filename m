Return-Path: <SRS0=ckLY=XT=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7C65C432C1
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Sep 2019 10:09:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A4729214AF
	for <linux-xfs@archiver.kernel.org>; Tue, 24 Sep 2019 10:09:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730034AbfIXKJ0 (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 24 Sep 2019 06:09:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52824 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725884AbfIXKJ0 (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 24 Sep 2019 06:09:26 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B5B832DA981;
        Tue, 24 Sep 2019 10:09:25 +0000 (UTC)
Received: from dhcp-12-171.nay.redhat.com (dhcp-12-171.nay.redhat.com [10.66.12.171])
        by smtp.corp.redhat.com (Postfix) with ESMTP id ADA5D578F;
        Tue, 24 Sep 2019 10:09:24 +0000 (UTC)
From:   Zorro Lang <zlang@redhat.com>
To:     fstests@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org
Subject: [PATCH v3] common/xfs: wipe the XFS superblock of each AGs
Date:   Tue, 24 Sep 2019 18:09:19 +0800
Message-Id: <20190924100919.28242-1-zlang@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.29]); Tue, 24 Sep 2019 10:09:25 +0000 (UTC)
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

So I try to wipe each XFS superblock if there's a XFS ondisk, then
try to erase superblock of each XFS AG by default mkfs.xfs geometry.
Thanks Darrick J. Wong helped to analyze this issue.

Reported-by: Yang Xu <xuyang2018.jy@cn.fujitsu.com>
Signed-off-by: Zorro Lang <zlang@redhat.com>
---

Hi,

All changes in V3 is under:
# Try to wipe each SB by default mkfs.xfs geometry
...
...

Thanks,
Zorro

 common/rc  |  8 ++++++++
 common/xfs | 40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 48 insertions(+)

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
index 1bce3c18..706ddf85 100644
--- a/common/xfs
+++ b/common/xfs
@@ -884,3 +884,43 @@ _xfs_mount_agcount()
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
+	# Try to wipe each SB if there's an existed XFS
+	agcount=`_scratch_xfs_get_sb_field agcount 2>/dev/null`
+	agsize=`_scratch_xfs_get_sb_field agblocks 2>/dev/null`
+	dbsize=`_scratch_xfs_get_sb_field blocksize 2>/dev/null`
+	if [[ $agcount =~ $num && $agsize =~ $num && $dbsize =~ $num ]];then
+		for ((i = 0; i < agcount; i++)); do
+			$XFS_IO_PROG -c "pwrite $((i * dbsize * agsize)) $dbsize" \
+				$SCRATCH_DEV >/dev/null;
+		done
+	fi
+
+	# Try to wipe each SB by default mkfs.xfs geometry
+	local tmp=`mktemp -u`
+	unset agcount agsize dbsize
+	_scratch_mkfs_xfs -N 2>/dev/null | perl -ne '
+		if (/^meta-data=.*\s+agcount=(\d+), agsize=(\d+) blks/) {
+			print STDOUT "agcount=$1\nagsize=$2\n";
+		}
+		if (/^data\s+=\s+bsize=(\d+)\s/) {
+			print STDOUT "dbsize=$1\n";
+		}' > $tmp.mkfs
+
+	. $tmp.mkfs
+	if [[ $agcount =~ $num && $agsize =~ $num && $dbsize =~ $num ]];then
+		for ((i = 0; i < agcount; i++)); do
+			$XFS_IO_PROG -c "pwrite $((i * dbsize * agsize)) $dbsize" \
+				$SCRATCH_DEV >/dev/null;
+		done
+	fi
+	rm -f $tmp.mkfs
+}
-- 
2.20.1

