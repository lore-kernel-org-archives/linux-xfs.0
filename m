Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 29 Oct 2007 07:04:01 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9TE3rI6021876
	for <xfs@oss.sgi.com>; Mon, 29 Oct 2007 07:03:56 -0700
Message-ID: <4725E84D.3030609@sandeen.net>
Date: Mon, 29 Oct 2007 09:03:57 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Default mount options (that suck less).
References: <20071029075657.GA84369978@melbourne.sgi.com>
In-Reply-To: <20071029075657.GA84369978@melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Niv Sardi <xaiki@sgi.com>
Cc: xfs@oss.sgi.com

Niv Sardi wrote:
> Hello,
> 
> XFS's default mount options are in most cases sub-optimal, we should try
> to have more sensible defaults, so far I'm following some quick dave-powered
> recomendations:
> 
> - version 2 logs
> - attr2

FWIW any anaconda-installed xfs filesystems have been using attr2 since
FC6, and after the initial pain, I haven't heard any reports of problems.


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

larger logbuf count/size seems to be the other tuning that's thrown
around a lot.

-Eric
