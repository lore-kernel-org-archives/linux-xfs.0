Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 77EE17F3F
	for <xfs@oss.sgi.com>; Fri, 10 Jan 2014 06:27:13 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 5CCBA30407F
	for <xfs@oss.sgi.com>; Fri, 10 Jan 2014 04:27:10 -0800 (PST)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20]) by
	cuda.sgi.com with ESMTP id cRigOBtQYQy4HV8o for
	<xfs@oss.sgi.com>; Fri, 10 Jan 2014 04:27:06 -0800 (PST)
Date: Fri, 10 Jan 2014 20:27:00 +0800
From: fengguang.wu@intel.com
Subject: [xfs] c91c46c12: xfstests generic/313 regression
Message-ID: <20140110122700.GA12624@localhost>
MIME-Version: 1.0
Content-Disposition: inline
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

Hi Christoph,

We find this commit failed xfstests generic/313.
Attached is our kconfig.

c91c46c12768daac8486dff0f74bc52c2ec974cd is the first bad commit
commit c91c46c12768daac8486dff0f74bc52c2ec974cd
Author:     Christoph Hellwig <hch@infradead.org>
AuthorDate: Mon Nov 18 05:10:52 2013 -0800
Commit:     Ben Myers <bpm@sgi.com>
CommitDate: Fri Dec 6 17:26:19 2013 -0600

    xfs: add xfs_setattr_time
    
    Split out a xfs_setattr_time helper to share code between truncate and
    regular setattr similar to xfs_setattr_mode.  I might also have another
    caller growing for this in the near future.
    
    Signed-off-by: Christoph Hellwig <hch@lst.de>
    Reviewed-by: Brian Foster <bfoster@redhat.com>
    Signed-off-by: Ben Myers <bpm@sgi.com>

 fs/xfs/xfs_iops.c | 66 +++++++++++++++++++++++++------------------------------
 1 file changed, 30 insertions(+), 36 deletions(-)

Thanks,
Fengguang

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
