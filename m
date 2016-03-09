Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3D29F7CA0
	for <xfs@oss.sgi.com>; Wed,  9 Mar 2016 06:06:47 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id E5444304039
	for <xfs@oss.sgi.com>; Wed,  9 Mar 2016 04:06:43 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id Vps4OmIixXKPXewv (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 09 Mar 2016 04:06:42 -0800 (PST)
Received: from int-mx11.intmail.prod.int.phx2.redhat.com
	(int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
	by mx1.redhat.com (Postfix) with ESMTPS id A486B6315B
	for <xfs@oss.sgi.com>; Wed,  9 Mar 2016 12:06:42 +0000 (UTC)
From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [XFSTESTS v4 0/4] Richacl tests
Date: Wed,  9 Mar 2016 13:06:34 +0100
Message-Id: <1457525199-15355-1-git-send-email-agruenba@redhat.com>
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

Hello,

here is a new version of the richacl tests. According to feedback from the
previous posting (http://oss.sgi.com/archives/xfs/2015-12/msg00316.html), each
of the richacl tests is not run separately, on a new scratch filesystem.

Thanks,
Andreas

Andreas Gruenbacher (4):
  Rename output file templates to match TEST.out*
  check: Add support for tests without *.out files
  xfs/191: Remove obsolete nfs4acl tests
  Add richacl tests

 .gitignore                          |  19 +++
 Makefile                            |   2 +-
 check                               |  77 ++++++---
 common/rc                           |  36 ++++
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
 richacl/Makefile                    |  23 +++
 richacl/apply-masks                 | 163 ++++++++++++++++++
 richacl/auto-inheritance            | 191 +++++++++++++++++++++
 richacl/basic                       |  97 +++++++++++
 richacl/chmod                       |  40 +++++
 richacl/chown                       |  42 +++++
 richacl/create                      |  36 ++++
 richacl/ctime                       |  35 ++++
 richacl/delete                      |  89 ++++++++++
 richacl/setrichacl-modify           |  57 +++++++
 richacl/test-lib.sh                 | 154 +++++++++++++++++
 richacl/write-vs-append             |  54 ++++++
 tests/generic/338                   |  67 ++++++++
 tests/generic/339-apply-masks       |   1 +
 tests/generic/340-auto-inheritance  |   1 +
 tests/generic/341-basic             |   1 +
 tests/generic/342-chmod             |   1 +
 tests/generic/343-chown             |   1 +
 tests/generic/344-create            |   1 +
 tests/generic/345-ctime             |   1 +
 tests/generic/346-delete            |   1 +
 tests/generic/347-setrichacl-modify |   1 +
 tests/generic/348-write-vs-append   |   1 +
 tests/generic/group                 |  10 ++
 tests/xfs/096                       |   4 +-
 tests/xfs/096.external              |  50 ------
 tests/xfs/096.internal              |  51 ------
 tests/xfs/096.out.external          |  50 ++++++
 tests/xfs/096.out.internal          |  51 ++++++
 tests/xfs/191                       |  75 ---------
 tests/xfs/191.out                   | 324 ------------------------------------
 tests/xfs/group                     |   1 -
 48 files changed, 1277 insertions(+), 1441 deletions(-)
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
 create mode 100755 tests/generic/338
 create mode 120000 tests/generic/339-apply-masks
 create mode 120000 tests/generic/340-auto-inheritance
 create mode 120000 tests/generic/341-basic
 create mode 120000 tests/generic/342-chmod
 create mode 120000 tests/generic/343-chown
 create mode 120000 tests/generic/344-create
 create mode 120000 tests/generic/345-ctime
 create mode 120000 tests/generic/346-delete
 create mode 120000 tests/generic/347-setrichacl-modify
 create mode 120000 tests/generic/348-write-vs-append
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
