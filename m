Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 03 Sep 2008 05:18:32 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m83CIUsa023723
	for <xfs@oss.sgi.com>; Wed, 3 Sep 2008 05:18:30 -0700
Date: Wed, 3 Sep 2008 08:19:56 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: REVIEW: Change mkfs.xfs to set primary superblock inodes in
	ALL secondaries
Message-ID: <20080903121956.GC5980@infradead.org>
References: <op.ugv794p63jf8g2@pc-bnaujok.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.ugv794p63jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Wed, Sep 03, 2008 at 04:57:30PM +1000, Barry Naujok wrote:
> One peculiarity of mkfs.xfs that no-one has yet been able to explain
> to me is that all the secondary superblocks do not contain the
> primary superblock's root inode, realtime inodes and quota inodes.
>
> The root inode is stored in the middle and last AG as well to
> make things more unexpected.
>
> The following makes all the secondaries the same as the primary
> (other than the global counters).

Looks good to me, but I'd really love to know the original reason behind
it, too..
