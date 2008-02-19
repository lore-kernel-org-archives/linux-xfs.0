Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 18 Feb 2008 17:55:10 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1J1sviR020082
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2008 17:55:01 -0800
Date: Tue, 19 Feb 2008 12:55:20 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [patch] Don't change ctime in truncate is size does not change
Message-ID: <20080219015520.GA155407@sgi.com>
References: <20080218233251.GV155407@sgi.com> <47BA16CC.7040700@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47BA16CC.7040700@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Mark Goodwin <markgw@sgi.com>
Cc: David Chinner <dgc@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Tue, Feb 19, 2008 at 10:37:48AM +1100, Mark Goodwin wrote:
> Did we ever discover what was behind the comment:
> "Have to do this even if the file's size doesn't change"

It was put there when the patch was checked in - I can only
assume that it was done this way because the old test script
that was being run didn't discriminate between the truncate
and truncate differences.

Basically, both the code and the comment are wrong and needed
to be fixed....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
