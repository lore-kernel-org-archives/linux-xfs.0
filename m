Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 22 Oct 2008 09:27:17 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9MGQlmK027031
	for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 09:26:47 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 49ED410C9370
	for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 09:28:32 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id oWVQ7jZQpHCITCeI for <xfs@oss.sgi.com>; Wed, 22 Oct 2008 09:28:32 -0700 (PDT)
Received: from hch by bombadil.infradead.org with local (Exim 4.68 #1 (Red Hat Linux))
	id 1KsgZT-0002Mu-Sh
	for xfs@oss.sgi.com; Wed, 22 Oct 2008 16:28:31 +0000
Date: Wed, 22 Oct 2008 12:28:31 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] free inodes using destroy_inode
Message-ID: <20081022162831.GA25556@infradead.org>
References: <20081020222044.GC23662@lst.de> <20081021030726.GD18495@disturbed> <20081021090708.GA30463@infradead.org> <20081021210633.GM25906@disturbed>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081021210633.GM25906@disturbed>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

On Wed, Oct 22, 2008 at 08:06:33AM +1100, Dave Chinner wrote:
> Hmmmm - I still don't see that as possible. We don't set I_NEW until
> we are inside xfs_setup_inode(), which occurs after we insert
> the inode into the radix tree. xfs_setup_inode() also calls
> unlock_new_inode(), so the I_NEW flag is cleared before it returns,
> too. So I can't really see how this check in reclaim does anything....
> 
> AFAICT, once we've inserted the new inode into the radix tree,
> we can't get an error before xfs_setup_inode() is called - even
> in the allocation case. Hence once we're in the radix tree,
> xfs_iput_new() should be called to cleanup.
> 
> All the cases that xfs_destroy_inode() handles are before the inode
> is inserted into the radix tree, so marking the XFS inode XFS_IBAD
> in xfs_destroy_inode() is probably a much more reliable way to
> detect immediate destroy cases in the reclaim code than relying
> on I_NEW......

I've put in some instrumentation and we indeed newer hit the I_NEW
case.  I also can't reproduce the problems I saw before anymore -
in fact calling radix_tree_remove on an inode is explicitly fine
per documentation and does work.  I'll send a  reworked patch that
just uses make_inode_bad as this has passed xfsqa a few times now.

I've also removed patch 2 for now a it's not a bug fix an I'll put
it into my later series that cleans up a lot of mess in that area.
