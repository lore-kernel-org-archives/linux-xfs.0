Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8D9317F6A
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 12:24:46 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 112B1AC001
	for <xfs@oss.sgi.com>; Tue, 13 Aug 2013 10:24:42 -0700 (PDT)
Received: from xp-ob.rzone.de (xp-ob.rzone.de [81.169.146.139]) by
	cuda.sgi.com with ESMTP id OrWB5Hyl0oaGIuLL (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 13 Aug 2013 10:24:40 -0700 (PDT)
From: Jan Schmidt <list.xfs@jan-o-sch.net>
Subject: [PATCH v4 0/2] xfstest btrfs/316: test send / receive
Date: Tue, 13 Aug 2013 19:24:16 +0200
Message-Id: <1376414658-4563-1-git-send-email-list.xfs@jan-o-sch.net>
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
Cc: sandeen@sandeen.net, sbehrens@giantdisaster.de, linux-btrfs@vger.kernel.org

These two patches add the announced tests for btrfs send / receive. As
requested, the fssum tool is now included.

--
v1->v2:
 - included fssum
 - test number is now 316 (was 314)
v2->v3:
 - added missing -lcrypto to build fssum
 - removed obsolete change in README now that fssum is included
 - fixed comment in test/btrfs/316's header (314 -> 316)
v3->v4:
 - build fssum with help of autotools only if libssl is available
 - removed clumsy OPT_TARGETS in src/Makefile
 - added #define directives for SEEK_DATA and SEEK_HOLE to fssum.c

Jan Schmidt (2):
  xfstests: add fssum tool
  xfstests btrfs/316: test send / receive

 .gitignore           |    1 +
 aclocal.m4           |    1 +
 configure.ac         |    1 +
 include/builddefs.in |    1 +
 m4/Makefile          |    1 +
 m4/package_ssldev.m4 |    4 +
 src/Makefile         |    8 +
 src/fssum.c          |  828 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/316      |  116 +++++++
 tests/btrfs/316.out  |    4 +
 tests/btrfs/group    |    1 +
 11 files changed, 966 insertions(+), 0 deletions(-)
 create mode 100644 m4/package_ssldev.m4
 create mode 100644 src/fssum.c
 create mode 100755 tests/btrfs/316
 create mode 100644 tests/btrfs/316.out

-- 
1.7.2.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
