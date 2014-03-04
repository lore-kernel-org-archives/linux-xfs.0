Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 399697F4E
	for <xfs@oss.sgi.com>; Tue,  4 Mar 2014 11:21:08 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1CB628F8070
	for <xfs@oss.sgi.com>; Tue,  4 Mar 2014 09:21:05 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id rNFBjU0MHuG2lHZm (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 04 Mar 2014 09:21:03 -0800 (PST)
Date: Tue, 4 Mar 2014 09:21:03 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/2] RFC: O_TMPFILE tests
Message-ID: <20140304172103.GA24528@infradead.org>
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
To: xfs@oss.sgi.com
Cc: Zhi Yong Wu <zwu.kernel@gmail.com>

This series adds a generic and one xfs-specific test for the O_TMPFILE
functionality.  For now it's purely RFC as there is no infrastructure
to test the filesystem and xfs_io supports O_TMPFILE yet, as I plan to
implement that ontop of Lukas' refactoring of the related feature
checks.

Even with these tests not going in ASAP having them out and waiting to
be merged is enough that I'd be fine with merging the tmpfile branch
into for-next so that it can go into the 3.15 merge window.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
