Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	pA59WKcM148444 for <xfs@oss.sgi.com>; Sat, 5 Nov 2011 04:32:21 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E24DF223161
	for <xfs@oss.sgi.com>; Sat,  5 Nov 2011 02:32:19 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	W5tbXh72yVfYSQRp for <xfs@oss.sgi.com>;
	Sat, 05 Nov 2011 02:32:19 -0700 (PDT)
Date: Sat, 5 Nov 2011 05:32:19 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: XFS status update for October 2011
Message-ID: <20111105093219.GA5303@infradead.org>
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
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

October finally saw the delayed release of Linux 3.1, which is a fairly
boring release as XFS is concerned.  In addition to a few bug fixes
and cleanups the biggest item is an XFS-internal re organization of the
source files, dropping all sub directories under fs/xfs.

Due to the long Linux 3.1 release cycle development for 3.3 has already
started full steam in October while adding a few more small optimization
and fixes to the development tree for Linux 3.2, and merging that tree
into mainline.

Notable items for Linux 3.2 are speedup for parallel O_DIRECT reads and
writes on high IOPS devices, optimizations for fsync(2) on directories
and sync(2) latency, as well as further small improvements for metadata
performance on highly parallel workloads.

On the user space side xfsprogs saw a few more xfs_repair fixes, as well
as some updates of mount point handling for the xfs_quota tools, which
together with the updates from the last months was published in form
of the xfsprogs 3.1.6 release.  This was accompanied by an xfsdump
3.0.6 release, which does not include any new updates in October, but
lots of work from the previous month.  Xfstests saw two additional
test cases and various fixes, and it's first versioned release ever.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
