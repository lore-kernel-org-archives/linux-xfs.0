Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 02B787FC0
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 14:12:27 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CAD21304067
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 12:12:23 -0800 (PST)
Received: from mail-pb0-f74.google.com (mail-pb0-f74.google.com
	[209.85.160.74]) by cuda.sgi.com with ESMTP id UG0GojN2VAUAE5CF
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 10 Dec 2013 12:12:22 -0800 (PST)
Received: by mail-pb0-f74.google.com with SMTP id uo5so882390pbc.5
	for <xfs@oss.sgi.com>; Tue, 10 Dec 2013 12:12:22 -0800 (PST)
From: Junho Ryu <jayr@google.com>
Subject: [PATCH 10/10] xfstests: skip parts of tests which cannot work on tmpfs
Date: Tue, 10 Dec 2013 12:12:01 -0800
Message-Id: <1386706321-15795-11-git-send-email-jayr@google.com>
In-Reply-To: <1386706321-15795-1-git-send-email-jayr@google.com>
References: <1386706321-15795-1-git-send-email-jayr@google.com>
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
To: xfs@oss.sgi.com
Cc: tytso@mit.edu, hughd@google.com, branto@redhat.com, Junho Ryu <jayr@google.com>

Skip generic/076 which tests concurrent access while testing tmpfs
because there are other tests cover the case using fsstress.

Skip generic/277 which requires chattr.

Even if generic/053 will not be able to test exactly what the test has
been intended to test, it will be still useful to have this test to try
out some functionality on tmpfs rather than always failing or being
skipped.

Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Junho Ryu <jayr@google.com>
---
 tests/generic/053 | 6 +++---
 tests/generic/076 | 2 ++
 tests/generic/277 | 2 ++
 3 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/tests/generic/053 b/tests/generic/053
index b8bd9e6..885b87c 100755
--- a/tests/generic/053
+++ b/tests/generic/053
@@ -81,9 +81,9 @@ list_acls()
 
 echo "acls before repair:"
 list_acls
-_do 'unmount $SCRATCH_DEV' 'umount $SCRATCH_DEV'
-_do 'repair filesystem' '_check_scratch_fs'
-_do 'mount filesytem' '_scratch_mount'
+_do 'unmount $SCRATCH_DEV' '[ $FSTYP = tmpfs ] || umount $SCRATCH_DEV'
+_do 'repair filesystem' '[ $FSTYP = tmpfs ] || _check_scratch_fs'
+_do 'mount filesytem' '[ $FSTYP = tmpfs ] || _scratch_mount'
 echo "acls after repair: "
 list_acls
 
diff --git a/tests/generic/076 b/tests/generic/076
index a53840f..faeed2f 100755
--- a/tests/generic/076
+++ b/tests/generic/076
@@ -57,6 +57,8 @@ _supported_os IRIX Linux
 
 _require_scratch
 
+[ "$FSTYP" = "tmpfs" ] && _notrun "not applicable for the tmpfs file system"
+
 echo "*** init fs"
 
 rm -f $seqres.full
diff --git a/tests/generic/277 b/tests/generic/277
index 8461ad9..4672343 100755
--- a/tests/generic/277
+++ b/tests/generic/277
@@ -44,6 +44,8 @@ _supported_fs generic
 _supported_os Linux
 _require_scratch
 
+[ "$FSTYP" = "tmpfs" ] && _notrun "not applicable for the tmpfs file system"
+
 _scratch_mkfs > /dev/null 2>&1
 _scratch_mount
 
-- 
1.8.5.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
