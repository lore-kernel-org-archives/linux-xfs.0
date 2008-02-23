Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 23 Feb 2008 01:22:40 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1N9MUpX014630
	for <xfs@oss.sgi.com>; Sat, 23 Feb 2008 01:22:35 -0800
Date: Sat, 23 Feb 2008 04:22:55 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [patch] fix inode leak in xfs_iget_core()
Message-ID: <20080223092255.GA21453@infradead.org>
References: <20080223061924.GI155259@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080223061924.GI155259@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Sat, Feb 23, 2008 at 05:19:24PM +1100, David Chinner wrote:
> If the radix_tree_preload() fails, we need to destroy the
> inode we just read in before trying again. This could leak
> xfs_vnode structures when there is memory pressure. Noticed
> by Christoph Hellwig.

What we're leaking would be the xfs_inode.  But this is exactly
the patch I had so OK from me :)
