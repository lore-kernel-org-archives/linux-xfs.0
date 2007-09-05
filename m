Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 04 Sep 2007 23:54:22 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l856sF4p029545
	for <xfs@oss.sgi.com>; Tue, 4 Sep 2007 23:54:18 -0700
Date: Wed, 5 Sep 2007 16:54:07 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] log replay should not overwrite newer ondisk inodes
Message-ID: <20070905065407.GO734179@sgi.com>
References: <46D6279F.40601@sgi.com> <46DDE4A2.1070204@agami.com> <46DE042D.8060103@sgi.com> <46DE0906.2040602@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46DE0906.2040602@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: Timothy Shimmin <tes@sgi.com>, Shailendra Tripathi <stripathi@agami.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Wed, Sep 05, 2007 at 11:40:22AM +1000, Lachlan McIlroy wrote:
> >Dave answered this but yes this is a case where we are breaking
> >the transaction model IMO. And my understanding is that we are doing
> >this for performance reasons.
> >One of Lachlan's proposals (IIRC) was to log the size change before the
> >ondisk size change in xfs_aops.c/xfs_setfilesize()
> >and thus follow the model but questions were raised about introducing
> >performance overhead of log traffic in the write path.
> 
> It would make life easier to do it that way - we wouldn't have to check
> the flushiter field of the ondisk inode because we know we will end up
> with the same thing by just replaying the log.  But since the addition
> of the flushiter stuff pre-dates the NULL files changes there must be
> another reason we need it.  Previously the size change would get logged
> with an extent allocation transaction but extending a file within the
> same last block would not send the new file size to the log.  I think
> that may have been the reason for needing the flushiter stuff.  If we
> log the file size change in xfs_setfilesize() we may not need the
> flushiter stuff at all, hmmm maybe for timestamp updates?

atime, size updates and inode version format conversion may be written without
a transaction first logging the change.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
