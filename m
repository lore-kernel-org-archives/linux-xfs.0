Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 8D51B7CA1
	for <xfs@oss.sgi.com>; Wed,  3 Feb 2016 12:40:23 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 2C543AC006
	for <xfs@oss.sgi.com>; Wed,  3 Feb 2016 10:40:23 -0800 (PST)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id V4eF9DqxEIMcYZpV (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 03 Feb 2016 10:40:20 -0800 (PST)
From: Christoph Hellwig <hch@lst.de>
Subject: vfs/xfs: directio updates to ease COW handling V2
Date: Wed,  3 Feb 2016 19:40:13 +0100
Message-Id: <1454524816-11392-1-git-send-email-hch@lst.de>
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
To: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com, linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com

The first patch ensures ->end_io is always called for direct I/O requests
that pass it in, even if there was a zero length write, or if an error
occured.  The existing users have been updated to ignore it, but XFS
will make use of it in the future, and a comment in ext4 suggests it
might be useful for it as well.

The other two simplify the XFS direct I/O code.

Changes since V1:
 - allow ->end_io to return errors
 - a comment spelling fix


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
