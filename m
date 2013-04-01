Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 1C33B29DFE
	for <xfs@oss.sgi.com>; Mon,  1 Apr 2013 05:57:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id EB5168F8033
	for <xfs@oss.sgi.com>; Mon,  1 Apr 2013 03:57:56 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id T1cui4zZa5VeIwHc for
	<xfs@oss.sgi.com>; Mon, 01 Apr 2013 03:57:56 -0700 (PDT)
Received: from int-mx02.intmail.prod.int.phx2.redhat.com
	(int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r31Avt3l011182
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <xfs@oss.sgi.com>; Mon, 1 Apr 2013 06:57:56 -0400
From: Eryu Guan <eguan@redhat.com>
Subject: [PATCH 0/4] xfstests: random regression tests
Date: Mon,  1 Apr 2013 18:57:40 +0800
Message-Id: <1364813864-10820-1-git-send-email-eguan@redhat.com>
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

308 and 309 are actually at version 3, revised after the re-factor.
Posts for version 2 are:
http://oss.sgi.com/archives/xfs/2013-03/msg00746.html
http://oss.sgi.com/archives/xfs/2013-03/msg00747.html

310 and 311 are new test cases.

I keep the NNN test name and make the seq number unique across different
test types.

All comments are appreciated.

Thanks,
Eryu Guan

Eryu Guan (4):
  xfstests generic 308: check ctime updates for setfacl
  xfstests generic 309: test write to the last block of max file size on
    ext4
  xfstests ext4 310: test read /proc/fs/ext4/<dev>/mb_groups while the
    fs is being unmounted
  xfstests generic 311: test dir mtime and ctime are updated on rename

 tests/ext4/310        | 74 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/ext4/310.out    |  2 ++
 tests/ext4/group      |  2 +-
 tests/generic/308     | 79 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/308.out |  2 ++
 tests/generic/309     | 69 ++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/309.out |  2 ++
 tests/generic/311     | 74 +++++++++++++++++++++++++++++++++++++++++++++++
 tests/generic/311.out |  2 ++
 tests/generic/group   |  3 ++
 10 files changed, 308 insertions(+), 1 deletion(-)
 create mode 100644 tests/ext4/310
 create mode 100644 tests/ext4/310.out
 create mode 100644 tests/generic/308
 create mode 100644 tests/generic/308.out
 create mode 100644 tests/generic/309
 create mode 100644 tests/generic/309.out
 create mode 100644 tests/generic/311
 create mode 100644 tests/generic/311.out

-- 
1.8.1.4

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
