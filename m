Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o3IHxK5d152117 for <xfs@oss.sgi.com>; Sun, 18 Apr 2010 12:59:20 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id F0AB812C242F
	for <xfs@oss.sgi.com>; Sun, 18 Apr 2010 11:01:18 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id pRFxkUFZqb6tXElx for
	<xfs@oss.sgi.com>; Sun, 18 Apr 2010 11:01:18 -0700 (PDT)
Date: Sun, 18 Apr 2010 14:01:18 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: XFS status update for March 2010
Message-ID: <20100418180118.GA20394@infradead.org>
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

The merge window for Linux 2.6.34 closed in the first week of March,
with the important XFS features already landing in February.  Not
surprisingly the XFS merge activity in March has been rather slow,
with only about a dozen bug fixes patches making it towards Linus'
tree in that time.

On the other hand active development for the 2.6.35 merge window has
been very active.  Most importantly there was a lot of work on the
transaction and log subsystems.  Starting with a large patchset to
clean up and refactor the transaction subsystem and introducing more
flexible I/O containers in the low-level logging code work is
progressing to a new, more efficient logging implementation.  While
this preparatory work has already been merged in the development tree,
the actual delayed logging implementation still needs more work after
the initial public posting.  The delayed logging implementation which
is very briefly modeled after the journaling mode in the ext3/4
and reiserfs filesystems allows to accumulated multiple asynchronous
transactions in memory instead of possibly writing them out
many times.  Using the new delayed logging mechanism I/O bandwidth
used for the log decreases by orders of magnitude and performance
on metadata intensive workloads increases massively. 

In addition to that a new version of the discard (aka TRIM) support
has been posted, this time entirely contained in kernel space
and without the need of a userspace utility to drive it.  Last but
not least the usual steady stream of cleanups and bug fixes has not
ceased this month either.

Besides the usual flow of fixes and new test cases in the xfstests
test suite development on the userspace side has been rather slow.
Xfsprogs has only seen a single fix for SMP locking in xfs_repair
and support for building on Debian GNU/kFreeBSD, and xfsdump
has seen no commit at all.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
