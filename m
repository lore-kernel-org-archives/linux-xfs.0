Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o67NnQi2003174 for <xfs@oss.sgi.com>; Wed, 7 Jul 2010 18:49:27 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D849E432080
	for <xfs@oss.sgi.com>; Wed,  7 Jul 2010 16:52:18 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id G7B22v0hMc8zNGvK for
	<xfs@oss.sgi.com>; Wed, 07 Jul 2010 16:52:18 -0700 (PDT)
Date: Wed, 7 Jul 2010 19:52:18 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Check block magic number so we scan only valid blocks.
Message-ID: <20100707235218.GA30851@infradead.org>
References: <1278515351-24928-1-git-send-email-treestem@gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1278515351-24928-1-git-send-email-treestem@gmail.com>
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
To: Peter Watkins <treestem@gmail.com>
Cc: xfs@oss.sgi.com

On Wed, Jul 07, 2010 at 11:09:11AM -0400, Peter Watkins wrote:
> Hello,
> 
> Occasionally I've hit a SEGV while querying free space in xfs_db on a mounted
> file system. In scanfunc_bno, block->bb_numrecs has crazy values. And bb_magic 
> is not XFS_ABTB_MAGIC.
> 
> Does a check like this, similiar to other places, make sense?

Yes, it's reasonable.  As long as you'd don't expect directly poking at
a life partition giving correct results..


> Should scanfunc_cnt make a similiar check?

Yes.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
