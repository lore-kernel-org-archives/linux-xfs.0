Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 07 Nov 2006 00:18:56 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kA78IjaG012195
	for <xfs@oss.sgi.com>; Tue, 7 Nov 2006 00:18:47 -0800
Date: Tue, 7 Nov 2006 19:17:48 +1100
From: David Chinner <dgc@sgi.com>
Subject: Re: mount failed after xfs_growfs beyond 16 TB
Message-ID: <20061107081748.GA8394166@melbourne.sgi.com>
References: <20061102172608.GA27769@pc51072.physik.uni-regensburg.de> <454A3B28.7010405@sandeen.net> <20061103093203.GA18010@pc51072.physik.uni-regensburg.de> <20061103123418.GP8394166@melbourne.sgi.com> <20061103154448.GA26647@pc51072.physik.uni-regensburg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20061103154448.GA26647@pc51072.physik.uni-regensburg.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christian Guggenberger <christian.guggenberger@physik.uni-regensburg.de>
Cc: David Chinner <dgc@sgi.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On Fri, Nov 03, 2006 at 04:44:48PM +0100, Christian Guggenberger wrote:
> > The superblock:
> > 
> > blocksize = 4096
> > dblocks = 18446744070056148512
> > ...
> > agblocks = 84976608
> > agcount = 570
> > 
> > An AG is ~43.5GB, so 570 AGs is 24.8TB. It's to big, and
> > we will only shrink by whole AGs. Hence we have to correct
> > agcount and dblocks.
> 
> isn't the AG size 'agblocks * blocksize' == ~324 GB here ?

Yes, you are right - I was thinking 512 byte blocks which
then gave the right size that you grew to. Otherwise 570*324GB
gives 200TB, which is somewhat larger than you apparently tried
to grow to...

Sorry for the misdirection, but I'm glad to see that you got
it fixed.

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
