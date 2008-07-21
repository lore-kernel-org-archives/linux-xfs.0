Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Jul 2008 01:00:26 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6L80MeA000955
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 01:00:22 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5CD64E716C9
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 01:01:32 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id zVQQTSLRVtJfBKYT for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 01:01:32 -0700 (PDT)
Date: Mon, 21 Jul 2008 04:01:31 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/3] XFS: sanitise VFS inode extraction
Message-ID: <20080721080131.GD6692@infradead.org>
References: <1216557828-29056-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216557828-29056-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Sun, Jul 20, 2008 at 10:43:45PM +1000, Dave Chinner wrote:
> Getting the VFS inode from the XFS inode is done in a variety of
> ways right now - direct deference or one of two XFS_ITOV macros.
> This should be consi??tent throughout the code - this patch
> series does that in a way that is consistent with the opposite
> XFS_I() conversion. We now use VFS_I() to extract the VFS inode
> from the XFS inode.

All three patches looks good to me, but please kill the vn_to_inode
useage in VFS_I - vn_to_inode and inode_to_vn are not needed anymore
at all nowdays and will go away completely real soon.
