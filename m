Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id A56DE7F37
	for <xfs@oss.sgi.com>; Wed, 18 Nov 2015 08:17:57 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 5490DAC003
	for <xfs@oss.sgi.com>; Wed, 18 Nov 2015 06:17:57 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id FCytPUeyFybRpjED (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 18 Nov 2015 06:17:53 -0800 (PST)
Received: from int-mx10.intmail.prod.int.phx2.redhat.com
	(int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (Postfix) with ESMTPS id DF296C00230B
	for <xfs@oss.sgi.com>; Wed, 18 Nov 2015 14:17:52 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [XFSTESTS 0/6] Richacl Tests
Date: Wed, 18 Nov 2015 15:17:43 +0100
Message-Id: <1447856269-7872-1-git-send-email-agruenba@redhat.com>
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
Cc: Andreas Gruenbacher <agruenba@redhat.com>

Here is a first set of patches for adding richacl tests to xfstexts.
The richacl tests are different from the other xfstests in that they are
self verifying: they report success or failure through their exit code
and don't have expected output files (*.out).

Thanks,
Andreas

Andreas Gruenbacher (6):
  check: Don't complain about missing tests/$FSTYP/group
  check: Enforce xfs filesystem recreation on $TEST_DEV
  Rename output file templates to match TEST.out*
  check: Add support for tests without *.out files
  Add richacl tests
  Remove the obsolete nfs4acl tests

 .gitignore                          |  17 ++
 check                               | 118 +++++++++----
 common/rc                           |  24 ++-
 nfs4acl/Makefile                    |  29 ----
 nfs4acl/apply-mask.test             | 143 ----------------
 nfs4acl/basic.test                  |  70 --------
 nfs4acl/chmod.test                  |  31 ----
 nfs4acl/chown.test                  |  63 -------
 nfs4acl/computed-mode.test          |  62 -------
 nfs4acl/create.test                 |  35 ----
 nfs4acl/ctime.test                  |  36 ----
 nfs4acl/delete.test                 |  77 ---------
 nfs4acl/run                         | 298 ---------------------------------
 nfs4acl/unrepresentable.test        |  20 ---
 nfs4acl/write-vs-append.test        |  46 -----
 src/Makefile                        |   2 +-
 src/require-richacls.c              |  35 ++++
 tests/richacl/001-apply-masks       |   1 +
 tests/richacl/002-auto-inheritance  |   1 +
 tests/richacl/003-basic             |   1 +
 tests/richacl/004-chmod             |   1 +
 tests/richacl/005-chown             |   1 +
 tests/richacl/006-create            |   1 +
 tests/richacl/007-ctime             |   1 +
 tests/richacl/008-delete            |   1 +
 tests/richacl/009-setrichacl-modify |   1 +
 tests/richacl/010-write-vs-append   |   1 +
 tests/richacl/Makefile              |  44 +++++
 tests/richacl/apply-masks           | 163 ++++++++++++++++++
 tests/richacl/auto-inheritance      | 191 +++++++++++++++++++++
 tests/richacl/basic                 |  97 +++++++++++
 tests/richacl/chmod                 |  40 +++++
 tests/richacl/chown                 |  42 +++++
 tests/richacl/create                |  36 ++++
 tests/richacl/ctime                 |  35 ++++
 tests/richacl/delete                |  89 ++++++++++
 tests/richacl/group                 |  15 ++
 tests/richacl/setrichacl-modify     |  57 +++++++
 tests/richacl/test-lib.sh           | 149 +++++++++++++++++
 tests/richacl/write-vs-append       |  54 ++++++
 tests/xfs/033                       |   2 +-
 tests/xfs/033.crc.out.linux         | 197 ----------------------
 tests/xfs/033.out.crc.linux         | 197 ++++++++++++++++++++++
 tests/xfs/096                       |   4 +-
 tests/xfs/096.external              |  50 ------
 tests/xfs/096.internal              |  51 ------
 tests/xfs/096.out.external          |  50 ++++++
 tests/xfs/096.out.internal          |  51 ++++++
 tests/xfs/191                       |  75 ---------
 tests/xfs/191.out                   | 324 ------------------------------------
 tests/xfs/group                     |   1 -
 51 files changed, 1485 insertions(+), 1645 deletions(-)
 delete mode 100644 nfs4acl/Makefile
 delete mode 100644 nfs4acl/apply-mask.test
 delete mode 100644 nfs4acl/basic.test
 delete mode 100644 nfs4acl/chmod.test
 delete mode 100644 nfs4acl/chown.test
 delete mode 100644 nfs4acl/computed-mode.test
 delete mode 100644 nfs4acl/create.test
 delete mode 100644 nfs4acl/ctime.test
 delete mode 100644 nfs4acl/delete.test
 delete mode 100755 nfs4acl/run
 delete mode 100644 nfs4acl/unrepresentable.test
 delete mode 100644 nfs4acl/write-vs-append.test
 create mode 100644 src/require-richacls.c
 create mode 120000 tests/richacl/001-apply-masks
 create mode 120000 tests/richacl/002-auto-inheritance
 create mode 120000 tests/richacl/003-basic
 create mode 120000 tests/richacl/004-chmod
 create mode 120000 tests/richacl/005-chown
 create mode 120000 tests/richacl/006-create
 create mode 120000 tests/richacl/007-ctime
 create mode 120000 tests/richacl/008-delete
 create mode 120000 tests/richacl/009-setrichacl-modify
 create mode 120000 tests/richacl/010-write-vs-append
 create mode 100644 tests/richacl/Makefile
 create mode 100755 tests/richacl/apply-masks
 create mode 100755 tests/richacl/auto-inheritance
 create mode 100755 tests/richacl/basic
 create mode 100755 tests/richacl/chmod
 create mode 100755 tests/richacl/chown
 create mode 100755 tests/richacl/create
 create mode 100755 tests/richacl/ctime
 create mode 100755 tests/richacl/delete
 create mode 100644 tests/richacl/group
 create mode 100755 tests/richacl/setrichacl-modify
 create mode 100644 tests/richacl/test-lib.sh
 create mode 100755 tests/richacl/write-vs-append
 delete mode 100644 tests/xfs/033.crc.out.linux
 create mode 100644 tests/xfs/033.out.crc.linux
 delete mode 100644 tests/xfs/096.external
 delete mode 100644 tests/xfs/096.internal
 create mode 100644 tests/xfs/096.out.external
 create mode 100644 tests/xfs/096.out.internal
 delete mode 100755 tests/xfs/191
 delete mode 100644 tests/xfs/191.out

-- 
2.5.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
