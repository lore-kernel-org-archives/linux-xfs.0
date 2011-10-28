Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p9SA3a3v145261 for <xfs@oss.sgi.com>; Fri, 28 Oct 2011 05:03:37 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 375C71CC6EC5
	for <xfs@oss.sgi.com>; Fri, 28 Oct 2011 03:03:35 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	5n3jjwqUdN8uqTvl for <xfs@oss.sgi.com>;
	Fri, 28 Oct 2011 03:03:35 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.76 #1 (Red Hat
	Linux)) id 1RJjHj-0002qZ-ET
	for xfs@oss.sgi.com; Fri, 28 Oct 2011 10:03:35 +0000
Message-Id: <20111028095423.796574703@bombadil.infradead.org>
Date: Fri, 28 Oct 2011 05:54:23 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 00/45] write back all metadata via the AIL (and remove xfsbufd)
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

Sorry for the patchbomb, but I wanted to flush out my current working
series now that is passing all the testing I've thrown at, including
on a high IOPS flash device that I won't have access to for much longer.

The series really is multiple ones, but we need all of it to make it
to the end goal.


1) inode shrinkage.  This has been posted and partially revieved before,
   and isn't absolutely nessecary but will make life easier later on.

2) log all inode updates and stop using the VFS dirty tracking for metadata.
   This has also been posted before, and it did get some updates.  It still
   lacks support for optimizing fdatasync, and it still hasn't been updated
   to the suggestion by Dave to allocate log space from ->writepage.  I have
   tried to implement the latter but run into various issues, more on that
   later.

3) the various quota updates, which mostly have been posted before.  This
   version also has a few new patches that add a proper shrinker callout
   to the quota code.  While the code looks fairly good the testing doesn't
   really stress much of this code at all.  I will have to write a new
   testcase (or a few) that actually have a lot of dquots in memory,
   and create memory pressure before I feel confident enought about these
   changes.

4) stop writing back inodes from async reclaim.  This is just a single patch,
   but a huge change in behaviour.

5) implement a way to completely empty the AIL and use it during freeze, umount
   and remount r/o.  This remove a whole lot of nasty heuristics for flushing
   back all metadata to its regular, non-log place by using a single piece
   of well understood code.

6) remove xfsbufd and queue up buffers on on-stack list, with the only
   one during normal operation beeing the one in xfsaild.  Besides greatly
   reducing the code this massively reduces calls to the buffercache that
   reduce scalability in highly parallel, metada-intensive loads.

7) a few cleanups the reduce and centralize log force trying to unpin buffers.


Comments on all these are highly appreciated, and I will resubmit patches in
here in smaller chunks as soon as were are confident about one or more of
the sub-series. 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
