Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 912B27CA0
	for <xfs@oss.sgi.com>; Wed, 16 Mar 2016 10:05:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 63A93304051
	for <xfs@oss.sgi.com>; Wed, 16 Mar 2016 08:05:27 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id v37k0ZOXP3HWG0kb (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 16 Mar 2016 08:05:23 -0700 (PDT)
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH v2] xfs/073: avoid finobt warning from mkfs
Date: Wed, 16 Mar 2016 23:04:44 +0800
Message-Id: <1458140684-4723-1-git-send-email-eguan@redhat.com>
In-Reply-To: <1458129204-31882-1-git-send-email-eguan@redhat.com>
References: <1458129204-31882-1-git-send-email-eguan@redhat.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: fstests@vger.kernel.org
Cc: Eryu Guan <eguan@redhat.com>, xfs@oss.sgi.com

When testing xfs/073 with MKFS_OPTIONS="-m crc=1,finobt=1" set, it fails
due to extra warning about disabling finobt feature:

 +warning: finobt not supported without CRC support, disabled.

Because xfs/073 disables crc unconditionally and finobt can not be
enabled either.

Fix it by explicitly disabling finobt as well.

Also remove all meta related mkfs options in _scratch_mkfs_xfs_opts() if
mkfs.xfs has no metadata support, not only the crc option. So that test
still passes on distros with such old binaries.

Suggested-by: Christoph Hellwig <hch@infradead.org>
Signed-off-by: Eryu Guan <eguan@redhat.com>
---

v2:
- disable finobt explicitly, instead of filtering the warning

 common/rc     | 4 ++--
 tests/xfs/073 | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/common/rc b/common/rc
index a34c387..73d2ea6 100644
--- a/common/rc
+++ b/common/rc
@@ -444,9 +444,9 @@ _scratch_mkfs_xfs_opts()
 {
 	mkfs_opts=$*
 
-	# remove crc related mkfs options if mkfs.xfs doesn't support v5 xfs
+	# remove metadata related mkfs options if mkfs.xfs doesn't them
 	if [ -n "$XFS_MKFS_HAS_NO_META_SUPPORT" ]; then
-		mkfs_opts=`echo $mkfs_opts | sed "s/-m\s\+crc=.//"`
+		mkfs_opts=`echo $mkfs_opts | sed "s/-m\s\+\S\+//g"`
 	fi
 
 	_scratch_options mkfs
diff --git a/tests/xfs/073 b/tests/xfs/073
index e1335df..e2c1af3 100755
--- a/tests/xfs/073
+++ b/tests/xfs/073
@@ -138,7 +138,7 @@ _require_loop
 
 rm -f $seqres.full
 
-_scratch_mkfs_xfs -m crc=0 -dsize=41m,agcount=2 | _filter_mkfs 2>/dev/null
+_scratch_mkfs_xfs -m crc=0,finobt=0 -dsize=41m,agcount=2 | _filter_mkfs 2>/dev/null
 _scratch_mount 2>/dev/null || _fail "initial scratch mount failed"
 
 echo
-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
