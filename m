Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id EF7DF7F4E
	for <xfs@oss.sgi.com>; Thu,  8 Aug 2013 03:17:26 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id CF6FB304064
	for <xfs@oss.sgi.com>; Thu,  8 Aug 2013 01:17:26 -0700 (PDT)
Received: from xp-ob.rzone.de (xp-ob.rzone.de [81.169.146.136]) by
	cuda.sgi.com with ESMTP id CqlxE9GHE0xhA1VE (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 08 Aug 2013 01:17:24 -0700 (PDT)
From: Jan Schmidt <list.xfs@jan-o-sch.net>
Subject: [PATCH v3 0/2] xfstest btrfs/316: test send / receive
Date: Thu,  8 Aug 2013 10:17:11 +0200
Message-Id: <1375949833-1104-1-git-send-email-list.xfs@jan-o-sch.net>
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
Cc: sbehrens@giantdisaster.de, linux-btrfs@vger.kernel.org

These two patches add the announced tests for btrfs send / receive. As
requested, the fssum tool is now included.

One drawback is that I'm unable to edit configure.ac or whatever needs
to be modified in an autotools preferred way. Any hints appreciated,
preferrably hints containing all the modifications required to introduce
something like HAVE_SEEK_HOLE.

I do not want to make modifications to fssum.c here, if that's
absolutely required (because one /could/ get along using linux/fs.h,
which is not the way I would like to go), I'd like to have that changed
in the far-progs repository where fssum.c comes from as well.

--
v1->v2:
 - included fssum
 - test number is now 316 (was 314)
v2->v3:
 - added missing -lcrypto to build fssum
 - removed obsolete change in README now that fssum is included
 - fixed comment in test/btrfs/316's header (314 -> 316)

Jan Schmidt (2):
  xfstests: add fssum tool
  xfstests btrfs/316: test send / receive

 .gitignore          |    1 +
 common/config       |    2 +
 src/Makefile        |   11 +-
 src/fssum.c         |  819 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/316     |  113 +++++++
 tests/btrfs/316.out |    4 +
 tests/btrfs/group   |    1 +
 7 files changed, 950 insertions(+), 1 deletions(-)
 create mode 100644 src/fssum.c
 create mode 100755 tests/btrfs/316
 create mode 100644 tests/btrfs/316.out

-- 
1.7.2.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
