Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 22 Jul 2007 16:39:56 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l6MNdobm003160
	for <xfs@oss.sgi.com>; Sun, 22 Jul 2007 16:39:52 -0700
Date: Mon, 23 Jul 2007 09:39:43 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: [PATCH 1/7] - remove m_nreadaheads
Message-ID: <20070722233943.GJ31489@sgi.com>
References: <46A03612.6030806@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46A03612.6030806@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On Thu, Jul 19, 2007 at 11:12:02PM -0500, Eric Sandeen wrote:
> Dave pointed this out...
> 
> m_nreadaheads in the mount struct is never used;
> remove it and the various macros assigned to it.
> 
> Also remove a couple other unused macros in the same areas.
> 
> Removes one user of xfs_physmem.
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>

The patch series looks good, Eric. I've grabbed all of them for
testing, but I'll hold off applying the lock wrapper changes 
until we decide exactly what to do there...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
