Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id F17CA7F62
	for <xfs@oss.sgi.com>; Tue,  2 Sep 2014 09:22:48 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id D2987304039
	for <xfs@oss.sgi.com>; Tue,  2 Sep 2014 07:22:45 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id bTAHBgOq5Qi9QJcB (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 02 Sep 2014 07:22:44 -0700 (PDT)
From: Brian Foster <bfoster@redhat.com>
Subject: [PATCH 0/2] xfs buf I/O error race test
Date: Tue,  2 Sep 2014 10:22:39 -0400
Message-Id: <1409667761-50248-1-git-send-email-bfoster@redhat.com>
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

Here's a complete test for the XFS buf I/O error race problem reported
by Alex. An incomplete rfc of this test was previously posted here:

http://oss.sgi.com/archives/xfs/2014-08/msg00261.html

This version utilizes the recently posted log recovery delay mechanism.
As such, this test only runs on kernels compiled with XFS debug support.
The first patch updates the generic require sysfs helper to support
global (i.e., non-device specific) sysfs attributes.

Brian

v1:
- Use the log recovery delay mechanism to coordinate I/O failures with
  log recovery.
rfc: http://oss.sgi.com/archives/xfs/2014-08/msg00261.html

Brian Foster (2):
  xfstests/common: don't assume sysfs attrs all reside under test dev
  xfs/051: test buffer use after free race on I/O failure in XFS log
    recovery

 common/rc         |  3 +-
 tests/xfs/011     |  2 +-
 tests/xfs/051     | 95 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/xfs/051.out |  2 ++
 tests/xfs/group   |  1 +
 5 files changed, 100 insertions(+), 3 deletions(-)
 create mode 100755 tests/xfs/051
 create mode 100644 tests/xfs/051.out

-- 
1.8.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
