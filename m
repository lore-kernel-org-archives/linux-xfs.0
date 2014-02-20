Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9DC497F76
	for <xfs@oss.sgi.com>; Thu, 20 Feb 2014 09:41:24 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 25FC9AC00D
	for <xfs@oss.sgi.com>; Thu, 20 Feb 2014 07:41:24 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id YHo1T8IXfJZccZbp (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 20 Feb 2014 07:41:22 -0800 (PST)
Date: Thu, 20 Feb 2014 07:41:22 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfs_repair: fix sibling pointer tests in
	verify_dir2_path()
Message-ID: <20140220154122.GC26146@infradead.org>
References: <53051DB5.4080403@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <53051DB5.4080403@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Wed, Feb 19, 2014 at 03:10:13PM -0600, Eric Sandeen wrote:
> RH QE reported that if we create a 1G filesystem with default
> options, mount it, and create inodes until full, then run
> repair, repair reports corruption in verify_dir2_path() with:
> 
> > bad back pointer in block 8390324 for directory inode 131

Can you please wire this up for xfstests?

> 
> The commit 88b32f0 xfs: add CRCs to dir2/da node blocks
> had a small error which regressed this; although we switch
> to the "newnode," to check sibling pointers, we re-populate
> the node hdr with the old "node" data.  This causes the
> backpointer test to be testing the wrong node's values.
> 
> Fixing this bug fixes the testcase.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
