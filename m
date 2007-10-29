Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 29 Oct 2007 16:48:53 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9TNmk9M002911
	for <xfs@oss.sgi.com>; Mon, 29 Oct 2007 16:48:50 -0700
Date: Tue, 30 Oct 2007 10:48:43 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Default mount options (that suck less).
Message-ID: <20071029234843.GV995458@sgi.com>
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
> 
> - dropping the ability to turn unwritten extents off completely
> 
> please submit your pet-idea for better defaults here.

Another one for you - make the log larger. The kernel code supports
a log of up to 2GB, so mkfs could making a larger log without
requiring changes elsewhere.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
