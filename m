Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5TKXoKD140392 for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 15:33:51 -0500
Received: from e1.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6777741778
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 13:33:49 -0700 (PDT)
Received: from e1.ny.us.ibm.com (e1.ny.us.ibm.com [32.97.182.141]) by
	cuda.sgi.com with ESMTP id h1YpRdlmBYWe7UDX for
	<xfs@oss.sgi.com>; Wed, 29 Jun 2011 13:33:49 -0700 (PDT)
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p5TKLmA5028570
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 16:21:48 -0400
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p5TKXmvV054426 for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 16:33:48 -0400
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p5TKXj9O000572 for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 16:33:47 -0400
Subject: Re: [PATCH] xfs: replace bp->flags usage with predefined macros
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <20110629063001.GA12554@infradead.org>
References: <1309308784.5505.6214.camel@chandra-lucid.beaverton.ibm.com>
	<20110629044616.GB1026@dastard> <20110629063001.GA12554@infradead.org>
Date: Wed, 29 Jun 2011 13:33:43 -0700
Message-ID: <1309379623.5505.6222.camel@chandra-lucid.beaverton.ibm.com>
Mime-Version: 1.0
Reply-To: sekharan@us.ibm.com
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: XFS Mailing List <xfs@oss.sgi.com>, Alex Elder <aelder@sgi.com>

On Wed, 2011-06-29 at 02:30 -0400, Christoph Hellwig wrote:
> On Wed, Jun 29, 2011 at 02:46:16PM +1000, Dave Chinner wrote:
> > On Tue, Jun 28, 2011 at 05:53:04PM -0700, Chandra Seetharaman wrote:
> > > Cleanup: Replace bp->flags usage with predefined macros.
> > > 
> > > Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> > 
> > Christoph can correct me if I'm wrong, but I'm pretty sure his long term
> > direction is to remove the XFS_BUF_* macros completely.
> 
> Yes, at least those that are simpler flags get/set/clear wrappers.

So, the suggestion is to go the other way and remove all the wrappers
and use bp->flags directly ?
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
