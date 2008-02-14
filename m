Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 13 Feb 2008 18:59:32 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1E2xNAk016659
	for <xfs@oss.sgi.com>; Wed, 13 Feb 2008 18:59:25 -0800
Date: Thu, 14 Feb 2008 13:59:36 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: PARTIAL TAKE 971186 - Fix regression due to refcache removal
Message-ID: <20080214025935.GJ155259@sgi.com>
References: <20080214011850.8F03858C4C11@chook.melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080214011850.8F03858C4C11@chook.melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: sgi.bugs.xfs@engr.sgi.com, xfs@oss.sgi.com

On Thu, Feb 14, 2008 at 12:18:50PM +1100, Lachlan McIlroy wrote:
> Fix regression due to refcache removal

Can we please use more descriptive check-in messages?

Remember, the description is what ends up in the git commit log and
so needs to include a summary of the problem and the fix that was
made. That way the it's easy see what changes were made when read
the git log without needed to look at diffs.

IOWs, the description should read:

"Fix a regression due to the refcache removal.

Some code in xfs_rwunlock() was accidentally removed
when removing the refcache. This results in inodes not
being properly unlocked and causes system hangs. Fixed
by reinstating the missing code."

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
