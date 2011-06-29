Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p5TM2iGZ145115 for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 17:02:44 -0500
Received: from e5.ny.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 309A31782258
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 15:02:40 -0700 (PDT)
Received: from e5.ny.us.ibm.com (e5.ny.us.ibm.com [32.97.182.145]) by
	cuda.sgi.com with ESMTP id MF5fHEdlHrMY0KTB for
	<xfs@oss.sgi.com>; Wed, 29 Jun 2011 15:02:40 -0700 (PDT)
Received: from d01relay07.pok.ibm.com (d01relay07.pok.ibm.com [9.56.227.147])
	by e5.ny.us.ibm.com (8.14.4/8.13.1) with ESMTP id p5TLYMbf017384
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 17:34:22 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay07.pok.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p5TM2evE1454096
	for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 18:02:40 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id
	p5TM2d8n007321 for <xfs@oss.sgi.com>; Wed, 29 Jun 2011 18:02:39 -0400
Subject: Re: [PATCH] xfs: replace bp->flags usage with predefined macros
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <1309384706.8649.31.camel@doink>
References: <1309308784.5505.6214.camel@chandra-lucid.beaverton.ibm.com>
	<20110629044616.GB1026@dastard> <20110629063001.GA12554@infradead.org>
	<1309379623.5505.6222.camel@chandra-lucid.beaverton.ibm.com>
	<1309384706.8649.31.camel@doink>
Date: Wed, 29 Jun 2011 15:02:37 -0700
Message-ID: <1309384957.5505.6280.camel@chandra-lucid.beaverton.ibm.com>
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
To: aelder@sgi.com
Cc: Christoph Hellwig <hch@infradead.org>, XFS Mailing List <xfs@oss.sgi.com>

On Wed, 2011-06-29 at 16:58 -0500, Alex Elder wrote:
> On Wed, 2011-06-29 at 13:33 -0700, Chandra Seetharaman wrote:
> > On Wed, 2011-06-29 at 02:30 -0400, Christoph Hellwig wrote:
> > > On Wed, Jun 29, 2011 at 02:46:16PM +1000, Dave Chinner wrote:
> > > > On Tue, Jun 28, 2011 at 05:53:04PM -0700, Chandra Seetharaman wrote:
> > > > > Cleanup: Replace bp->flags usage with predefined macros.
> > > > > 
> > > > > Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> > > > 
> > > > Christoph can correct me if I'm wrong, but I'm pretty sure his long term
> > > > direction is to remove the XFS_BUF_* macros completely.
> > > 
> > > Yes, at least those that are simpler flags get/set/clear wrappers.
> > 
> > So, the suggestion is to go the other way and remove all the wrappers
> > and use bp->flags directly ?
> 
> Yes, that's right.
> 
> Sorry about that.  Chandra asked me for some things to do
> on XFS so I fired a few small simple odds and ends I had
> made note of along the way.  This was one--I said that the
> use of macros should be consistent.  I said we should
> eventually do away with them entirely, but I didn't recommend
> he do that right now since this was being done by a new
> contributor.
> 
> Chandra, I think if you're up to it, doing away with the
> macros is the right way to go.

Will do.
> 
> 					-Alex
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
