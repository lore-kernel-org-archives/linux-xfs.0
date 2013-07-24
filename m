Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1D15A7F3F
	for <xfs@oss.sgi.com>; Wed, 24 Jul 2013 10:07:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id F0F8F8F8059
	for <xfs@oss.sgi.com>; Wed, 24 Jul 2013 08:07:45 -0700 (PDT)
Received: from xp-ob.rzone.de (xp-ob.rzone.de [81.169.146.137]) by
	cuda.sgi.com with ESMTP id CtENPWbKNIQX2VFZ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Wed, 24 Jul 2013 08:07:44 -0700 (PDT)
From: Jan Schmidt <list.xfs@jan-o-sch.net>
Subject: [PATCH v2 0/2] xfstest btrfs/316: test send / receive (was: btrfs/314)
Date: Wed, 24 Jul 2013 17:07:27 +0200
Message-Id: <1374678449-21780-1-git-send-email-list.xfs@jan-o-sch.net>
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

From: root <root@zarzz.(none)>

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

Jan Schmidt (2):
  xfstests: add fssum tool
  xfstests btrfs/316: test send / receive

 .gitignore          |    1 +
 README              |    3 +
 common/config       |    2 +
 src/Makefile        |   11 +-
 src/fssum.c         |  819 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/316     |  113 +++++++
 tests/btrfs/316.out |    4 +
 tests/btrfs/group   |    1 +
 8 files changed, 953 insertions(+), 1 deletions(-)
 create mode 100644 src/fssum.c
 create mode 100755 tests/btrfs/316
 create mode 100644 tests/btrfs/316.out

-- 
1.7.2.5

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
