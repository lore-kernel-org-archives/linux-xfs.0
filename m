Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 23 Jul 2008 00:16:42 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6N7Gdk2003853
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 00:16:40 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 497B6317DC0
	for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 00:17:49 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id 8kesupJmnNcDyQey for <xfs@oss.sgi.com>; Wed, 23 Jul 2008 00:17:49 -0700 (PDT)
Date: Wed, 23 Jul 2008 03:17:48 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/4] XFS: replace the mount inode list with radix tree
	traversals V2
Message-ID: <20080723071748.GA25807@infradead.org>
References: <1216773673-3620-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216773673-3620-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Wed, Jul 23, 2008 at 10:41:09AM +1000, Dave Chinner wrote:
> The list of all inodes on a mount is superfluous. We can traverse
> all inodes now by walking the per-AG inode radix trees without
> needing a separate list. This enables us to remove a bunch of
> complex list traversal code and remove another two pointers from
> the xfs_inode.
> 
> Also, by replacing the sync traversal with an ascending inode
> number traversal, we will issue better inode I/O patterns for
> writeback triggered by xfssyncd or unmount.

All patches looks good to me.  Well, minus the xfsidbg issue in 4
which would be a merge blocker for that patch.
