Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 24 Jan 2008 23:42:29 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m0P7gHQl003806
	for <xfs@oss.sgi.com>; Thu, 24 Jan 2008 23:42:22 -0800
Date: Fri, 25 Jan 2008 18:42:35 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [patch] Prevent AIL lock contention during transaction completion
Message-ID: <20080125074235.GI155407@sgi.com>
References: <20080121052330.GG155259@sgi.com> <4796E8C8.3030702@sgi.com> <20080123073446.GU155259@sgi.com> <479986F5.7070800@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <479986F5.7070800@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Timothy Shimmin <tes@sgi.com>
Cc: David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Fri, Jan 25, 2008 at 05:51:33PM +1100, Timothy Shimmin wrote:
> So do we really need to call xlog_assign_tail_lsn() then?
> Or are we just being conservative in case we missed something?

Conservative - the last thing I want is to introduce a subtle
difference to the tail lsn in the log record because we didn't
update it immediately before writing it to disk. I think we are
probably safe removing it, but lets leave that until we got some
wider test coverage on this change first....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
