Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 67E317CA1
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2016 19:16:06 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 3A7D6304039
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2016 17:16:03 -0800 (PST)
Received: from aserp1040.oracle.com (aserp1040.oracle.com [141.146.126.69]) by
	cuda.sgi.com with ESMTP id LkENikjDlPhV3c5l (version=TLSv1.2
	cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 04 Mar 2016 17:16:01 -0800 (PST)
Date: Fri, 4 Mar 2016 17:15:30 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [NOPATCH v5]: XFS reverse-mapping, reflink, and dedupe support
Message-ID: <20160305011530.GG27973@birch.djwong.org>
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
To: david@fromorbit.com
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

Hi all,

Dave's started reviewing the rmap/reflink patches I sent him, and said he'll
trickle the patches (with various edits) out to the mailing list as he gets to
them.  Therefore, I won't blast the mailing list with the kernel/xfsprogs
patches that will soon be obsolete, though I will push out all the pending
xfstests and xfsdocumentation fixes.

I've also renamed the confusing 'for-dave' branches on github to
'rmap-reflink-devel' to make it clearer that it's just a development branch and
not what I'm trying to get pushed upstream.

Soooo... stuff I'm hoping to get upstream for 4.6:
https://github.com/djwong/linux/tree/for-dave-for-4.6
https://github.com/djwong/xfsprogs/tree/for-dave-for-4.6

Stuff I hope to get upstream:
https://github.com/djwong/xfs-documentation/tree/reflink-devel
https://github.com/djwong/xfstests/tree/reflink-dev

Development branch, not for upstream:
https://github.com/djwong/linux/tree/rmap-reflink-devel
https://github.com/djwong/xfsprogs/tree/rmap-reflink-devel

I'm taking a break from active development for a week or two to concentrate on
finding and fixing bugs.  The content of the branches hasn't changed from
a few days ago, so no need to re-pull if you just did.

--D

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
