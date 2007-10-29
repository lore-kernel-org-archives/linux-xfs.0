Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 29 Oct 2007 01:55:20 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9T8t55v014478
	for <xfs@oss.sgi.com>; Mon, 29 Oct 2007 01:55:08 -0700
Date: Mon, 29 Oct 2007 19:55:02 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Default mount options (that suck less).
Message-ID: <20071029085502.GI995458@sgi.com>
References: <20071029075657.GA84369978@melbourne.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071029075657.GA84369978@melbourne.sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Niv Sardi <xaiki@sgi.com>
Cc: xfs@oss.sgi.com

On Mon, Oct 29, 2007 at 06:56:57PM +1100, Niv Sardi wrote:
> Hello,
> 
> XFS's default mount options are in most cases sub-optimal, we should try

Mkfs options ;)

> to have more sensible defaults, so far I'm following some quick dave-powered
> recomendations:
> 
> - version 2 logs
> - attr2
> - lazy superblock counters
> - less allocation groups for single disk configs
> 
> - imaxpct default can be reduced
> 
> it is currently 25, what would be reasonable ?

Given that 25% on a 4GB filesystem will allow about 5million inodes,
I think it's probably reasonable to bring it down to 5% by the time we
pass 1TB and 1% by 50TB.....

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
