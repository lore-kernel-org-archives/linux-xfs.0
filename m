Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 02 Oct 2007 22:50:28 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l935oLrR014888
	for <xfs@oss.sgi.com>; Tue, 2 Oct 2007 22:50:23 -0700
Date: Wed, 3 Oct 2007 15:50:11 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: REVIEW: xfs_reno
Message-ID: <20071003055011.GP23367404@sgi.com>
References: <op.tzj549h63jf8g2@pc-bnaujok.melbourne.sgi.com> <20071002090216.GA22721@infradead.org> <20071002091951.GE995458@sgi.com> <4702F0CD.1070300@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4702F0CD.1070300@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: David Chinner <dgc@sgi.com>, Christoph Hellwig <hch@infradead.org>, Barry Naujok <bnaujok@sgi.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

On Wed, Oct 03, 2007 at 11:30:53AM +1000, Timothy Shimmin wrote:
> David Chinner wrote:
> >At that point, we'll got a "working" shrink that will allow
> >shrinking to only 50% of the original size because the log will
> >get in the way. To fix that, we'll need to implement transactions
> >to move the log...
> >
> Moving the log sounds pretty tricky.
> 
> Either we'd need to clean out the log (a la freeze) or
> copy the active part (tail->head) to the new location and zero out the rest 
> of
> the new log space (or may even need to write sectors with
> previous cycle#s at the start of each sector for the rest).
> So how would one do that with the copying approach because
> we'd need to be writing in to the new log and we'd need the log
> pointer in the superblock to be logged somewhere ughhhh.
> I think a type of freezing may be the way to go.

Yes.

> The trouble is we need to point the sb to the new log and the
> only place to log that is in the old log.

Sure.

> So I guess before unfreezing you write the sb logptr change
> using the old log and then after the unfreeze, everything uses the new log.

Yes.

> If you die before the sb change to disk then on mount you replay the sb 
> change
> using the old log and then start writing to the new log.

Yes.

> If you die before 
> writing the
> sb change in the old log then you are stuck.

No, the log swap never occurred. These would be sync transactions,
so if it never hit the disk no further transactions every occurred.
Hence this doesn't really cause any problems.

> You need this log change and freespace change (for making room for the log)
> in a transaction together and probably with other stuff.

a new log involves:

	freeze
	allocate new log space
	do log swap xaction
	sync old log
	<now safe to use new log>
	free old log
	sync new log
	unfreeze

Recovery is only complex in terms of freeing the new log space if we
crash without the logswap transaction being on disk, or freeing the
old log if we crash before that transaction hits the disk....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
