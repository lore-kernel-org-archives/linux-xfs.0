Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 3E7827CB4
	for <xfs@oss.sgi.com>; Wed,  2 Mar 2016 09:50:11 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 9DC41AC001
	for <xfs@oss.sgi.com>; Wed,  2 Mar 2016 07:50:10 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id NFiCRgp1GsYoGoo8 (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 02 Mar 2016 07:50:08 -0800 (PST)
Date: Wed, 2 Mar 2016 07:50:07 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: falloc vs reflink revisited
Message-ID: <20160302155007.GB7125@infradead.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: xfs@oss.sgi.com

Hi Darrick,

I know that I suggested unsharing blocks on fallocate, but it turns out
this is causing problems.  Applications expect falloc to be a fast
metadata operation, and copying a potentially large number of blocks
is against that expextation.  This is especially bad for the NFS
server, which should not be blocked for a long time in a synchronous
operation.

I think we'll have to remove the unshare and just fail the fallocate
for a reflinked region for now.  I still think it makes sense to expose
an unshare operation, and we probably should make that anyother
fallocate mode.

Opininions?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
