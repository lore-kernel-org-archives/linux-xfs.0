Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 21 Nov 2007 07:22:18 -0800 (PST)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lALFLs6C008190
	for <xfs@oss.sgi.com>; Wed, 21 Nov 2007 07:22:07 -0800
Date: Wed, 21 Nov 2007 15:05:26 +0000
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [REVIEW] Refactor xfs_repair's process_dinode_int
Message-ID: <20071121150526.GA8454@infradead.org>
References: <op.t1tl53ac3jf8g2@pc-bnaujok.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.t1tl53ac3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

On Thu, Nov 15, 2007 at 05:40:41PM +1100, Barry Naujok wrote:
> Implementing casefold-table checking in xfs_repair, I have to
> touch process_dinode_int. It's a horrendous function. The attached
> patch hopefully makes it much clearer what it does and removes a
> lot of duplicate code when bad inodes are found. There are some
> obscure bug fixes too (eg. two places where the inode's di_mode is
> updated, but not marked dirty - libxfs would have tossed it).
> 
> The refactoring involved removing unused variables, working out
> what various variables actually did and use them appropriately
> and break blocks of functionality into separate functions.

This looks very good f4rom a quick glance over it.  I can't claim
I've verified that it still does the same thing, though.
