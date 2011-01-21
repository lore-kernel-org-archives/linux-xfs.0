Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0L9NX9X260911 for <xfs@oss.sgi.com>; Fri, 21 Jan 2011 03:23:34 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 67C6319FBC00
	for <xfs@oss.sgi.com>; Fri, 21 Jan 2011 01:25:51 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id rsUyrIq4gcen5dDf for
	<xfs@oss.sgi.com>; Fri, 21 Jan 2011 01:25:51 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.72 #1 (Red Hat
	Linux)) id 1PgDFe-0002Bn-9h
	for xfs@oss.sgi.com; Fri, 21 Jan 2011 09:25:50 +0000
Message-Id: <20110121092227.115815324@bombadil.infradead.org>
Date: Fri, 21 Jan 2011 04:22:27 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/6] do not reuse busy extents
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

This series makes sure we never reallocated a busy extent.  This is absolutely
needed for a working online discard implementation, and should also speed
up large concurrent workloads that would trip over a busy extents a lot.

The two most significant patches are from a series Dave posted mored than
two years ago, although the main patch to avoid busy ranges in the normal
allocator need a lot of bug fixes to survived QA.  In addition to that we
now also completely avoid resues for AGFL based allocations.  While this
might not be important from a performance perspectice it is critical for
the discard implementation I'm currently working on.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
