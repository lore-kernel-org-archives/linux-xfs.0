Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 6909C7F53
	for <xfs@oss.sgi.com>; Mon, 14 Dec 2015 17:41:11 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 566F48F8035
	for <xfs@oss.sgi.com>; Mon, 14 Dec 2015 15:41:08 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id CM9LsSjg9I51weYY (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Mon, 14 Dec 2015 15:41:07 -0800 (PST)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id 7EE12C803
	for <xfs@oss.sgi.com>; Mon, 14 Dec 2015 23:41:06 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [XFSTESTS v3 0/6] Richacl tests
Date: Tue, 15 Dec 2015 00:40:56 +0100
Message-Id: <1450136462-11521-1-git-send-email-agruenba@redhat.com>
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

Here is an updated version that adds generic/178 which runs all of the richacl
tests on a scratch richacl filesystem.  On filesystems and kernels without
richacl support, generic/178 will be skipped.

Previous posting: http://oss.sgi.com/archives/xfs/2015-12/msg00178.html

Andreas Gruenbacher (6):
  check: Don't complain about missing tests/$FSTYP/group
  check: Enforce xfs filesystem recreation on $TEST_DEV
  Rename output file templates to match TEST.out*
  check: Add support for tests without *.out files
  generic/178: Add richacl tests
  Remove the obsolete nfs4acl tests

 .gitignore                   |  16 +++
 Makefile                     |   2 +-
 check                        |  79 +++++++----
 common/rc                    |  33 +++++
 nfs4acl/Makefile             |  29 ----
 nfs4acl/apply-mask.test      | 143 -------------------
 nfs4acl/basic.test           |  70 ----------
 nfs4acl/chmod.test           |  31 -----
 nfs4acl/chown.test           |  63 ---------
 nfs4acl/computed-mode.test   |  62 ---------
 nfs4acl/create.test          |  35 -----
 nfs4acl/ctime.test           |  36 -----
 nfs4acl/delete.test          |  77 ----------
 nfs4acl/run                  | 298 ---------------------------------------
 nfs4acl/unrepresentable.test |  20 ---
 nfs4acl/write-vs-append.test |  46 ------
 richacl/Makefile             |  23 +++
 richacl/apply-masks          | 163 ++++++++++++++++++++++
 richacl/auto-inheritance     | 191 +++++++++++++++++++++++++
 richacl/basic                |  97 +++++++++++++
 richacl/chmod                |  40 ++++++
 richacl/chown                |  42 ++++++
 richacl/create               |  36 +++++
 richacl/ctime                |  35 +++++
 richacl/delete               |  89 ++++++++++++
 richacl/setrichacl-modify    |  57 ++++++++
 richacl/test-lib.sh          | 154 ++++++++++++++++++++
 richacl/write-vs-append      |  54 ++++++++
 tests/generic/178            |  77 ++++++++++
 tests/generic/group          |   1 +
 tests/xfs/033                |   2 +-
 tests/xfs/033.crc.out.linux  | 197 --------------------------
 tests/xfs/033.out.crc.linux  | 197 ++++++++++++++++++++++++++
 tests/xfs/096                |   4 +-
 tests/xfs/096.external       |  50 -------
 tests/xfs/096.internal       |  51 -------
 tests/xfs/096.out.external   |  50 +++++++
 tests/xfs/096.out.internal   |  51 +++++++
 tests/xfs/191                |  75 ----------
 tests/xfs/191.out            | 324 -------------------------------------------
 tests/xfs/group              |   1 -
 41 files changed, 1462 insertions(+), 1639 deletions(-)
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
 create mode 100644 richacl/Makefile
 create mode 100755 richacl/apply-masks
 create mode 100755 richacl/auto-inheritance
 create mode 100755 richacl/basic
 create mode 100755 richacl/chmod
 create mode 100755 richacl/chown
 create mode 100755 richacl/create
 create mode 100755 richacl/ctime
 create mode 100755 richacl/delete
 create mode 100755 richacl/setrichacl-modify
 create mode 100644 richacl/test-lib.sh
 create mode 100755 richacl/write-vs-append
 create mode 100755 tests/generic/178
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
