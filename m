Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6MLQN6g107090 for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 16:26:24 -0500
Received: from e32.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 864A7180DA21
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 14:26:23 -0700 (PDT)
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150]) by
	cuda.sgi.com with ESMTP id ZNb4pRQfjFH2uc81 for
	<xfs@oss.sgi.com>; Fri, 22 Jul 2011 14:26:23 -0700 (PDT)
Received: from d03relay03.boulder.ibm.com (d03relay03.boulder.ibm.com
	[9.17.195.228])
	by e32.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p6MKGVBp030665
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 14:16:31 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay03.boulder.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id
	p6MLQMjp183556 for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 15:26:22 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p6MFPsrE016445
	for <xfs@oss.sgi.com>; Fri, 22 Jul 2011 09:25:54 -0600
Subject: Re: [PATCH 12/12] xfs: Remove the macro XFS_BUFTARG_NAME
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <1311369805.3210.974.camel@chandra-lucid.beaverton.ibm.com>
References: <20110722003226.21069.58401.sendpatchset@chandra-lucid.beaverton.ibm.com>
	<20110722003408.21069.44409.sendpatchset@chandra-lucid.beaverton.ibm.com>
	<1311364181.2771.114.camel@doink>
	<1311369805.3210.974.camel@chandra-lucid.beaverton.ibm.com>
Date: Fri, 22 Jul 2011 14:26:19 -0700
Message-ID: <1311369979.3210.975.camel@chandra-lucid.beaverton.ibm.com>
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
Cc: xfs@oss.sgi.com

On Fri, 2011-07-22 at 14:23 -0700, Chandra Seetharaman wrote:
> On Fri, 2011-07-22 at 14:49 -0500, Alex Elder wrote:
> > On Thu, 2011-07-21 at 17:34 -0700, Chandra Seetharaman wrote:
> > > Remove the definition and usages of the macro XFS_BUFTARG_NAME.
> > > 
> > > Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
> > > Reviewed-by: Christoph Hellwig <hch@lst.de>
> > 
> > 
> > Wow, I hadn't looked at the definition of
> > xfs_buf_target_name() before.  It's not safe
> > (using a pointer to since-released stack space),
> > though in practice it's going to be fine.
> > 
> > Defining it as an inline function with a static
> > buffer would at least avoid that, though it
> > means it's not reentrant either.
> > 
> > I would personally prefer doing it that way though.
> > 
> > /* NB: returns pointer to buffer reused on each call */
> > static inline char *
> > xfs_buf_target_name(struct xfs_buftarg *target)
> > {
> >         static char __b[BDEVNAME_SIZE];
> > 
> >         return bdevname(target->bt_bdev, __b);
> > }
> > 
> > 
> > Anyway, you didn't change this, but you're touching
> > the code that uses it.  So unless others object I
> > would like to see this changed along with the
> > rest of what you do here (which is all good, by
> > the way).

Will do it.
> > 
> > Either way:
> > 
> > Reviewed-by: Alex Elder <aelder@sgi.com>
> > 
> > 
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
