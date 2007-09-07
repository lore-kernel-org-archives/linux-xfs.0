Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 07 Sep 2007 07:05:51 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l87E5h4p005531
	for <xfs@oss.sgi.com>; Fri, 7 Sep 2007 07:05:48 -0700
Date: Sat, 8 Sep 2007 00:05:41 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] log replay should not overwrite newer ondisk inodes
Message-ID: <20070907140541.GA734179@sgi.com>
References: <46D6279F.40601@sgi.com> <46D6480F.4040307@sgi.com> <46D64CAD.6050705@sgi.com> <46D67FE6.20205@sgi.com> <46D68510.1020404@sgi.com> <46D77B79.3040104@sgi.com> <46D792A1.7030308@sgi.com> <20070831154822.GD734179@sgi.com> <46E0B154.1000805@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46E0B154.1000805@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: Mark Goodwin <markgw@sgi.com>, Timothy Shimmin <tes@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Fri, Sep 07, 2007 at 12:03:00PM +1000, Lachlan McIlroy wrote:
> David Chinner wrote:
> >An unlinked inode is only detectable by the mode parameter being zero.
> >The rest of the inode will look valid.
> >
> >To detect the difference between a newly allocated inode *chunk*
> >that has been written to and a stale inode chunk that we have
> >just allocated and not written to yet, you need to walk every inode
> >in the chunk and determine if the mode parameter is zero in every
> >inode.
> >
> >If the mode is zero for all inodes and there are generation numbers
> >that are not zero, then you've detected a stale buffer and you should
> >replay the inode cluster buffer initialisation.
> >
> 
> Thanks for this info Dave.  I looked into it and came up with a solution
> that looks at the ondisk inode buffer and determines if it has been
> written to since being logged.  It iterates through all the inodes and
> checks each one with:
> 
> - if the magic number is wrong the buffer is stale

*nod*

> - if the mode is non-zero then the buffer is newer than the log

*nod*

> - if the mode is zero and the generation count is non-zero then the
>   buffer is stale

On second thoughts, this might be more complex - the buffer is stale
only if all inodes in the *chunk* have this pattern. We may have multiple
buffers to a chunk. e.g. allocate 55 inodes, they span two 8k cluster
buffers. Both meet the second criteria. Now remove the first 32 inodes,
and we have one buffer with zero allocated inodes but non-zero generation
numbers (i.e. thrid state) and one that meets the second criteria.

However, both buffers are more recent than the buffer being replayed.
We could lose generation count changes if we overwrite the buffer with
no inodes in it....

So I think the stale buffer criteria must be that all the inodes in the entire
inode chunk (i.e. across all buffers) must have a zero mode and at least one
of the inodes has a non-zero generation count. Does that make sense?

> If the end result is a stale buffer then the buffer is replayed otherwise
> it is skipped.  I added a new flag that gets logged with a new inode
> cluster so that we can identify a buffer of inodes from something else.
> This fix is passing all the tests we have.  Is this a better approach
> than the last fix?

Definitely, but I think our "stale buffer" detection needs more work.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
