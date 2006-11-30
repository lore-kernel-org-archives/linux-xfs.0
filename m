Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 30 Nov 2006 15:42:58 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kAUNgmaG031346
	for <xfs@oss.sgi.com>; Thu, 30 Nov 2006 15:42:50 -0800
Date: Fri, 1 Dec 2006 10:41:46 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: TAKE 957159 - Reduce XFS 4k stack kernel issues
Message-ID: <20061130234146.GR37654165@melbourne.sgi.com>
References: <20061130080359.E3F7C58FF58B@chook.melbourne.sgi.com> <456F4A25.80709@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <456F4A25.80709@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: David Chinner <dgc@sgi.com>, xfs@oss.sgi.com

On Thu, Nov 30, 2006 at 03:16:21PM -0600, Eric Sandeen wrote:
> David, did this add any new static declarations, or just get the
> existing ones into shape?

It just got the existing stuff into shape and fixed the
xfs_clear_inode inlining problems.

> IOW, I think I should rework my make-more-things-static patch?

Sure - it would be good to get it in before the .20-rc1 merge
window closes....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
