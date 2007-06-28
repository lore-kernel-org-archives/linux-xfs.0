Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 27 Jun 2007 20:07:14 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5S376tL022756
	for <xfs@oss.sgi.com>; Wed, 27 Jun 2007 20:07:09 -0700
Date: Thu, 28 Jun 2007 13:07:00 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [patch 2/3] Fix XFS_IOC_*_TO_HANDLE and XFS_IOC_{OPEN,READLINK}_BY_HANDLE in compat mode
Message-ID: <20070628030700.GD989688@sgi.com>
References: <20070619132549.266927601@suse.cz> <20070619132726.627137347@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070619132726.627137347@suse.cz>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: mmarek@suse.cz
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org

On Tue, Jun 19, 2007 at 03:25:51PM +0200, mmarek@suse.cz wrote:
> 32bit struct xfs_fsop_handlereq has different size and offsets (due to
> pointers). TODO: case XFS_IOC_{FSSETDM,ATTRLIST,ATTRMULTI}_BY_HANDLE
> still not handled.

Looks good. Added to my qa tree...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
