Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 10 Oct 2007 04:28:39 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9ABSPlt000445
	for <xfs@oss.sgi.com>; Wed, 10 Oct 2007 04:28:27 -0700
Date: Wed, 10 Oct 2007 21:28:21 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: review: use correct buffer flags when reading superblock
Message-ID: <20071010112821.GI23367404@sgi.com>
References: <470C8F5B.90705@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <470C8F5B.90705@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

On Wed, Oct 10, 2007 at 06:37:47PM +1000, Lachlan McIlroy wrote:
> When reading the superblock during log recovery we are not setting
> the correct buffer flags.  Specifically we are not turning off flags
> we do not need such as XBF_ASYNC that is causing the synchronous
> xfs_iowait() to hang.  We should also turn off XBF_WRITE and remove
> the buffer from the delay write queue just to be safe.

We really don't need the removal of the write flags - the XFS_bflush()
call above the xfs_getsb() call guarantees that they won't be set....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
