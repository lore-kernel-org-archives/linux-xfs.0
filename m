Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA336Xkv223464 for <xfs@oss.sgi.com>; Wed, 2 Nov 2011 22:06:34 -0500
Received: from song.cn.fujitsu.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 3EF2E1000B26
	for <xfs@oss.sgi.com>; Wed,  2 Nov 2011 20:06:31 -0700 (PDT)
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id 5czU2twXUzVRxwOF for
	<xfs@oss.sgi.com>; Wed, 02 Nov 2011 20:06:31 -0700 (PDT)
Message-ID: <4EB20505.7070005@cn.fujitsu.com>
Date: Thu, 03 Nov 2011 11:05:41 +0800
From: WuBo <wu.bo@cn.fujitsu.com>
MIME-Version: 1.0
Subject: [PATCH 0/3] xfstests: Add a group of reservation space test
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: linux-fsdevel@vger.kernel.org, Linux Btrfs <linux-btrfs@vger.kernel.org>, xfs@oss.sgi.com

This patch set add a group of reservation space test. Especailly for btrfs.
It includes three parts: copy workload, prealloc and write posix.

For test 264, I hope it's usefull for Josef's reserve improve work.
For test 265 and 266, the current btrfs is not pass yet.

TO avoid fill the huge disk, I just resize the filesystem size which NOT 
all filesystems supportted. Here I just make these tests support btrfs only,
but it's can ream to ext3/4 if needed.

Wu Bo (3):
  xfstests 264: add a copy and reserve test
  xfstests 265: add a prealloc and reserve test
  xfstests 266: add a write and reserve test

 264     |  158 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 264.out |    6 ++
 265     |  107 ++++++++++++++++++++++++++++++++++++++++++
 265.out |    5 ++
 266     |  104 +++++++++++++++++++++++++++++++++++++++++
 266.out |    5 ++
 group   |    3 +
 7 files changed, 388 insertions(+), 0 deletions(-)
 create mode 100755 264
 create mode 100644 264.out
 create mode 100755 265
 create mode 100644 265.out
 create mode 100755 266
 create mode 100644 266.out

-- 
1.7.3.1


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
