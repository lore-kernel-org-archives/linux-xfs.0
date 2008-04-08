Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 08 Apr 2008 08:50:30 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m38FoHwQ022540
	for <xfs@oss.sgi.com>; Tue, 8 Apr 2008 08:50:19 -0700
Date: Wed, 9 Apr 2008 01:50:43 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: inconsistent xfs log record
Message-ID: <20080408155043.GZ108924158@sgi.com>
References: <47FAD04D.5080308@agami.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47FAD04D.5080308@agami.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Michael Nishimoto <miken@agami.com>
Cc: XFS Mailing List <xfs@oss.sgi.com>

On Mon, Apr 07, 2008 at 06:54:21PM -0700, Michael Nishimoto wrote:
> I've just finished analyzing an xfs filesystem which won't recover.
> An inconsistent log record has 332 log operations but the num_logop field
> in the record header says 333 log operations.  The result is that xfs 
> recovery
> complains with "bad clientid" because recovery eventually attempts to decode
> garbage.
> 
> The log record really has 332 log ops (I counted!).
> 
> Looking through xlog_write(), I don't see any way that record_cnt can be 
> bumped
> without also writing out a log operation.

Yeah, i remember going through this a while back tracking done the same
error on snapshot images (was a freeze problem) and I couldn't see how
it would happen, either. 

Still, it's a single bit error so that's always suspicious - can you
reproduce this error reliably?

> Does this issue ring a bell with anyone?

FWIW, I have had 2-3 failures with a "bad clientid" on a 64k page size ia64
box since I switched from 16k page size about a month ago. I haven't seen any
consistent pattern to the failure yet, nor had a chance to perform any
sort of triage on the problem so I can't say whether I'm seeing the same
issue...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
