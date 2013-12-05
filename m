Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 41A027F59
	for <xfs@oss.sgi.com>; Thu,  5 Dec 2013 09:59:53 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C2733AC009
	for <xfs@oss.sgi.com>; Thu,  5 Dec 2013 07:59:52 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.9])
	by cuda.sgi.com with ESMTP id omfudqpiV9Du75PZ (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 05 Dec 2013 07:59:51 -0800 (PST)
Received: from hch by bombadil.infradead.org with local (Exim 4.80.1 #2 (Red
	Hat Linux)) id 1VobLD-0004v5-4V
	for xfs@oss.sgi.com; Thu, 05 Dec 2013 15:59:51 +0000
Message-Id: <20131205155830.620826868@bombadil.infradead.org>
Date: Thu, 05 Dec 2013 07:58:30 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/5] extent list locking fixes
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com

As discussed in the getdents locking thread I think we should assert
the we have the right locking for reading in the extent list and
the xfs_bmap_* operations.

This series contains a patch to add those asserts (the last one),
as well a the fallout it detected.  This is in addition to the getdents
patch from Ben.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
