Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n82Hvhqg034365 for <xfs@oss.sgi.com>; Wed, 2 Sep 2009 12:57:58 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 30CC841E03E
	for <xfs@oss.sgi.com>; Wed,  2 Sep 2009 10:58:40 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id vVvhnHtGq9HZq35q for
	<xfs@oss.sgi.com>; Wed, 02 Sep 2009 10:58:40 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.69 #1 (Red Hat
	Linux)) id 1Miu6R-0006SB-N3
	for xfs@oss.sgi.com; Wed, 02 Sep 2009 17:58:39 +0000
Message-Id: <20090902175531.469184575@bombadil.infradead.org>
Date: Wed, 02 Sep 2009 13:55:31 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 00/14] repair memory usage reductions
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
To: xfs@oss.sgi.com

This is a respin of the patches Barry Naujok wrote at SGI for reducing
the memory usage in repair.  I've split it up, fixed a few small bugs
and added two preparatory cleanups - but all the real work is Barry's.
There has been lots of heavy testing on large filesystems by Barry
on the original patches, and quite a lot of testing on slightly smaller
filesystems by me.  These were all ad-hoc tests as XFSQA coverage is
rather low on repair.  My plan is to add various additional testcase
for XFSQA both for intentional corruptions as well as reproducing past
reported bugs before we'll release these patches in xfsprogs.  But I think
it would be good if we could get them into the development git tree to
get wider coverage already.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
