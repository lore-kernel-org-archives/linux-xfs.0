Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 01 Nov 2007 15:55:01 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lA1MssbB018151
	for <xfs@oss.sgi.com>; Thu, 1 Nov 2007 15:54:57 -0700
Date: Fri, 2 Nov 2007 09:54:53 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] fix transaction overrun during writeback
Message-ID: <20071101225453.GF995458@sgi.com>
References: <20071029234010.GU995458@sgi.com> <4729304A.2010202@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4729304A.2010202@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com, xfs-dev@sgi.com

On Thu, Nov 01, 2007 at 12:47:54PM +1100, Lachlan McIlroy wrote:
> Looks good Dave.  Since this is a writeback path is there some way
> we can tell xfs_bmapi() that it should not convert anything but
> delayed allocs and have it assert/error out if it tries to - not
> that it will now with this change but just as defensive measure?

I looked at that, but it's not straight forward. In this case we
are simply asking for an allocation, assuming the range we ask
for is already delalloc. however, the same call could be used
to allocate the space if the transaction reservation took into
account the space needing to be allocated.

So there's not really any simple way to deal with this, esp.
as it is valid to allocate both delalloc and unreserved
space in the one xfs_bmapi() call as long as you do the right
thing with the transaction reservation...

We really need to fix the way xfs_iomap works so we don't have the
race condition in the first place....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
