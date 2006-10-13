Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 12 Oct 2006 19:49:36 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id k9D2nPaG030482
	for <xfs@oss.sgi.com>; Thu, 12 Oct 2006 19:49:28 -0700
Date: Fri, 13 Oct 2006 12:48:30 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH] Remove DIO_OWN_LOCKING
Message-ID: <20061013024830.GF11034@melbourne.sgi.com>
References: <1160700998.5723.65.camel@xenon.msp.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1160700998.5723.65.camel@xenon.msp.redhat.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Russell Cattelan <cattelan@thebarn.com>
Cc: linux-fsdevel@vger.kernel.org, xfs@oss.sgi.com

On Thu, Oct 12, 2006 at 07:56:38PM -0500, Russell Cattelan wrote:
> While trying to fix up GFS2 directio and reading through the code
> involving the various lock flags I discovered the DIO_OWN_LOCKING 
> flag is no longer used.
>  
> XFS recently changed it xfs_vm_direct_IO function to call
> blockdev_direct_IO_no_locking for reads and
> blockdev_direct_IO_own_locking
> for writes. But DIO_OWN_LOCKING is only used in the direct IO read case
> so effectively the flag is never checked an therefore can probably be
> removed.

NACK.

This breaks XFS direct writes - the DIO_OWN_LOCKING flag has meaning
for direct writes even though a simple grep doesn't give you any
hits. get_more_blocks() sets the create flag unconditionally on
writes when DIO_OWN_LOCKING is set, and this is needed for XFS to be
able to allocate underlying blocks if the direct write is over a
hole or past EOF.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
