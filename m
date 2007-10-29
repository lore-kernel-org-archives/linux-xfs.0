Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 29 Oct 2007 14:06:09 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id l9TL61T6009505
	for <xfs@oss.sgi.com>; Mon, 29 Oct 2007 14:06:04 -0700
Date: Tue, 30 Oct 2007 08:05:53 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: Default mount options (that suck less).
Message-ID: <20071029210553.GJ995458@sgi.com>
References: <20071029075657.GA84369978@melbourne.sgi.com> <4725E84D.3030609@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4725E84D.3030609@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Niv Sardi <xaiki@sgi.com>, xfs@oss.sgi.com

On Mon, Oct 29, 2007 at 09:03:57AM -0500, Eric Sandeen wrote:
> Niv Sardi wrote:
> > please submit your pet-idea for better defaults here.
> 
> larger logbuf count/size seems to be the other tuning that's thrown
> around a lot.

Well, we already default to 8 logbufs, and 256k log buffers are not a
win in a lot of situations. The log buffer size is a mount option,
so it's much easier to tweak once we default to v2 logs...

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
