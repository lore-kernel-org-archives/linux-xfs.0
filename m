Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 5A4BB7CA1
	for <xfs@oss.sgi.com>; Mon,  5 Sep 2016 00:34:01 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1E57F8F8033
	for <xfs@oss.sgi.com>; Sun,  4 Sep 2016 22:33:58 -0700 (PDT)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id 9hoUgwEK9d7EStch (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 04 Sep 2016 22:33:48 -0700 (PDT)
Date: Sun, 4 Sep 2016 22:33:17 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: XFS reflink and development tip git trees updated
Message-ID: <20160905053317.GA15302@birch.djwong.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>, Christoph Hellwig <hch@infradead.org>, Brian Foster <bfoster@redhat.com>
Cc: linux-xfs@vger.kernel.org, xfs@oss.sgi.com

Hi everyone,

I've just rebased the reflink patches against kernel 4.8-rc5 and the xfsprogs
dev branch:

https://github.com/djwong/linux/tree/for-dave-for-4.9-1 [17f66c42de]
https://github.com/djwong/xfsprogs/tree/for-dave-for-4.9-1 [7b015920a]

These branches should contain /only/ the patches needed to get reflink working:
no fsmap ioctl, no online scrub, and no realtime rmapbt.  I'm publishing these
branches in the hopes of getting wider testing prior to the merge window.  I
haven't heard any complaints for several weeks now.

I created these two branches partly because Brian was complaining about it
being a PITA to carve out a working branch.  The patches haven't changed at all
since the giant mailing a couple of weeks ago.

-----------

For the latest development branch, check out the djwong-wtf branches on github:
https://github.com/djwong/linux/tree/djwong-wtf
https://github.com/djwong/xfsprogs/tree/djwong-wtf

Note that I'm in the middle of reworking the GETFSMAP ioctl to eliminate the
problems that Andreas pointed out last week, and reworking the getfsmap and
scrub code to eliminate buffer deadlocks when a btree loop exists, so the last
few patches are ... very scraggly.

--D

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
