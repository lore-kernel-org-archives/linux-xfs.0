Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 08 Apr 2008 19:30:19 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m392U6kh025683
	for <xfs@oss.sgi.com>; Tue, 8 Apr 2008 19:30:10 -0700
Date: Wed, 9 Apr 2008 12:30:36 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: inconsistent xfs log record
Message-ID: <20080409023036.GB108924158@sgi.com>
References: <47FAD04D.5080308@agami.com> <20080408155043.GZ108924158@sgi.com> <47FBE558.1020106@agami.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47FBE558.1020106@agami.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Michael Nishimoto <miken@agami.com>
Cc: XFS Mailing List <xfs@oss.sgi.com>

On Tue, Apr 08, 2008 at 02:36:24PM -0700, Michael Nishimoto wrote:
> David Chinner wrote:
> >On Mon, Apr 07, 2008 at 06:54:21PM -0700, Michael Nishimoto wrote:
> > > I've just finished analyzing an xfs filesystem which won't recover.
> > > An inconsistent log record has 332 log operations but the num_logop 
> > field
> > > in the record header says 333 log operations.  The result is that xfs
> > > recovery
> > > complains with "bad clientid" because recovery eventually attempts to 
> >decode
> > > garbage.
> > >
> > > The log record really has 332 log ops (I counted!).
.....
> >FWIW, I have had 2-3 failures with a "bad clientid" on a 64k page size ia64
> >box since I switched from 16k page size about a month ago. I haven't 
> >seen any
> >consistent pattern to the failure yet, nor had a chance to perform any
> >sort of triage on the problem so I can't say whether I'm seeing the same
> >issue...
> 
> When you saw the problem, did you also have an off-by-one or one-bit 
> difference
> between num_logops and the real count?

No idea - i didn't traige it because I'd just switched over to 64k page size
and had about 10 new QA failures to catalogue and record. Going back to
the bug I originally raised, I see that there was a reproducable case to
produce the error:

$ sudo XFS_MKFS_OPTIONS="-s size=1024" ./check 139

i.e. sector size of 1k on a 64k page machine. However, that's as far as
I got and i haven't revisited it yet so I can't say if there's any
real correlation or not to what you've seen. It does, however, point
out that there is a problem there somewhere...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
