Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 14 May 2007 17:05:45 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l4F05efB021310
	for <xfs@oss.sgi.com>; Mon, 14 May 2007 17:05:41 -0700
Date: Tue, 15 May 2007 10:05:23 +1000
From: David Chinner <dgc@sgi.com>
Subject: Re: Review: Concurrent Multi-File Data Streams
Message-ID: <20070515000523.GQ86004887@sgi.com>
References: <p73sla1ev7o.fsf@bingen.suse.de> <000001c79544$44076ac0$0501010a@DCHATTERTONLAPTOP> <20070514223946.GA19487@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070514223946.GA19487@one.firstfloor.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Andi Kleen <andi@firstfloor.org>
Cc: David Chatterton <dchatterton@aconex.com>, 'xfs-dev' <xfs-dev@sgi.com>, 'xfs-oss' <xfs@oss.sgi.com>, 'David Chinner' <dgc@sgi.com>

On Tue, May 15, 2007 at 12:39:46AM +0200, Andi Kleen wrote:
> > So yes this is designed for a workload where the number of AGs is a multiple
> > of the number of streams since mixing streams in the one AG is the problem
> > it tries to avoid.
> 
> Sounds like a awful special case. Is that common? 

Common enough to be a serious problem when running multiple 2k ingest and
playout streams (320MB/s each).

Cheers,

Dave.
-- 
Dave Chinner
Principal Engineer
SGI Australian Software Group
