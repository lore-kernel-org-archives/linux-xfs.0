Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 12 Jul 2007 07:15:26 -0700 (PDT)
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l6CEF7bm022516
	for <xfs@oss.sgi.com>; Thu, 12 Jul 2007 07:15:11 -0700
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e36.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l6CEF6Sv019246
	for <xfs@oss.sgi.com>; Thu, 12 Jul 2007 10:15:06 -0400
Received: from d03av01.boulder.ibm.com (d03av01.boulder.ibm.com [9.17.195.167])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l6CEF1xh149892
	for <xfs@oss.sgi.com>; Thu, 12 Jul 2007 08:15:03 -0600
Received: from d03av01.boulder.ibm.com (loopback [127.0.0.1])
	by d03av01.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l6CEF1wo002566
	for <xfs@oss.sgi.com>; Thu, 12 Jul 2007 08:15:01 -0600
Date: Thu, 12 Jul 2007 19:45:16 +0530
From: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Subject: Re: [PATCH 4/7][TAKE5] support new modes in fallocate
Message-ID: <20070712141516.GC21606@amitarora.in.ibm.com>
References: <20070625214626.GJ5181@schatzie.adilger.int> <20070626103247.GA19870@amitarora.in.ibm.com> <20070630102111.GB23568@infradead.org> <20070630165246.GA5159@schatzie.adilger.int> <20070703100848.GA14936@amitarora.in.ibm.com> <20070703103107.GA29763@infradead.org> <20070703114650.GB14936@amitarora.in.ibm.com> <20070711090312.GA18301@infradead.org> <20070712072813.GA31260@in.ibm.com> <20070712131334.GY31489@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070712131334.GY31489@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Suparna Bhattacharya <suparna@in.ibm.com>, Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, adilger@clusterfs.com, cmm@us.ibm.com, xfs@oss.sgi.com

On Thu, Jul 12, 2007 at 11:13:34PM +1000, David Chinner wrote:
> On Thu, Jul 12, 2007 at 12:58:13PM +0530, Suparna Bhattacharya wrote:
> > 
> > Why don't we just merge the interface for preallocation (essentially
> > enough to satisfy posix_fallocate() and the simple XFS requirement for 
> > space reservation without changing file size), which there is clear agreement
> > on (I hope :)).  After all, this was all that we set out to do when we
> > started.
> > 
> > And leave all the dealloc/punch/hsm type features for separate future patches/
> > debates, those really shouldn't hold up the basic fallocate interface.
> > I agree with Christoph that we are just diverging too much in trying to
> > club those decisions here.
> > 
> > Dave, Andreas, Ted ?
> 
> Sure. I'll just make XFS work with whatever it is that gets merged.

Great. I will post the new patches soon.

--
Regards,
Amit Arora
