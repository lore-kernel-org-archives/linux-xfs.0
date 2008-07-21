Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 21 Jul 2008 04:53:59 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m6LBrtrW024164
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 04:53:55 -0700
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 560E030D9D3
	for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 04:55:05 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id JehFUPA2hSg8BQ8w for <xfs@oss.sgi.com>; Mon, 21 Jul 2008 04:55:05 -0700 (PDT)
Date: Mon, 21 Jul 2008 07:55:04 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/3] XFS: sanitise VFS inode extraction V2
Message-ID: <20080721115504.GB14346@infradead.org>
References: <1216640819-19924-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1216640819-19924-1-git-send-email-david@fromorbit.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, Jul 21, 2008 at 09:46:56PM +1000, Dave Chinner wrote:
> Getting the VFS inode from the XFS inode is done in a variety of
> ways right now - direct deference or one of two XFS_ITOV macros.
> This should be consistent throughout the code - this patch
> series does that in a way that is consistent with the opposite
> XFS_I() conversion. We now use VFS_I() to extract the VFS inode
> from the XFS inode.
> 
> Version 2:
> o don't use vn_to_inode() and inode_to_vn() functions as they
>   are not needed
> o rediff patches 2 and 3 against the change patch.

ACK for all three patches.
