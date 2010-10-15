Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o9FMRD5L158136 for <xfs@oss.sgi.com>; Fri, 15 Oct 2010 17:27:13 -0500
Received: from canuck.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id A3BED1C02D46
	for <xfs@oss.sgi.com>; Fri, 15 Oct 2010 15:28:21 -0700 (PDT)
Received: from canuck.infradead.org (canuck.infradead.org [134.117.69.58]) by
	cuda.sgi.com with ESMTP id lFCZzPxTCKF3lVNY for
	<xfs@oss.sgi.com>; Fri, 15 Oct 2010 15:28:21 -0700 (PDT)
Date: Fri, 15 Oct 2010 18:28:20 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/4] xfstests fixes for hfsplus
Message-ID: <20101015222820.GA3655@infradead.org>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

I've recently started working on hfsplus and it's a filesystem close
enough to Posix that xfstests should work.  In fact it mostly did except
for a few tests using features not found in the basic posix set.

This series makes sure we don't run these "advanced" tests on
filesystems not supporting them.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
