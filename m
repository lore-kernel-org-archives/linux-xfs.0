Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 03 Feb 2008 20:46:07 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m144jv9V023120
	for <xfs@oss.sgi.com>; Sun, 3 Feb 2008 20:46:03 -0800
Date: Mon, 4 Feb 2008 15:46:11 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: unpushed 4-month-old mods?
Message-ID: <20080204044611.GF155407@sgi.com>
References: <47A694F3.9010307@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47A694F3.9010307@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Sun, Feb 03, 2008 at 10:30:43PM -0600, Eric Sandeen wrote:
> At least these three mods which I did back in September to get Fedora 8
> / 2.6.23 into shape on 4k stacks, and a bugfix, are still not pushed to
> kernel.org, and are missing in 2.6.24...
> 
> Is there any reason for the holdup?  Makes me wonder what else isn't
> pushed...

The holdup is that we drew a line in the sand for the 2.6.24 before
2.6.23 was released. We did this because of the massive amount of invasive
change we already had queued up for 2.6.24.  All those mods that got
held up will be pushed into 2.6.25 release.

Given the problems with the readdir changes (which still isn't 100% right
given we've had at least one bug report of a crash in the readdir code
post 2.6.24 release), we couldn't have handled much more change in that
release.....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
