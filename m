Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9I6PuFV058102 for <xfs@oss.sgi.com>; Tue, 18 Oct 2011 01:25:56 -0500
Received: from rcsinet15.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D3D9E1C92A62
	for <xfs@oss.sgi.com>; Mon, 17 Oct 2011 23:25:55 -0700 (PDT)
Received: from rcsinet15.oracle.com (rcsinet15.oracle.com [148.87.113.117]) by
	cuda.sgi.com with ESMTP id Q2rQoHz23kuTFDBB for
	<xfs@oss.sgi.com>; Mon, 17 Oct 2011 23:25:55 -0700 (PDT)
From: Anand Jain <Anand.Jain@oracle.com>
Subject: [PATCH 0/3] xfstests patches
Date: Tue, 18 Oct 2011 14:28:53 +0800
Message-Id: <1318919336-32206-1-git-send-email-Anand.Jain@oracle.com>
In-Reply-To: <20111013005652.GM3159@dastard>
References: <20111013005652.GM3159@dastard>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: hch@infradead.org, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com, david@fromorbit.com
Cc: Anand Jain <Anand.Jain@oracle.com>

Looks like there are no further comments.
Changes per Dave pointing out to reuse _populate_fs.
Thanks for the review.

Anand Jain (3):
  264: Functional test case for the btrfs snapshot
  265: Functional test case for the btrfs de-fragmentation
  266: Functional test case for the btrfs raid operations

 264           |  192 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 264.out       |    2 +
 265           |   60 ++++++++++++++++++
 265.out       |    2 +
 266           |  187 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 266.out       |    2 +
 README        |    7 ++-
 common.config |   14 ++++
 common.rc     |   95 +++++++++++++++++++++++++++-
 group         |    3 +
 10 files changed, 559 insertions(+), 5 deletions(-)
 create mode 100755 264
 create mode 100644 264.out
 create mode 100755 265
 create mode 100644 265.out
 create mode 100755 266
 create mode 100644 266.out

-- 
1.7.7

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
