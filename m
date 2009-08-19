Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n7JIiN3p221127 for <xfs@oss.sgi.com>; Wed, 19 Aug 2009 13:44:39 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0FAB33E26C8
	for <xfs@oss.sgi.com>; Wed, 19 Aug 2009 11:45:12 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id gncSq7KzkZFobAu2 for
	<xfs@oss.sgi.com>; Wed, 19 Aug 2009 11:45:12 -0700 (PDT)
Message-Id: <20090819184258.542698202@bombadil.infradead.org>
Date: Wed, 19 Aug 2009 14:42:58 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/4] 2.6.30-stable backport of the XFS+NFSD inode cache race
	fix
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: stable@kernel.org
Cc: xfs@oss.sgi.com


This is a backport of the fix for the XFS inode cache races lots of people
have reported.  The context for the two VFS patches changed quite a bit from
2.6.30 to 2.6.31-rc so I consider these backports.  The backport has been
tested by me with xfstest for XFS and extN, and by lots of users that have
been waiting for the fix for their nfs servers still running 2.6.30.


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
