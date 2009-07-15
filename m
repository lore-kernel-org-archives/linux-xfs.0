Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6FD6QnH197707 for <xfs@oss.sgi.com>; Wed, 15 Jul 2009 08:06:27 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E8F0D364EC0
	for <xfs@oss.sgi.com>; Wed, 15 Jul 2009 06:07:05 -0700 (PDT)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34])
	by cuda.sgi.com with ESMTP id 0RgqDr6kvqbmDaCC for
	<xfs@oss.sgi.com>; Wed, 15 Jul 2009 06:07:05 -0700 (PDT)
Date: Wed, 15 Jul 2009 09:07:05 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH, RFC] xfs_repair - clear inodes in incorrect btree format
Message-ID: <20090715130705.GA27973@infradead.org>
References: <4A582070.9040907@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4A582070.9040907@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

Adding this check is certainly better than having nothing, but I would
be much happier if we could do something.

On Sat, Jul 11, 2009 at 12:17:36AM -0500, Eric Sandeen wrote:
> 1) How'd it get into this state? ... but maybe more importantly...

End of last year lachlan had case that looked a bit like this where
we had problems resetting the fork state.

> 2) Should these really get cleared?  It's possibly a sane extent list,
> it's just that it -could- be in extents rather than btree format...

That is indeed the the most likely case.  Do you still have a metadump
with this problem around?  We should probably sanity-check for a valid
looking extent format inode and then process it as such.

> 3) By the same token, should the kernel really be choking on it?

Well, not choking could cause all kinds of harm by treating it as
a btree inode while it's not.  We could try to apply a very careful
variant of 2) above, but I'd really rather leave that kind of thing
to repair.

> +	if (*nex <= XFS_DFORK_SIZE(dip, mp, whichfork) / sizeof(xfs_bmbt_rec_t)) {
> +		do_warn(_("extent count for ino %lld %s fork too low "
> +			  "(%d) for file format\n"),
> +				lino,
> +				whichfork == XFS_DATA_FORK ? _("data") : _("attr"),
> +				*nex);
> +		return(1);
> +	}

Well, you'll get my ok in the sense of this looks good and better than
nothing, but I'd really prefer a real fixup for this issues.  Also the
code above looks a bit unreadable, why not:


	if (*nex <= XFS_DFORK_SIZE(dip, mp, whichfork) /
			sizeof(xfs_bmbt_rec_t)) {
		do_warn(
	_("extent count for ino %lld %s fork too low (%d) for file format\n"),
			lino, forkname, *nex);
		return 1;
	}

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
