Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p56JYxWR248527 for <xfs@oss.sgi.com>; Mon, 6 Jun 2011 14:35:02 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0BA6615DE2EE
	for <xfs@oss.sgi.com>; Mon,  6 Jun 2011 12:34:51 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	CXwx9cBvc1p7bsoN for <xfs@oss.sgi.com>;
	Mon, 06 Jun 2011 12:34:51 -0700 (PDT)
Date: Mon, 6 Jun 2011 15:34:51 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: XFS status update for May 2011
Message-ID: <20110606193451.GA9800@infradead.org>
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
To: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

May finally saw the release of Linux 2.6.39, which was a little more calm
than usual for XFS, and only contains about half the amount of the changes
we are used to see:

  58 files changed, 1660 insertions(+), 1912 deletions(-)

The most visible change is an overhaul of the XFS-internal interfaces
to print kernel messages, which makes all messages from XFS look slightly
different from before by always providing information about which device
these messages relate to.  In addition to that support for the RT subvolume,
which had been broken for a while has been resurrect, the XFS buffer cache
switched away from using the Linux pagecache to improve performance on
metadata intensive workloads, and all but one of the XFS kernel threads have
been switched to the new concurrent managed workqueue infrastructure that
is present in more recent Linux 2.6 releases.

In the meantime development for the release now known as Linux 3.0 went
ahead full steam up to the merge of the XFS tree into Linux 3.0-rc1. News
in that release contain support for vastly improved busy extent tracking,
support for online discard (aka TRIM) and the usual amount of bug fixes.

On the user space side the xfsprogs saw a fix for a corner case in xfs_repair,
and xfstests saw a few bug fixes as well as a new test case to test
btrfs-specific functionality.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
