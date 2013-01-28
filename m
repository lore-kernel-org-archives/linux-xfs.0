Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 227C97F4C
	for <xfs@oss.sgi.com>; Mon, 28 Jan 2013 01:20:25 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 106F98F8050
	for <xfs@oss.sgi.com>; Sun, 27 Jan 2013 23:20:22 -0800 (PST)
Received: from mail-pa0-f50.google.com (mail-pa0-f50.google.com
	[209.85.220.50]) by cuda.sgi.com with ESMTP id FEThJ07bFk0Hxu3b
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 27 Jan 2013 23:20:21 -0800 (PST)
Received: by mail-pa0-f50.google.com with SMTP id hz10so1347279pad.37
	for <xfs@oss.sgi.com>; Sun, 27 Jan 2013 23:20:20 -0800 (PST)
From: Zheng Liu <gnehzuil.liu@gmail.com>
Subject: [PATCH 0/4] xfstests: seek data/hole and hole punching improvements
Date: Mon, 28 Jan 2013 15:32:47 +0800
Message-Id: <1359358371-21411-1-git-send-email-wenqing.lz@taobao.com>
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
To: xfs@oss.sgi.com, linux-ext4@vger.kernel.org
Cc: Theodore Ts'o <tytso@mit.edu>, Zheng Liu <wenqing.lz@taobao.com>

Hi all,

Here is my first try to improve seek data/hole and hole punching test
cases in xfstests.  The key issue in 255 and 285 is that they assume that
all file systems that are tested support unwritten extent preallocation.
Before 3.8 kernel it is correct.  But now ext4 file system has ability
to seek data/hole and punch a hole for a file w/o unwritten extent.  So
it is time to improve these test cases.

In this patch series it calls _require_xfs_io_falloc in 255 and 285 to
make sure that unwritten extent is supprted by tested file system.  A
new argument '-t' is added into seek_sanity_test to check a file system
that supports seek data/hole or not.  In the mean time _require_seek_data_hole
is defined to be used by all tests.

Further two new test cases are created to test seek data/hole and hole
punching w/o unwritten extent, which do the same thing like 255 and 285
except that they don't do some test cases which are related to unwritten
extent.

Any comments or feedbacks are welcome.

Thanks,
						- Zheng

Zheng Liu (4):
  xfstests: check unwritten extent preallocation in 255
  xfstests: 295: test fallocate hole punching for all file systems
  xfstests: check llseek(2) SEEK_DATA/HOLE and unwritten extent
    preallocation in 285
  xfstests: 296: add a seek data/hole test w/o unwritten extent

 255                    |   3 +-
 285                    |   7 +-
 295                    |  68 +++++++++++
 295.out                | 307 +++++++++++++++++++++++++++++++++++++++++++++++++
 296                    |  57 +++++++++
 296.out                |   1 +
 common.rc              |  12 ++
 group                  |   2 +
 src/seek_sanity_test.c |  46 ++++++--
 9 files changed, 491 insertions(+), 12 deletions(-)
 mode change 100644 => 100755 285
 create mode 100755 295
 create mode 100644 295.out
 create mode 100755 296
 create mode 100644 296.out

-- 
1.7.12.rc2.18.g61b472e

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
