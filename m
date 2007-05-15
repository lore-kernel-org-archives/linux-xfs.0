Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 14 May 2007 17:15:54 -0700 (PDT)
Received: from postoffice.aconex.com (mail.app.aconex.com [203.89.192.138])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l4F0FmfB024021
	for <xfs@oss.sgi.com>; Mon, 14 May 2007 17:15:50 -0700
From: "David Chatterton" <dchatterton@aconex.com>
Subject: RE: Review: Concurrent Multi-File Data Streams
Date: Tue, 15 May 2007 10:15:50 +1000
Message-ID: <00f501c79686$319a0530$0501010a@DCHATTERTONLAPTOP>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
In-Reply-To: <20070514223946.GA19487@one.firstfloor.org>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: 'Andi Kleen' <andi@firstfloor.org>
Cc: 'xfs-dev' <xfs-dev@sgi.com>, 'xfs-oss' <xfs@oss.sgi.com>, 'David Chinner' <dgc@sgi.com>

Andi,

Dave just beat me to it, this represents the workload used by all
post-production houses since they moved to digital where each stream is
320MB/s (2K format) or 1.3GB/s (4K format). Making sure those files are
written sequentially on disk and do not overlap other streams has a huge
benefit when supporting multiple streams.

There is no reason why other workloads that would benefit from files in the
same directory being written sequentially into their "own AG" would not use
this feature. Post-production just tends to push the filesystem to the
limits earlier than some other workloads.

David



> -----Original Message-----
> From: Andi Kleen [mailto:andi@firstfloor.org] 
> Sent: Tuesday, 15 May 2007 8:40 AM
> To: David Chatterton
> Cc: 'Andi Kleen'; 'xfs-dev'; 'xfs-oss'; 'David Chinner'
> Subject: Re: Review: Concurrent Multi-File Data Streams
> 
> > So yes this is designed for a workload where the number of AGs is a 
> > multiple of the number of streams since mixing streams in 
> the one AG 
> > is the problem it tries to avoid.
> 
> Sounds like a awful special case. Is that common? 
> 
> -Andi
> 
