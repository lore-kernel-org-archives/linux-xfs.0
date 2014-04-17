Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 262077F56
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 23:17:06 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id AEC62AC001
	for <xfs@oss.sgi.com>; Wed, 16 Apr 2014 21:17:02 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id yyaJGqOM98eczHBA for
	<xfs@oss.sgi.com>; Wed, 16 Apr 2014 21:17:01 -0700 (PDT)
Received: from int-mx09.intmail.prod.int.phx2.redhat.com
	(int-mx09.intmail.prod.int.phx2.redhat.com [10.5.11.22])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id s3H4H0eH023843
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256
	verify=OK) for <xfs@oss.sgi.com>; Thu, 17 Apr 2014 00:17:00 -0400
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH 1/3] common: set _fs_has_crcs=0 as default in _filter_mkfs()
Date: Thu, 17 Apr 2014 12:16:52 +0800
Message-Id: <1397708214-8197-1-git-send-email-eguan@redhat.com>
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
Cc: Eryu Guan <eguan@redhat.com>

xfsprogs without crc support won't print crc=0/crc=1, so
_filter_mkfs() leaves _fs_has_crcs variable unset, and xfs/033 fails
because of that.

xfs/033 4s ... - output mismatch (see /root/xfstests/results//xfs/033.out.bad)
    --- tests/xfs/033.out       2014-04-16 22:31:49.818350450 -0400
    +++ /root/xfstests/results//xfs/033.out.bad 2014-04-16 22:35:08.264401190 -0400
    @@ -5,6 +5,7 @@
     naming   =VERN bsize=XXX
     log      =LDEV bsize=XXX blocks=XXX
     realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
    +./tests/xfs/033: line 87: [: -eq: unary operator expected
     Corrupting root inode - setting bits to 0
     Wrote X.XXKb (value 0x0)
     Phase 1 - find and verify superblock...

Print _fs_has_crcs=0 to stderr by default, so old xfsprogs could have
this variable set too, and a latter _fs_has_crcs=1 could overwrite it
if the fs does have crc support.

Signed-off-by: Eryu Guan <eguan@redhat.com>
---
 common/filter | 1 +
 1 file changed, 1 insertion(+)

diff --git a/common/filter b/common/filter
index a7d2aa9..05dbae6 100644
--- a/common/filter
+++ b/common/filter
@@ -143,6 +143,7 @@ _filter_mkfs()
 	return ;;
     esac
 
+    echo "_fs_has_crcs=0" >&2
     set -
     perl -ne '
     if (/^meta-data=([\w,|\/.-]+)\s+isize=(\d+)\s+agcount=(\d+), agsize=(\d+) blks/) {
-- 
1.9.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
