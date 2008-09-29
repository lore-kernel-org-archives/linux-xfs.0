Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 29 Sep 2008 07:21:46 -0700 (PDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8TELhjw024012
	for <xfs@oss.sgi.com>; Mon, 29 Sep 2008 07:21:43 -0700
Date: Mon, 29 Sep 2008 10:23:18 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: REVIEW: Don't reset dirty inode flag in xfs_repair
Message-ID: <20080929142318.GA3709@infradead.org>
References: <op.uhy9dlyz3jf8g2@pc-bnaujok.melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.uhy9dlyz3jf8g2@pc-bnaujok.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Wed, Sep 24, 2008 at 06:47:35PM +1000, Barry Naujok wrote:
> If an inode is dirtied due to some error in an inode, the very last
> check (nlink version) in process_dinode_int() in xfs_repair sets the
> dirty flag rather than just bumping it if it dirtied the inode.
>
> So, if something earlier dirtied the inode without marking it bad
> (eg. resetting the inode's next unlinked field in the example that
> detected this issue), that dirty state will be lost if the nlink
> version checks out fine.

Looks good, but the diff you posted also includes a hunk in db/check.c
that introduces another sanity check in process_inode() which seems
unrelated.
