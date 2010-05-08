Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o48J6WIv199772 for <xfs@oss.sgi.com>; Sat, 8 May 2010 14:06:34 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 144A91DE8EDB
	for <xfs@oss.sgi.com>; Sat,  8 May 2010 12:08:43 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id xfE5sDfgADFmQSp3 for
	<xfs@oss.sgi.com>; Sat, 08 May 2010 12:08:43 -0700 (PDT)
Date: Sat, 8 May 2010 15:08:43 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: XFS status update for April 2010
Message-ID: <20100508190843.GA20445@infradead.org>
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

In April 2.6.34 still was in the release candidate phase, with
a hand full of XFS fixes making it into mainline.  Development for
the 2.6.35 merge window went ahead full steam at the same time.

While a fair amount of patches hit the development tree these were
largely cleanups, with the real development activity happening on
the mailing list.  There was another round of patches and following
discussion on the scalable busy extent tracking and delayed logging
features mentioned last month.  They are expected to be merged in
May and queue up for the Linux 2.6.35 window.  Last but not least
April saw a large number of XFS fixes backported to the 2.6.32 and
2.6.33 -stable series.

In user land xfsprogs has seen few but important updates, preparing
for a new release next month.  The xfs_repair tool saw a fix to
correctly enable the lazy superblock counters on an existing
filesystem, and xfs_fsr saw updates to better deal with dynamic
attribute forks.  Last but not a least a port to Debian GNU/kFreeBSD
got merged. The xfstests test suite saw two new test cases and various
smaller fixes.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
