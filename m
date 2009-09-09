Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n892EHO3119133 for <xfs@oss.sgi.com>; Tue, 8 Sep 2009 21:14:34 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 2471443746F
	for <xfs@oss.sgi.com>; Tue,  8 Sep 2009 19:14:57 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id KrBBXDa5Vgbv7G6d for
	<xfs@oss.sgi.com>; Tue, 08 Sep 2009 19:14:57 -0700 (PDT)
Date: Tue, 8 Sep 2009 22:14:53 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: XFS status update for August 2009
Message-ID: <20090909021453.GA24173@infradead.org>
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
To: xfs@oss.sgi.com, linux-kernel@vger.kernel.org


In August the Linux 2.6.31 kernel has still been in the release candidate
stage, but a couple of important XFS fixes made it in time for the release,
including a fix for the inode cache races with NFS workloads that have
plagued us for a long time.

The list saw various patches destined for the Linux 2.6.32 merge window,
including a merge of the fsync and O_SYNC handling code to address various
issues with the latter, a workaround for deficits in the timestamp handling
interface between the VFS and filesystems, a repost of the sync improvements
patch series and various smaller patches. 

August also saw the minor 3.0.3 release of xfsprogs which collects smaller
fixes to the various tools and most importantly a fix to allow xfsprogs to
work again on SPARC and other strict alignment handling which regressed a
few releases ago.  The xfstests repository saw a few new test cases and a
various small improvements.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
