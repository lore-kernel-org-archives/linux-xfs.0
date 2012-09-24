Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8OLMvHX212349 for <xfs@oss.sgi.com>; Mon, 24 Sep 2012 16:22:57 -0500
Message-ID: <5060CF7C.5010500@sgi.com>
Date: Mon, 24 Sep 2012 16:24:12 -0500
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2] xfstests: improve test 286 for repeated unwritten/hole
	extents.
References: <4FF31296.8050406@oracle.com>
In-Reply-To: <4FF31296.8050406@oracle.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: jeff.liu@oracle.com
Cc: xfs@oss.sgi.com



Enlarge the test coverage of 286 to includes file mapping with repeated
hole/unwritten/unwritten_without_data/data intersections.

Those two new sub-tests could help verifying the current seek_data/seek_hole
improvements.

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Reviewed-by: Mark Tinguely <tinguely@sgi.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>


Committed to git://oss.sgi.com/xfs/cmds/xfstests.git, master branch.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
