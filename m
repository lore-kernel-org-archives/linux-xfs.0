Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p6PFvdh6009057 for <xfs@oss.sgi.com>; Mon, 25 Jul 2011 10:57:39 -0500
Subject: Re: [PATCH 08/12] xfs: Remove the macro XFS_BUF_SET_PTR
From: Alex Elder <aelder@sgi.com>
In-Reply-To: <20110724113543.GB26332@infradead.org>
References: <20110722003226.21069.58401.sendpatchset@chandra-lucid.beaverton.ibm.com>
	<20110722003333.21069.32295.sendpatchset@chandra-lucid.beaverton.ibm.com>
	<1311363510.2771.103.camel@doink>
	<20110724113543.GB26332@infradead.org>
Date: Mon, 25 Jul 2011 10:57:36 -0500
Message-ID: <1311609456.2914.24.camel@doink>
MIME-Version: 1.0
Reply-To: aelder@sgi.com
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
Cc: Chandra Seetharaman <sekharan@us.ibm.com>, xfs@oss.sgi.com

On Sun, 2011-07-24 at 07:35 -0400, Christoph Hellwig wrote:
> On Fri, Jul 22, 2011 at 02:38:30PM -0500, Alex Elder wrote:
> > > -					    (__psint_t)count), split);
> > > +		xfs_buf_associate_memory(bp,
> > > +				(xfs_caddr_t)((__psint_t)&(iclog->ic_header)+
> > > +				    (__psint_t)count), split);
> > 
> > If you just cast the address appropriately you can make this
> > look a lot nicer:
> > 
> > 		xfs_buf_associate_memory(bp,
> > 			(void *) &iclog->ic_header + count, split);
> 
> If we have to cast anyway I'd suggest casting to char * at least, as
> that is standard behaviour. I'm okay with using the gcc void pointer
> arithmetics extension when it saves us ugliness, but in this case it
> doesn't really buy us anything.

Yes, I agree.  I guess I had the "void *" addition on the brain
when I did this.  Chandra, I would like to make this small change
before I commit this.  OK with you?

> Btw, nice follow-on cleanups would be to kill off the xfs_caddr_t and
> __psint_t/__psunsigned_t types entirely.

Yes.  What do you suggest to use for a pointer-sized
type?  Just cast to (long) and rely on the usual arithmetic
conversions to do the right thing?

					-Alex


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
