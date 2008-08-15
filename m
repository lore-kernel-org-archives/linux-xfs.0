Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 15 Aug 2008 15:05:46 -0700 (PDT)
Received: from cuda.sgi.com ([192.48.176.15])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m7FM5iY3022255
	for <xfs@oss.sgi.com>; Fri, 15 Aug 2008 15:05:45 -0700
Date: Fri, 15 Aug 2008 18:07:01 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] Fix reference counting race on log buffers
Message-ID: <20080815220701.GA13770@infradead.org>
References: <1215752481-6862-1-git-send-email-david@fromorbit.com> <20080814180603.GA3087@infradead.org> <48A4DB09.7020702@sgi.com> <20080815012807.GA547@infradead.org> <48A4F61E.3050106@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48A4F61E.3050106@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>, xfs@oss.sgi.com

On Fri, Aug 15, 2008 at 01:21:02PM +1000, Lachlan McIlroy wrote:
>>  - a different xfs_version.h - IMHO we should just kill this versioning
>>    scheme completely..
>>  - xfsidbg.  Maybe now with kgdb in the kgdb folks get something
>>    submitted and then this is taken care off..
> That stuff is there for kdb.  Are you suggesting we switch to kgdb and
> drop this file?

No, sorry for the stupid typo.  I meant now with kgdb in maybe the kdb
folks can get their act together and try to submit it, at which point
xfsidbg could go upstream.

>>  - modular quota.  IMHO we should just stop doing this in CVS, it
>>    doesn't really buy us anything.  If people are okay with that
>>    I'll send a patch
> I don't see any problem with this.  Seems like a good idea.

Ok, I'll prepare something.

>
>>  - dmapi - well, this won't get merged and currently I don't see anyone
>>    doing HSM for mainline properly.  But I have some ideas how to make
>>    it less intrusive at least
> All that would be very helpful.

> Last time I checked the fs/xfs differences between mainline and our
> internal tree resulted in a patch around 470KB.  Most of that is changes
> that we don't push to mainline such as fs/xfs/dmapi and fs/xfs/xfsidbg.c.
> The rest I'm working though.

Yeah, the list above should have been complete, I just went through the
diff yesterday.
