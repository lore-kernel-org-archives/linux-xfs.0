Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6FDtl4O200688 for <xfs@oss.sgi.com>; Wed, 15 Jul 2009 08:55:48 -0500
Received: from mail.sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B68BD12A0862
	for <xfs@oss.sgi.com>; Wed, 15 Jul 2009 07:04:02 -0700 (PDT)
Received: from mail.sandeen.net (sandeen.net [209.173.210.139]) by
	cuda.sgi.com with ESMTP id yRSGIDgPQjGbIKHE for
	<xfs@oss.sgi.com>; Wed, 15 Jul 2009 07:04:02 -0700 (PDT)
Message-ID: <4A5DE008.5040103@sandeen.net>
Date: Wed, 15 Jul 2009 08:56:24 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH, RFC] xfs_repair - clear inodes in incorrect btree	format
References: <4A582070.9040907@sandeen.net>
	<20090715130705.GA27973@infradead.org>
In-Reply-To: <20090715130705.GA27973@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs-oss <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> Adding this check is certainly better than having nothing, but I would
> be much happier if we could do something.
> 
> On Sat, Jul 11, 2009 at 12:17:36AM -0500, Eric Sandeen wrote:
>> 1) How'd it get into this state? ... but maybe more importantly...
> 
> End of last year lachlan had case that looked a bit like this where
> we had problems resetting the fork state.
> 
>> 2) Should these really get cleared?  It's possibly a sane extent list,
>> it's just that it -could- be in extents rather than btree format...
> 
> That is indeed the the most likely case.  Do you still have a metadump
> with this problem around?  We should probably sanity-check for a valid
> looking extent format inode and then process it as such.

yep I do... and the user was able to perfectly copy off the files by
disabling the kernel check, FWIW.  So in this case it really was OK.

>> 3) By the same token, should the kernel really be choking on it?
> 
> Well, not choking could cause all kinds of harm by treating it as
> a btree inode while it's not.  We could try to apply a very careful
> variant of 2) above, but I'd really rather leave that kind of thing
> to repair.

Yep, probably best.

>> +	if (*nex <= XFS_DFORK_SIZE(dip, mp, whichfork) / sizeof(xfs_bmbt_rec_t)) {
>> +		do_warn(_("extent count for ino %lld %s fork too low "
>> +			  "(%d) for file format\n"),
>> +				lino,
>> +				whichfork == XFS_DATA_FORK ? _("data") : _("attr"),
>> +				*nex);
>> +		return(1);
>> +	}
> 
> Well, you'll get my ok in the sense of this looks good and better than
> nothing, but I'd really prefer a real fixup for this issues.  Also the
> code above looks a bit unreadable, why not:

I guess I tend to prefer a real fixup too, if possible; I suppose
there's existing infrastructure to check it as a btree inode, and
hopefully to move it into extents as well.

FWIW I just copied the check above from xfs_check ;)

Sure, below formatting is better.

thanks,
-Eric

> 	if (*nex <= XFS_DFORK_SIZE(dip, mp, whichfork) /
> 			sizeof(xfs_bmbt_rec_t)) {
> 		do_warn(
> 	_("extent count for ino %lld %s fork too low (%d) for file format\n"),
> 			lino, forkname, *nex);
> 		return 1;
> 	}
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
