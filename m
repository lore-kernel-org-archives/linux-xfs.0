Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 07 Dec 2006 21:34:11 -0800 (PST)
Received: from omx1.sgi.com (omx1.americas.sgi.com [198.149.16.13])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id kB85Y0qw031342
	for <xfs@oss.sgi.com>; Thu, 7 Dec 2006 21:34:01 -0800
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by omx1.sgi.com (8.12.10/8.12.9/linux-outbound_gateway-1.1) with SMTP id kB85GZDW030162
	for <xfs@oss.sgi.com>; Thu, 7 Dec 2006 23:16:37 -0600
Date: Fri, 8 Dec 2006 16:16:29 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Review: Reduce in-core superblock lock contention near ENOSPC
Message-ID: <20061208051629.GV33919298@melbourne.sgi.com>
References: <20061123044122.GU11034@melbourne.sgi.com> <456F1CFC.2060705@sgi.com> <20061130223810.GO37654165@melbourne.sgi.com> <457080EA.1010807@sgi.com> <20061203234928.GA37654165@melbourne.sgi.com> <45755C26.2080505@gmx.net> <20061205215503.GW44411608@melbourne.sgi.com> <457682C3.6000802@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <457682C3.6000802@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>
Cc: David Chinner <dgc@sgi.com>, Klaus Strebel <klaus.strebel@gmx.net>, xfs-dev@sgi.com, xfs@oss.sgi.com

On Wed, Dec 06, 2006 at 08:43:47AM +0000, Lachlan McIlroy wrote:
> David Chinner wrote:
> >On Tue, Dec 05, 2006 at 12:46:46PM +0100, Klaus Strebel wrote:
> >
> >>Hi guys,
> >>
> >>just updated my CVS copy from oss.sgi.com ( the linux-2.6-xfs ) and 
> >>tried to compile ... but your patch failes to compile if HAVE_PERCPU_SB 
> >>is #ifndef'd :-(, the m_icsb_mutex is not in the struct see xfs_mount.h. 
> >>Make oldconfig didn't show HAVE_PERCPU_SB as option for .config, looks 
> >>like nobody tested on a single processor config ??
> >
> >
> >Sorry - my bad. The code did not change for UP, so I didn't think to
> >test it.  The patch below abstracts the icsb_mutex so that it
> >doesn't get directly referenced by code outside the per-cpu counter
> >code. Builds with and without HAVE_PERCPU_SB defined.
> >
> >I'll run a test cycle on it and get it fixed up.
> >
> >Cheers,
> >
> >Dave.
> 
> @@ -1803,6 +1803,7 @@ xfs_icsb_destroy_counters(
>  		unregister_hotcpu_notifier(&mp->m_icsb_notifier);
>  		free_percpu(mp->m_sb_cnts);
>  	}
> +	mutex_destroy(&mp->m_icsb_mutex);
>  }
> 
> Do you need to abstract the call to mutex_destroy too?

No. I didn't abstract the mutex_init and mutex_destroy calls because
they are in the init/destroy functions for the icsb subsystem and
those functions are #define'd out when HAVE_PERCPU_SB is not
defined.

> The rest of the change looks good.

Thanks, Lachlan.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
