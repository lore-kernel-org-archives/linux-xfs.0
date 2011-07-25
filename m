Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6PMIJh7050335 for <xfs@oss.sgi.com>; Mon, 25 Jul 2011 17:18:20 -0500
Received: from e34.co.us.ibm.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id E2D96955B7
	for <xfs@oss.sgi.com>; Mon, 25 Jul 2011 15:18:18 -0700 (PDT)
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152]) by
	cuda.sgi.com with ESMTP id o3URmA1WQEHPBHPJ for
	<xfs@oss.sgi.com>; Mon, 25 Jul 2011 15:18:18 -0700 (PDT)
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com
	[9.17.195.227])
	by e34.co.us.ibm.com (8.14.4/8.13.1) with ESMTP id p6PMIGV8020562
	for <xfs@oss.sgi.com>; Mon, 25 Jul 2011 16:18:16 -0600
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v9.1) with ESMTP id
	p6PMIFrn116988 for <xfs@oss.sgi.com>; Mon, 25 Jul 2011 16:18:15 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP
	id p6PGHk2F007847
	for <xfs@oss.sgi.com>; Mon, 25 Jul 2011 10:17:48 -0600
Subject: Re: [PATCH 08/12] xfs: Remove the macro XFS_BUF_SET_PTR
From: Chandra Seetharaman <sekharan@us.ibm.com>
In-Reply-To: <1311609456.2914.24.camel@doink>
References: <20110722003226.21069.58401.sendpatchset@chandra-lucid.beaverton.ibm.com>
	<20110722003333.21069.32295.sendpatchset@chandra-lucid.beaverton.ibm.com>
	<1311363510.2771.103.camel@doink>
	<20110724113543.GB26332@infradead.org>
	<1311609456.2914.24.camel@doink>
Date: Mon, 25 Jul 2011 15:18:10 -0700
Message-ID: <1311632290.3210.986.camel@chandra-lucid.beaverton.ibm.com>
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
Cc: Christoph Hellwig <hch@infradead.org>, xfs@oss.sgi.com

On Mon, 2011-07-25 at 10:57 -0500, Alex Elder wrote:
> On Sun, 2011-07-24 at 07:35 -0400, Christoph Hellwig wrote:
> > On Fri, Jul 22, 2011 at 02:38:30PM -0500, Alex Elder wrote:
> > > > -					    (__psint_t)count), split);
> > > > +		xfs_buf_associate_memory(bp,
> > > > +				(xfs_caddr_t)((__psint_t)&(iclog->ic_header)+
> > > > +				    (__psint_t)count), split);
> > > 
> > > If you just cast the address appropriately you can make this
> > > look a lot nicer:
> > > 
> > > 		xfs_buf_associate_memory(bp,
> > > 			(void *) &iclog->ic_header + count, split);
> > 
> > If we have to cast anyway I'd suggest casting to char * at least, as
> > that is standard behaviour. I'm okay with using the gcc void pointer
> > arithmetics extension when it saves us ugliness, but in this case it
> > doesn't really buy us anything.
> 
> Yes, I agree.  I guess I had the "void *" addition on the brain
> when I did this.  Chandra, I would like to make this small change
> before I commit this.  OK with you?
> 

Yes.
> > Btw, nice follow-on cleanups would be to kill off the xfs_caddr_t and
> > __psint_t/__psunsigned_t types entirely.
> 
> Yes.  What do you suggest to use for a pointer-sized
> type?  Just cast to (long) and rely on the usual arithmetic
> conversions to do the right thing?
> 
> 					-Alex
> 
> 


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
