Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 06 Feb 2008 23:20:06 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m177JxkS031584
	for <xfs@oss.sgi.com>; Wed, 6 Feb 2008 23:20:02 -0800
Date: Thu, 7 Feb 2008 18:20:16 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH V2] make inode reclaim synchronise with xfs_iflush_done()
Message-ID: <20080207072016.GR155407@sgi.com>
References: <47AA86E5.5030804@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47AA86E5.5030804@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Thu, Feb 07, 2008 at 03:19:49PM +1100, Lachlan McIlroy wrote:
> On a forced shutdown, xfs_finish_reclaim() will skip flushing the inode.
> If the inode flush lock is not already held and there is an outstanding
> xfs_iflush_done() then we might free the inode prematurely.  By acquiring
> and releasing the flush lock we will synchronise with xfs_iflush_done().

Looks fine.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
