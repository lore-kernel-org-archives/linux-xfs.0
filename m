Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 26 Jul 2007 23:59:37 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6R6xWbm001845
	for <xfs@oss.sgi.com>; Thu, 26 Jul 2007 23:59:34 -0700
Date: Fri, 27 Jul 2007 16:59:30 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: RFC: log record CRC validation
Message-ID: <20070727065930.GT12413810@sgi.com>
References: <20070725092445.GT12413810@sgi.com> <46A7226D.8080906@sgi.com> <46A8DF7E.4090006@agami.com> <20070726233129.GM12413810@sgi.com> <46A94963.7000103@agami.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A94963.7000103@agami.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Michael Nishimoto <miken@agami.com>
Cc: David Chinner <dgc@sgi.com>, markgw@sgi.com, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, Jul 26, 2007 at 06:24:51PM -0700, Michael Nishimoto wrote:
> The log checksum code has not been used since the
> development phase of xfs.  It did work at one point because I
> remember using it and then decided to disable it and use just
> the current cycle stamping technique.  The checksum code was
> just advisory, so I could see if it ever occurred during
> development.
> 
> When a CRC error is found, your suggestion is correct.  Recovery
> should backup and process only completely good log records.  The code
> backs up in this same fashion when it encounters a region of
> missing sector updates because of the async nature of log
> writes and disk caches.

Yes, but that's usually only in the last 8 log-buffers worth of the
the log that the hole exists in (i.e. 256k by default). However, if
the tail block has a CRC error, we've got to through away the entire
log and that, like zeroing a dirty log from xfs_repair, generally
results in a corrupted filesystem image.

An example of where this could be a problem is reusing a just-freed
extent. Before reusing it we force the log to get the transaction on
disk and rely on log replay to ensure that the block is freed in the
event of a crash. We then go and write over the contents of the
block. If that log transaction is not replayed (that freed the
extent) then we've overwritten the previous contents of that extent
and so the "current" contents of the extent after log replay are wrong.

IOWs, I think that if we come across a bad CRC in a log record we
can replay up to that point but we've still got to abort the mount
and ask the user to run repair....

> At this point, I'm not convinced that xfs needs to do CRCs on
> the xfs log because the size of an xfs log is relatively small.

Sure, but the same argument can be made about the superblock,
or an AGF and a directory block. That doesn't mean that they'll
never have an error.

Statistically speaking, the log contains that blocks in the
filesystem we most frequently do I/O to, so it's the most likely
region to see an I/O path induced bit error. If we see one
on recovery......

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
