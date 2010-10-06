Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o969en6H074844 for <xfs@oss.sgi.com>; Wed, 6 Oct 2010 04:40:55 -0500
Received: from canuck.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8F4331BB61B9
	for <xfs@oss.sgi.com>; Wed,  6 Oct 2010 02:41:52 -0700 (PDT)
Received: from canuck.infradead.org (canuck.infradead.org [134.117.69.58]) by
	cuda.sgi.com with ESMTP id 0VmspJUj6BBSXtbi for
	<xfs@oss.sgi.com>; Wed, 06 Oct 2010 02:41:52 -0700 (PDT)
Date: Wed, 6 Oct 2010 05:41:52 -0400
From: Christoph Hellwig <hch@lst.de>
Subject: XFS status update for September 2010
Message-ID: <20101006094152.GA24239@lst.de>
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

Mainline activity has been rather low in September while with only
two more fixes going into the 2.6.36 release candidates after the
large merge activity in August.  Development for the next merge
window has been more active.  The largest item was the inclusion
of the metadata scalability patch series, which provides very large
speedups for parallel metadata operations.  In addition a new
ioctl to punch holes and convert the whole to an unwritten extent
was added and a small number of cleanups also made it into the tree.

Patches to add support for 32bit wide project ID identifiers and
using group and project quotas concurrently were posted to the list
and discussed but not yet included.

Userspace development has been rather quited again, with a single fix
committed to xfsprogs and xfsdump each.  The xfstests test suite grew
a new test case and received a few additional fixes.  Last but not least
the XFS Users Guide [1] was updated with various factual corrections
and spelling fixes.

[1] http://xfs.org/docs/xfsdocs-xml-dev/XFS_User_Guide//tmp/en-US/html/index.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
