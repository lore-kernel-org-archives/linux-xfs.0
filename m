Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mBHEPEdi024303 for <xfs@oss.sgi.com>; Wed, 17 Dec 2008 08:25:14 -0600
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B426F1748BA0
	for <xfs@oss.sgi.com>; Wed, 17 Dec 2008 06:25:13 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id R3XdtjNZPz0G6oRq for
	<xfs@oss.sgi.com>; Wed, 17 Dec 2008 06:25:13 -0800 (PST)
Date: Wed, 17 Dec 2008 09:24:42 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Fwd: [PATCH] Fix speculative allocation beyond eof]
Message-ID: <20081217142442.GC22023@infradead.org>
References: <49378444.9040108@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <49378444.9040108@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Dec 04, 2008 at 06:18:28PM +1100, Lachlan McIlroy wrote:
> Speculative allocation beyond eof doesn't work properly.  It was broken some
> time ago after a code cleanup that moved what is now xfs_iomap_eof_align_last_fsb()
> and xfs_iomap_eof_want_preallocate() out of xfs_iomap_write_delay() into
> separate functions.  The code used to use the current file size in various checks
> but got changed to be max(file_size, i_new_size).  Since i_new_size is the result
> of 'offset + count' then in xfs_iomap_eof_want_preallocate() the check for
> '(offset + count) <= isize' will always be true.
> 
> ie if 'offset + count' is > ip->i_size then isize will be i_new_size and equal to
> 'offset + count'.
> 
> This change fixes all the places that used to use the current file size.

Looks good, we should be using the current i_size everywhere.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
