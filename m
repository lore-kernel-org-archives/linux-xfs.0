Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 80A0B7F37
	for <xfs@oss.sgi.com>; Wed, 25 Nov 2015 14:19:54 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 1F194AC003
	for <xfs@oss.sgi.com>; Wed, 25 Nov 2015 12:19:54 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id vQF9GocT4ugxCiA4 (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 25 Nov 2015 12:19:53 -0800 (PST)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 0/2] xfstests: xfsprogs logformat tests
Date: Wed, 25 Nov 2015 15:19:48 -0500
Message-Id: <1448482790-44469-1-git-send-email-bfoster@redhat.com>
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
Cc: xfs@oss.sgi.com

Hi all,

Here are a couple prospective tests that use the recently posted xfs_db
logformat command:

  http://oss.sgi.com/pipermail/xfs/2015-November/045139.html

Note that these should not be merged until xfs_db logformat support is
fully reviewed and merged into xfsprogs. Also note that the test numbers
are arbitrarily high and should be renumbered.

Patch 1 adds a test that uses xfs_logprint to verify that logformat
formats the log correctly with various stripe unit alignments. Patch 2
uses the logformat command to test invalid metadata LSN detection and
recovery. Thoughts, reviews, flames appreciated.

Brian

Brian Foster (2):
  tests/xfs: test xfsprogs log formatting infrastructure
  tests/xfs: verify invalid metadata LSN detection

 common/rc         | 14 +++++++++
 tests/xfs/376     | 71 +++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/376.out |  6 ++++
 tests/xfs/377     | 90 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/377.out |  3 ++
 tests/xfs/group   |  2 ++
 6 files changed, 186 insertions(+)
 create mode 100755 tests/xfs/376
 create mode 100644 tests/xfs/376.out
 create mode 100755 tests/xfs/377
 create mode 100644 tests/xfs/377.out

-- 
2.1.0

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
