Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA83dCR7088823 for <xfs@oss.sgi.com>; Mon, 7 Nov 2011 21:39:13 -0600
Received: from song.cn.fujitsu.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 042AB16235EA
	for <xfs@oss.sgi.com>; Mon,  7 Nov 2011 19:39:10 -0800 (PST)
Received: from song.cn.fujitsu.com (cn.fujitsu.com [222.73.24.84]) by
	cuda.sgi.com with ESMTP id 7T2NdLvLUv5hN4pJ for
	<xfs@oss.sgi.com>; Mon, 07 Nov 2011 19:39:10 -0800 (PST)
Message-ID: <4EB8A441.7090506@cn.fujitsu.com>
Date: Tue, 08 Nov 2011 11:38:41 +0800
From: WuBo <wu.bo@cn.fujitsu.com>
MIME-Version: 1.0
Subject: [PATCH v2 0/3] xfstests: Add a group of reservation space test
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
To: linux-fsdevel@vger.kernel.org, Linux Btrfs <linux-btrfs@vger.kernel.org>, xfs@oss.sgi.com, Christoph Hellwig <hch@infradead.org>

Changes v1->v2:
- Make test-set support generic

This patch set add a group of reservation space test. Especailly for btrfs.
It includes three parts: copy workload, prealloc and write posix.

For test 273, I hope it's usefull for Josef's reserve improve work.
For test 274 and 275, the current btrfs is not pass yet.

Wu Bo (3):
  xfstests 273: add a copy and reserve test
  xfstests 274: add a prealloc and reserve test
  xfstests 275: add a write and reserve test

 273     |  145 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 273.out |    4 ++
 274     |   91 +++++++++++++++++++++++++++++++++++++++
 274.out |    5 ++
 275     |   89 ++++++++++++++++++++++++++++++++++++++
 275.out |    5 ++
 group   |    3 +
 7 files changed, 342 insertions(+), 0 deletions(-)
 create mode 100755 273
 create mode 100644 273.out
 create mode 100755 274
 create mode 100644 274.out
 create mode 100755 275
 create mode 100644 275.out

-- 
1.7.3.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
