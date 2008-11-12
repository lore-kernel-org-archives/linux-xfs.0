Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 12 Nov 2008 01:22:46 -0800 (PST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mAC9MaE7029541
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2008 01:22:37 -0800
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 5A66F154A993
	for <xfs@oss.sgi.com>; Wed, 12 Nov 2008 01:22:36 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id RrKsfpqJAgBt7yEf for <xfs@oss.sgi.com>; Wed, 12 Nov 2008 01:22:36 -0800 (PST)
Date: Wed, 12 Nov 2008 04:22:36 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/3 v4]  Add new flags to getbmapx interface
Message-ID: <20081112092236.GC8896@infradead.org>
References: <49089596.80006@sandeen.net> <49089644.8070402@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49089644.8070402@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs mailing list <xfs@oss.sgi.com>

On Wed, Oct 29, 2008 at 11:58:44AM -0500, Eric Sandeen wrote:
> Add new getbmap flags.
> 
> This adds a new output flag, BMV_OF_LAST to indicate if we've hit
> the last extent in the inode.  This potentially saves an extra call
> from userspace to see when the whole mapping is done.
> 
> It also adds BMV_IF_DELALLOC and BMV_OF_DELALLOC to request, and
> indicate, delayed-allocation extents.  In this case bmv_block
> is set to -2 (-1 was already taken for HOLESTARTBLOCK; unfortunately
> these are the reverse of the in-kernel constants.)
> 
> These new flags facilitate addition of the new fiemap interface.
> 
> Rather than adding sh_delalloc, remove sh_unwritten & just test
> the flags directly.

Looks good.
