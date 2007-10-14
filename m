Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sat, 13 Oct 2007 17:23:32 -0700 (PDT)
Received: from smtp.aaisp.net.uk (smtp.aaisp.net.uk [81.187.81.51])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id l9E0NNQ3030253
	for <xfs@oss.sgi.com>; Sat, 13 Oct 2007 17:23:24 -0700
Date: Sun, 14 Oct 2007 01:23:23 +0100
From: Andrew Clayton <andrew@digital-domain.net>
Subject: Re: Latencies in XFS.
Message-ID: <20071014012323.1d6c9e8e@alpha.digital-domain.net>
In-Reply-To: <20071013201015.4a8008bb@galadriel.home>
References: <20071009163635.413dec0c@zeus.pccl.info>
	<20071013201015.4a8008bb@galadriel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Emmanuel Florac <eflorac@intellique.com>
Cc: xfs@oss.sgi.com

On Sat, 13 Oct 2007 20:10:15 +0200, Emmanuel Florac wrote:

> Le Tue, 9 Oct 2007 16:36:35 +0100 vous écriviez:
> 
> > I think I have narrowed it down to XFS.
> 
> I notice you use a bleeding-edge unstable kernel, with a whole new
> scheduler. I tried your benchmark on a machine running a known stable
> kernel (2.6.20.17) and the slowdown is similar in xfs and other fs.

I don't see the slowdown in ext3.
 
> As a side note, I personnally wouldn't choose xfs for desktop users
> home directories (email,web, etc) because it's much better at pure
> throughput and quite slower at IOPS than other FSes. Reiserfs is the
> best of the common FSes for this.
> 
> I'm quite surprised that apparently your production system is running
> a prerelease kernel. Why? 

Actually it's now running 2.6.23
