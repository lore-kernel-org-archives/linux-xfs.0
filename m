Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 27 Jun 2007 20:06:19 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l5S36DtL022373
	for <xfs@oss.sgi.com>; Wed, 27 Jun 2007 20:06:15 -0700
Date: Thu, 28 Jun 2007 13:06:04 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [patch 1/3] Fix XFS_IOC_FSGEOMETRY_V1 in compat mode
Message-ID: <20070628030603.GC989688@sgi.com>
References: <20070619132549.266927601@suse.cz> <20070619132726.360453113@suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070619132726.360453113@suse.cz>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: mmarek@suse.cz
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org

On Tue, Jun 19, 2007 at 03:25:50PM +0200, mmarek@suse.cz wrote:
> i386 struct xfs_fsop_geom_v1 has no padding after the last member, so
> the size is different.

Looks good. Added to my qa tree...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
