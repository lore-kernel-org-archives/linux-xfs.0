Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q16EUjS3139322 for <xfs@oss.sgi.com>; Mon, 6 Feb 2012 08:30:45 -0600
Message-ID: <4F2FE3F6.8040808@oracle.com>
Date: Mon, 06 Feb 2012 22:30:14 +0800
From: Jeff Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
Subject: [PATCH v2 0/2] Add two SEEK_DATA/SEEK_HOLE tests
Reply-To: jeff.liu@oracle.com
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
To: xfs@oss.sgi.com
Cc: Christoph Hellwig <hch@infradead.org>, Mark Tinguely <tinguely@sgi.com>

Hello,

This patch series add two tests to verify SEEK_DATA/SEEK_HOLE feature works fine on supported
file systems(Btrfs/OCFS2) and XFS which is in progress.


V2 changes in seek_sanity_tester:
* change test index number from 276 to 279 since I observed that 276~278 have already been used by other tests.

v2 changes in seek_copy_tester:
* change test index number to 280 accordingly.
* s/do_pwrite/full_pwrite/
* add more debug info when writing ZERO byte to dest file.
* fix a bug at create_data_and_holes() to avoid write more bytes exceeding total file size, thank Mark. :)
* mark all function as static, maybe it's better to consolidate some common functions at sanity check and copy tester to a lib file in future.

Thanks,
-Jeff

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
