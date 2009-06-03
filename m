Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n53NSquK201949 for <xfs@oss.sgi.com>; Wed, 3 Jun 2009 18:28:52 -0500
Received: from josefsipek.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 0D92810521C5
	for <xfs@oss.sgi.com>; Wed,  3 Jun 2009 16:35:43 -0700 (PDT)
Received: from josefsipek.net (josefsipek.net [141.211.133.196]) by
	cuda.sgi.com with ESMTP id eJBGr7JU9nClVfnp for
	<xfs@oss.sgi.com>; Wed, 03 Jun 2009 16:35:43 -0700 (PDT)
Date: Wed, 3 Jun 2009 19:29:07 -0400
From: "Josef 'Jeff' Sipek" <jeffpc@josefsipek.net>
Subject: Re: [PATCH 6/7] xfs: use generic inode iterator in
	xfs_qm_dqrele_all_inodes
Message-ID: <20090603232907.GC9167@josefsipek.net>
References: <20090514171233.942489000@bombadil.infradead.org>
	<20090514171559.029154000@bombadil.infradead.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20090514171559.029154000@bombadil.infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

On Thu, May 14, 2009 at 01:12:39PM -0400, Christoph Hellwig wrote:
> Use xfs_inode_ag_iterator instead of opencoding the inode walk in the
> quota code.  Mark xfs_inode_ag_iterator and xfs_sync_inode_valid non-static
> to allow using them from the quota code.

Nice cleanup.

I don't see any problems with it.

Jeff.

-- 
Keyboard not found!
Press F1 to enter Setup

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
